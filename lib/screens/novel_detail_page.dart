import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/models/download_result.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/providers/connectivity_provider.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// 小説の詳細ページ
class NovelDetailPage extends ConsumerStatefulWidget {
  /// コンストラクタ
  const NovelDetailPage({required this.ncode, super.key});

  /// 詳細ページの識別子として使用される小説のコード
  final String ncode;

  @override
  ConsumerState<NovelDetailPage> createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends ConsumerState<NovelDetailPage> {
  int _currentPage = 1;

  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Threshold can be adjusted. 40.0 is roughly where the big title might start disappearing.
    final show = _scrollController.offset > 40.0;
    if (show != _showTitle) {
      setState(() {
        _showTitle = show;
      });
    }
  }

  void _loadMoreEpisodes() {
    final novelInfo = ref
        .read(novelInfoWithCacheProvider(widget.ncode))
        .asData
        ?.value;
    if (novelInfo?.generalAllNo != null) {
      final currentTotal = (_currentPage - 1) * 100; // approximation
      if (currentTotal >= novelInfo!.generalAllNo!) {
        return;
      }
    }

    setState(() {
      _currentPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. ノベル情報の取得とエラー通知
    final novelInfoAsync = ref.watch(novelInfoWithCacheProvider(widget.ncode));
    ref.listen(novelInfoWithCacheProvider(widget.ncode), (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ノベル情報の更新に失敗しました: ${next.error}')),
        );
      }
    });

    // 2. エピソードリストのリアクティブな集約
    final allEpisodes = <Episode>[];
    var isListLoading = false;
    var listHasError = false;

    // 読み込み済みのページまで全てwatchする
    // これにより、SWRの再検証やフェッチが自動的にトリガーされる
    for (var i = 1; i <= _currentPage; i++) {
      final pageState = ref.watch(episodeListProvider('${widget.ncode}_$i'));

      // エラー通知のためのリスナー
      ref.listen(episodeListProvider('${widget.ncode}_$i'), (previous, next) {
        if (next.hasError && !next.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ページ $i の更新に失敗しました: ${next.error}')),
          );
        }
      });

      if (pageState.hasValue) {
        allEpisodes.addAll(pageState.value!);
      } else if (pageState.isLoading) {
        isListLoading = true;
      } else if (pageState.hasError) {
        listHasError = true;
      }
    }

    // Graceful Degradation: キャッシュがあれば表示優先
    // novelInfo が取得できていれば画面を構築
    final novelInfo = novelInfoAsync.asData?.value;

    if (novelInfo != null) {
      return _buildContent(
        context,
        novelInfo,
        allEpisodes,
        isLoading: isListLoading,
        hasError: listHasError,
      );
    }

    if (novelInfoAsync.isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Failed to load novel info: ${novelInfoAsync.error}'),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    NovelInfo novelInfo,
    List<Episode> episodes, {
    required bool isLoading,
    required bool hasError,
  }) {
    final isShortStory = novelInfo.generalAllNo == 1;
    final downloadProgressAsync = ref.watch(
      downloadProgressProvider(widget.ncode),
    );

    final progressBar = downloadProgressAsync.when(
      data: (progress) {
        if (progress != null && progress.isDownloading) {
          return LinearProgressIndicator(
            value: progress.progress,
            minHeight: 2,
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // 詳細情報と読み込み済みの全エピソードページを再検証
          ref.invalidate(novelInfoWithCacheProvider(widget.ncode));
          for (var i = 1; i <= _currentPage; i++) {
            ref.invalidate(episodeListProvider('${widget.ncode}_$i'));
          }
          // SWRなのでinvalidateしてもキャッシュがあれば即表示されるが、
          // fetch完了を待ちたい場合はここでは難しい。
          // RefreshIndicatorはFuture完了で閉じるため、簡単なウェイトを入れるか、
          // 厳密にはLoading状態の変化を監視する必要がある。
          // ここではUX向上のため、少し待機してから閉じる
          await Future<void>.delayed(const Duration(milliseconds: 800));
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              title: AnimatedOpacity(
                opacity: _showTitle ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  novelInfo.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: progressBar,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, novelInfo),
                    const SizedBox(height: 24),
                    _buildActionButtons(
                      context,
                      ref,
                      novelInfo,
                      widget.ncode,
                    ),
                    const SizedBox(height: 24),
                    _StorySection(story: novelInfo.story ?? ''),
                    const SizedBox(height: 16),
                    _buildGenreTags(context, novelInfo),
                  ],
                ),
              ),
            ),
            if (isShortStory)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.menu_book),
                      label: const Text('この小説を読む'),
                      onPressed: () => context.push('/novel/${widget.ncode}/1'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        textStyle: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
              )
            else
              _EpisodeListSliver(
                ncode: widget.ncode,
                totalEpisodes: novelInfo.generalAllNo ?? 0,
                episodes: episodes,
                isLoading: isLoading,
                hasMore:
                    !isShortStory &&
                    (novelInfo.generalAllNo == null ||
                        episodes.length < novelInfo.generalAllNo!),
                onLoadMoreRequested: _loadMoreEpisodes,
              ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, NovelInfo novelInfo) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        novelInfo.title ?? 'No Title',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          const Icon(Icons.person_outline, size: 16),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              novelInfo.writer ?? 'Unknown',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.star_outline, size: 16),
          const SizedBox(width: 4),
          Text('${novelInfo.allPoint ?? 0} pt'),
        ],
      ),
    ],
  );
}

class _StorySection extends StatefulWidget {
  const _StorySection({required this.story});

  final String story;

  @override
  _StorySectionState createState() => _StorySectionState();
}

class _StorySectionState extends State<_StorySection> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.story.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'あらすじ',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: Text(
            widget.story,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
          ),
          secondChild: Text(
            widget.story,
            style: textTheme.bodyMedium,
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            child: Text(_isExpanded ? '閉じる' : 'もっと読む'),
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
          ),
        ),
      ],
    );
  }
}

class _EpisodeListSliver extends StatelessWidget {
  const _EpisodeListSliver({
    required this.ncode,
    required this.totalEpisodes,
    required this.episodes,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMoreRequested,
    // initialLoadDone is no longer needed as parent handles loading state
  });

  final String ncode;
  final int totalEpisodes;
  final List<Episode> episodes;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback onLoadMoreRequested;

  @override
  Widget build(BuildContext context) {
    // If we have no episodes and are loading, show spinner (though parent might handle this)
    if (episodes.isEmpty && isLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (episodes.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('エピソードがありません'),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$totalEpisodes 話',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final episodeIndex = index - 1;
          if (episodeIndex >= episodes.length) {
            // Reached end of list
            if (hasMore) {
              // Trigger load more if we still have more page and not currently loading the NEXT page
              // Note: isLoading passed here is aggregate. We might want to be more specific.
              // But strictly, if we are scrolling and see spinner, we shouldn't spam.
              if (!isLoading) {
                unawaited(Future.microtask(onLoadMoreRequested));
              }
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return const SizedBox.shrink();
          }

          final episode = episodes[episodeIndex];
          return _EpisodeListTile(
            episode: episode,
            ncode: ncode,
          );
        },
        childCount: episodes.length + 2, // Header + Items + Footer
      ),
    );
  }
}

Widget _buildGenreTags(BuildContext context, NovelInfo novelInfo) {
  final keywords =
      novelInfo.keyword?.split(' ').where((k) => k.isNotEmpty).toList() ?? [];
  if (keywords.isEmpty) {
    return const SizedBox.shrink();
  }

  return Wrap(
    spacing: 8,
    runSpacing: 4,
    children: keywords.map((keyword) => Chip(label: Text(keyword))).toList(),
  );
}

Widget _buildActionButtons(
  BuildContext context,
  WidgetRef ref,
  NovelInfo novelInfo,
  String ncode,
) {
  final isFavoriteAsync = ref.watch(libraryStatusProvider(ncode));
  final downloadStatusAsync = ref.watch(downloadStatusProvider(novelInfo));
  final isOffline = ref.watch(isOfflineProvider);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      isFavoriteAsync.when(
        data: (isFavorite) => _buildActionButton(
          context,
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          label: isFavorite ? '追加済' : '追加',
          color: isFavorite ? Theme.of(context).colorScheme.primary : null,
          onPressed: () =>
              ref.read(libraryStatusProvider(ncode).notifier).toggle(novelInfo),
        ),
        loading: () => _buildActionButton(
          context,
          icon: Icons.favorite_border,
          label: '追加',
        ),
        error: (e, s) =>
            _buildActionButton(context, icon: Icons.error, label: 'Error'),
      ),
      if (!isOffline) ...[
        downloadStatusAsync.when(
          data: (isDownloaded) {
            final downloadProgressAsync = ref.watch(
              downloadProgressProvider(ncode),
            );
            return downloadProgressAsync.when(
              data: (progress) => _buildDownloadButton(
                context,
                ref,
                novelInfo,
                isDownloaded,
                progress,
              ),
              loading: () => _buildDownloadButton(
                context,
                ref,
                novelInfo,
                isDownloaded,
                null,
              ),
              error: (e, s) => _buildActionButton(
                context,
                icon: Icons.error,
                label: 'Error',
              ),
            );
          },
          loading: () => _buildActionButton(
            context,
            icon: Icons.downloading,
            label: 'ダウンロード中...',
          ),
          error: (e, s) =>
              _buildActionButton(context, icon: Icons.error, label: 'Error'),
        ),
        _buildActionButton(
          context,
          icon: Icons.public,
          label: 'WebView',
          onPressed: () {
            unawaited(
              launchUrl(
                Uri.parse('https://ncode.syosetu.com/$ncode/'),
              ),
            );
          },
        ),
      ],
    ],
  );
}

Widget _buildDownloadButton(
  BuildContext context,
  WidgetRef ref,
  NovelInfo novelInfo,
  bool isDownloaded,
  DownloadProgress? progress,
) {
  if (progress != null && progress.isDownloading) {
    return _buildActionButton(
      context,
      icon: Icons.downloading,
      label: 'ダウンロード中',
    );
  }

  if (progress != null && progress.hasError) {
    return _buildActionButton(
      context,
      icon: Icons.error,
      label: 'エラー',
      color: Theme.of(context).colorScheme.error,
      onPressed: () => _handleDownload(context, ref, novelInfo),
    );
  }

  return _buildActionButton(
    context,
    icon: isDownloaded
        ? Icons.download_done
        : Icons.download_for_offline_outlined,
    label: isDownloaded ? 'ダウンロード済' : 'ダウンロード',
    onPressed: () {
      if (isDownloaded) {
        unawaited(_handleDelete(context, ref, novelInfo));
      } else {
        unawaited(_handleDownload(context, ref, novelInfo));
      }
    },
  );
}

Future<void> _handleDownload(
  BuildContext context,
  WidgetRef ref,
  NovelInfo novelInfo,
) async {
  final result = await ref
      .read(downloadStatusProvider(novelInfo).notifier)
      .executeDownload(novelInfo);

  if (!context.mounted) return;

  result.when(
    success: (needsLibraryAddition) {
      if (needsLibraryAddition) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('ライブラリに追加しますか?'),
            action: SnackBarAction(
              label: '追加',
              onPressed: () {
                unawaited(
                  ref
                      .read(libraryStatusProvider(novelInfo.ncode!).notifier)
                      .toggle(novelInfo),
                );
              },
            ),
          ),
        );
      }
    },
    permissionDenied: () {
      unawaited(
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('権限が必要です'),
            content: const Text('小説をダウンロードするには、ファイルへのアクセス権限を許可してください。'),
            actions: [
              TextButton(
                child: const Text('キャンセル'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('設定を開く'),
                onPressed: () {
                  unawaited(openAppSettings());
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
    cancelled: () {},
    error: (message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ダウンロードに失敗しました: $message')),
      );
    },
  );
}

Future<void> _handleDelete(
  BuildContext context,
  WidgetRef ref,
  NovelInfo novelInfo,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('削除の確認'),
      content: Text('「${novelInfo.title}」を端末から削除しますか？'),
      actions: [
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('削除'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;

  final result = await ref
      .read(downloadStatusProvider(novelInfo).notifier)
      .executeDelete(novelInfo);

  if (!context.mounted) return;

  result.when(
    success: (_) {},
    permissionDenied: () {},
    cancelled: () {},
    error: (message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('削除に失敗しました: $message')),
      );
    },
  );
}

Widget _buildActionButton(
  BuildContext context, {
  required IconData icon,
  required String label,
  VoidCallback? onPressed,
  Color? color,
}) {
  final effectiveColor = color ?? Theme.of(context).textTheme.bodySmall?.color;
  return Column(
    children: [
      IconButton(
        icon: Icon(icon, color: effectiveColor),
        onPressed: onPressed,
        iconSize: 28,
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: effectiveColor),
      ),
    ],
  );
}

class _EpisodeListTile extends ConsumerWidget {
  const _EpisodeListTile({
    required this.episode,
    required this.ncode,
  });

  final Episode episode;
  final String ncode;

  int? _extractEpisodeNumber(String? url) {
    if (url == null) return null;
    final match = RegExp(r'/(\d+)/').firstMatch(url);
    if (match != null) {
      final episodeNumber = match.group(1);
      if (episodeNumber != null) {
        return int.tryParse(episodeNumber);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodeNumber = _extractEpisodeNumber(episode.url);
    final episodeTitle = episode.subtitle ?? 'No Title';

    if (episodeNumber == null) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          episodeTitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: episode.update != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '更新日: ${episode.update}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            : null,
      );
    }

    final downloadStatusAsync = ref.watch(
      episodeDownloadStatusProvider(ncode: ncode, episode: episodeNumber),
    );
    final isOffline = ref.watch(isOfflineProvider);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '第$episodeNumber話',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            episodeTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
      subtitle: episode.update != null
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '更新日: ${episode.update}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          : null,
      trailing: isOffline
          ? null
          : downloadStatusAsync.when(
              data: (status) {
                if (status == 2) {
                  return IconButton(
                    icon: Icon(
                      Icons.download_done,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: null,
                  );
                } else if (status == 3) {
                  return IconButton(
                    icon: Icon(
                      Icons.download,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () {
                      unawaited(_handleDownload(context, ref, episodeNumber));
                    },
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      unawaited(_handleDownload(context, ref, episodeNumber));
                    },
                  );
                }
              },
              loading: () => const SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              error: (e, s) => IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  unawaited(_handleDownload(context, ref, episodeNumber));
                },
              ),
            ),
      onTap: () {
        final uri = Uri(
          path: '/novel/$ncode/$episodeNumber',
          queryParameters: episode.revised != null
              ? {'revised': episode.revised}
              : null,
        );
        unawaited(context.push(uri.toString()));
      },
    );
  }

  Future<void> _handleDownload(
    BuildContext context,
    WidgetRef ref,
    int episodeNumber,
  ) async {
    final repo = ref.read(novelRepositoryProvider);

    try {
      final success = await repo.downloadSingleEpisode(
        ncode,
        episodeNumber,
        revised: episode.revised,
      );

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ダウンロードしました')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ダウンロードに失敗しました')),
        );
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    }
  }
}
