import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/providers/enriched_novel_provider.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/novel_parser.dart';
import 'package:novelty/utils/settings_provider.dart';

/// 小説のダウンロードと管理を行うリポジトリ。
final novelRepositoryProvider = Provider<NovelRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final settings = ref.watch(settingsProvider);
  final db = ref.watch(appDatabaseProvider);
  final repository = NovelRepository(
    ref: ref,
    apiService: apiService,
    settings: settings,
    db: db,
  );

  ref.onDispose(repository.dispose);

  return repository;
});

/// 小説のダウンロードと管理を行うリポジトリクラス。
class NovelRepository {
  /// コンストラクタ。
  NovelRepository({
    required this.ref,
    required this.apiService,
    required this.settings,
    required AppDatabase db,
  }) : _db = db;

  /// アプリケーションの設定を取得するためのリファレンス。
  final Ref ref;

  /// APIサービスを通じて小説データを取得するためのサービス。
  final ApiService apiService;

  /// アプリケーションの設定。
  final AsyncValue<AppSettings> settings;

  final AppDatabase _db;

  /// ダウンロード進捗のストリームコントローラー
  final Map<String, StreamController<DownloadProgress>> _progressControllers =
      {};

  /// リソースをクリーンアップする
  void dispose() {
    for (final controller in _progressControllers.values) {
      if (!controller.isClosed) {
        controller.close();
      }
    }
    _progressControllers.clear();
  }

  /// ダウンロード進捗を監視するストリーム
  Stream<DownloadProgress> watchDownloadProgress(String ncode) {
    final normalizedNcode = ncode.toLowerCase();
    _progressControllers.putIfAbsent(
      normalizedNcode,
      StreamController.broadcast,
    );
    return _progressControllers[normalizedNcode]!.stream;
  }

  /// 小説をライブラリに追加する。
  ///
  /// 既に存在する場合は何もしない。
  /// 成功した場合はtrueを、既に存在した場合はfalseを返す。
  Future<bool> addNovelToLibrary(String ncode) async {
    final ncodeLower = ncode.toLowerCase();

    // 既にライブラリに存在するかチェック
    final isInLibrary = await _db.isInLibrary(ncodeLower);
    if (isInLibrary) {
      return false;
    }

    // ライブラリに追加
    final novelInfo = await apiService.fetchNovelInfo(ncodeLower);

    // Novelテーブルに保存
    await _db.insertNovel(novelInfo.toDbCompanion());

    // LibraryNovelsテーブルに追加
    await _db.addToLibrary(
      LibraryNovelsCompanion(
        ncode: Value(ncodeLower),
        addedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );

    // Providersを無効化してUIを更新
    ref
      ..invalidate(libraryNovelsProvider)
      ..invalidate(enrichedRankingDataProvider('d'))
      ..invalidate(enrichedRankingDataProvider('w'))
      ..invalidate(enrichedRankingDataProvider('m'))
      ..invalidate(enrichedRankingDataProvider('q'))
      ..invalidate(enrichedRankingDataProvider('all'));

    return true;
  }

  Future<List<NovelContentElement>> _fetchEpisodeContent(
    String ncode,
    int episode,
  ) async {
    final episodeData = await apiService.fetchEpisode(
      ncode.toLowerCase(),
      episode,
    );
    if (episodeData.body == null) {
      return [];
    }

    final parsedContent = parseNovel(episodeData.body!);
    return parsedContent;
  }

  /// 小説のエピソードを取得するメソッド。
  Future<List<NovelContentElement>> getEpisode(
    String ncode,
    int episode,
  ) async {
    final downloaded = await _db.getDownloadedEpisode(ncode, episode);
    if (downloaded != null) {
      return downloaded.content;
    }

    return _fetchEpisodeContent(ncode, episode);
  }

  /// 小説の情報を取得するメソッド。
  Future<void> downloadEpisode(String ncode, int episode) async {
    final content = await _fetchEpisodeContent(ncode, episode);
    await _db.insertDownloadedEpisode(
      DownloadedEpisodesCompanion(
        ncode: Value(ncode),
        episode: Value(episode),
        content: Value(content),
        downloadedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// 小説のダウンロードを行うメソッド。
  Future<void> downloadNovel(
    String ncode,
    int totalEpisodes,
  ) async {
    final ncodeLower = ncode.toLowerCase();
    final progressController = _progressControllers[ncodeLower];

    try {
      // ダウンロード開始をDBに記録
      await _db.upsertDownloadedNovel(
        DownloadedNovelsCompanion(
          ncode: Value(ncodeLower),
          downloadStatus: const Value(1), // 1: ダウンロード中
          downloadedAt: Value(DateTime.now().millisecondsSinceEpoch),
          totalEpisodes: Value(totalEpisodes),
          downloadedEpisodes: const Value(0),
        ),
      );
      progressController?.add(
        DownloadProgress(
          currentEpisode: 0,
          totalEpisodes: totalEpisodes,
          isDownloading: true,
        ),
      );

      for (var i = 1; i <= totalEpisodes; i++) {
        final content = await _fetchEpisodeContent(ncodeLower, i);

        // データベースに保存
        await _db.insertDownloadedEpisode(
          DownloadedEpisodesCompanion(
            ncode: Value(ncodeLower),
            episode: Value(i),
            content: Value(content),
            downloadedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );

        // DownloadedNovelsテーブルの進捗を更新
        await _db.upsertDownloadedNovel(
          DownloadedNovelsCompanion(
            ncode: Value(ncodeLower),
            downloadStatus: const Value(1), // 1: ダウンロード中
            downloadedAt: Value(DateTime.now().millisecondsSinceEpoch),
            totalEpisodes: Value(totalEpisodes),
            downloadedEpisodes: Value(i),
          ),
        );

        // 進捗を通知
        progressController?.add(
          DownloadProgress(
            currentEpisode: i,
            totalEpisodes: totalEpisodes,
            isDownloading: true,
          ),
        );
      }

      // ダウンロード完了をDBに記録
      await _db.upsertDownloadedNovel(
        DownloadedNovelsCompanion(
          ncode: Value(ncodeLower),
          downloadStatus: const Value(2), // 2: 完了
          downloadedAt: Value(DateTime.now().millisecondsSinceEpoch),
          totalEpisodes: Value(totalEpisodes),
          downloadedEpisodes: Value(totalEpisodes),
        ),
      );
      progressController?.add(
        DownloadProgress(
          currentEpisode: totalEpisodes,
          totalEpisodes: totalEpisodes,
          isDownloading: false,
        ),
      );
    } catch (e) {
      // ダウンロード失敗をDBに記録
      final existing = await _db.getDownloadedNovel(ncodeLower);
      await _db.upsertDownloadedNovel(
        DownloadedNovelsCompanion(
          ncode: Value(ncodeLower),
          downloadStatus: const Value(3), // 3: 失敗
          downloadedAt: Value(
            existing?.downloadedAt ?? DateTime.now().millisecondsSinceEpoch,
          ),
          totalEpisodes: Value(existing?.totalEpisodes ?? totalEpisodes),
          downloadedEpisodes: Value(existing?.downloadedEpisodes ?? 0),
        ),
      );
      progressController?.add(
        DownloadProgress(
          currentEpisode: existing?.downloadedEpisodes ?? 0,
          totalEpisodes: existing?.totalEpisodes ?? totalEpisodes,
          isDownloading: false,
          errorMessage: e.toString(),
        ),
      );
      // エラーを再スロー
      rethrow;
    } finally {
      await progressController?.close();
      _progressControllers.remove(ncodeLower);
    }
  }

  /// ダウンロード済みエピソードを削除するメソッド。
  Future<void> deleteDownloadedEpisode(String ncode, int episode) async {
    await _db.deleteDownloadedEpisode(ncode, episode);
  }

  /// ダウンロード済み小説を削除するメソッド。
  Future<void> deleteDownloadedNovel(String ncode) async {
    final novel = await _db.getDownloadedNovel(ncode);
    if (novel == null) {
      return;
    }

    for (var i = 1; i <= novel.totalEpisodes; i++) {
      await _db.deleteDownloadedEpisode(ncode, i);
    }
    await _db.deleteDownloadedNovel(ncode);
  }

  /// ダウンロードパスを取得するメソッド。
  Stream<bool> isEpisodeDownloaded(String ncode, int episode) async* {
    final downloaded = await _db.getDownloadedEpisode(ncode, episode);
    yield downloaded != null;
  }

  /// 小説がダウンロードされているかを確認するメソッド。
  Stream<bool> isNovelDownloaded(String ncode) async* {
    final novel = await _db.getDownloadedNovel(ncode);
    yield novel != null && novel.downloadStatus == 2;
  }
}
