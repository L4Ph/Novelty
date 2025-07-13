import 'dart:io' show Platform;

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_content.dart';
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
Future<List<NovelContentElement>> shortStoryContent(
  Ref ref,
  String ncode,
) async {
  final repo = ref.read(novelRepositoryProvider);
  return repo.getEpisode(ncode, 1);
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

      // TODO(L4Ph): ダウンロード中の状態をUIに反映する
      await repo.downloadNovel(novelInfo);
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ダウンロードに失敗しました: $e')),
        );
      }
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
        appBar: AppBar(),
        body: Center(child: Text('Failed to load novel info: $err')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    NovelInfo novelInfo,
  ) {
    final isShortStory =
        novelInfo.novelType == 2 || (novelInfo.episodes?.isEmpty ?? true);
    final isFavoriteAsync = ref.watch(favoriteStatusProvider(ncode));
    final downloadStatusAsync = ref.watch(downloadStatusProvider(novelInfo));

    if (isShortStory) {
      final shortStoryContentAsync = ref.watch(
        shortStoryContentProvider(ncode),
      );
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(novelInfo.title ?? ''),
          actions: [
            downloadStatusAsync.when(
              data: (isDownloaded) => IconButton(
                icon: Icon(isDownloaded ? Icons.download_done : Icons.download),
                onPressed: () => ref
                    .read(downloadStatusProvider(novelInfo).notifier)
                    .toggle(context, novelInfo),
              ),
              loading: () => const IconButton(
                icon: Icon(Icons.download),
                onPressed: null,
              ),
              error: (e, s) => const IconButton(
                icon: Icon(Icons.error),
                onPressed: null,
              ),
            ),
            isFavoriteAsync.when(
              data: (isFavorite) => IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () => ref
                    .read(favoriteStatusProvider(ncode).notifier)
                    .toggle(novelInfo),
              ),
              loading: () => const IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: null,
              ),
              error: (e, s) => const IconButton(
                icon: Icon(Icons.error),
                onPressed: null,
              ),
            ),
          ],
        ),
        body: shortStoryContentAsync.when(
          data: (content) => NovelContent(
            ncode: ncode,
            episode: 1,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(novelInfo.title ?? '目次'),
        actions: [
          downloadStatusAsync.when(
            data: (isDownloaded) => IconButton(
              icon: Icon(isDownloaded ? Icons.download_done : Icons.download),
              onPressed: () => ref
                  .read(downloadStatusProvider(novelInfo).notifier)
                  .toggle(context, novelInfo),
            ),
            loading: () => const IconButton(
              icon: Icon(Icons.download),
              onPressed: null,
            ),
            error: (e, s) => const IconButton(
              icon: Icon(Icons.error),
              onPressed: null,
            ),
          ),
          isFavoriteAsync.when(
            data: (isFavorite) => IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () => ref
                  .read(favoriteStatusProvider(ncode).notifier)
                  .toggle(novelInfo),
            ),
            loading: () => const IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: null,
            ),
            error: (e, s) => const IconButton(
              icon: Icon(Icons.error),
              onPressed: null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (novelInfo.story != null && novelInfo.story!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Card(
                child: ExpansionTile(
                  title: Text(
                    '作品情報',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  childrenPadding: const EdgeInsets.all(16),
                  children: [
                    if (novelInfo.writer != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '作者: ${novelInfo.writer}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      novelInfo.story!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: novelInfo.episodes?.length ?? 0,
              itemBuilder: (context, index) {
                final episode = novelInfo.episodes![index];
                final episodeTitle = episode.subtitle ?? 'No Title';
                return ListTile(
                  title: Text(episodeTitle),
                  subtitle: episode.update != null
                      ? Text('更新: ${episode.update}')
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
          ),
        ],
      ),
    );
  }
}
