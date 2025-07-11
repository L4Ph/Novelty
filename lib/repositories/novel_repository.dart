import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/novel_parser.dart';

final novelRepositoryProvider = Provider<NovelRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final database = ref.watch(appDatabaseProvider);
  return NovelRepository(apiService: apiService, database: database);
});

class NovelRepository {
  NovelRepository({
    required this.apiService,
    required this.database,
  });

  final ApiService apiService;
  final AppDatabase database;

  Future<List<NovelContentElement>> getEpisode(String ncode, int episode) async {
    // 1. Check local database first
    final downloadedEpisode = await database.getDownloadedEpisode(ncode, episode);
    if (downloadedEpisode != null) {
      return downloadedEpisode.content;
    }

    // 2. If not found, fetch from network
    final episodeData = await apiService.fetchEpisode(ncode, episode);
    if (episodeData.body == null) {
      return [];
    }

    // 3. Parse the HTML content
    final parsedContent = parseNovel(episodeData.body!);
    return parsedContent;
  }

  Future<void> downloadEpisode(String ncode, int episode) async {
    // 1. Check if already downloaded
    final existing = await database.getDownloadedEpisode(ncode, episode);
    if (existing != null) {
      return; // Already downloaded
    }

    // 2. Fetch from network
    final episodeData = await apiService.fetchEpisode(ncode, episode);
    if (episodeData.body == null) {
      throw Exception('Failed to fetch episode content');
    }

    // 3. Parse the HTML content
    final parsedContent = parseNovel(episodeData.body!);

    // 4. Save to database
    final companion = DownloadedEpisodesCompanion(
      ncode: Value(ncode),
      episode: Value(episode),
      title: Value(episodeData.subtitle),
      content: Value(parsedContent),
      downloadedAt: Value(DateTime.now().millisecondsSinceEpoch),
    );
    await database.insertDownloadedEpisode(companion);
  }

  Future<void> downloadNovel(NovelInfo novelInfo) async {
    final ncode = novelInfo.ncode!;
    if (novelInfo.novelType == 2) {
      await downloadEpisode(ncode, 1);
      return;
    }

    if (novelInfo.episodes == null) {
      return;
    }
    for (final episode in novelInfo.episodes!) {
      if (episode.index != null) {
        // TODO(L4Ph): 並列でダウンロードするように修正
        await downloadEpisode(ncode, episode.index!);
      }
    }
  }

  Future<void> deleteDownloadedEpisode(String ncode, int episode) async {
    await database.deleteDownloadedEpisode(ncode, episode);
  }

  Future<void> deleteDownloadedNovel(NovelInfo novelInfo) async {
    final ncode = novelInfo.ncode!;
    if (novelInfo.novelType == 2) {
      await deleteDownloadedEpisode(ncode, 1);
      return;
    }
    if (novelInfo.episodes == null) {
      return;
    }
    for (final episode in novelInfo.episodes!) {
      if (episode.index != null) {
        await deleteDownloadedEpisode(ncode, episode.index!);
      }
    }
  }

  Stream<bool> isEpisodeDownloaded(String ncode, int episode) {
    return database
        .getDownloadedEpisode(ncode, episode)
        .asStream()
        .map((event) => event != null);
  }

  Stream<bool> isNovelDownloaded(NovelInfo novelInfo) async* {
    final ncode = novelInfo.ncode!;
    if (novelInfo.novelType == 2) {
      yield* isEpisodeDownloaded(ncode, 1);
      return;
    }

    if (novelInfo.episodes == null || novelInfo.episodes!.isEmpty) {
      yield false;
      return;
    }

    // Listen to changes in the downloaded episodes table for this ncode
    final query = database.select(database.downloadedEpisodes)
      ..where((tbl) => tbl.ncode.equals(ncode));

    await for (final snapshot in query.watch()) {
      final downloadedIndexes = snapshot.map((e) => e.episode).toSet();
      final allEpisodesIndexes =
          novelInfo.episodes!.map((e) => e.index).whereType<int>().toSet();
      yield downloadedIndexes.containsAll(allEpisodesIndexes);
    }
  }
}
