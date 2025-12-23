import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/models/download_result.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/providers/connectivity_provider.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/ncode_utils.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_swr/riverpod_swr.dart';

part 'novel_repository.g.dart';

@Riverpod(keepAlive: true)
/// 小説のダウンロードと管理を行うリポジトリ。
NovelRepository novelRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  final settings = ref.watch(settingsProvider);
  final db = ref.watch(appDatabaseProvider);
  final swrClient = ref.watch(swrClientProvider);

  final repository = NovelRepository(
    ref: ref,
    apiService: apiService,
    settings: settings,
    db: db,
    swrClient: swrClient,
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
    required SwrClient swrClient,
  }) : _db = db,
       _swrClient = swrClient;

  /// アプリケーションの設定を取得するためのリファレンス。
  final Ref ref;

  /// APIサービスを通じて小説データを取得するためのサービス。
  final ApiService apiService;

  /// アプリケーションの設定。
  final AsyncValue<AppSettings> settings;

  final AppDatabase _db;

  final SwrClient _swrClient;

  /// ダウンロード進捗のストリームコントローラー
  final Map<String, StreamController<DownloadProgress>> _progressControllers =
      {};

  /// リソースをクリーンアップする
  void dispose() {
    for (final controller in _progressControllers.values) {
      if (!controller.isClosed) {
        unawaited(controller.close());
      }
    }
    _progressControllers.clear();
  }

  /// ダウンロード進捗を監視するストリーム
  Stream<DownloadProgress> watchDownloadProgress(String ncode) {
    final normalizedNcode = ncode.toNormalizedNcode();
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
    final ncodeLower = ncode.toNormalizedNcode();

    // 既にライブラリに存在するかチェック
    final isInLibrary = await _db.isInLibrary(ncodeLower);
    if (isInLibrary) {
      return false;
    }

    // ライブラリに追加
    final novelInfo = await apiService.fetchNovelInfo(ncodeLower);

    // Novelテーブルに保存
    await _db.insertNovel(novelInfo.toDbCompanion());

    // LibraryEntriesテーブルに追加
    await _db.addToLibrary(ncodeLower);

    // Providersを無効化してUIを更新
    ref.invalidate(libraryNovelsProvider);

    return true;
  }

  /// 小説をライブラリから削除する。
  Future<void> removeFromLibrary(String ncode) async {
    final ncodeLower = ncode.toNormalizedNcode();
    await _db.removeFromLibrary(ncodeLower);

    // Providersを無効化してUIを更新
    ref.invalidate(libraryNovelsProvider);
  }

  /// 小説を閲覧履歴に追加する。
  Future<void> addToHistory({
    required String ncode,
    required String title,
    required String writer,
    required int lastEpisode,
  }) async {
    final normalizedNcode = ncode.toNormalizedNcode();
    final validEpisode = lastEpisode > 0 ? lastEpisode : 1;

    // Note: addToHistory now expects ReadingHistoryCompanion
    // We assume the novel is already in Novels table (fetched via API or Library).
    // If not, we should ideally insert it, but we don't have full metadata here.
    // The previous implementation inserted into History table which had title/writer.
    // The new ReadingHistory table only links to Novels.
    // For now, we proceed with inserting into ReadingHistory.

    await _db.addToHistory(
      ReadingHistoryCompanion(
        ncode: Value(normalizedNcode),
        lastEpisodeId: Value(validEpisode),
        viewedAt: Value(DateTime.now().millisecondsSinceEpoch),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// 指定したncodeの閲覧履歴を削除する。
  Future<void> deleteHistory(String ncode) async {
    final normalizedNcode = ncode.toNormalizedNcode();
    await _db.deleteHistory(normalizedNcode);
  }

  /// Helper to fetch full episode data including metadata
  Future<Episode> _fetchEpisode(
    String ncode,
    int episode,
  ) async {
    return apiService.fetchEpisode(
      ncode.toNormalizedNcode(),
      episode,
    );
  }

  /// 単一エピソードのダウンロードを実行するメソッド。
  ///
  /// 既にダウンロード成功済み（contentが空でない）の場合はスキップする。
  /// [revised] が指定された場合、キャッシュの改稿日時と比較し、異なる場合は再ダウンロードする。
  /// 戻り値: ダウンロードに成功した場合true、失敗した場合false。
  Future<bool> downloadSingleEpisode(
    String ncode,
    int episode, {
    String? revised,
  }) async {
    final ncodeLower = ncode.toNormalizedNcode();
    final now = DateTime.now().millisecondsSinceEpoch;

    // 既にダウンロード成功済みかチェック
    final existing = await _db.getEpisodeData(ncodeLower, episode);
    if (existing != null &&
        existing.content != null &&
        existing.content!.isNotEmpty) {
      // revisedが指定されていない、または一致する場合はスキップ
      if (revised == null || existing.revisedAt == revised) {
        return true;
      }
    }

    try {
      // エピソードをフェッチ (Metadata + Content)
      final ep = await _fetchEpisode(ncodeLower, episode);
      final content = ep.body != null
          ? parseNovelContent(ep.body!)
          : <NovelContentElement>[];

      // データベースに保存（成功）
      await _db.updateEpisodeContent(
        EpisodeEntitiesCompanion(
          ncode: Value(ncodeLower),
          episodeId: Value(episode),
          content: Value(content),
          fetchedAt: Value(now),
          revisedAt: Value(revised),
          subtitle: Value(ep.subtitle ?? ''),
          url: Value(ep.url ?? ''),
          publishedAt: Value(ep.update ?? ''),
        ),
      );

      return true;
    } on Exception {
      // データベースに保存（失敗）
      // We need to insert a record with empty content to mark failure/attempt.
      // But updateEpisodeContent requires subtitle/url.
      // If fetch failed, we might not have them.
      // If we have existing metadata, we can try to use it, but here we assume fetch failed completely.
      // For now, we skip saving failure state if we can't get metadata,
      // OR we save with empty strings if that's acceptable.
      // Let's try to save with empty strings to indicate failure.

      try {
        await _db.updateEpisodeContent(
          EpisodeEntitiesCompanion(
            ncode: Value(ncodeLower),
            episodeId: Value(episode),
            content: const Value([]), // Empty content
            fetchedAt: Value(now),
            revisedAt: Value(revised),
            subtitle: const Value(''),
            url: const Value(''),
          ),
        );
      } on Exception catch (_) {
        // Ignore secondary failure
      }

      return false;
    }
  }

  /// 小説のエピソードを取得するメソッド。
  ///
  /// [revised] が指定された場合、キャッシュの改稿日時と比較し、
  /// 異なる場合は再取得する。
  Future<List<NovelContentElement>> getEpisode(
    String ncode,
    int episode, {
    String? revised,
  }) async {
    final cached = await _db.getEpisodeData(ncode, episode);

    // ネットワーク接続状態を確認
    // ネットワーク接続状態を確認
    final isOffline = ref.read(isOfflineProvider);

    // 1. オフラインの場合はキャッシュを強制的に使用
    if (isOffline) {
      if (cached != null &&
          cached.content != null &&
          cached.content!.isNotEmpty) {
        return cached.content!;
      }
      throw Exception('Offline: No cached content available');
    }

    // 2. オンラインでも、キャッシュがあり、かつ改稿日時が一致する場合はキャッシュを使用（通信しない）
    if (cached != null &&
        cached.content != null &&
        cached.content!.isNotEmpty) {
      if (revised == null || cached.revisedAt == revised) {
        return cached.content!;
      }
    }

    // 3. オンラインかつ更新が必要な場合のみ取得
    try {
      final ep = await _fetchEpisode(ncode, episode);
      final content = ep.body != null
          ? parseNovelContent(ep.body!)
          : <NovelContentElement>[];

      await _db.updateEpisodeContent(
        EpisodeEntitiesCompanion(
          ncode: Value(ncode.toNormalizedNcode()),
          episodeId: Value(episode),
          content: Value(content),
          fetchedAt: Value(DateTime.now().millisecondsSinceEpoch),
          revisedAt: Value(revised),
          subtitle: Value(ep.subtitle ?? ''),
          url: Value(ep.url ?? ''),
          publishedAt: Value(ep.update ?? ''),
        ),
      );
      return content;
    } on Exception {
      // 失敗時はキャッシュがあればそれを返す
      if (cached != null &&
          cached.content != null &&
          cached.content!.isNotEmpty) {
        return cached.content!;
      }

      // 失敗時は空contentで保存
      try {
        await _db.updateEpisodeContent(
          EpisodeEntitiesCompanion(
            ncode: Value(ncode.toNormalizedNcode()),
            episodeId: Value(episode),
            content: const Value([]),
            fetchedAt: Value(DateTime.now().millisecondsSinceEpoch),
            revisedAt: Value(revised),
            subtitle: const Value(''),
            url: const Value(''),
          ),
        );
      } on Exception catch (_) {}
      rethrow;
    }
  }

  /// 小説の情報を取得するメソッド。
  Future<void> downloadEpisode(String ncode, int episode) async {
    // 既存のdownloadSingleEpisodeを利用するように変更
    await downloadSingleEpisode(ncode, episode);
  }

  /// 小説のダウンロードを行うメソッド。
  ///
  /// 各エピソードのダウンロードを試み、失敗したエピソードがあっても継続する。
  /// 最初に目次を取得して改稿日時(revised)を確認する。
  Future<void> downloadNovel(
    String ncode,
    int totalEpisodes,
  ) async {
    final ncodeLower = ncode.toNormalizedNcode();
    final progressController = _progressControllers[ncodeLower];

    try {
      // 初期進捗を通知
      progressController?.add(
        DownloadProgress(
          currentEpisode: 0,
          totalEpisodes: totalEpisodes,
          isDownloading: true,
        ),
      );

      // 目次情報を取得して改稿日時Mapを作成
      // これにより、改稿されたエピソードのみを再ダウンロードできる
      final revisedMap = <int, String?>{};
      try {
        final info = await apiService.fetchNovelInfo(ncodeLower);
        final episodes = info.episodes ?? [];
        for (final ep in episodes) {
          if (ep.index != null) {
            revisedMap[ep.index!] = ep.revised;
          }
        }
      } on Exception {
        // 目次取得失敗時はrevised情報なしで進める（全件チェックになるが、キャッシュがあればスキップされる）
        // ただし、キャッシュが古くてもスキップされてしまう可能性がある
      }

      var successCount = 0;
      var failureCount = 0;

      // 各エピソードをダウンロード
      for (var i = 1; i <= totalEpisodes; i++) {
        final revised = revisedMap[i];
        final success = await downloadSingleEpisode(
          ncodeLower,
          i,
          revised: revised,
        );

        if (success) {
          successCount++;
        } else {
          failureCount++;
        }

        // 進捗を通知
        progressController?.add(
          DownloadProgress(
            currentEpisode: successCount,
            totalEpisodes: totalEpisodes,
            isDownloading: true,
          ),
        );
      }

      // 完了通知
      progressController?.add(
        DownloadProgress(
          currentEpisode: successCount,
          totalEpisodes: totalEpisodes,
          isDownloading: false,
          errorMessage: failureCount > 0
              ? '$failureCount話のダウンロードに失敗しました'
              : null,
        ),
      );
    } on Exception catch (e) {
      // 予期しないエラーが発生した場合
      final summary = await _db.getNovelDownloadSummary(ncodeLower);
      progressController?.add(
        DownloadProgress(
          currentEpisode: summary?.successCount ?? 0,
          totalEpisodes: summary?.totalEpisodes ?? totalEpisodes,
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
    // コンテンツをNULLに更新
    await (_db.update(_db.episodeEntities)..where(
          (e) =>
              e.ncode.equals(ncode.toNormalizedNcode()) &
              e.episodeId.equals(episode),
        ))
        .write(const EpisodeEntitiesCompanion(content: Value(null)));
  }

  /// ダウンロード済み小説を削除するメソッド。
  ///
  /// 該当ncodeのすべてのダウンロード済みエピソードを一括削除する。
  Future<void> deleteDownloadedNovel(String ncode) async {
    // コンテンツをNULLに更新する。
    await (_db.update(_db.episodeEntities)
          ..where((e) => e.ncode.equals(ncode.toNormalizedNcode())))
        .write(const EpisodeEntitiesCompanion(content: Value(null)));
  }

  /// ダウンロードパスを取得するメソッド。
  Stream<bool> isEpisodeDownloaded(String ncode, int episode) async* {
    final cached = await _db.getEpisodeData(ncode, episode);
    yield cached != null &&
        cached.content != null &&
        cached.content!.isNotEmpty;
  }

  /// 小説がダウンロードされているかを確認するメソッド。
  ///
  /// DownloadedEpisodesから集計した状態を確認する。
  Stream<bool> isNovelDownloaded(String ncode) async* {
    final summary = await _db.getNovelDownloadSummary(ncode);
    yield summary != null && summary.downloadStatus == 2;
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
      final isInLibrary = await _db.isInLibrary(ncode.toNormalizedNcode());

      return DownloadResult.success(needsLibraryAddition: !isInLibrary);
    } on Exception catch (e) {
      return DownloadResult.error(e.toString());
    }
  }

  /// エピソードリストを取得する
  Future<List<Episode>> fetchEpisodeList(String ncode, int page) async {
    final normalizedNcode = ncode.toNormalizedNcode();
    final start = (page - 1) * 100 + 1;
    final end = page * 100;

    // ネットワーク接続状態を確認
    final isOffline = ref.read(isOfflineProvider);

    // オフラインの場合はDBから取得
    if (isOffline) {
      final cachedEpisodes = await _db.getEpisodesRange(
        normalizedNcode,
        start,
        end,
      );
      if (cachedEpisodes.isNotEmpty) {
        return cachedEpisodes;
      }
      // オフラインでキャッシュもない場合はエラー
      throw Exception('Offline: No cached episode list available');
    }

    try {
      // オンラインの場合はAPIから取得
      final episodes = await apiService.fetchEpisodeList(normalizedNcode, page);

      // DBに保存
      final episodesCompanions = episodes.map((e) {
        return EpisodeEntitiesCompanion(
          ncode: Value(normalizedNcode),
          episodeId: Value(e.index ?? 0),
          subtitle: Value(e.subtitle),
          url: Value(e.url),
          publishedAt: Value(e.update),
          revisedAt: Value(e.revised),
          // content is not updated here
        );
      }).toList();
      await _db.upsertEpisodes(episodesCompanions);

      return episodes;
    } catch (e) {
      // API取得失敗時はDBから取得を試みる
      final cachedEpisodes = await _db.getEpisodesRange(
        normalizedNcode,
        start,
        end,
      );
      if (cachedEpisodes.isNotEmpty) {
        return cachedEpisodes;
      }
      rethrow;
    }
  }

  /// 小説情報を監視する（SWR）
  Stream<AsyncValue<NovelInfo>> watchNovelInfo(String ncode) {
    final normalizedNcode = ncode.toNormalizedNcode();
    return _swrClient.watch<NovelInfo>(
      key: 'novel_info:$normalizedNcode',
      fetcher: () => apiService.fetchNovelInfo(normalizedNcode),
      watcher: () => _db
          .watchNovel(normalizedNcode)
          .where((novel) => novel != null)
          .map((novel) => novel!.toModel()),
      onPersist: (data) async {
        await _db.insertNovel(data.toDbCompanion());
      },
    );
  }

  /// エピソードリストを監視する（SWR）
  Stream<AsyncValue<List<Episode>>> watchEpisodeList(String ncode, int page) {
    final normalizedNcode = ncode.toNormalizedNcode();
    final start = (page - 1) * 100 + 1;
    final end = page * 100;

    return _swrClient.watch<List<Episode>>(
      key: 'episode_list:$normalizedNcode:$page',
      fetcher: () => apiService.fetchEpisodeList(normalizedNcode, page),
      watcher: () => _db.watchEpisodesRange(normalizedNcode, start, end),
      onPersist: (data) async {
        final companions = data.map((Episode e) {
          return EpisodeEntitiesCompanion(
            ncode: Value(normalizedNcode),
            episodeId: Value(e.index ?? 0),
            subtitle: Value(e.subtitle ?? ''),
            url: Value(e.url ?? ''),
            publishedAt: Value(e.update ?? ''),
            revisedAt: Value(e.revised ?? ''),
          );
        }).toList();
        await _db.upsertEpisodes(companions);
      },
    );
  }
}

// ==================== Providers ====================

@riverpod
/// 小説の情報を取得し、DBにキャッシュするプロバイダー（SWR）。
Stream<NovelInfo> novelInfoWithCache(
  Ref ref,
  String ncode,
) {
  final normalizedNcode = ncode.toNormalizedNcode();
  final repository = ref.watch(novelRepositoryProvider);
  return repository
      .watchNovelInfo(normalizedNcode)
      .where((av) => av.hasValue)
      .map((av) => av.value!);
}

@riverpod
/// 小説のコンテンツを取得するプロバイダー。
Future<List<NovelContentElement>> novelContent(
  Ref ref, {
  required String ncode,
  required int episode,
  String? revised,
}) async {
  final normalizedNcode = ncode.toNormalizedNcode();
  final repository = ref.read(novelRepositoryProvider);
  return repository.getEpisode(normalizedNcode, episode, revised: revised);
}

@riverpod
/// 小説のライブラリ状態を管理するプロバイダー。
class LibraryStatus extends _$LibraryStatus {
  @override
  Stream<bool> build(String ncode) {
    final normalizedNcode = ncode.toNormalizedNcode();
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
        // Note: We need to ensure Novel is in Novels table first.
        // Usually fetchNovelInfo handles this.
        await db.insertNovel(novelInfo.toDbCompanion());
        await db.addToLibrary(novelInfo.ncode!);
      } else {
        await db.removeFromLibrary(novelInfo.ncode!);
      }

      ref.invalidate(libraryNovelsProvider);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
/// 小説のダウンロード進捗を監視するプロバイダー。
Stream<DownloadProgress?> downloadProgress(
  Ref ref,
  String ncode,
) {
  final normalizedNcode = ncode.toNormalizedNcode();
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
/// エピソードのダウンロード状態を監視するプロバイダー。
///
/// 戻り値: ダウンロード状態を表すint値（2=成功、3=失敗、null=未ダウンロード）
Stream<int?> episodeDownloadStatus(
  Ref ref, {
  required String ncode,
  required int episode,
}) {
  final normalizedNcode = ncode.toNormalizedNcode();
  final db = ref.watch(appDatabaseProvider);

  return db.watchEpisodeEntity(normalizedNcode, episode).map((cached) {
    if (cached == null) return null;
    if (cached.content != null && cached.content!.isNotEmpty) {
      return 2; // Success
    } else if (cached.content != null && cached.content!.isEmpty) {
      return 3; // Failure (assuming empty content means failure as per logic)
    }
    return null;
  });
}

@riverpod
/// エピソードリストをページ単位で取得するプロバイダー（SWR）
Stream<List<Episode>> episodeList(
  Ref ref,
  String ncodeAndPage,
) {
  final parts = ncodeAndPage.split('_');
  final ncode = parts[0];
  final page = int.parse(parts[1]);
  final repository = ref.watch(novelRepositoryProvider);

  return repository
      .watchEpisodeList(ncode, page)
      .where((av) => av.hasValue)
      .map((av) => av.value!);
}
