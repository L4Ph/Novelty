import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
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
      'CREATE TABLE novels (ncode TEXT NOT NULL PRIMARY KEY, title TEXT)',
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
    db.dispose();
  }

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
    final ep1 = await db.getEpisodeData('n1234ab', 1);
    expect(ep1, isNotNull);
    expect(ep1!.content, isNotNull);
    expect(ep1.content!.length, 1);
    expect(ep1.fetchedAt, 1000);
    expect(ep1.revisedAt, '2024-01-02 00:00:00');
    expect(ep1.subtitle, '第1話');

    // 公開インターフェース越しの確認(空配列は未ダウンロード扱い)
    final episodes = await db.getEpisodesRange('n1234ab', 1, 100);
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
    final novel = await db.getNovel('n1234ab');
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
        cached_at INTEGER)
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

    // ignore: prefer_foreach
    for (final sql in statements) {
      db.execute(sql);
    }
    db.dispose();
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
    final novel = await db.getNovel('n1234ab');
    expect(novel, isNotNull);
    expect(novel!.isPrivate, isFalse);
  });

  test('新規作成データベースでも非公開フラグのデフォルトがfalseであること', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    await db.insertNovel(
      NovelsCompanion.insert(ncode: 'n1234ab', title: const Value('テスト')),
    );

    final novel = await db.getNovel('n1234ab');
    expect(novel!.isPrivate, isFalse);
  });
}
