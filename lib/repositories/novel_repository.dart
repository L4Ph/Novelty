import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/models/download_result.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/novel_parser.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'novel_repository.g.dart';

@Riverpod(keepAlive: true)
/// 小説のダウンロードと管理を行うリポジトリ。
NovelRepository novelRepository(Ref ref) {
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
}

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

  /// 小説をライブラリから削除する。
  Future<void> removeFromLibrary(String ncode) async {
    final ncodeLower = ncode.toLowerCase();
    await _db.removeFromLibrary(ncodeLower);

    // Providersを無効化してUIを更新
    ref
      ..invalidate(libraryNovelsProvider)
      ..invalidate(enrichedRankingDataProvider('d'))
      ..invalidate(enrichedRankingDataProvider('w'))
      ..invalidate(enrichedRankingDataProvider('m'))
      ..invalidate(enrichedRankingDataProvider('q'))
      ..invalidate(enrichedRankingDataProvider('all'));
  }

  /// 小説を閲覧履歴に追加する。
  Future<void> addToHistory({
    required String ncode,
    required String title,
    required String writer,
    required int lastEpisode,
  }) async {
    final normalizedNcode = ncode.toLowerCase();
    final validEpisode = lastEpisode > 0 ? lastEpisode : 1;

    await _db.addToHistory(
      HistoryCompanion(
        ncode: Value(normalizedNcode),
        title: Value(title),
        writer: Value(writer),
        lastEpisode: Value(validEpisode),
        viewedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// 指定したncodeの閲覧履歴を削除する。
  Future<void> deleteHistory(String ncode) async {
    final normalizedNcode = ncode.toLowerCase();
    await _db.deleteHistory(normalizedNcode);
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

  /// Permission処理を含む小説のダウンロードを行うメソッド。
  ///
  /// 戻り値の[DownloadResult]によって、UIでの処理を判断する。
  Future<DownloadResult> downloadNovelWithPermission(
    String ncode,
    int totalEpisodes,
  ) async {
    // Permissionチェック
    var hasPermission = false;
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.status;
      if (status.isGranted) {
        hasPermission = true;
      } else {
        final result = await Permission.manageExternalStorage.request();
        hasPermission = result.isGranted;
      }
    } else {
      final status = await Permission.storage.status;
      if (status.isGranted) {
        hasPermission = true;
      } else {
        final result = await Permission.storage.request();
        hasPermission = result.isGranted;
      }
    }

    if (!hasPermission) {
      return const DownloadResult.permissionDenied();
    }

    try {
      await downloadNovel(ncode, totalEpisodes);

      // ライブラリに追加されているかをチェック
      final isInLibrary = await _db.isInLibrary(ncode.toLowerCase());

      return DownloadResult.success(needsLibraryAddition: !isInLibrary);
    } on Exception catch (e) {
      return DownloadResult.error(e.toString());
    }
  }
}

// ==================== Providers ====================

@riverpod
/// 小説のコンテンツを取得するプロバイダー。
Future<List<NovelContentElement>> novelContent(
  Ref ref, {
  required String ncode,
  required int episode,
}) async {
  final normalizedNcode = ncode.toLowerCase();
  final repository = ref.read(novelRepositoryProvider);
  return repository.getEpisode(normalizedNcode, episode);
}

@riverpod
/// 小説のライブラリ状態を管理するプロバイダー。
class LibraryStatus extends _$LibraryStatus {
  @override
  Stream<bool> build(String ncode) {
    final normalizedNcode = ncode.toLowerCase();
    final db = ref.watch(appDatabaseProvider);
    return db.watchIsInLibrary(normalizedNcode);
  }

  /// ライブラリの状態をトグルするメソッド。
  Future<void> toggle(NovelInfo novelInfo) async {
    final db = ref.read(appDatabaseProvider);
    final isInLibrary = state.value ?? false;
    final newStatus = !isInLibrary;

    state = const AsyncValue.loading();
    try {
      if (newStatus) {
        final entry = LibraryNovelsCompanion(
          ncode: Value(novelInfo.ncode!),
          title: Value(novelInfo.title),
          writer: Value(novelInfo.writer),
          story: Value(novelInfo.story),
          novelType: Value(novelInfo.novelType),
          end: Value(novelInfo.end),
          generalAllNo: Value(novelInfo.generalAllNo),
          novelUpdatedAt: Value(novelInfo.novelupdatedAt?.toString()),
          addedAt: Value(DateTime.now().millisecondsSinceEpoch),
        );
        await db.addToLibrary(entry);
      } else {
        await db.removeFromLibrary(novelInfo.ncode!);
      }

      ref
        ..invalidate(libraryNovelsProvider)
        ..invalidate(enrichedRankingDataProvider('d'))
        ..invalidate(enrichedRankingDataProvider('w'))
        ..invalidate(enrichedRankingDataProvider('m'))
        ..invalidate(enrichedRankingDataProvider('q'))
        ..invalidate(enrichedRankingDataProvider('all'));
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
/// 小説のダウンロード進捗を監視するプロバイダー。
Stream<DownloadProgress?> downloadProgress(Ref ref, String ncode) {
  final normalizedNcode = ncode.toLowerCase();
  final repo = ref.watch(novelRepositoryProvider);
  return repo.watchDownloadProgress(normalizedNcode);
}

@riverpod
/// 小説のダウンロード状態を管理するプロバイダー。
///
/// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。
class DownloadStatus extends _$DownloadStatus {
  @override
  Stream<bool> build(NovelInfo novelInfo) {
    final repo = ref.watch(novelRepositoryProvider);

    // downloadProgressProviderを監視
    ref.listen<AsyncValue<DownloadProgress?>>(
      downloadProgressProvider(novelInfo.ncode!),
      (previous, next) {
        final progress = next.value;
        if (progress != null && !progress.isDownloading) {
          // ダウンロードが完了または失敗したら、自身の状態を再評価
          ref.invalidateSelf();
        }
      },
    );

    return repo.isNovelDownloaded(novelInfo.ncode!);
  }

  /// 小説のダウンロードを実行するメソッド。
  ///
  /// Permission処理を含み、結果を[DownloadResult]で返す。
  /// UIでの処理（Dialog、SnackBar表示等）は呼び出し側で行う。
  Future<DownloadResult> executeDownload(NovelInfo novelInfo) async {
    final repo = ref.read(novelRepositoryProvider);
    final previousState = state;
    state = const AsyncValue.loading();

    try {
      final result = await repo.downloadNovelWithPermission(
        novelInfo.ncode!,
        novelInfo.generalAllNo!,
      );

      return result;
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
      await Future<void>.delayed(const Duration(seconds: 2));
      state = previousState;
      return DownloadResult.error(e.toString());
    }
  }

  /// 小説の削除を実行するメソッド。
  ///
  /// 削除確認はUIレイヤーで行うため、このメソッドは削除のみを実行する。
  Future<DownloadResult> executeDelete(NovelInfo novelInfo) async {
    final repo = ref.read(novelRepositoryProvider);
    state = const AsyncValue.loading();

    try {
      await repo.deleteDownloadedNovel(novelInfo.ncode!);
      ref.invalidateSelf();
      return const DownloadResult.success();
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
      return DownloadResult.error(e.toString());
    }
  }
}

@riverpod
/// 現在のエピソード番号を管理するプロバイダー。
class CurrentEpisode extends _$CurrentEpisode {
  @override
  int build() => 1;

  /// 現在のエピソード番号を設定するメソッド。
  void set(int value) => state = value;
}
