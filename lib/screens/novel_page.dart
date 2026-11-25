import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/async_subscription.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/gesture_shield.dart';
import 'package:novelty/widgets/novel_content.dart';

/// 小説のページを表示するウィジェット。
class NovelPage extends StatefulWidget {
  /// コンストラクタ。
  const NovelPage({
    required this.source,
    required this.workId,
    super.key,
    this.episode,
    this.revised,
  });

  /// 提供サイト（プロバイダ）。
  final NovelSource source;

  /// サイト共通の作品ID（なろうはNコード）。
  final String workId;

  /// 表示するエピソード番号。
  final int? episode;

  /// 改稿日時（指定された場合、キャッシュ判定に使用）
  final String? revised;

  /// AppBarに表示するタイトルを生成する。
  ///
  /// - 短編の場合: 小説タイトルのみ
  /// - 連載の場合: 「第X話 サブタイトル」または「第X話」
  @visibleForTesting
  static String buildTitle(
    NovelInfo novelInfo,
    int currentEpisodeNum,
    Episode? currentEpisode,
  ) {
    // 短編の場合はタイトルのみ
    if (novelInfo.novelType == 2) {
      return novelInfo.title ?? '';
    }

    // 連載の場合
    final subtitle = currentEpisode?.subtitle;

    // サブタイトルがある場合は「第X話 サブタイトル」
    // ない場合は「第X話」のみ
    if (subtitle != null && subtitle.isNotEmpty) {
      return '第$currentEpisodeNum話 $subtitle';
    } else {
      return '第$currentEpisodeNum話';
    }
  }

  @override
  State<NovelPage> createState() => _NovelPageState();
}

class _NovelPageState extends State<NovelPage> {
  late int _currentEpisode = widget.episode ?? 1;
  var _hasAddedInitialHistory = false;
  var _isAppBarVisible = false;
  var _bound = false;

  PageController? _pageController;
  int _pageControllerItemCount = 0;

  late final AsyncSubscription<NovelInfo> _novelInfo;
  AsyncSubscription<List<Episode>>? _episodeList;
  int _episodeListPage = 0;

  Map<int, String?>? _episodeMap;
  NovelInfo? _episodeMapFor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bound) return;
    _bound = true;
    _novelInfo = AsyncSubscription(
      context.services.repository.watchNovelInfo(widget.source, widget.workId),
      onChanged: _rebuild,
    );
    _syncEpisodeList();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    unawaited(_novelInfo.cancel());
    final episodeList = _episodeList;
    if (episodeList != null) unawaited(episodeList.cancel());
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  /// 表示中の話が属する目次ページだけを購読する。
  void _syncEpisodeList() {
    final page = ((_currentEpisode - 1) ~/ 100) + 1;
    if (page == _episodeListPage) return;
    _episodeListPage = page;
    final previous = _episodeList;
    if (previous != null) unawaited(previous.cancel());
    _episodeList = AsyncSubscription(
      context.services.repository.watchEpisodeList(
        widget.source,
        widget.workId,
        page,
      ),
      onChanged: _rebuild,
    );
  }

  Map<int, String?> _episodeRevisions(NovelInfo novelInfo) {
    if (identical(_episodeMapFor, novelInfo) && _episodeMap != null) {
      return _episodeMap!;
    }
    final episodes = novelInfo.episodes;
    final map = episodes == null
        ? <int, String?>{}
        : {for (final e in episodes) ?e.index: e.revised};
    _episodeMapFor = novelInfo;
    _episodeMap = map;
    return map;
  }

  /// 最初の履歴追加（novelInfoが読み込まれたら一度だけ実行）。
  void _addInitialHistory(NovelInfo novelInfo) {
    if (_hasAddedInitialHistory) return;
    _hasAddedInitialHistory = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateHistory(novelInfo, _currentEpisode);
    });
  }

  void _updateHistory(NovelInfo novelInfo, int episode) {
    unawaited(
      context.services.repository.addToHistory(
        source: widget.source,
        workId: widget.workId,
        title: novelInfo.title ?? '',
        writer: novelInfo.writer ?? '',
        lastEpisode: episode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = context.services.settings.state;

    return _novelInfo.state.when(
      data: (novelInfo) {
        _addInitialHistory(novelInfo);
        return settingsAsync.when(
          data: (settings) => _buildReader(context, novelInfo, settings),
          loading: () => _scaffoldWith(
            const Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) =>
              _scaffoldWith(Center(child: Text('Error: $error'))),
        );
      },
      loading: () =>
          _scaffoldWith(const Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('エラーが発生しました: $error'),
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

  Widget _scaffoldWith(Widget body) => Scaffold(appBar: AppBar(), body: body);

  Widget _buildReader(
    BuildContext context,
    NovelInfo novelInfo,
    AppSettings settings,
  ) {
    final totalEpisodes = novelInfo.generalAllNo ?? 1;
    final itemCount = _getItemCount(_currentEpisode, totalEpisodes);
    final episodeMap = _episodeRevisions(novelInfo);
    final currentEpisodeData = _episodeList?.state.valueOrNull?.firstWhere(
      (e) => e.index == _currentEpisode,
      orElse: () => const Episode(),
    );

    final pageController = _pageController ??= PageController(
      initialPage: _getInitialPage(_currentEpisode),
    );
    if (itemCount != _pageControllerItemCount) {
      _pageControllerItemCount = itemCount;
      // itemCountが変わったらページ位置をリセット
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!pageController.hasClients) return;
        final targetPage = _getInitialPage(_currentEpisode);
        if (pageController.page?.round() != targetPage) {
          pageController.jumpToPage(targetPage);
        }
      });
    }

    // The reader pages horizontally, so the iOS back gesture would
    // fight the page swipe. Refusing the pop turns the gesture off;
    // the back button above calls appRouter.pop directly.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          appRouter.pop();
        }
      },
      child: Scaffold(
        appBar: _isAppBarVisible
            ? AppBar(
                leading: BackButton(onPressed: appRouter.pop),
                title: Text(
                  NovelPage.buildTitle(
                    novelInfo,
                    _currentEpisode,
                    currentEpisodeData,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : null,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          // 本文タップでAppBarの表示/非表示を切り替える
          onTap: () => setState(() => _isAppBarVisible = !_isAppBarVisible),
          child: Stack(
            children: [
              PageView.builder(
                scrollDirection: settings.isVertical
                    ? Axis.vertical
                    : Axis.horizontal,
                controller: pageController,
                itemCount: itemCount,
                onPageChanged: (index) => _handlePageChanged(
                  index,
                  totalEpisodes,
                  pageController,
                  novelInfo,
                ),
                itemBuilder: (context, index) {
                  final episodeNum = _getEpisodeNumber(
                    index,
                    _currentEpisode,
                    totalEpisodes,
                  );

                  // 指定されたエピソードかつ改稿日時が指定されている場合はそちらを優先
                  // それ以外はNovelInfoから取得した改稿日時を使用
                  final revisedDate =
                      (episodeNum == widget.episode && widget.revised != null)
                      ? widget.revised
                      : episodeMap[episodeNum];

                  return RepaintBoundary(
                    child: NovelContent(
                      source: widget.source,
                      workId: widget.workId,
                      episode: episodeNum,
                      revised: revisedDate,
                      isAppBarVisible: _isAppBarVisible,
                    ),
                  );
                },
              ),
              // 縦書きモード時、ホームジェスチャーとの競合を防ぐためシールドを表示
              if (settings.isVertical) const GestureShield(),
            ],
          ),
        ),
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
    int totalEpisodes,
    PageController pageController,
    NovelInfo novelInfo,
  ) {
    final current = _currentEpisode;

    if (current == 1) {
      // 第1話から第2話へ移動
      if (index == 1 && totalEpisodes > 1) {
        setState(() => _currentEpisode = 2);
        _updateHistory(novelInfo, 2);
        _syncEpisodeList();
      }
    } else if (current == totalEpisodes) {
      // 最終話から前のエピソードへ移動
      if (index == 0 && totalEpisodes > 1) {
        setState(() => _currentEpisode = totalEpisodes - 1);
        _updateHistory(novelInfo, totalEpisodes - 1);
        _syncEpisodeList();
      }
    } else {
      // 中間エピソードの通常処理
      if (index == 0) {
        // 前のエピソードへ
        setState(() => _currentEpisode--);
        _updateHistory(novelInfo, _currentEpisode);
        _syncEpisodeList();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients) {
            pageController.jumpToPage(1);
          }
        });
      } else if (index == 2) {
        // 次のエピソードへ
        setState(() => _currentEpisode++);
        _updateHistory(novelInfo, _currentEpisode);
        _syncEpisodeList();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients) {
            pageController.jumpToPage(1);
          }
        });
      }
    }
  }
}
