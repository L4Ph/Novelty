import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/database/database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Download Summary Tests', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase.memory();
    });

    tearDown(() async {
      await database.close();
    });

    const ncode = 'n1234ab';
    final normalizedNcode = ncode.toLowerCase();

    Future<void> insertNovelWithEpisodes() async {
      // Insert Novel
      await database
          .into(database.novels)
          .insert(
            NovelsCompanion(
              ncode: Value(normalizedNcode),
              title: const Value('Test Novel'),
              generalAllNo: const Value(10), // Total 10 episodes
            ),
          );

      // Insert Episodes
      // 1. Downloaded (Success)
      await database
          .into(database.episodeEntities)
          .insert(
            EpisodeEntitiesCompanion(
              ncode: Value(normalizedNcode),
              episodeId: const Value(1),
              content: Value([NovelContentElement.plainText('Content 1')]),
            ),
          );

      // 2. Downloaded (Success)
      await database
          .into(database.episodeEntities)
          .insert(
            EpisodeEntitiesCompanion(
              ncode: Value(normalizedNcode),
              episodeId: const Value(2),
              content: Value([NovelContentElement.plainText('Content 2')]),
            ),
          );

      // 3. Downloaded (Failed - Empty List)
      await database
          .into(database.episodeEntities)
          .insert(
            EpisodeEntitiesCompanion(
              ncode: Value(normalizedNcode),
              episodeId: const Value(3),
              content: const Value([]), // Empty list means failure
            ),
          );

      // 4. Not Downloaded (Null content)
      await database
          .into(database.episodeEntities)
          .insert(
            EpisodeEntitiesCompanion(
              ncode: Value(normalizedNcode),
              episodeId: const Value(4),
              content: const Value(null),
            ),
          );

      // 5. Downloaded (Success - Content with structure)
      await database
          .into(database.episodeEntities)
          .insert(
            EpisodeEntitiesCompanion(
              ncode: Value(normalizedNcode),
              episodeId: const Value(5),
              content: Value([NovelContentElement.rubyText('漢字', 'かんじ')]),
            ),
          );
    }

    test('watchDownloadingNovels should include downloading novel', () async {
      await insertNovelWithEpisodes();

      // Current status: 3 success, 1 failure, total 10.
      // 3+1 = 4 downloaded. 10 total. Status should be Downloading (1).
      // If success+failure >= total, it's Downloaded (2).

      final stream = database.watchDownloadingNovels();
      final list = await stream.first;

      expect(list.length, 1);
      expect(list.first.ncode, normalizedNcode);
      expect(list.first.successCount, 3);
    });

    test(
      'watchCompletedDownloads should include fully downloaded novel',
      () async {
        await database
            .into(database.novels)
            .insert(
              NovelsCompanion(
                ncode: Value(normalizedNcode),
                title: const Value('Completed Novel'),
                generalAllNo: const Value(2),
              ),
            );

        await database
            .into(database.episodeEntities)
            .insert(
              EpisodeEntitiesCompanion(
                ncode: Value(normalizedNcode),
                episodeId: const Value(1),
                content: Value([NovelContentElement.plainText('1')]),
              ),
            );
        await database
            .into(database.episodeEntities)
            .insert(
              EpisodeEntitiesCompanion(
                ncode: Value(normalizedNcode),
                episodeId: const Value(2),
                content: Value([NovelContentElement.plainText('2')]),
              ),
            );

        final stream = database.watchCompletedDownloads();
        final list = await stream.first;

        expect(list.length, 1);
        expect(list.first.ncode, normalizedNcode);
        expect(list.first.successCount, 2);
      },
    );
  });
}
