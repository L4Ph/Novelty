import 'dart:convert';

import 'package:novelty/models/novel_info.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  static final _instance = DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'novelty.db');
    return openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE novels (
        title TEXT,
        ncode TEXT PRIMARY KEY,
        writer TEXT,
        story TEXT,
        novel_type INTEGER,
        end INTEGER,
        general_all_no INTEGER,
        genre INTEGER,
        keyword TEXT,
        general_firstup TEXT,
        general_lastup TEXT,
        global_point INTEGER,
        daily_point INTEGER,
        weekly_point INTEGER,
        monthly_point INTEGER,
        quarter_point INTEGER,
        yearly_point INTEGER,
        fav_novel_cnt INTEGER,
        impression_cnt INTEGER,
        review_cnt INTEGER,
        all_point INTEGER,
        all_hyoka_cnt INTEGER,
        sasie_cnt INTEGER,
        kaiwaritu INTEGER,
        novelupdated_at INTEGER,
        updated_at INTEGER,
        episodes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE history (
        ncode TEXT PRIMARY KEY,
        viewed_at INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      await db.execute('DROP TABLE IF EXISTS novels');
      await db.execute('DROP TABLE IF EXISTS history');
      await _onCreate(db, newVersion);
    }
  }

  Future<void> addNovelToLibrary(NovelInfo novel) async {
    final db = await database;
    final novelJson = novel.toJson();
    if (novelJson['episodes'] != null) {
      novelJson['episodes'] = jsonEncode(novelJson['episodes']);
    }
    await db.insert(
      'novels',
      novelJson,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NovelInfo>> getLibraryNovels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('novels');

    return List.generate(maps.length, (i) {
      final map = Map<String, dynamic>.from(maps[i]);
      if (map['episodes'] is String) {
        map['episodes'] = jsonDecode(map['episodes'] as String);
      }
      return NovelInfo.fromJson(map);
    });
  }

  Future<bool> isNovelInLibrary(String ncode) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'novels',
      where: 'ncode = ?',
      whereArgs: [ncode],
    );
    return maps.isNotEmpty;
  }

  Future<void> removeNovelFromLibrary(String ncode) async {
    final db = await database;
    await db.delete('novels', where: 'ncode = ?', whereArgs: [ncode]);
  }

  Future<void> addNovelToHistory(String ncode) async {
    final db = await database;
    await db.insert(
      'history',
      {'ncode': ncode, 'viewed_at': DateTime.now().millisecondsSinceEpoch},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      orderBy: 'viewed_at DESC',
    );
    return maps;
  }
}
