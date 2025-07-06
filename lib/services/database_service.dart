import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_service.g.dart';

@riverpod
DatabaseService databaseService(DatabaseServiceRef ref) {
  return DatabaseService(ref.watch(appDatabaseProvider));
}

class DatabaseService {
  DatabaseService(this._db);
  final AppDatabase _db;

  Future<void> addNovelToLibrary(NovelInfo novel) async {
    // await _db.addNovelToLibrary(novel);
  }

  Future<List<NovelInfo>> getLibraryNovels() async {
    return [];
    // return _db.getLibraryNovels();
  }

  Future<bool> isNovelInLibrary(String ncode) async {
    return false;
    // return _db.isNovelInLibrary(ncode);
  }

  Future<void> removeNovelFromLibrary(String ncode) async {
    // await _db.removeNovelFromLibrary(ncode);
  }

  Future<void> addNovelToHistory(
    String ncode, {
    String? title,
    String? writer,
    int? lastEpisode,
  }) async {
    // await _db.addNovelToHistory(ncode, title: title, writer: writer, lastEpisode: lastEpisode);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    return [];
    // return _db.getHistory();
  }

  Future<void> cacheNovelInfo(NovelInfo novel) async {
    // await _db.cacheNovelInfo(novel);
  }

  Future<void> cacheMultipleNovels(List<NovelInfo> novels) async {
    // await _db.cacheMultipleNovels(novels);
  }

  Future<NovelInfo?> getCachedNovelInfo(
    String ncode, {
    int maxAgeMinutes = 60,
  }) async {
    return null;
    // return _db.getCachedNovelInfo(ncode, maxAgeMinutes: maxAgeMinutes);
  }

  Future<Map<String, NovelInfo>> getCachedNovels(
    List<String> ncodes, {
    int maxAgeMinutes = 60,
  }) async {
    return {};
    // return _db.getCachedNovels(ncodes, maxAgeMinutes: maxAgeMinutes);
  }

  // Future<List<Map<String, dynamic>>> getNovelsForMigration() async {
  //   return [];
  // }

  // Future<List<Map<String, dynamic>>> getHistoryForMigration() async {
  //   return [];
  // }
}




