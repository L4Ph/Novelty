import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';

class DriftDatabaseService {
  DriftDatabaseService(this._database);
  final AppDatabase _database;

  // 小説をライブラリに追加
  Future<void> addNovelToLibrary(NovelInfo novel) async {
    novel.toJson();

    await _database.insertNovel(
      NovelsCompanion(
        ncode: Value(novel.ncode),
        title: Value(novel.title),
        writer: Value(novel.writer),
        story: Value(novel.story),
        novelType: Value(novel.novelType),
        end: Value(novel.end),
        isr15: Value(novel.isr15),
        isbl: Value(novel.isbl),
        isgl: Value(novel.isgl),
        iszankoku: Value(novel.iszankoku),
        istensei: Value(novel.istensei),
        istenni: Value(novel.istenni),
        keyword: Value(novel.keyword),
        generalFirstup: Value(novel.generalFirstup),
        generalLastup: Value(novel.generalLastup),
        globalPoint: Value(novel.globalPoint),
        fav: Value(novel.fav),
        reviewCount: Value(novel.reviewCount),
        rateCount: Value(novel.rateCount),
        allPoint: Value(novel.allPoint),
        poinCount: Value(novel.poinCount),
        weeklyPoint: Value(novel.weeklyPoint),
        monthlyPoint: Value(novel.monthlyPoint),
        quarterPoint: Value(novel.quarterPoint),
        yearlyPoint: Value(novel.yearlyPoint),
        generalAllNo: Value(novel.generalAllNo),
        novelUpdatedAt: Value(novel.novelUpdatedAt),
        cachedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  // ライブラリの小説を取得
  Future<List<NovelInfo>> getLibraryNovels() async {
    final novels = await _database.select(_database.novels).get();
    return novels.map(_novelToNovelInfo).toList();
  }

  // 小説がライブラリにあるか確認
  Future<bool> isNovelInLibrary(String ncode) async {
    final novel = await _database.getNovel(ncode);
    return novel != null;
  }

  // ライブラリから小説を削除
  Future<void> removeNovelFromLibrary(String ncode) async {
    await _database.deleteNovel(ncode);
  }

  // 履歴に小説を追加
  Future<void> addNovelToHistory(
    String ncode, {
    String? title,
    String? writer,
    int? lastEpisode,
  }) async {
    // 既存のレコードがあるか確認
    final existing = await (_database.select(
      _database.history,
    )..where((t) => t.ncode.equals(ncode))).getSingleOrNull();

    // 既存のレコードがあり、lastEpisodeが指定されていない場合は、
    // 既存のlast_episodeを保持する
    var episodeToSave = lastEpisode;
    if (existing != null && episodeToSave == null) {
      episodeToSave = existing.lastEpisode;
    }

    await _database.addToHistory(
      HistoryCompanion(
        ncode: Value(ncode),
        title: Value(title),
        writer: Value(writer),
        lastEpisode: Value(episodeToSave),
        viewedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  // 履歴を取得
  Future<List<Map<String, dynamic>>> getHistory() async {
    final history = await _database.getHistory();
    return history
        .map(
          (item) => {
            'ncode': item.ncode,
            'title': item.title,
            'writer': item.writer,
            'last_episode': item.lastEpisode,
            'viewed_at': item.viewedAt,
          },
        )
        .toList();
  }

  // 小説情報をキャッシュ
  Future<void> cacheNovelInfo(NovelInfo novel) async {
    await addNovelToLibrary(novel);
  }

  // 複数の小説情報をキャッシュ
  Future<void> cacheMultipleNovels(List<NovelInfo> novels) async {
    for (final novel in novels) {
      await cacheNovelInfo(novel);
    }
  }

  // キャッシュされた小説情報を取得
  Future<NovelInfo?> getCachedNovelInfo(
    String ncode, {
    int maxAgeMinutes = 60,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final maxAgeMs = maxAgeMinutes * 60 * 1000;

    final novel =
        await (_database.select(_database.novels)..where(
              (t) =>
                  t.ncode.equals(ncode) &
                  t.cachedAt.isBiggerThanValue(now - maxAgeMs),
            ))
            .getSingleOrNull();

    if (novel == null) {
      return null;
    }

    return _novelToNovelInfo(novel);
  }

  // 複数のキャッシュされた小説情報を取得
  Future<Map<String, NovelInfo>> getCachedNovels(
    List<String> ncodes, {
    int maxAgeMinutes = 60,
  }) async {
    if (ncodes.isEmpty) {
      return {};
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final maxAgeMs = maxAgeMinutes * 60 * 1000;

    final novels =
        await (_database.select(_database.novels)..where(
              (t) =>
                  t.ncode.isIn(ncodes) &
                  t.cachedAt.isBiggerThanValue(now - maxAgeMs),
            ))
            .get();

    final result = <String, NovelInfo>{};
    for (final novel in novels) {
      result[novel.ncode] = _novelToNovelInfo(novel);
    }

    return result;
  }

  // エピソードを保存
  Future<void> saveEpisode(
    String ncode,
    int episode,
    String? title,
    String? content,
  ) async {
    await _database.insertEpisode(
      EpisodesCompanion(
        ncode: Value(ncode),
        episode: Value(episode),
        title: Value(title),
        content: Value(content),
        cachedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  // エピソードを取得
  Future<Map<String, dynamic>?> getEpisode(String ncode, int episode) async {
    final result = await _database.getEpisode(ncode, episode);
    if (result == null) {
      return null;
    }

    return {
      'ncode': result.ncode,
      'episode': result.episode,
      'title': result.title,
      'content': result.content,
      'cached_at': result.cachedAt,
    };
  }

  // ブックマークを追加
  Future<void> addBookmark(
    String ncode,
    int episode,
    int position,
    String? content,
  ) async {
    await _database.addBookmark(
      BookmarksCompanion(
        ncode: Value(ncode),
        episode: Value(episode),
        position: Value(position),
        content: Value(content),
        createdAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  // ブックマークを取得
  Future<List<Map<String, dynamic>>> getBookmarks(String ncode) async {
    final bookmarks = await _database.getBookmarks(ncode);
    return bookmarks
        .map(
          (bookmark) => {
            'ncode': bookmark.ncode,
            'episode': bookmark.episode,
            'position': bookmark.position,
            'content': bookmark.content,
            'created_at': bookmark.createdAt,
          },
        )
        .toList();
  }

  // ブックマークを削除
  Future<void> deleteBookmark(String ncode, int episode, int position) async {
    await _database.deleteBookmark(ncode, episode, position);
  }

  // Novel エンティティから NovelInfo モデルへの変換
  NovelInfo _novelToNovelInfo(Novel novel) {
    return NovelInfo(
      title: novel.title,
      ncode: novel.ncode,
      writer: novel.writer,
      story: novel.story,
      novelType: novel.novelType,
      end: novel.end,
      isr15: novel.isr15,
      isbl: novel.isbl,
      isgl: novel.isgl,
      iszankoku: novel.iszankoku,
      istensei: novel.istensei,
      istenni: novel.istenni,
      keyword: novel.keyword,
      generalFirstup: novel.generalFirstup,
      generalLastup: novel.generalLastup,
      globalPoint: novel.globalPoint,
      fav: novel.fav,
      reviewCount: novel.reviewCount,
      rateCount: novel.rateCount,
      allPoint: novel.allPoint,
      poinCount: novel.poinCount,
      weeklyPoint: novel.weeklyPoint,
      monthlyPoint: novel.monthlyPoint,
      quarterPoint: novel.quarterPoint,
      yearlyPoint: novel.yearlyPoint,
      generalAllNo: novel.generalAllNo,
      novelUpdatedAt: novel.novelUpdatedAt,
    );
  }
}
