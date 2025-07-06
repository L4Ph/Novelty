import 'dart:io';

import 'package:drift/drift.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/services/database_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class DatabaseMigrationService {
  DatabaseMigrationService(this._oldDatabaseService, this._newDatabase);
  final DatabaseService _oldDatabaseService;
  final AppDatabase _newDatabase;

  Future<void> migrateData() async {
    await _migrateNovels();
    await _migrateHistory();
  }

  Future<void> _migrateNovels() async {
    final db = await _oldDatabaseService.database;
    final novels = await db.query('novels');
    for (final novel in novels) {
      await _newDatabase.insertNovel(
        NovelsCompanion(
          ncode: Value(novel['ncode'] as String),
          title: Value(novel['title'] as String?),
          writer: Value(novel['writer'] as String?),
          story: Value(novel['story'] as String?),
          novelType: Value(novel['novel_type'] as int?),
          end: Value(novel['end'] as int?),
          isr15: Value(novel['isr15'] as int?),
          isbl: Value(novel['isbl'] as int?),
          isgl: Value(novel['isgl'] as int?),
          iszankoku: Value(novel['iszankoku'] as int?),
          istensei: Value(novel['istensei'] as int?),
          istenni: Value(novel['istenni'] as int?),
          keyword: Value(novel['keyword'] as String?),
          generalFirstup:
              Value(int.tryParse((novel['general_firstup'] as String?) ?? '')),
          generalLastup:
              Value(int.tryParse((novel['general_lastup'] as String?) ?? '')),
          globalPoint: Value(novel['global_point'] as int?),
          fav: Value(novel['fav_novel_cnt'] as int?),
          reviewCount: Value(novel['review_cnt'] as int?),
          rateCount: Value(novel['all_hyoka_cnt'] as int?),
          allPoint: Value(novel['all_point'] as int?),
          poinCount: Value(novel['impression_cnt'] as int?),
          weeklyPoint: Value(novel['weekly_point'] as int?),
          monthlyPoint: Value(novel['monthly_point'] as int?),
          quarterPoint: Value(novel['quarter_point'] as int?),
          yearlyPoint: Value(novel['yearly_point'] as int?),
          generalAllNo: Value(novel['general_all_no'] as int?),
          novelUpdatedAt: Value(novel['novelupdated_at']?.toString()),
          cachedAt: Value(novel['cached_at'] as int?),
        ),
      );
    }
  }

  Future<void> _migrateHistory() async {
    final historyItems = await _oldDatabaseService.getHistory();
    for (final item in historyItems) {
      await _newDatabase.addToHistory(
        HistoryCompanion(
          ncode: Value(item['ncode'] as String),
          title: Value(item['title'] as String?),
          writer: Value(item['writer'] as String?),
          lastEpisode: Value(item['last_episode'] as int?),
          viewedAt: Value(item['viewed_at'] as int),
        ),
      );
    }
  }

  // 古いデータベースファイルを削除
  Future<void> deleteOldDatabase() async {
    final databasesPath = await sqflite.getDatabasesPath();
    final path = join(databasesPath, 'novelty.db');
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
