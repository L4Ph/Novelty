import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/database/database.dart' hide Episode;
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/widgets/novel_content.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'novel_detail_page.g.dart';

final novelInfoProvider =
    FutureProvider.autoDispose.family<NovelInfo, String>((ref, ncode) async {
  final apiService = ref.read(apiServiceProvider);
  final db = ref.watch(appDatabaseProvider);

  // まずDBから取得試行
  final cachedNovel = await db.getNovel(ncode);
  if (cachedNovel != null) {
    // TODO: キャッシュ有効期限チェック
    // return NovelInfo.fromDb(cachedNovel);
  }

  // なければAPIから取得
  final novelInfo = await apiService.fetchNovelInfo(ncode);
  final existingNovel = await db.getNovel(ncode);

  var companion = novelInfo.toDbCompanion();
  if (existingNovel?.fav != null) {
    companion = companion.copyWith(fav: drift.Value(existingNovel!.fav));
  }

  await db.insertNovel(companion);

  // 履歴に追加
  await db.addToHistory(
    HistoryCompanion(
      ncode: drift.Value(ncode),
      title: drift.Value(novelInfo.title),
      writer: drift.Value(novelInfo.writer),
      viewedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
    ),
  );

  return novelInfo;
});

final shortStoryEpisodeProvider =
    FutureProvider.autoDispose.family<Episode, String>((ref, ncode) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchEpisode(ncode, 1);
});

@riverpod
class IsInLibrary extends _$IsInLibrary {
  @override
  Future<bool> build(String ncode) async {
    final db = ref.watch(appDatabaseProvider);
    final novel = await db.getNovel(ncode);
    return novel?.fav == 1;
  }

  Future<void> toggle(NovelInfo novelInfo) async {
    final db = ref.read(appDatabaseProvider);
    final currentStatus = await future;
    final newStatus = !currentStatus;

    final companion = novelInfo.toDbCompanion().copyWith(
          fav: drift.Value(newStatus ? 1 : 0),
        );
    await db.insertNovel(companion);

    ref.invalidateSelf();
    ref.invalidate(libraryNovelsProvider);
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
    final isInLibraryAsync = ref.watch(isInLibraryProvider(ncode));

    final favoriteIcon = isInLibraryAsync.when(
      data: (inLibrary) => IconButton(
        icon: Icon(inLibrary ? Icons.favorite : Icons.favorite_border),
        onPressed: () async {
          await ref.read(isInLibraryProvider(ncode).notifier).toggle(novelInfo);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(!inLibrary ? 'ライブラリに追加しました' : 'ライブラリから削除しました'),
              ),
            );
          }
        },
      ),
      loading: () => const IconButton(
        icon: Icon(Icons.favorite_border),
        onPressed: null,
      ),
      error: (e, s) => const IconButton(
        icon: Icon(Icons.error),
        onPressed: null,
      ),
    );

    if (isShortStory) {
      final shortStoryEpisodeAsync = ref.watch(
        shortStoryEpisodeProvider(ncode),
      );
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(novelInfo.title ?? ''),
          actions: [favoriteIcon],
        ),
        body: shortStoryEpisodeAsync.when(
          data: (episode) => NovelContent(
            ncode: ncode,
            episode: 1,
            initialData: episode,
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
        actions: [favoriteIcon],
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
