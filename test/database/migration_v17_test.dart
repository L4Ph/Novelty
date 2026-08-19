// ignore_for_file: lines_longer_than_80_chars, reason: SQL リテラルのため

import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:sqlite3/sqlite3.dart';

/// スキーマバージョン16 → 17 のマイグレーションテスト。
///
/// 複数プロバイダ対応（カクヨム対応 #240）の一環で、全テーブルの主キーを
/// `(source, work_id)`（エピソード系は `(source, work_id, episode_id)`）に
/// 移行する。既存のなろうデータは `source='narou'` として100%維持されることを検証する。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late File dbFile;

  setUp(() {
    dbFile = File(
      '${Directory.systemTemp.path}/novelty_migration_v17_test_'
      '${DateTime.now().microsecondsSinceEpoch}.db',
    );
  });

  tearDown(() {
    if (dbFile.existsSync()) {
      dbFile.deleteSync();
    }
  });

  /// v16 相当のスキーマ（全カラム）とデータを持つDBファイルを作成する。
  ///
  /// 実在のv16データベース（アプリの `novelty.db`）と同じ構造を再現する。
  Future<void> createV16Database(File file) async {
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
      CREATE TABLE library_entries (
        ncode TEXT NOT NULL PRIMARY KEY REFERENCES novels(ncode),
        added_at INTEGER NOT NULL
      )
      ''',
      '''
      CREATE TABLE reading_history (
        ncode TEXT NOT NULL PRIMARY KEY REFERENCES novels(ncode),
        last_episode_id INTEGER,
        viewed_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL DEFAULT 0
      )
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
      '''
      CREATE VIRTUAL TABLE novels_search USING fts5(
        ncode UNINDEXED,
        title,
        writer,
        story
      )
      ''',
      '''
      CREATE VIRTUAL TABLE episodes_search USING fts5(
        ncode UNINDEXED,
        episode_id UNINDEXED,
        subtitle,
        content
      )
      ''',
      // 完全なデータを持つ作品
      '''
      INSERT INTO novels (
        ncode, title, writer, user_id, story, novel_type, "end", genre,
        isr15, isbl, isgl, iszankoku, istensei, istenni, keyword,
        general_firstup, general_lastup, global_point, fav, review_count,
        rate_count, all_point, point_count, daily_point, weekly_point,
        monthly_point, quarter_point, yearly_point, general_all_no,
        novel_updated_at, cached_at, is_private
      ) VALUES (
        'n1234ab', 'テスト小説', 'テスト作者', 100, 'あらすじ', 1, 1, 101,
        1, 0, 0, 1, 1, 0, '転生',
        1700000000, 1701000000, 5000, 100, 5,
        10, 200, 50, 100, 200,
        300, 400, 500, 20,
        '2024-01-01 00:00:00', 1700000000000, 0
      )
      ''',
      // 最小限のデータを持つ作品
      '''
      INSERT INTO novels (
        ncode, title, writer, genre, general_all_no, cached_at
      ) VALUES (
        'n9999zz', '短編作品', '短編作者', 9901, 1, 1700000000001
      )
      ''',
      '''
      INSERT INTO library_entries (ncode, added_at) VALUES
        ('n1234ab', 1700000000000),
        ('n9999zz', 1700000000001)
      ''',
      '''
      INSERT INTO reading_history
        (ncode, last_episode_id, viewed_at, updated_at)
      VALUES ('n1234ab', 2, 1700000000000, 1700000000000)
      ''',
      '''
      INSERT INTO episode_list_entries
        (ncode, episode_id, subtitle, url, published_at, revised_at, fetched_at)
      VALUES
        ('n1234ab', 1, '第1話', 'https://ncode.syosetu.com/n1234ab/1/',
         '2024-01-01 00:00:00', '2024-01-02 00:00:00', 1700000000000),
        ('n1234ab', 2, '第2話', 'https://ncode.syosetu.com/n1234ab/2/',
         '2024-01-03 00:00:00', NULL, 1700000000000)
      ''',
      '''
      INSERT INTO episode_contents
        (ncode, episode_id, content, fetched_at, revised_at)
      VALUES
        ('n1234ab', 1,
         '[{"runtimeType":"plainText","text":"本文1"}]', 1700000000000,
         '2024-01-02 00:00:00'),
        ('n1234ab', 2, '[]', 1700000000000, NULL)
      ''',
      '''
      INSERT INTO novels_search(rowid, ncode, title, writer, story) VALUES
        (1, 'n1234ab', 'テスト 小説', 'テスト 作者', 'あらすじ'),
        (2, 'n9999zz', '短編 作品', '短編 作者', '')
      ''',
      '''
      INSERT INTO episodes_search
        (rowid, ncode, episode_id, subtitle, content) VALUES
        (1, 'n1234ab', 1, '第1話', '本文1'),
        (2, 'n1234ab', 2, '第2話', '')
      ''',
      'PRAGMA user_version = 16',
    ];

    // 可読性のためforEachは使用しない
    // ignore: prefer_foreach
    for (final sql in statements) {
      db.execute(sql);
    }
    db.close();
  }

  test('v16からのアップグレードで全データがsource=narouとして維持されること', () async {
    await createV16Database(dbFile);

    final db = AppDatabase.test(NativeDatabase(dbFile));
    addTearDown(db.close);

    // novels: 複合主キー (source, work_id) に移行し、ncodeがwork_idとして維持される
    final novels = await db
        .customSelect(
          'SELECT source, work_id, title, genre_id '
          'FROM novels ORDER BY work_id',
        )
        .get();
    expect(novels.length, 2);
    expect(novels[0].read<String>('source'), 'narou');
    expect(novels[0].read<String>('work_id'), 'n1234ab');
    expect(novels[0].read<String>('title'), 'テスト小説');
    // genre は INTEGER → TEXT に変換され、値が維持される
    expect(novels[0].read<String>('genre_id'), '101');
    expect(novels[1].read<String>('source'), 'narou');
    expect(novels[1].read<String>('work_id'), 'n9999zz');
    expect(novels[1].read<String>('genre_id'), '9901');

    // 全カラムが維持されていること（n1234ab の詳細）
    final detail = await db
        .customSelect(
          'SELECT writer, user_id, story, novel_type, "end", isr15, isbl, '
          'iszankoku, istensei, istenni, keyword, general_all_no, '
          'novel_updated_at, cached_at, is_private, daily_point, yearly_point '
          'FROM novels WHERE work_id = ?',
          variables: [Variable.withString('n1234ab')],
        )
        .getSingle();
    expect(detail.read<String>('writer'), 'テスト作者');
    expect(detail.read<int>('user_id'), 100);
    expect(detail.read<String>('story'), 'あらすじ');
    expect(detail.read<int>('novel_type'), 1);
    expect(detail.read<int>('end'), 1);
    expect(detail.read<int>('isr15'), 1);
    expect(detail.read<int>('isbl'), 0);
    expect(detail.read<int>('iszankoku'), 1);
    expect(detail.read<int>('istensei'), 1);
    expect(detail.read<int>('istenni'), 0);
    expect(detail.read<String>('keyword'), '転生');
    expect(detail.read<int>('general_all_no'), 20);
    expect(detail.read<String>('novel_updated_at'), '2024-01-01 00:00:00');
    expect(detail.read<int>('cached_at'), 1700000000000);
    expect(detail.read<int>('is_private'), 0);
    expect(detail.read<int>('daily_point'), 100);
    expect(detail.read<int>('yearly_point'), 500);

    // 旧ncodeカラムが存在しないこと（主キー移行が完了していること）
    final columns = await db
        .customSelect(
          'PRAGMA table_info(novels)',
        )
        .get();
    final columnNames = columns.map((c) => c.read<String>('name')).toSet();
    expect(columnNames, isNot(contains('ncode')));
    expect(columnNames, containsAll(['source', 'work_id']));

    // library_entries: source/work_id が維持される
    final library = await db
        .customSelect(
          'SELECT source, work_id, added_at '
          'FROM library_entries ORDER BY work_id',
        )
        .get();
    expect(library.length, 2);
    expect(library[0].read<String>('source'), 'narou');
    expect(library[0].read<String>('work_id'), 'n1234ab');
    expect(library[0].read<int>('added_at'), 1700000000000);

    // reading_history: 維持される
    final history = await db
        .customSelect(
          'SELECT source, work_id, last_episode_id, viewed_at, updated_at '
          'FROM reading_history',
        )
        .get();
    expect(history.length, 1);
    expect(history[0].read<String>('source'), 'narou');
    expect(history[0].read<String>('work_id'), 'n1234ab');
    expect(history[0].read<int>('last_episode_id'), 2);

    // episode_list_entries: 複合主キー (source, work_id, episode_id)
    final toc = await db
        .customSelect(
          'SELECT source, work_id, episode_id, subtitle, url, published_at, '
          'revised_at, fetched_at '
          'FROM episode_list_entries ORDER BY episode_id',
        )
        .get();
    expect(toc.length, 2);
    expect(toc[0].read<String>('source'), 'narou');
    expect(toc[0].read<String>('work_id'), 'n1234ab');
    expect(toc[0].read<int>('episode_id'), 1);
    expect(toc[0].read<String>('subtitle'), '第1話');
    expect(toc[0].read<String>('url'), 'https://ncode.syosetu.com/n1234ab/1/');
    expect(toc[0].read<String>('published_at'), '2024-01-01 00:00:00');
    expect(toc[0].read<String>('revised_at'), '2024-01-02 00:00:00');
    expect(toc[0].read<int>('fetched_at'), 1700000000000);
    expect(toc[1].read<int>('episode_id'), 2);
    expect(toc[1].read<String?>('revised_at'), isNull);

    // episode_contents: 本文キャッシュが維持され、v18で Hybrid に変換される
    final contents = await db
        .customSelect(
          'SELECT source, work_id, episode_id, content, fetched_at, revised_at '
          'FROM episode_contents ORDER BY episode_id',
        )
        .get();
    expect(contents.length, 2);
    expect(contents[0].read<String>('source'), 'narou');
    expect(contents[0].read<String>('work_id'), 'n1234ab');
    expect(
      contents[0].read<String>('content'),
      '{"txt":"本文1","rb":[]}',
    );
    expect(contents[0].read<int>('fetched_at'), 1700000000000);
    expect(contents[0].read<String?>('revised_at'), '2024-01-02 00:00:00');
    // v18 で空配列 '[]' は Hybrid 空値へ正規化される
    expect(contents[1].read<String?>('content'), '{"txt":"","rb":[]}');

    // FTSテーブルが再構築され、データが再投入されていること
    // v18で episodes_search は廃止されたため novels_search のみ
    final novelFtsCount = await db
        .customSelect(
          'SELECT COUNT(*) AS c FROM novels_search',
        )
        .getSingle();
    expect(novelFtsCount.read<int>('c'), 2);

    final episodeFtsTables = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='episodes_search'",
        )
        .get();
    expect(episodeFtsTables, isEmpty);

    // 新スキーマで新しいsourceの行を追加できること（複合主キーの動作確認）
    await db.customStatement(
      'INSERT INTO novels (source, work_id, title) '
      "VALUES ('kakuyomu', 'k-test-1', 'カクヨムテスト')",
    );
    final inserted = await db
        .customSelect(
          "SELECT source, work_id FROM novels WHERE source = 'kakuyomu'",
        )
        .get();
    expect(inserted.length, 1);
    expect(inserted[0].read<String>('work_id'), 'k-test-1');
  });
}
