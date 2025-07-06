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
    await _migrateEpisodes();
    await _migrateBookmarks();
  }

  Future<void> _migrateNovels() async {
    final novels = await _oldDatabaseService.getAllNovels();
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
          generalFirstup: Value(novel['general_firstup'] as int?),
          generalLastup: Value(novel['general_lastup'] as int?),
          globalPoint: Value(novel['global_point'] as int?),
          fav: Value(novel['fav'] as int?),
          reviewCount: Value(novel['review_count'] as int?),
          rateCount: Value(novel['rate_count'] as int?),
          allPoint: Value(novel['all_point'] as int?),
          poinCount: Value(novel['poin_count'] as int?),
          weeklyPoint: Value(novel['weekly_point'] as int?),
          monthlyPoint: Value(novel['monthly_point'] as int?),
          quarterPoint: Value(novel['quarter_point'] as int?),
          yearlyPoint: Value(novel['yearly_point'] as int?),
          generalAllNo: Value(novel['general_all_no'] as int?),
          novelUpdatedAt: Value(novel['novel_updated_at'] as String?),
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

  Future<void> _migrateEpisodes() async {
    final episodes = await _oldDatabaseService.getAllEpisodes();
    for (final episode in episodes) {
      await _newDatabase.insertEpisode(
        EpisodesCompanion(
          ncode: Value(episode['ncode'] as String),
          episode: Value(episode['episode'] as int),
          title: Value(episode['title'] as String?),
          content: Value(episode['content'] as String?),
          cachedAt: Value(episode['cached_at'] as int?),
        ),
      );
    }
  }

  Future<void> _migrateBookmarks() async {
    final bookmarks = await _oldDatabaseService.getAllBookmarks();
    for (final bookmark in bookmarks) {
      await _newDatabase.addBookmark(
        BookmarksCompanion(
          ncode: Value(bookmark['ncode'] as String),
          episode: Value(bookmark['episode'] as int),
          position: Value(bookmark['position'] as int),
          content: Value(bookmark['content'] as String?),
          createdAt: Value(bookmark['created_at'] as int),
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
