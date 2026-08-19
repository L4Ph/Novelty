import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:sqlite3/sqlite3.dart';

/// スキーマバージョン15 → 16 のマイグレーションテスト。
/// 旧 `episodes` テーブルのデータが、目次テーブルと本文テーブルに
/// 欠損なく引き継がれることを検証する。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late File dbFile;

  setUp(() {
    dbFile = File(
      '${Directory.systemTemp.path}/novelty_migration_test_'
      '${DateTime.now().microsecondsSinceEpoch}.db',
    );
  });

  tearDown(() {
    if (dbFile.existsSync()) {
      dbFile.deleteSync();
    }
  });

  /// v15 相当のスキーマ(最小限のカラム)とデータを持つDBファイルを作成する
  Future<void> createV15Database(File file) async {
    final db = sqlite3.open(file.path);

    const statements = <String>[
      '''
      CREATE TABLE novels (
        ncode TEXT NOT NULL PRIMARY KEY,
        title TEXT,
        writer TEXT,
        user_id INTEGER,
        story TEXT,
        novel_type INTEGER,
        "end" INTEGER,
        genre INTEGER,
        isr15 INTEGER,
        isbl INTEGER,
        isgl INTEGER,
        iszankoku INTEGER,
        istensei INTEGER,
        istenni INTEGER,
        keyword TEXT,
        general_firstup INTEGER,
        general_lastup INTEGER,
        global_point INTEGER,
        fav INTEGER,
        review_count INTEGER,
        rate_count INTEGER,
        all_point INTEGER,
        point_count INTEGER,
        daily_point INTEGER,
        weekly_point INTEGER,
        monthly_point INTEGER,
        quarter_point INTEGER,
        yearly_point INTEGER,
        general_all_no INTEGER,
        novel_updated_at TEXT,
        cached_at INTEGER,
        is_private INTEGER NOT NULL DEFAULT 0
      )
      ''',
      '''
      CREATE TABLE episodes (
        ncode TEXT NOT NULL REFERENCES novels(ncode),
        episode_id INTEGER NOT NULL,
        subtitle TEXT,
        url TEXT,
        published_at TEXT,
        revised_at TEXT,
        content TEXT,
        fetched_at INTEGER,
        PRIMARY KEY (ncode, episode_id)
      )
      ''',
      "INSERT INTO novels (ncode, title) VALUES ('n1234ab', 'テスト小説')",
      '''
      INSERT INTO episodes VALUES (
        'n1234ab', 1, '第1話', 'https://example.com/1',
        '2024-01-01 00:00:00', '2024-01-02 00:00:00',
        '[{"runtimeType":"plainText","text":"本文"}]', 1000)
      ''',
      '''
      INSERT INTO episodes VALUES (
        'n1234ab', 2, '第2話', 'https://example.com/2',
        '2024-01-01 00:00:00', NULL, '[]', 2000)
      ''',
      '''
      INSERT INTO episodes
        (ncode, episode_id, subtitle, url, published_at, revised_at)
      VALUES (
        'n1234ab', 3, '第3話', 'https://example.com/3',
        '2024-01-03 00:00:00', '2024-01-04 00:00:00')
      ''',
      'PRAGMA user_version = 15',
    ];

    // 可読性のためforEachは使用しない
    // ignore: prefer_foreach
    for (final sql in statements) {
      db.execute(sql);
    }
    db.close();
  }

  /// 中断により中間状態が残った v15 相当の DB を作成する。
  /// episode_list_entries / episode_contents が既に存在し、
  /// episodes テーブルもまだ残っている状態を再現する。
  Future<void> createBrokenV15Database(File file) async {
    final db = sqlite3.open(file.path);

    const statements = <String>[
      '''
      CREATE TABLE novels (
        ncode TEXT NOT NULL PRIMARY KEY,
        title TEXT,
        writer TEXT,
        user_id INTEGER,
        story TEXT,
        novel_type INTEGER,
        "end" INTEGER,
        genre INTEGER,
        isr15 INTEGER,
        isbl INTEGER,
        isgl INTEGER,
        iszankoku INTEGER,
        istensei INTEGER,
        istenni INTEGER,
        keyword TEXT,
        general_firstup INTEGER,
        general_lastup INTEGER,
        global_point INTEGER,
        fav INTEGER,
        review_count INTEGER,
        rate_count INTEGER,
        all_point INTEGER,
        point_count INTEGER,
        daily_point INTEGER,
        weekly_point INTEGER,
        monthly_point INTEGER,
        quarter_point INTEGER,
        yearly_point INTEGER,
        general_all_no INTEGER,
        novel_updated_at TEXT,
        cached_at INTEGER,
        is_private INTEGER NOT NULL DEFAULT 0
      )
      ''',
      '''
      CREATE TABLE episodes (
        ncode TEXT NOT NULL REFERENCES novels(ncode),
        episode_id INTEGER NOT NULL,
        subtitle TEXT,
        url TEXT,
        published_at TEXT,
        revised_at TEXT,
        content TEXT,
        fetched_at INTEGER,
        PRIMARY KEY (ncode, episode_id)
      )
      ''',
      "INSERT INTO novels (ncode, title) VALUES ('n1234ab', 'テスト小説')",
      '''
      INSERT INTO episodes VALUES (
        'n1234ab', 1, '第1話', 'https://example.com/1',
        '2024-01-01 00:00:00', '2024-01-02 00:00:00',
        '[{"runtimeType":"plainText","text":"本文"}]', 1000)
      ''',
      '''
      INSERT INTO episodes VALUES (
        'n1234ab', 2, '第2話', 'https://example.com/2',
        '2024-01-01 00:00:00', NULL, '[]', 2000)
      ''',
      '''
      INSERT INTO episodes
        (ncode, episode_id, subtitle, url, published_at, revised_at)
      VALUES (
        'n1234ab', 3, '第3話', 'https://example.com/3',
        '2024-01-03 00:00:00', '2024-01-04 00:00:00')
      ''',
      // マイグレーションが中断された状態：目次・本文テーブルは存在するが
      // user_version や is_private カラムは更新されていない
      '''
      CREATE TABLE episode_list_entries (
        ncode TEXT NOT NULL REFERENCES novels(ncode),
        episode_id INTEGER NOT NULL,
        subtitle TEXT,
        url TEXT,
        published_at TEXT,
        revised_at TEXT,
        fetched_at INTEGER,
        PRIMARY KEY (ncode, episode_id)
      )
      ''',
      '''
      CREATE TABLE episode_contents (
        ncode TEXT NOT NULL REFERENCES novels(ncode),
        episode_id INTEGER NOT NULL,
        content TEXT,
        fetched_at INTEGER,
        revised_at TEXT,
        PRIMARY KEY (ncode, episode_id)
      )
      ''',
      '''
      INSERT INTO episode_list_entries
        (ncode, episode_id, subtitle, url, published_at, revised_at, fetched_at)
      SELECT ncode, episode_id, subtitle, url, published_at, revised_at, NULL
      FROM episodes
      ''',
      '''
      INSERT INTO episode_contents
        (ncode, episode_id, content, fetched_at, revised_at)
      SELECT ncode, episode_id, content, fetched_at, revised_at
      FROM episodes
      WHERE content IS NOT NULL
      ''',
      'PRAGMA user_version = 15',
    ];

    // 可読性のためforEachは使用しない
    // ignore: prefer_foreach
    for (final sql in statements) {
      db.execute(sql);
    }
    db.close();
  }

  /// 中断により episode_list_entries が不完全なスキーマで存在する
  /// 壊れた v15 DB を作成する。
  Future<void> createBrokenSchemaV15Database(File file) async {
    final db = sqlite3.open(file.path);

    const statements = <String>[
      '''
      CREATE TABLE novels (
        ncode TEXT NOT NULL PRIMARY KEY,
        title TEXT,
        writer TEXT,
        user_id INTEGER,
        story TEXT,
        novel_type INTEGER,
        "end" INTEGER,
        genre INTEGER,
        isr15 INTEGER,
        isbl INTEGER,
        isgl INTEGER,
        iszankoku INTEGER,
        istensei INTEGER,
        istenni INTEGER,
        keyword TEXT,
        general_firstup INTEGER,
        general_lastup INTEGER,
        global_point INTEGER,
        fav INTEGER,
        review_count INTEGER,
        rate_count INTEGER,
        all_point INTEGER,
        point_count INTEGER,
        daily_point INTEGER,
        weekly_point INTEGER,
        monthly_point INTEGER,
        quarter_point INTEGER,
        yearly_point INTEGER,
        general_all_no INTEGER,
        novel_updated_at TEXT,
        cached_at INTEGER,
        is_private INTEGER NOT NULL DEFAULT 0
      )
      ''',
      '''
      CREATE TABLE episodes (
        ncode TEXT NOT NULL REFERENCES novels(ncode),
        episode_id INTEGER NOT NULL,
        subtitle TEXT,
        url TEXT,
        published_at TEXT,
        revised_at TEXT,
        content TEXT,
        fetched_at INTEGER,
        PRIMARY KEY (ncode, episode_id)
      )
      ''',
      "INSERT INTO novels (ncode, title) VALUES ('n1234ab', 'テスト小説')",
      '''
      INSERT INTO episodes VALUES (
        'n1234ab', 1, '第1話', 'https://example.com/1',
        '2024-01-01 00:00:00', '2024-01-02 00:00:00',
        '[{"runtimeType":"plainText","text":"本文"}]', 1000)
      ''',
      // 不完全なスキーマで episode_list_entries が作成されている
      '''
      CREATE TABLE episode_list_entries (
        ncode TEXT NOT NULL,
        episode_id INTEGER NOT NULL,
        PRIMARY KEY (ncode, episode_id)
      )
      ''',
      'PRAGMA user_version = 15',
    ];

    // 可読性のためforEachは使用しない
    // ignore: prefer_foreach
    for (final sql in statements) {
      db.execute(sql);
    }
    db.close();
  }

  /// 中断により episode_list_entries / episode_contents が不完全なデータで
  /// 存在する壊れた v15 DB を作成する。
  Future<void> createBrokenV15DatabaseWithIncompleteEntries(File file) async {
    final db = sqlite3.open(file.path);

    const statements = <String>[
      '''
      CREATE TABLE novels (
        ncode TEXT NOT NULL PRIMARY KEY,
        title TEXT,
        writer TEXT,
        user_id INTEGER,
        story TEXT,
        novel_type INTEGER,
        "end" INTEGER,
        genre INTEGER,
        isr15 INTEGER,
        isbl INTEGER,
        isgl INTEGER,
        iszankoku INTEGER,
        istensei INTEGER,
        istenni INTEGER,
        keyword TEXT,
        general_firstup INTEGER,
        general_lastup INTEGER,
        global_point INTEGER,
        fav INTEGER,
        review_count INTEGER,
        rate_count INTEGER,
        all_point INTEGER,
        point_count INTEGER,
        daily_point INTEGER,
        weekly_point INTEGER,
        monthly_point INTEGER,
        quarter_point INTEGER,
        yearly_point INTEGER,
        general_all_no INTEGER,
        novel_updated_at TEXT,
        cached_at INTEGER,
        is_private INTEGER NOT NULL DEFAULT 0
      )
      ''',
      '''
      CREATE TABLE episodes (
        ncode TEXT NOT NULL REFERENCES novels(ncode),
        episode_id INTEGER NOT NULL,
        subtitle TEXT,
        url TEXT,
        published_at TEXT,
        revised_at TEXT,
        content TEXT,
        fetched_at INTEGER,
        PRIMARY KEY (ncode, episode_id)
      )
      ''',
      "INSERT INTO novels (ncode, title) VALUES ('n1234ab', 'テスト小説')",
      '''
      INSERT INTO episodes VALUES (
        'n1234ab', 1, '第1話', 'https://example.com/1',
        '2024-01-01 00:00:00', '2024-01-02 00:00:00',
        '[{"runtimeType":"plainText","text":"本文"}]', 1000)
      ''',
      '''
      CREATE TABLE episode_list_entries (
        ncode TEXT NOT NULL REFERENCES novels(ncode),
        episode_id INTEGER NOT NULL,
        subtitle TEXT,
        url TEXT,
        published_at TEXT,
        revised_at TEXT,
        fetched_at INTEGER,
        PRIMARY KEY (ncode, episode_id)
      )
      ''',
      '''
      CREATE TABLE episode_contents (
        ncode TEXT NOT NULL REFERENCES novels(ncode),
        episode_id INTEGER NOT NULL,
        content TEXT,
        fetched_at INTEGER,
        revised_at TEXT,
        PRIMARY KEY (ncode, episode_id)
      )
      ''',
      // 不完全な目次データ（subtitle 等が NULL）
      '''
      INSERT INTO episode_list_entries (ncode, episode_id)
      VALUES ('n1234ab', 1)
      ''',
      // 不完全な本文データ（content 等が NULL）
      '''
      INSERT INTO episode_contents (ncode, episode_id)
      VALUES ('n1234ab', 1)
      ''',
      'PRAGMA user_version = 15',
    ];

    // 可読性のためforEachは使用しない
    // ignore: prefer_foreach
    for (final sql in statements) {
      db.execute(sql);
    }
    db.close();
  }

  test('v15マイグレーション失敗時にMigrationExceptionが投げられること', () async {
    await createBrokenSchemaV15Database(dbFile);

    await expectLater(
      () async {
        final db = AppDatabase.test(NativeDatabase(dbFile));
        addTearDown(db.close);
        await db.doWhenOpened((_) async {});
        return db;
      },
      throwsA(
        isA<MigrationException>().having(
          (e) => e.toVersion,
          'toVersion',
          18,
        ),
      ),
    );
  });

  test('v15中間状態からの修復：目次・本文が重複せず正常に完了すること', () async {
    await createBrokenV15Database(dbFile);

    final db = AppDatabase.test(NativeDatabase(dbFile));
    addTearDown(db.close);

    // 目次は3件保持されていること
    final listRows = await db.select(db.episodeListEntries).get();
    expect(listRows.length, 3);

    // 本文は2件保持されていること
    final contentRows = await db.select(db.episodeContents).get();
    expect(contentRows.length, 2);

    // 旧テーブルが削除されていること
    final oldTables = await db
        .customSelect(
          'SELECT name FROM sqlite_master '
          "WHERE type='table' AND name='episodes'",
        )
        .get();
    expect(oldTables, isEmpty);

    // スキーマバージョンが18に更新されていること
    final versionResult = await db
        .customSelect('PRAGMA user_version')
        .getSingle();
    expect(versionResult.read<int>('user_version'), 18);

    // novelsに非公開フラグが追加されていること
    final novel = await db.getNovel(NovelSource.narou, 'n1234ab');
    expect(novel, isNotNull);
    expect(novel!.isPrivate, isFalse);
  });

  test('v15中間状態からの修復：不完全な目次・本文行が episodes の値で上書きされること', () async {
    await createBrokenV15DatabaseWithIncompleteEntries(dbFile);

    final db = AppDatabase.test(NativeDatabase(dbFile));
    addTearDown(db.close);

    // 目次行の値が episodes 側の完全な値で修復されていること
    final listRows = await db.select(db.episodeListEntries).get();
    expect(listRows.length, 1);
    final listRow = listRows.single;
    expect(listRow.episodeId, 1);
    expect(listRow.subtitle, '第1話');
    expect(listRow.url, 'https://example.com/1');
    expect(listRow.publishedAt, '2024-01-01 00:00:00');
    expect(listRow.revisedAt, '2024-01-02 00:00:00');

    // 本文行の値が episodes 側の完全な値で修復されていること
    final contentRows = await db.select(db.episodeContents).get();
    expect(contentRows.length, 1);
    final contentRow = contentRows.single;
    expect(contentRow.episodeId, 1);
    expect(contentRow.content, isNotNull);
    expect(contentRow.content!.length, 1);
    expect(contentRow.fetchedAt, 1000);
    expect(contentRow.revisedAt, '2024-01-02 00:00:00');
  });

  test('v15からのアップグレードで目次・本文が新テーブルに引き継がれること', () async {
    await createV15Database(dbFile);

    final db = AppDatabase.test(NativeDatabase(dbFile));
    addTearDown(db.close);

    // 目次は全3件引き継がれること
    final listRows = await db.select(db.episodeListEntries).get();
    expect(listRows.length, 3);
    expect(listRows.map((r) => r.episodeId), containsAll([1, 2, 3]));
    final ep3 = listRows.firstWhere((r) => r.episodeId == 3);
    expect(ep3.subtitle, '第3話');
    expect(ep3.revisedAt, '2024-01-04 00:00:00');

    // 本文はcontent IS NOT NULLの2件のみ引き継がれること
    final contentRows = await db.select(db.episodeContents).get();
    expect(contentRows.length, 2);
    expect(contentRows.map((r) => r.episodeId), containsAll([1, 2]));

    // 本文の内容と取得日時が保持されていること
    final ep1 = await db.getEpisodeData(NovelSource.narou, 'n1234ab', 1);
    expect(ep1, isNotNull);
    expect(ep1!.content, isNotNull);
    expect(ep1.content!.length, 1);
    expect(ep1.fetchedAt, 1000);
    expect(ep1.revisedAt, '2024-01-02 00:00:00');
    expect(ep1.subtitle, '第1話');

    // 公開インターフェース越しの確認(空配列は未ダウンロード扱い)
    final episodes = await db.getEpisodesRange(
      NovelSource.narou,
      'n1234ab',
      1,
      100,
    );
    expect(episodes.length, 3);
    expect(episodes[0].isDownloaded, isTrue);
    expect(episodes[1].isDownloaded, isFalse);
    expect(episodes[2].isDownloaded, isFalse);

    // 旧テーブルが削除されていること
    final oldTables = await db
        .customSelect(
          'SELECT name FROM sqlite_master '
          "WHERE type='table' AND name='episodes'",
        )
        .get();
    expect(oldTables, isEmpty);

    // novelsテーブルに非公開フラグが追加され、デフォルトfalseであること
    final novel = await db.getNovel(NovelSource.narou, 'n1234ab');
    expect(novel, isNotNull);
    expect(novel!.isPrivate, isFalse);
  });

  /// v14 相当のスキーマとデータを持つDBファイルを作成する
  Future<void> createV14Database(File file) async {
    final db = sqlite3.open(file.path);

    const createNovelsV14 = '''
      CREATE TABLE novels (
        ncode TEXT NOT NULL PRIMARY KEY,
        title TEXT,
        writer TEXT,
        user_id INTEGER,
        story TEXT,
        novel_type INTEGER,
        "end" INTEGER,
        genre INTEGER,
        isr15 INTEGER,
        isbl INTEGER,
        isgl INTEGER,
        iszankoku INTEGER,
        istensei INTEGER,
        istenni INTEGER,
        keyword TEXT,
        general_firstup INTEGER,
        general_lastup INTEGER,
        global_point INTEGER,
        fav INTEGER,
        review_count INTEGER,
        rate_count INTEGER,
        all_point INTEGER,
        point_count INTEGER,
        daily_point INTEGER,
        weekly_point INTEGER,
        monthly_point INTEGER,
        quarter_point INTEGER,
        yearly_point INTEGER,
        general_all_no INTEGER,
        novel_updated_at TEXT,
        cached_at INTEGER,
        is_private INTEGER NOT NULL DEFAULT 0
      )
    ''';
    const createLibraryEntriesV14 = '''
      CREATE TABLE library_entries (
        ncode TEXT NOT NULL PRIMARY KEY REFERENCES novels(ncode),
        added_at INTEGER)
    ''';
    const createReadingHistoryV14 = '''
      CREATE TABLE reading_history (
        ncode TEXT NOT NULL PRIMARY KEY REFERENCES novels(ncode),
        last_episode_id INTEGER,
        viewed_at INTEGER,
        updated_at INTEGER)
    ''';

    const statements = <String>[
      createNovelsV14,
      createLibraryEntriesV14,
      createReadingHistoryV14,
      '''
      CREATE TABLE episodes (
        ncode TEXT NOT NULL REFERENCES novels(ncode),
        episode_id INTEGER NOT NULL,
        subtitle TEXT,
        url TEXT,
        published_at TEXT,
        revised_at TEXT,
        content TEXT,
        fetched_at INTEGER,
        PRIMARY KEY (ncode, episode_id)
      )
      ''',
      "INSERT INTO novels (ncode, title) VALUES ('n1234ab', 'テスト小説')",
      '''
      INSERT INTO episodes VALUES (
        'n1234ab', 1, '第1話', 'https://example.com/1',
        '2024-01-01 00:00:00', '2024-01-02 00:00:00',
        '[{"runtimeType":"plainText","text":"本文"}]', 1000)
      ''',
      'PRAGMA user_version = 14',
    ];

    // 可読性のためforEachは使用しない
    // ignore: prefer_foreach
    for (final sql in statements) {
      db.execute(sql);
    }
    db.close();
  }

  test('v14からのアップグレードでFTS再構築前にテーブル分割が完了すること', () async {
    await createV14Database(dbFile);

    final db = AppDatabase.test(NativeDatabase(dbFile));
    addTearDown(db.close);

    // 目次・本文テーブルが作成されてデータが引き継がれること
    final listRows = await db.select(db.episodeListEntries).get();
    expect(listRows.length, 1);
    expect(listRows.single.episodeId, 1);
    expect(listRows.single.subtitle, '第1話');

    final contentRows = await db.select(db.episodeContents).get();
    expect(contentRows.length, 1);
    expect(contentRows.single.episodeId, 1);

    // 旧テーブルが削除されていること
    final oldTables = await db
        .customSelect(
          'SELECT name FROM sqlite_master '
          "WHERE type='table' AND name='episodes'",
        )
        .get();
    expect(oldTables, isEmpty);

    // novelsテーブルに非公開フラグが追加されること
    final novel = await db.getNovel(NovelSource.narou, 'n1234ab');
    expect(novel, isNotNull);
    expect(novel!.isPrivate, isFalse);
  });

  test('新規作成データベースでも非公開フラグのデフォルトがfalseであること', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    await db.insertNovel(
      NovelsCompanion.insert(
        source: NovelSource.narou,
        workId: 'n1234ab',
        title: const Value('テスト'),
      ),
    );

    final novel = await db.getNovel(NovelSource.narou, 'n1234ab');
    expect(novel!.isPrivate, isFalse);
  });
}
