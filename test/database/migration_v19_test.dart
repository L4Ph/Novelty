// ignore_for_file: lines_longer_than_80_chars, reason: テスト支援のため

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:sqlite3/sqlite3.dart';

/// v18 → v19 マイグレーションテスト
///
/// novels_search FTS5 の撤去と、VACUUM による物理ファイルサイズ回収を検証する。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late File dbFile;

  setUp(() {
    dbFile = File(
      '${Directory.systemTemp.path}/novelty_migration_v19_test_'
      '${DateTime.now().microsecondsSinceEpoch}.db',
    );
  });

  tearDown(() {
    if (dbFile.existsSync()) {
      dbFile.deleteSync();
    }
  });

  Future<void> createV18Database(File file) async {
    final db = sqlite3.open(file.path);

    const schema = <String>[
      '''
      CREATE TABLE novels (
        source TEXT NOT NULL,
        work_id TEXT NOT NULL,
        title TEXT,
        writer TEXT,
        story TEXT,
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
      '''
      CREATE VIRTUAL TABLE novels_search USING fts5(
        source UNINDEXED,
        work_id UNINDEXED,
        title,
        writer,
        story
      )
      ''',
      'PRAGMA user_version = 18',
    ];

    // forEach + tear-off だと cascade_invocations が出るため抑制する
    // ignore: cascade_invocations
    schema.forEach(db.execute);

    final st = db.prepare(
      'INSERT INTO novels_search(source, work_id, title, writer, story) VALUES (?, ?, ?, ?, ?)',
    );
    final title = 'これは長いタイトルのテスト小説です。' * 12;
    final story = 'これは長いあらすじのテスト本文です。' * 50;
    for (var i = 0; i < 3000; i++) {
      st.execute(['narou', 'n$i', '$title-$i', '作者', story]);
    }
    st.close();
    db.close();
  }

  test('v18からv19で novels_search が削除され VACUUM でファイルが縮むこと', () async {
    await createV18Database(dbFile);
    final sizeBefore = dbFile.lengthSync();

    final db = AppDatabase.test(NativeDatabase(dbFile));
    addTearDown(db.close);

    final tables = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='novels_search'",
        )
        .get();
    expect(tables, isEmpty);

    final shadow = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'novels_search_%'",
        )
        .get();
    expect(shadow, isEmpty);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), 19);

    await db.close();

    final sizeAfter = dbFile.lengthSync();
    expect(sizeAfter, lessThan(sizeBefore));
  });
}
