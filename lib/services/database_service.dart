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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE novels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ncode TEXT NOT NULL UNIQUE,
        title TEXT NOT NULL,
        writer TEXT,
        story TEXT,
        genre INTEGER,
        keyword TEXT,
        general_all_no INTEGER,
        end INTEGER,
        novel_type INTEGER
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS novels');
      await _onCreate(db, newVersion);
    }
  }

  Future<void> addNovelToLibrary(NovelInfo novel) async {
    final db = await database;
    await db.insert(
      'novels',
      novel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NovelInfo>> getLibraryNovels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('novels');

    return List.generate(maps.length, (i) {
      return NovelInfo.fromJson(maps[i]);
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
}
