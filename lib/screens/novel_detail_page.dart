import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/database/database.dart' hide Episode;
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_content.dart';
import 'package:riverpod/src/providers/future_provider.dart';

final FutureProviderFamily<NovelInfo, String> novelInfoProvider = FutureProvider
    .autoDispose
    .family<NovelInfo, String>((
      ref,
      ncode,
    ) async {
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

      var companion = novelInfo.toDbCompanion();
      if (cachedNovel?.fav != null) {
        companion = companion.copyWith(fav: drift.Value(cachedNovel!.fav));
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

final FutureProviderFamily<Episode, String> shortStoryEpisodeProvider =
    FutureProvider.autoDispose.family<Episode, String>((ref, ncode) async {
      final apiService = ref.read(apiServiceProvider);
      return apiService.fetchEpisode(ncode, 1);
    });

final isFavoriteProvider = StreamProvider.autoDispose.family<bool, String>((ref, ncode) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchIsFavorite(ncode);
});

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
    final isInLibrary = ref.watch(isFavoriteProvider(ncode));

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
          actions: [
            isInLibrary.when(
              data: (inLibrary) => IconButton(
                icon: Icon(inLibrary ? Icons.favorite : Icons.favorite_border),
                onPressed: () => _toggleLibraryStatus(ref, novelInfo),
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
        actions: [
          isInLibrary.when(
            data: (inLibrary) => IconButton(
              icon: Icon(inLibrary ? Icons.favorite : Icons.favorite_border),
              onPressed: () => _toggleLibraryStatus(ref, novelInfo),
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

  Future<void> _toggleLibraryStatus(WidgetRef ref, NovelInfo novelInfo) async {
    final db = ref.read(appDatabaseProvider);
    final existingNovel = await db.getNovel(ncode);
    final inLibrary = existingNovel?.fav == 1;

    if (existingNovel != null) {
      await (db.update(
        db.novels,
      )..where((tbl) => tbl.ncode.equals(ncode))).write(
        NovelsCompanion(
          fav: drift.Value(inLibrary ? 0 : 1),
        ),
      );
    } else {
      final companion = novelInfo.toDbCompanion().copyWith(
        fav: const drift.Value(1),
      );
      await db.insertNovel(companion);
    }

    if (ref.context.mounted) {
      ScaffoldMessenger.of(ref.context).showSnackBar(
        SnackBar(content: Text(inLibrary ? 'ライブラリから削除しました' : 'ライブラリに追加しました')),
      );
    }
    ref
      ..invalidate(isFavoriteProvider(ncode))
      ..invalidate(libraryNovelsProvider);
    // Invalidate all ranking data providers
    ref.invalidate(rankingDataProvider('d'));
    ref.invalidate(rankingDataProvider('w'));
    ref.invalidate(rankingDataProvider('m'));
    ref.invalidate(rankingDataProvider('q'));
    ref.invalidate(rankingDataProvider('all'));
  }
}
