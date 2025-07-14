import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'novel_detail_page.g.dart';

@riverpod
Future<NovelInfo> novelInfo(Ref ref, String ncode) async {
  final apiService = ref.read(apiServiceProvider);
  final db = ref.watch(appDatabaseProvider);

  final novelInfo = await apiService.fetchNovelInfo(ncode);

  // Insert into history
  await db.addToHistory(
    HistoryCompanion(
      ncode: drift.Value(ncode),
      title: drift.Value(novelInfo.title),
      writer: drift.Value(novelInfo.writer),
      viewedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
    ),
  );

  // Upsert novel data, preserving fav status
  final existing = await db.getNovel(ncode);
  await db.insertNovel(
    novelInfo.toDbCompanion().copyWith(
      fav: drift.Value(existing?.fav ?? 0),
    ),
  );

  return novelInfo;
}

@riverpod
class FavoriteStatus extends _$FavoriteStatus {
  @override
  Future<bool> build(String ncode) async {
    final db = ref.watch(appDatabaseProvider);
    final novel = await db.getNovel(ncode);
    return novel?.fav == 1;
  }

  Future<bool> toggle(NovelInfo novelInfo) async {
    final db = ref.read(appDatabaseProvider);
    final currentStatus = state.value ?? false;
    final newStatus = !currentStatus;

    state = const AsyncValue.loading();
    try {
      final companion = novelInfo.toDbCompanion().copyWith(
        fav: drift.Value(newStatus ? 1 : 0),
      );
      await db.insertNovel(companion);
      state = AsyncValue.data(newStatus);

      ref
        ..invalidate(libraryNovelsProvider)
        ..invalidate(rankingDataProvider('d'))
        ..invalidate(rankingDataProvider('w'))
        ..invalidate(rankingDataProvider('m'))
        ..invalidate(rankingDataProvider('q'))
        ..invalidate(rankingDataProvider('all'));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

@riverpod
class DownloadStatus extends _$DownloadStatus {
  @override
  Stream<bool> build(NovelInfo novelInfo) {
    final repo = ref.watch(novelRepositoryProvider);
    return repo.isNovelDownloaded(novelInfo);
  }

  Future<void> toggle(BuildContext context, NovelInfo novelInfo) async {
    final repo = ref.read(novelRepositoryProvider);
    final isDownloaded = state.value ?? false;
    final previousState = state;
    state = const AsyncValue.loading();

    try {
      if (isDownloaded) {
        await repo.deleteDownloadedNovel(novelInfo);
        return;
      }

      var hasPermission = false;
      if (Platform.isAndroid) {
        final status = await Permission.manageExternalStorage.status;
        if (status.isGranted) {
          hasPermission = true;
        } else {
          final result = await Permission.manageExternalStorage.request();
          if (result.isGranted) {
            hasPermission = true;
          }
        }
      } else {
        final status = await Permission.storage.status;
        if (status.isGranted) {
          hasPermission = true;
        } else {
          final result = await Permission.storage.request();
          if (result.isGranted) {
            hasPermission = true;
          }
        }
      }

      if (!hasPermission) {
        state = previousState;
        if (context.mounted) {
          await showDialog<void>(
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
                    openAppSettings();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
        return;
      }

      await repo.downloadNovel(novelInfo);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ダウンロードに失敗しました: $e')),
        );
      }
      await Future<void>.delayed(const Duration(seconds: 2));
      state = previousState;
    }
  }
}

class NovelDetailPage extends ConsumerWidget {
  const NovelDetailPage({super.key, required this.ncode});
  final String ncode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final novelInfoAsync = ref.watch(novelInfoProvider(ncode));

    return novelInfoAsync.when(
      data: (novelInfo) => _buildContent(context, ref, novelInfo),
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
    WidgetRef ref,
    NovelInfo novelInfo,
  ) {
    final isShortStory = novelInfo.generalAllNo == 1;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              novelInfo.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                    ncode,
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
                    onPressed: () => context.push('/novel/$ncode/1'),
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
            SliverToBoxAdapter(
              child: _buildEpisodeList(
                context,
                ref,
                novelInfo,
                ncode,
              ),
            ),
        ],
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
          Text(novelInfo.writer ?? 'Unknown'),
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

Widget _buildEpisodeList(
  BuildContext context,
  WidgetRef ref,
  NovelInfo novelInfo,
  String ncode,
) {
  final episodes = novelInfo.episodes ?? [];
  if (episodes.isEmpty) {
    return const SizedBox.shrink();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          '${novelInfo.generalAllNo} 話',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: episodes.length,
        itemBuilder: (context, index) {
          final episode = episodes[index];
          final episodeTitle = episode.subtitle ?? 'No Title';
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(episodeTitle),
            subtitle: episode.update != null
                ? Text('更新日: ${episode.update}')
                : null,
            onTap: () {
              final episodeUrl = episode.url;
              if (episodeUrl != null) {
                final match = RegExp(r'/(\d+)/').firstMatch(episodeUrl);
                if (match != null) {
                  final episodeNumber = match.group(1);
                  if (episodeNumber != null) {
                    context.push('/novel/$ncode/$episodeNumber');
                  }
                }
              }
            },
          );
        },
      ),
    ],
  );
}

Widget _buildActionButtons(
  BuildContext context,
  WidgetRef ref,
  NovelInfo novelInfo,
  String ncode,
) {
  final isFavoriteAsync = ref.watch(favoriteStatusProvider(ncode));
  final downloadStatusAsync = ref.watch(downloadStatusProvider(novelInfo));

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      isFavoriteAsync.when(
        data: (isFavorite) => _buildActionButton(
          context,
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          label: isFavorite ? '追加済' : 'ライブラリに追加',
          color: isFavorite ? Theme.of(context).colorScheme.primary : null,
          onPressed: () => ref
              .read(favoriteStatusProvider(ncode).notifier)
              .toggle(novelInfo),
        ),
        loading: () => _buildActionButton(
          context,
          icon: Icons.favorite_border,
          label: 'ライブラリに追加',
        ),
        error: (e, s) =>
            _buildActionButton(context, icon: Icons.error, label: 'Error'),
      ),
      downloadStatusAsync.when(
        data: (isDownloaded) => _buildActionButton(
          context,
          icon: isDownloaded
              ? Icons.download_done
              : Icons.download_for_offline_outlined,
          label: isDownloaded ? 'ダウンロード済' : 'ダウンロード',
          onPressed: () => ref
              .read(downloadStatusProvider(novelInfo).notifier)
              .toggle(context, novelInfo),
        ),
        loading: () => _buildActionButton(
          context,
          icon: Icons.download_for_offline_outlined,
          label: 'ダウンロード',
        ),
        error: (e, s) =>
            _buildActionButton(context, icon: Icons.error, label: 'Error'),
      ),
    ],
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
