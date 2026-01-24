import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/novel_content.dart';

/// 小説のページを表示するウィジェット。
class NovelPage extends HookConsumerWidget {
  /// コンストラクタ。
  const NovelPage({
    required this.ncode,
    super.key,
    this.episode,
    this.revised,
  });

  /// 小説のNコード。
  ///
  /// 常に小文字で扱う
  final String ncode;

  /// 表示するエピソード番号。
  final int? episode;

  /// 改稿日時（指定された場合、キャッシュ判定に使用）
  final String? revised;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final novelInfoAsync = ref.watch(novelInfoWithCacheProvider(ncode));
    final initialEpisode = episode ?? 1;

    // 現在のエピソード番号をローカル状態で管理
    final currentEpisode = useState(initialEpisode);

    // 初回履歴追加フラグ（重複追加を防ぐ）
    final hasAddedInitialHistory = useRef(false);

    // 最初の履歴追加（novelInfoが読み込まれたら実行）
    useEffect(() {
      if (novelInfoAsync.hasValue && !hasAddedInitialHistory.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateHistory(ref, novelInfoAsync.value!, currentEpisode.value);
          hasAddedInitialHistory.value = true;
        });
      }
      return null;
    }, [novelInfoAsync.hasValue]);

    return novelInfoAsync.when(
      data: (novelInfo) {
        final totalEpisodes = novelInfo.generalAllNo ?? 1;
        final settings = ref.watch(settingsProvider);

        // PageViewのitemCountとinitialPageを動的に決定
        final itemCount = _getItemCount(currentEpisode.value, totalEpisodes);
        final initialPageIndex = _getInitialPage(currentEpisode.value);

        // 改稿日時マップを作成
        final episodeMap = useMemoized(() {
          // エピソードリストがnullの場合は空のMapを返す
          if (novelInfo.episodes == null) {
            return <int, String?>{};
          }
          return {
            for (final e in novelInfo.episodes!)
              if (e.index != null) e.index!: e.revised,
          };
        }, [novelInfo]);

        // PageControllerをメモ化（itemCountが変わったときのみ再作成）
        final pageController = useMemoized(
          () => PageController(initialPage: initialPageIndex),
          [itemCount],
        );

        // itemCountが変わったらページ位置をリセット
        useEffect(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (pageController.hasClients) {
              final targetPage = _getInitialPage(currentEpisode.value);
              if (pageController.page?.round() != targetPage) {
                pageController.jumpToPage(targetPage);
              }
            }
          });
          return null;
        }, [itemCount]);

        return settings.when(
          data: (settings) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  buildTitle(novelInfo, currentEpisode.value),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              body: PageView.builder(
                scrollDirection: settings.isVertical
                    ? Axis.vertical
                    : Axis.horizontal,
                controller: pageController,
                itemCount: itemCount,
                onPageChanged: (index) {
                  _handlePageChanged(
                    index,
                    currentEpisode,
                    totalEpisodes,
                    pageController,
                    ref,
                    novelInfo,
                  );
                },
                itemBuilder: (context, index) {
                  final episodeNum = _getEpisodeNumber(
                    index,
                    currentEpisode.value,
                    totalEpisodes,
                  );

                  // 指定されたエピソードかつ改稿日時が指定されている場合はそちらを優先
                  // それ以外はNovelInfoから取得した改稿日時を使用
                  final revisedDate = (episodeNum == episode && revised != null)
                      ? revised
                      : episodeMap[episodeNum];

                  return RepaintBoundary(
                    child: NovelContent(
                      ncode: ncode,
                      episode: episodeNum,
                      revised: revisedDate,
                    ),
                  );
                },
              ),
            );
          },
          loading: () => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (e, s) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: $e')),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('エラーが発生しました: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('戻る'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateHistory(WidgetRef ref, NovelInfo novelInfo, int episode) {
    unawaited(
      ref
          .read(novelRepositoryProvider)
          .addToHistory(
            ncode: ncode,
            title: novelInfo.title ?? '',
            writer: novelInfo.writer ?? '',
            lastEpisode: episode,
          ),
    );
  }

  /// PageViewのアイテム数を決定する。
  ///
  /// - 1話だけの小説: 1ページ
  /// - 第1話（2話以上）: 2ページ（現在 + 次）
  /// - 最終話: 2ページ（前 + 現在）
  /// - 中間エピソード: 3ページ（前 + 現在 + 次）
  static int _getItemCount(int currentEpisode, int totalEpisodes) {
    if (totalEpisodes == 1) return 1;
    if (currentEpisode == 1) return 2;
    if (currentEpisode == totalEpisodes) return 2;
    return 3;
  }

  /// PageControllerの初期ページインデックスを決定する。
  ///
  /// - 第1話: 0（最初のページ）
  /// - それ以外: 1（中央のページ）
  static int _getInitialPage(int currentEpisode) {
    return currentEpisode == 1 ? 0 : 1;
  }

  /// PageViewのindexから実際のエピソード番号を計算する。
  static int _getEpisodeNumber(
    int index,
    int currentEpisode,
    int totalEpisodes,
  ) {
    if (totalEpisodes == 1) return 1;

    if (currentEpisode == 1) {
      // 第1話: [1話, 2話]
      return index + 1;
    }

    if (currentEpisode == totalEpisodes) {
      // 最終話: [totalEpisodes-1話, totalEpisodes話]
      return totalEpisodes - 1 + index;
    }

    // 中間エピソード: [current-1話, current話, current+1話]
    return currentEpisode - 1 + index;
  }

  /// ページ変更時の処理を行う。
  void _handlePageChanged(
    int index,
    ValueNotifier<int> currentEpisode,
    int totalEpisodes,
    PageController pageController,
    WidgetRef ref,
    NovelInfo novelInfo,
  ) {
    final current = currentEpisode.value;

    if (current == 1) {
      // 第1話から第2話へ移動
      if (index == 1 && totalEpisodes > 1) {
        currentEpisode.value = 2;
        _updateHistory(ref, novelInfo, 2);
      }
    } else if (current == totalEpisodes) {
      // 最終話から前のエピソードへ移動
      if (index == 0 && totalEpisodes > 1) {
        currentEpisode.value = totalEpisodes - 1;
        _updateHistory(ref, novelInfo, totalEpisodes - 1);
      }
    } else {
      // 中間エピソードの通常処理
      if (index == 0) {
        // 前のエピソードへ
        currentEpisode.value--;
        _updateHistory(ref, novelInfo, currentEpisode.value);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients) {
            pageController.jumpToPage(1);
          }
        });
      } else if (index == 2) {
        // 次のエピソードへ
        currentEpisode.value++;
        _updateHistory(ref, novelInfo, currentEpisode.value);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients) {
            pageController.jumpToPage(1);
          }
        });
      }
    }
  }

  /// AppBarに表示するタイトルを生成する。
  ///
  /// - 短編の場合: 小説タイトルのみ
  /// - 連載の場合: 「第X話 サブタイトル」または「第X話」
  @visibleForTesting
  static String buildTitle(NovelInfo novelInfo, int currentEpisodeNum) {
    // 短編の場合はタイトルのみ
    if (novelInfo.novelType == 2) {
      return novelInfo.title ?? '';
    }

    // 連載の場合
    // エピソードリストから現在のエピソード番号に対応するエピソードを検索
    final currentEpisodeData = novelInfo.episodes?.firstWhere(
      (ep) => ep.index == currentEpisodeNum,
      orElse: () => const Episode(),
    );

    final subtitle = currentEpisodeData?.subtitle;

    // サブタイトルがある場合は「第X話 サブタイトル」
    // ない場合は「第X話」のみ
    if (subtitle != null && subtitle.isNotEmpty) {
      return '第$currentEpisodeNum話 $subtitle';
    } else {
      return '第$currentEpisodeNum話';
    }
  }
}
