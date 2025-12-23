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
  final List<Episode> _episodes = [];
  bool _isLoadingEpisodes = false;
  bool _hasMoreEpisodes = true;
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadMoreEpisodes());
  }

  Future<void> _loadMoreEpisodes() async {
    if (_isLoadingEpisodes || !_hasMoreEpisodes) {
      return;
    }

    // すべてのエピソードを読み込み済みかチェック
    final novelInfo = ref
        .read(novelInfoWithCacheProvider(widget.ncode))
        .unwrapPrevious()
        .asData
        ?.value;
    if (novelInfo != null && novelInfo.generalAllNo != null) {
      if (_episodes.length >= novelInfo.generalAllNo!) {
        if (mounted) {
          setState(() {
            _hasMoreEpisodes = false;
          });
        }
        return;
      }
    }

    setState(() {
      _isLoadingEpisodes = true;
    });

    try {
      final newEpisodes = await ref.read(
        episodeListProvider('${widget.ncode}_$_currentPage').future,
      );

      if (newEpisodes.isEmpty) {
        _hasMoreEpisodes = false;
      } else {
        // 重複チェック
        final duplicate =
            _episodes.isNotEmpty &&
            _episodes.any((e) => e.url == newEpisodes.first.url);

        if (duplicate) {
          _hasMoreEpisodes = false;
        } else {
          _episodes.addAll(newEpisodes);
          _currentPage++;
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エピソードの読み込みに失敗しました: $e')),
        );
      }
      _hasMoreEpisodes = false;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingEpisodes = false;
          _initialLoadDone = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final novelInfoAsync = ref.watch(novelInfoWithCacheProvider(widget.ncode));

    return novelInfoAsync.when(
      data: (novelInfo) => _buildContent(context, novelInfo),
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Failed to load novel info: $err')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    NovelInfo novelInfo,
  ) {
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
          for (var i = 1; i < _currentPage; i++) {
            ref.invalidate(episodeListProvider('${widget.ncode}_$i'));
          }

          setState(() {
            _episodes.clear();
            _currentPage = 1;
            _hasMoreEpisodes = true;
            _initialLoadDone = false;
          });
          await _loadMoreEpisodes();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text(
                novelInfo.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                episodes: _episodes,
                isLoading: _isLoadingEpisodes,
                hasMore: _hasMoreEpisodes,
                initialLoadDone: _initialLoadDone,
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
    required this.initialLoadDone,
    required this.onLoadMoreRequested,
  });

  final String ncode;
  final int totalEpisodes;
  final List<Episode> episodes;
  final bool isLoading;
  final bool hasMore;
  final bool initialLoadDone;
  final VoidCallback onLoadMoreRequested;

  @override
  Widget build(BuildContext context) {
    if (!initialLoadDone) {
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
            if (!isLoading && hasMore) {
              unawaited(Future.microtask(onLoadMoreRequested));
            }
            return isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }

          final episode = episodes[episodeIndex];
          return _EpisodeListTile(
            episode: episode,
            ncode: ncode,
          );
        },
        childCount: episodes.length + 2,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(episodeTitle),
        subtitle: episode.update != null
            ? Text('更新日: ${episode.update}')
            : null,
      );
    }

    final downloadStatusAsync = ref.watch(
      episodeDownloadStatusProvider(ncode: ncode, episode: episodeNumber),
    );
    final isOffline = ref.watch(isOfflineProvider);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(episodeTitle),
      subtitle: episode.update != null ? Text('更新日: ${episode.update}') : null,
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
          SnackBar(
            content: Text('第$episodeNumber話をダウンロードしました'),
            duration: const Duration(seconds: 1),
          ),
        );
        ref.invalidate(
          episodeDownloadStatusProvider(ncode: ncode, episode: episodeNumber),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('第$episodeNumber話のダウンロードに失敗しました'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('エラー: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
