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
      version: 8,
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
        episodes TEXT,
        cached_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE history (
        ncode TEXT PRIMARY KEY,
        title TEXT,
        writer TEXT,
        last_episode INTEGER,
        viewed_at INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      await db.execute('DROP TABLE IF EXISTS novels');
      await db.execute('DROP TABLE IF EXISTS history');
      await _onCreate(db, newVersion);
    } else if (oldVersion < 6) {
      // Add cached_at column if upgrading from version 5
      try {
        await db.execute('ALTER TABLE novels ADD COLUMN cached_at INTEGER');
      } catch (e) {
        // Column might already exist
        print('Error adding cached_at column: $e');
      }
    } else if (oldVersion < 7) {
      // Add title and writer columns to history table
      try {
        await db.execute('ALTER TABLE history ADD COLUMN title TEXT');
        await db.execute('ALTER TABLE history ADD COLUMN writer TEXT');
      } catch (e) {
        // Columns might already exist
        print('Error adding title/writer columns to history: $e');
      }
    } else if (oldVersion < 8) {
      // Add last_episode column to history table
      try {
        await db.execute('ALTER TABLE history ADD COLUMN last_episode INTEGER');
      } catch (e) {
        // Column might already exist
        print('Error adding last_episode column to history: $e');
      }
    }
  }

  Future<void> addNovelToLibrary(NovelInfo novel) async {
    final db = await database;
    final novelJson = novel.toJson();
    
    // Add cached_at timestamp
    novelJson['cached_at'] = DateTime.now().millisecondsSinceEpoch;
    
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

  Future<void> addNovelToHistory(
    String ncode, {
    String? title,
    String? writer,
    int? lastEpisode,
  }) async {
    final db = await database;
    
    // 既存のレコードがあるか確認
    final List<Map<String, dynamic>> existing = await db.query(
      'history',
      where: 'ncode = ?',
      whereArgs: [ncode],
    );
    
    // 既存のレコードがあり、lastEpisodeが指定されていない場合は、
    // 既存のlast_episodeを保持する
    int? episodeToSave = lastEpisode;
    if (existing.isNotEmpty && episodeToSave == null) {
      episodeToSave = existing.first['last_episode'] as int?;
    }
    
    await db.insert(
      'history',
      {
        'ncode': ncode, 
        'title': title,
        'writer': writer,
        'last_episode': episodeToSave,
        'viewed_at': DateTime.now().millisecondsSinceEpoch
      },
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
  
  /// Caches novel information in the database
  /// This allows us to avoid making API requests for novels we've already fetched
  Future<void> cacheNovelInfo(NovelInfo novel) async {
    final db = await database;
    final novelJson = novel.toJson();
    
    // Add cached_at timestamp
    novelJson['cached_at'] = DateTime.now().millisecondsSinceEpoch;
    
    // Convert episodes to JSON string if present
    if (novelJson['episodes'] != null) {
      novelJson['episodes'] = jsonEncode(novelJson['episodes']);
    }
    
    await db.insert(
      'novels',
      novelJson,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  /// Caches multiple novels at once
  Future<void> cacheMultipleNovels(List<NovelInfo> novels) async {
    final db = await database;
    final batch = db.batch();
    final now = DateTime.now().millisecondsSinceEpoch;
    
    for (final novel in novels) {
      final novelJson = novel.toJson();
      novelJson['cached_at'] = now;
      
      if (novelJson['episodes'] != null) {
        novelJson['episodes'] = jsonEncode(novelJson['episodes']);
      }
      
      batch.insert(
        'novels',
        novelJson,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }
  
  /// Gets cached novel information if available and not expired
  /// Returns null if the novel is not cached or the cache is expired
  Future<NovelInfo?> getCachedNovelInfo(String ncode, {int maxAgeMinutes = 60}) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final maxAgeMs = maxAgeMinutes * 60 * 1000;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'novels',
      where: 'ncode = ? AND cached_at > ?',
      whereArgs: [ncode, now - maxAgeMs],
    );
    
    if (maps.isEmpty) {
      return null;
    }
    
    final map = Map<String, dynamic>.from(maps.first);
    if (map['episodes'] is String) {
      try {
        map['episodes'] = jsonDecode(map['episodes'] as String);
      } catch (e) {
        // If JSON decoding fails, set episodes to null
        map['episodes'] = null;
      }
    }
    
    return NovelInfo.fromJson(map);
  }
  
  /// Gets multiple cached novels if available and not expired
  Future<Map<String, NovelInfo>> getCachedNovels(List<String> ncodes, {int maxAgeMinutes = 60}) async {
    if (ncodes.isEmpty) {
      return {};
    }
    
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final maxAgeMs = maxAgeMinutes * 60 * 1000;
    
    // Create placeholders for SQL query
    final placeholders = List.filled(ncodes.length, '?').join(',');
    
    final List<Map<String, dynamic>> maps = await db.query(
      'novels',
      where: 'ncode IN ($placeholders) AND cached_at > ?',
      whereArgs: [...ncodes, now - maxAgeMs],
    );
    
    final result = <String, NovelInfo>{};
    for (final map in maps) {
      final ncode = map['ncode'] as String;
      final novelMap = Map<String, dynamic>.from(map);
      
      if (novelMap['episodes'] is String) {
        try {
          novelMap['episodes'] = jsonDecode(novelMap['episodes'] as String);
        } catch (e) {
          // If JSON decoding fails, set episodes to null
          novelMap['episodes'] = null;
        }
      }
      
      result[ncode] = NovelInfo.fromJson(novelMap);
    }
    
    return result;
  }
}
