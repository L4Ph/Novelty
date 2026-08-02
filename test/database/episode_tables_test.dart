import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/sites/novel_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EpisodeListEntries / EpisodeContents テーブル', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.memory();
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> insertDummyNovel(String ncode) async {
      await db
          .into(db.novels)
          .insert(
            NovelsCompanion(
              source: const Value(NovelSource.narou),
              workId: Value(ncode),
              title: const Value('dummy title'),
              writer: const Value('dummy writer'),
            ),
          );
    }

    test('目次のupsertと取得ができること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      await db.upsertEpisodes([
        const EpisodeListEntriesCompanion(
          source: Value(NovelSource.narou),
          workId: Value(ncode),
          episodeId: Value(1),
          subtitle: Value('第1話'),
          url: Value('https://example.com/1'),
          publishedAt: Value('2024-01-01 00:00:00'),
          revisedAt: Value('2024-01-02 00:00:00'),
        ),
      ]);

      // 目次の取得日時が記録されていること
      final rows = await db.select(db.episodeListEntries).get();
      expect(rows.length, 1);
      expect(rows.single.subtitle, '第1話');
      expect(rows.single.fetchedAt, isNotNull);

      final episodes = await db.getEpisodesRange(
        NovelSource.narou,
        ncode,
        1,
        100,
      );
      expect(episodes.length, 1);
      expect(episodes.single.subtitle, '第1話');
      expect(episodes.single.revised, '2024-01-02 00:00:00');
      expect(episodes.single.isDownloaded, isFalse);
    });

    test('目次の再upsertでメタデータが上書きされること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      await db.upsertEpisodes([
        const EpisodeListEntriesCompanion(
          source: Value(NovelSource.narou),
          workId: Value(ncode),
          episodeId: Value(1),
          subtitle: Value('第1話'),
          url: Value('https://example.com/1'),
        ),
      ]);
      await db.upsertEpisodes([
        const EpisodeListEntriesCompanion(
          source: Value(NovelSource.narou),
          workId: Value(ncode),
          episodeId: Value(1),
          subtitle: Value('第1話(改稿)'),
          url: Value('https://example.com/1'),
        ),
      ]);

      final episodes = await db.getEpisodesRange(
        NovelSource.narou,
        ncode,
        1,
        100,
      );
      expect(episodes.single.subtitle, '第1話(改稿)');
    });

    test('本文の保存と取得ができること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      await db.upsertEpisodes([
        const EpisodeListEntriesCompanion(
          source: Value(NovelSource.narou),
          workId: Value(ncode),
          episodeId: Value(1),
          subtitle: Value('第1話'),
          url: Value('https://example.com/1'),
        ),
      ]);

      await db.updateEpisodeContent(
        source: NovelSource.narou,
        workId: ncode,
        episodeId: 1,
        content: [NovelContentElement.plainText('本文テキスト')],
        fetchedAt: 1234567890,
        revisedAt: '2024-02-01 00:00:00',
      );

      final data = await db.getEpisodeData(NovelSource.narou, ncode, 1);
      expect(data, isNotNull);
      expect(data!.subtitle, '第1話');
      expect(data.content, isNotNull);
      expect(data.content!.length, 1);
      expect(data.fetchedAt, 1234567890);
      expect(data.revisedAt, '2024-02-01 00:00:00');

      // 本文取得済みはダウンロード済み扱いになること
      final episodes = await db.getEpisodesRange(
        NovelSource.narou,
        ncode,
        1,
        100,
      );
      expect(episodes.single.isDownloaded, isTrue);
    });

    test('本文の取得日時が目次とは独立して記録されること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      await db.updateEpisodeContent(
        source: NovelSource.narou,
        workId: ncode,
        episodeId: 1,
        content: [NovelContentElement.plainText('本文テキスト')],
        fetchedAt: 111,
      );

      final contents = await db.select(db.episodeContents).get();
      expect(contents.length, 1);
      expect(contents.single.fetchedAt, 111);

      // 本文のみの場合でも目次行が作られ、目次の取得日時はNULLのままであること
      final listRows = await db.select(db.episodeListEntries).get();
      expect(listRows.length, 1);
      expect(listRows.single.fetchedAt, isNull);
    });

    test('watchEpisodesRangeが本文の保存を検知すること', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      await db.upsertEpisodes([
        const EpisodeListEntriesCompanion(
          source: Value(NovelSource.narou),
          workId: Value(ncode),
          episodeId: Value(1),
          subtitle: Value('第1話'),
        ),
      ]);

      final stream = db.watchEpisodesRange(NovelSource.narou, ncode, 1, 100);
      final expectation = expectLater(
        stream,
        emitsInOrder([
          predicate<List<Episode>>(
            (list) => !list.single.isDownloaded,
          ),
          predicate<List<Episode>>(
            (list) => list.single.isDownloaded,
          ),
        ]),
      );

      await Future<void>.delayed(Duration.zero);
      await db.updateEpisodeContent(
        source: NovelSource.narou,
        workId: ncode,
        episodeId: 1,
        content: [NovelContentElement.plainText('本文テキスト')],
        fetchedAt: 222,
      );

      await expectation;
    });

    test('取得日時がNULLの行が含まれる場合、最古取得日時はNULLを返すこと', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      // updateEpisodeContentを直接呼ぶと、目次行は作られるがfetchedAtはNULLのまま
      await db.updateEpisodeContent(
        source: NovelSource.narou,
        workId: ncode,
        episodeId: 1,
        content: [NovelContentElement.plainText('本文テキスト')],
        fetchedAt: 222,
      );

      // episodeId=1の目次行はfetchedAtがNULLのままであること
      final listRows = await db.select(db.episodeListEntries).get();
      expect(listRows.single.fetchedAt, isNull);

      // NULL行が含まれるため、最古取得日時はNULL（TTL切れ）として返されること
      final oldest = await db.getEpisodeListOldestFetchedAt(
        NovelSource.narou,
        ncode,
        1,
        100,
      );
      expect(oldest, isNull);
    });

    test('全行の取得日時が設定されている場合、最古取得日時を返すこと', () async {
      const ncode = 'n1234ab';
      await insertDummyNovel(ncode);

      await db
          .into(db.episodeListEntries)
          .insert(
            const EpisodeListEntriesCompanion(
              source: Value(NovelSource.narou),
              workId: Value(ncode),
              episodeId: Value(1),
              subtitle: Value('第1話'),
              url: Value('https://example.com/1'),
              fetchedAt: Value(1000),
            ),
          );

      final oldest = await db.getEpisodeListOldestFetchedAt(
        NovelSource.narou,
        ncode,
        1,
        100,
      );
      expect(oldest, 1000);
    });
  });
}
