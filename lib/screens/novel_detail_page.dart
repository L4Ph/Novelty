import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/models/download_result.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/providers/connectivity_provider.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

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
    final isFavoriteAsync = ref.watch(libraryStatusProvider(widget.ncode));
    final isInLibrary = isFavoriteAsync.value ?? false;
    final downloadStatusAsync = ref.watch(downloadStatusProvider(novelInfo));
    final isDownloaded = downloadStatusAsync.value ?? false;

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

    final lastReadEpisode = ref
        .watch(lastReadEpisodeProvider(widget.ncode))
        .value;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Short story: always go to episode 1.
          if (isShortStory) {
            await context.push('/novel/${widget.ncode}/1');
            return;
          }

          // Series: go to last read episode or episode 1.
          final targetEpisode = lastReadEpisode ?? 1;
          await context.push('/novel/${widget.ncode}/$targetEpisode');
        },
        icon: const Icon(Icons.menu_book),
        label: Text(
          isShortStory
              ? '読む'
              : (lastReadEpisode != null ? '第$lastReadEpisode話から読む' : '第1話を読む'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(novelInfoWithCacheProvider(widget.ncode));
          for (var i = 1; i <= _currentPage; i++) {
            ref.invalidate(episodeListProvider('${widget.ncode}_$i'));
          }
          await Future<void>.delayed(const Duration(milliseconds: 800));
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              title: AnimatedOpacity(
                opacity: _showTitle ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  novelInfo.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: progressBar,
              ),
              actions: [
                IconButton(
                  tooltip: '共有',
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    final url = 'https://ncode.syosetu.com/${novelInfo.ncode}/';
                    unawaited(
                      SharePlus.instance.share(
                        ShareParams(text: '${novelInfo.title}\n$url'),
                      ),
                    );
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'download') {
                      if (isDownloaded) {
                        unawaited(_handleDelete(context, ref, novelInfo));
                      } else {
                        unawaited(_handleDownload(context, ref, novelInfo));
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'download',
                        child: Row(
                          children: [
                            Icon(
                              isDownloaded ? Icons.delete : Icons.download,
                              color: isDownloaded
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(isDownloaded ? 'ダウンロード削除' : '一括ダウンロード'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      novelInfo.title ?? '',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                    ),
                    const SizedBox(height: 12),
                    // Writer
                    Text(
                      novelInfo.writer ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Library Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: isInLibrary
                          ? FilledButton.tonalIcon(
                              onPressed: () {
                                unawaited(
                                  ref
                                      .read(
                                        libraryStatusProvider(
                                          widget.ncode,
                                        ).notifier,
                                      )
                                      .toggle(novelInfo),
                                );
                              },
                              icon: const Icon(Icons.favorite),
                              label: const Text('ライブラリ登録済み'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                              ),
                            )
                          : FilledButton.icon(
                              onPressed: () {
                                unawaited(
                                  ref
                                      .read(
                                        libraryStatusProvider(
                                          widget.ncode,
                                        ).notifier,
                                      )
                                      .toggle(novelInfo),
                                );
                              },
                              icon: const Icon(Icons.favorite_border),
                              label: const Text('ライブラリに追加'),
                            ),
                    ),
                    const SizedBox(height: 32),
                    // Keywords (Tags)
                    if (novelInfo.keyword != null) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: novelInfo.keyword!
                              .split(' ')
                              .where((k) => k.isNotEmpty)
                              .map((keyword) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Chip(
                                    label: Text(keyword),
                                    visualDensity: VisualDensity.compact,
                                    side: BorderSide.none,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHigh,
                                    padding: EdgeInsets.zero,
                                    labelStyle: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Story
                    _StorySection(
                      story: novelInfo.story ?? '',
                      isShortStory: isShortStory,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            if (isShortStory)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: SizedBox(height: 100),
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
            // Add extra padding at the bottom for FAB
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _StorySection extends StatefulWidget {
  const _StorySection({
    required this.story,
    this.isShortStory = false,
  });

  final String story;
  final bool isShortStory;

  @override
  _StorySectionState createState() => _StorySectionState();
}

class _StorySectionState extends State<_StorySection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.story.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isShortStory) ...[
          Text(
            'あらすじ',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
        ],
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: Text(
            widget.story,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
          secondChild: Text(
            widget.story,
            style: textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
          crossFadeState: isExpanded || widget.isShortStory
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        if (!widget.isShortStory)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              child: Text(isExpanded ? '閉じる' : 'もっと読む'),
              onPressed: () => setState(() => isExpanded = !isExpanded),
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
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Text(
                '全$totalEpisodes話',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
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

class _EpisodeListTile extends ConsumerWidget {
  const _EpisodeListTile({
    required this.episode,
    required this.ncode,
  });

  final Episode episode;
  final String ncode;

  int? extractEpisodeNumber(String? url) {
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
    final episodeNumber = extractEpisodeNumber(episode.url);
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

    // Determine swipe background colors and icons
    Widget buildSwipeBackground({
      required Alignment alignment,
      required Color color,
      required Color onColor,
      required IconData icon,
      required String label,
    }) {
      return Container(
        color: color,
        alignment: alignment,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (alignment == Alignment.centerRight) ...[
              Text(
                label,
                style: TextStyle(
                  color: onColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(icon, color: onColor),
            if (alignment == Alignment.centerLeft) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: onColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      );
    }

    final isDownloaded =
        downloadStatusAsync.asData?.value == 2; // 2 = Success, 3 = Fail

    return Dismissible(
      key: Key('episode_$ncode$episodeNumber'),
      direction: isOffline
          ? DismissDirection.none
          : DismissDirection.horizontal,
      background: buildSwipeBackground(
        alignment: Alignment.centerLeft,
        color: Theme.of(context).colorScheme.primary,
        onColor: Theme.of(context).colorScheme.onPrimary,
        icon: Icons.download,
        label: 'ダウンロード',
      ),
      secondaryBackground: buildSwipeBackground(
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        onColor: Theme.of(context).colorScheme.onError,
        icon: Icons.delete,
        label: '削除',
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe Right -> Download
          if (isDownloaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('既にダウンロード済みです')),
            );
            return false;
          }
          await handleDownload(context, ref, episodeNumber);
          return false; // Don't dismiss
        } else if (direction == DismissDirection.endToStart) {
          // Swipe Left -> Delete
          // We attempt delete even if UI thinks it's not downloaded, just in case state is out of sync.
          // DB update is safe to run on non-downloaded items (no-op).
          await handleDelete(context, ref, episodeNumber);
          return false; // Don't dismiss
        }
        return false;
      },
      child: ListTile(
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
        trailing: downloadStatusAsync.when(
          data: (status) {
            if (status == 2) {
              return Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              );
            }
            return null;
          },
          loading: () => const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, _) => Icon(
            Icons.error_outline,
            size: 16,
            color: Theme.of(context).colorScheme.error,
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
      ),
    );
  }

  Future<void> handleDelete(
    BuildContext context,
    WidgetRef ref,
    int episodeNumber,
  ) async {
    final repo = ref.read(novelRepositoryProvider);
    try {
      await repo.deleteDownloadedEpisode(ncode, episodeNumber);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('削除しました')),
        );
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('削除に失敗しました: $e')),
        );
      }
    }
  }

  Future<void> handleDownload(
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
