import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/database/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  test('Search novels returns correct results', () async {
    // Arrange
    await db.insertNovel(
      NovelsCompanion.insert(
        ncode: 'n1234a',
        title: const Value('転生したらスライムだった件'),
        writer: const Value('伏瀬'),
        story: const Value('スライムに転生してしまった。'),
      ),
    );
    await db.insertNovel(
      NovelsCompanion.insert(
        ncode: 'n5678b',
        title: const Value('無職転生'),
        writer: const Value('理不尽な孫の手'),
        story: const Value('異世界に行きたい。'),
      ),
    );

    // Act & Assert
    // Title search
    final results1 = await db.searchNovels('スライム');
    expect(results1.length, 1);
    expect(results1.first.title, '転生したらスライムだった件');

    // Writer search
    final results2 = await db.searchNovels('孫の手');
    expect(results2.length, 1);
    expect(results2.first.title, '無職転生');

    // Story search
    final results3 = await db.searchNovels('異世界');
    expect(results3.length, 1);
    expect(results3.first.title, '無職転生');

    // No match
    final results4 = await db.searchNovels('ドラゴン');
    expect(results4.isEmpty, true);
  });

  test('Search episodes returns correct results', () async {
    // Arrange
    await db.insertNovel(
      NovelsCompanion.insert(
        ncode: 'n1234a',
        title: const Value('Test Novel'),
      ),
    );
    await db.upsertEpisodes([
      EpisodeEntitiesCompanion.insert(
        ncode: 'n1234a',
        episodeId: 1,
        subtitle: const Value('プロローグ'),
      ),
      EpisodeEntitiesCompanion.insert(
        ncode: 'n1234a',
        episodeId: 2,
        subtitle: const Value('旅立ち'),
      ),
    ]);

    // Update content (this triggers the FTS update via updateEpisodeContent)
    await db.updateEpisodeContent(
      EpisodeEntitiesCompanion(
        ncode: const Value('n1234a'),
        episodeId: const Value(1),
        content: Value([
          NovelContentElement.plainText('昔々あるところに'),
        ]),
        fetchedAt: const Value(1234567890),
        subtitle: const Value('プロローグ'),
        url: const Value('http://example.com/1'),
      ),
    );

    await db.updateEpisodeContent(
      EpisodeEntitiesCompanion(
        ncode: const Value('n1234a'),
        episodeId: const Value(2),
        content: Value([
          NovelContentElement.plainText('勇者は旅に出た'),
        ]),
        fetchedAt: const Value(1234567890),
        subtitle: const Value('旅立ち'),
        url: const Value('http://example.com/2'),
      ),
    );

    // Act & Assert
    // Subtitle search
    final results1 = await db.searchEpisodes('プロローグ');
    expect(results1.length, 1);
    expect(results1.first.subtitle, 'プロローグ');

    // Content search
    final results2 = await db.searchEpisodes('勇者は'); // Try 3 chars
    expect(results2.length, 1);
    expect(results2.first.subtitle, '旅立ち');

    // No match
    final results3 = await db.searchEpisodes('魔王');
    expect(results3.isEmpty, true);
  });

  test('Deleting novel removes from search index', () async {
    // Arrange
    await db.insertNovel(
      NovelsCompanion.insert(
        ncode: 'n1234a',
        title: const Value('Delete Me'),
      ),
    );

    // Verify it exists
    expect((await db.searchNovels('Delete')).length, 1);

    // Act
    // We don't have a deleteNovel method exposed in AppDatabase yet,
    // but we can use removeFromLibrary if it cascades?
    // Actually removeFromLibrary only deletes from library_entries.
    // We need to verify triggers on 'novels' table.
    // Let's use customStatement to delete for test purpose or add deleteNovel method.
    // Or just use deleteHistory if it was cascading? No.

    // Let's add a delete helper in test or just use customStatement.
    await db.customStatement('DELETE FROM novels WHERE ncode = ?', ['n1234a']);

    // Assert
    expect((await db.searchNovels('Delete')).isEmpty, true);
  });
}
