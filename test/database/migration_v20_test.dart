import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:sqlite3/sqlite3.dart';

/// v19 → v20 マイグレーション
///
/// 未使用だった `general_firstup` / `general_lastup` を撤去し、既存の行を
/// そのまま残すことを検証する。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late File dbFile;

  setUp(() {
    dbFile = File(
      '${Directory.systemTemp.path}/novelty_migration_v20_test_'
      '${DateTime.now().microsecondsSinceEpoch}.db',
    );
  });

  tearDown(() {
    if (dbFile.existsSync()) {
      dbFile.deleteSync();
    }
  });

  Future<void> createV19Database(File file) async {
    final db = sqlite3.open(file.path);
    const schema = <String>[
      '''
      CREATE TABLE novels (
        source TEXT NOT NULL,
        work_id TEXT NOT NULL,
        title TEXT,
        writer TEXT,
        story TEXT,
        general_firstup INTEGER,
        general_lastup INTEGER,
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
      'PRAGMA user_version = 19',
    ];
    // forEach だと cascade_invocations が出るため抑制する。
    // ignore: cascade_invocations
    schema.forEach(db.execute);
    db
      ..execute(
        '''
      INSERT INTO novels(source, work_id, title, writer, general_firstup,
        general_lastup, cached_at)
      VALUES ('narou', 'n1', 'タイトル', '作者', 1362260307000, 1362260307000, 1)
      ''',
      )
      ..execute(
        'INSERT INTO library_entries(source, work_id, added_at) '
        "VALUES ('narou', 'n1', 2)",
      )
      ..close();
  }

  Future<Set<String>> novelColumns(AppDatabase db) async {
    final rows = await db.customSelect('PRAGMA table_info(novels)').get();
    return rows.map((row) => row.read<String>('name')).toSet();
  }

  test('v19からv20で未使用の日時列が消え、行は残ること', () async {
    await createV19Database(dbFile);

    final db = AppDatabase.test(NativeDatabase(dbFile));
    addTearDown(db.close);

    final columns = await novelColumns(db);
    expect(columns, isNot(contains('general_firstup')));
    expect(columns, isNot(contains('general_lastup')));
    expect(columns, containsAll(<String>['title', 'novel_updated_at']));

    final novel = await db.getNovel(NovelSource.narou, 'n1');
    expect(novel, isNotNull);
    expect(novel!.title, 'タイトル');

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), AppDatabase.currentSchemaVersion);
  });

  test('新規作成のスキーマにも日時列が無いこと', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    final columns = await novelColumns(db);
    expect(columns, isNot(contains('general_firstup')));
    expect(columns, isNot(contains('general_lastup')));
  });
}
