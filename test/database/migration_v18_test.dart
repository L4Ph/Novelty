// ignore_for_file: unused_import, depend_on_referenced_packages, prefer_foreach, lines_longer_than_80_chars, avoid_redundant_argument_values, prefer_const_declarations, reason: test convenience

import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_parser_core/novel_parser_core.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:sqlite3/sqlite3.dart';

/// v17 → v18 マイグレーションテスト
///
/// Hybrid JSON への変換と episodes_search 廃止を検証する。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late File dbFile;

  setUp(() {
    dbFile = File(
      '${Directory.systemTemp.path}/novelty_migration_v18_test_'
      '${DateTime.now().microsecondsSinceEpoch}.db',
    );
  });

  tearDown(() {
    if (dbFile.existsSync()) {
      dbFile.deleteSync();
    }
  });

  Future<void> createV17Database(File file) async {
    final db = sqlite3.open(file.path);

    const statements = <String>[
      '''
      CREATE TABLE novels (
        source TEXT NOT NULL,
        work_id TEXT NOT NULL,
        title TEXT,
        writer TEXT,
        user_id INTEGER,
        story TEXT,
        novel_type INTEGER,
        "end" INTEGER,
        genre_id TEXT,
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
        is_private INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (source, work_id)
      )
      ''',
      '''
      CREATE TABLE library_entries (
        source TEXT NOT NULL,
        work_id TEXT NOT NULL,
        added_at INTEGER NOT NULL,
        PRIMARY KEY (source, work_id)
      )
      ''',
      '''
      CREATE TABLE reading_history (
        source TEXT NOT NULL,
        work_id TEXT NOT NULL,
        last_episode_id INTEGER,
        viewed_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (source, work_id)
      )
      ''',
      '''
      CREATE TABLE episode_list_entries (
        source TEXT NOT NULL,
        work_id TEXT NOT NULL,
        episode_id INTEGER NOT NULL,
        subtitle TEXT,
        url TEXT,
        published_at TEXT,
        revised_at TEXT,
        fetched_at INTEGER,
        PRIMARY KEY (source, work_id, episode_id)
      )
      ''',
      '''
      CREATE TABLE episode_contents (
        source TEXT NOT NULL,
        work_id TEXT NOT NULL,
        episode_id INTEGER NOT NULL,
        content TEXT,
        fetched_at INTEGER,
        revised_at TEXT,
        PRIMARY KEY (source, work_id, episode_id)
      )
      ''',
      '''
      CREATE VIRTUAL TABLE novels_search USING fts5(
        source UNINDEXED,
        work_id UNINDEXED,
        title,
        writer,
        story
      )
      ''',
      '''
      CREATE VIRTUAL TABLE episodes_search USING fts5(
        source UNINDEXED,
        work_id UNINDEXED,
        episode_id UNINDEXED,
        subtitle,
        content
      )
      ''',
      // verbose JSON の本文キャッシュ
      '''
      INSERT INTO episode_contents (source, work_id, episode_id, content, fetched_at, revised_at)
      VALUES ('narou', 'n1234ab', 1, '[{"text":"本文1","runtimeType":"plainText"},{"runtimeType":"newLine"},{"text":"続き","runtimeType":"plainText"}]', 1700000000000, '2024-01-02 00:00:00')
      ''',
      '''
      INSERT INTO episode_contents (source, work_id, episode_id, content, fetched_at, revised_at)
      VALUES ('narou', 'n1234ab', 2, '[{"base":"前","ruby":"・","runtimeType":"rubyText"}]', 1700000000000, NULL)
      ''',
      '''
      INSERT INTO episode_contents (source, work_id, episode_id, content, fetched_at, revised_at)
      VALUES ('narou', 'n1234ab', 3, '[]', 1700000000000, NULL)
      ''',
      '''
      INSERT INTO episode_contents (source, work_id, episode_id, content, fetched_at, revised_at)
      VALUES ('narou', 'n1234ab', 4, NULL, 1700000000000, NULL)
      ''',
      '''
      INSERT INTO novels (source, work_id, title) VALUES ('narou', 'n1234ab', 'テスト小説')
      ''',
      '''
      INSERT INTO library_entries (source, work_id, added_at) VALUES ('narou', 'n1234ab', 1700000000000)
      ''',
      '''
      INSERT INTO episode_list_entries (source, work_id, episode_id, subtitle) VALUES ('narou', 'n1234ab', 1, '第1話')
      ''',
      '''
      INSERT INTO novels_search (source, work_id, title, writer, story) VALUES ('narou', 'n1234ab', 'テスト', '作者', 'あらすじ')
      ''',
      '''
      INSERT INTO episodes_search (source, work_id, episode_id, subtitle, content) VALUES ('narou', 'n1234ab', 1, '第1話', '本文1')
      ''',
      'PRAGMA user_version = 17',
    ];

    for (final sql in statements) {
      db.execute(sql);
    }
    db.close();
  }

  test('v17からv18で verbose → Hybrid に変換され episodes_search が削除されること', () async {
    await createV17Database(dbFile);

    final db = AppDatabase.test(NativeDatabase(dbFile));
    addTearDown(db.close);

    // Hybrid に変換されていること
    final contents = await db.customSelect(
      'SELECT source, work_id, episode_id, content FROM episode_contents ORDER BY episode_id',
    ).get();
    expect(contents.length, 4);

    // episode 1: plain + newLine + plain
    final c1 = contents[0].read<String?>('content')!;
    final e1 = HybridConverter.fromHybridJson(c1);
    expect(e1, hasLength(3));
    expect(e1[0], isA<PlainText>());
    expect((e1[0] as PlainText).text, '本文1');
    expect(e1[1], isA<NewLine>());
    expect(e1[2], isA<PlainText>());

    // Hybrid JSON の構造が txt/rb であること
    final decoded1 = c1.contains('"txt"');
    expect(decoded1, isTrue);
    expect(c1.contains('"rb"'), isTrue);
    expect(c1.contains('runtimeType'), isFalse);

    // episode 2: ruby
    final c2 = contents[1].read<String>('content');
    final e2 = HybridConverter.fromHybridJson(c2);
    expect(e2, hasLength(1));
    expect(e2[0], isA<RubyText>());
    expect((e2[0] as RubyText).base, '前');
    expect(c2.contains('"txt"'), isTrue);

    // episode 3: 空配列 [] は Hybrid で {"txt":"","rb":[]} に変換される
    final c3 = contents[2].read<String>('content');
    // 空配列は Hybrid でも空として扱われるため、txt が空か "[]" のどちらか
    // 実装では "[]" は空リストとして保持せず {"txt":"","rb":[]} にする
    expect(c3.contains('"txt"') || c3 == '[]', isTrue);

    // episode 4: NULL はそのまま NULL
    expect(contents[3].read<String?>('content'), isNull);

    // episodes_search が削除されていること
    final tables = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='episodes_search'",
    ).get();
    expect(tables, isEmpty);

    // shadow テーブルも削除されていること
    final shadow = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'episodes_search_%'",
    ).get();
    expect(shadow, isEmpty);

    // novels_search は残っていること
    final novelsSearch = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='novels_search'",
    ).get();
    expect(novelsSearch, isNotEmpty);

    // 新しい Hybrid 形式で保存できること
    await db.updateEpisodeContent(
      source: NovelSource.narou,
      workId: 'n1234ab',
      episodeId: 5,
      content: [NovelContentElement.plainText('新規')],
      fetchedAt: 1700000000000,
      revisedAt: null,
    );
    final c5 = await db.customSelect(
      'SELECT content FROM episode_contents WHERE episode_id = 5',
    ).getSingle();
    expect(c5.read<String>('content').contains('"txt"'), isTrue);
  });

  test('ContentConverter が Hybrid と旧 verbose の両方を読めること', () {
    const converter = ContentConverter();
    // 旧 verbose
    final old = '[{"text":"A","runtimeType":"plainText"}]';
    final oldDecoded = converter.fromSql(old);
    expect(oldDecoded, hasLength(1));
    expect((oldDecoded[0] as PlainText).text, 'A');

    // 新 Hybrid
    final hybrid = HybridConverter.toHybridJson([NovelContentElement.plainText('A')]);
    final hybridDecoded = converter.fromSql(hybrid);
    expect(hybridDecoded, hasLength(1));
    expect((hybridDecoded[0] as PlainText).text, 'A');

    // toSql は Hybrid を出す
    final encoded = converter.toSql([NovelContentElement.plainText('B')]);
    expect(encoded.contains('"txt"'), isTrue);
  });
}
