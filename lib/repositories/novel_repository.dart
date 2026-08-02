import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/models/download_result.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/providers/network_fallback_event_provider.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
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
        unawaited(controller.close());
      }
    }
    _progressControllers.clear();
  }

  /// 進捗管理用のキーを生成する
  String _progressKey(NovelSource source, String workId) =>
      '${source.dbId}:$workId';

  /// ダウンロード進捗を監視するストリーム
  Stream<DownloadProgress> watchDownloadProgress(
    NovelSource source,
    String workId,
  ) {
    final key = _progressKey(source, workId);
    _progressControllers.putIfAbsent(key, StreamController.broadcast);
    return _progressControllers[key]!.stream;
  }

  /// 小説をライブラリに追加する。
  ///
  /// 既に存在する場合は何もしない。
  /// 成功した場合はtrueを、既に存在した場合はfalseを返す。
  Future<bool> addNovelToLibrary(NovelSource source, String workId) async {
    // 既にライブラリに存在するかチェック
    final isInLibrary = await _db.isInLibrary(source, workId);
    if (isInLibrary) {
      return false;
    }

    // ライブラリに追加（P1時点ではなろうのみ対応）
    final novelInfo = await apiService.fetchNovelInfo(workId);

    // Novelテーブルに保存
    await _db.insertNovel(novelInfo.toDbCompanion());

    // LibraryEntriesテーブルに追加
    await _db.addToLibrary(source, workId);

    // Providersを無効化してUIを更新
    ref.invalidate(libraryNovelsProvider);

    return true;
  }

  /// 小説をライブラリから削除する。
  Future<void> removeFromLibrary(NovelSource source, String workId) async {
    await _db.removeFromLibrary(source, workId);

    // Providersを無効化してUIを更新
    ref.invalidate(libraryNovelsProvider);
  }

  /// 小説を閲覧履歴に追加する。
  Future<void> addToHistory({
    required NovelSource source,
    required String workId,
    required String title,
    required String writer,
    required int lastEpisode,
  }) async {
    // シークレットモードの場合は履歴を保存しない
    if (settings.value?.isIncognito ?? false) {
      return;
    }

    final validEpisode = lastEpisode > 0 ? lastEpisode : 1;

    // addToHistoryは現在ReadingHistoryCompanionを受け取る。
    // 小説情報は既にNovelsテーブルに存在するものとして扱う
    // （APIまたはライブラリ経由で取得済み）。
    // 存在しない場合は本来であれば挿入すべきだが、
    // ここでは完全なメタデータを持たないため挿入しない。
    // 以前の実装ではタイトル・作者名を持つHistoryテーブルに挿入していたが、
    // 新しいReadingHistoryテーブルはNovelsへの参照のみを持つ。
    // そのため、ReadingHistoryへの挿入のみを行う。

    await _db.addToHistory(
      ReadingHistoryCompanion(
        source: Value(source),
        workId: Value(workId),
        lastEpisodeId: Value(validEpisode),
        viewedAt: Value(DateTime.now().millisecondsSinceEpoch),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// 指定した作品の閲覧履歴を削除する。
  Future<void> deleteHistory(NovelSource source, String workId) async {
    await _db.deleteHistory(source, workId);
  }

  /// メタデータを含むエピソード本文を取得するヘルパーメソッド。
  Future<Episode> _fetchEpisode(
    String workId,
    int episode,
  ) async {
    return apiService.fetchEpisode(
      workId,
      episode,
    );
  }

  /// 単一エピソードのダウンロードを実行するメソッド。
  ///
  /// 既にダウンロード成功済み（contentが空でない）の場合はスキップする。
  /// [revised] が指定された場合、キャッシュの改稿日時と比較し、異なる場合は再ダウンロードする。
  /// 戻り値: ダウンロードに成功した場合true、失敗した場合false。
  Future<bool> downloadSingleEpisode(
    NovelSource source,
    String workId,
    int episode, {
    String? revised,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // 既にダウンロード成功済みかチェック
    final existing = await _db.getEpisodeData(source, workId, episode);
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
      final ep = await _fetchEpisode(workId, episode);
      final content = ep.body != null
          ? parseNovelContent(ep.body!)
          : <NovelContentElement>[];

      // データベースに保存（成功）
      await _db.updateEpisodeContent(
        source: source,
        workId: workId,
        episodeId: episode,
        content: content,
        fetchedAt: now,
        revisedAt: revised,
        subtitle: ep.subtitle,
        url: ep.url,
        publishedAt: ep.update,
      );

      return true;
    } on Exception {
      // データベースに保存（失敗）
      // フェッチに失敗した場合、空の本文で失敗記録を残す。
      // subtitle/urlは指定せず、既存の目次メタデータを上書きしない。

      try {
        await _db.updateEpisodeContent(
          source: source,
          workId: workId,
          episodeId: episode,
          content: const [], // 空の本文
          fetchedAt: now,
          revisedAt: revised,
        );
      } on Exception catch (_) {
        // 二次的な失敗は無視する
      }

      return false;
    }
  }

  /// 小説のエピソードを取得するメソッド。
  ///
  /// [revised] が指定された場合、キャッシュの改稿日時と比較し、
  /// 異なる場合は再取得する。
  Future<List<NovelContentElement>> getEpisode(
    NovelSource source,
    String workId,
    int episode, {
    String? revised,
  }) async {
    final cached = await _db.getEpisodeData(source, workId, episode);

    // ネットワーク接続状態を確認
    final isOffline = ref.read(isOfflineModeProvider);

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
      final ep = await _fetchEpisode(workId, episode);
      final content = ep.body != null
          ? parseNovelContent(ep.body!)
          : <NovelContentElement>[];

      await _db.updateEpisodeContent(
        source: source,
        workId: workId,
        episodeId: episode,
        content: content,
        fetchedAt: DateTime.now().millisecondsSinceEpoch,
        revisedAt: revised,
        subtitle: ep.subtitle,
        url: ep.url,
        publishedAt: ep.update,
      );
      return content;
    } on Exception {
      // 失敗時はキャッシュがあればフォールバックして返す
      if (cached != null &&
          cached.content != null &&
          cached.content!.isNotEmpty) {
        _emitFallbackEvent('最新のエピソードを取得できませんでした。キャッシュを表示しています。');
        return cached.content!;
      }

      // 失敗時は空の本文で失敗記録を残す
      // subtitle/urlは指定せず、既存の目次メタデータを上書きしない
      try {
        await _db.updateEpisodeContent(
          source: source,
          workId: workId,
          episodeId: episode,
          content: const [],
          fetchedAt: DateTime.now().millisecondsSinceEpoch,
          revisedAt: revised,
        );
      } on Exception catch (_) {}
      rethrow;
    }
  }

  /// 小説の情報を取得するメソッド。
  Future<void> downloadEpisode(
    NovelSource source,
    String workId,
    int episode,
  ) async {
    // 既存のdownloadSingleEpisodeを利用するように変更
    await downloadSingleEpisode(source, workId, episode);
  }

  /// 小説のダウンロードを行うメソッド。
  ///
  /// 各エピソードのダウンロードを試み、失敗したエピソードがあっても継続する。
  /// 最初に目次を取得して改稿日時(revised)を確認する。
  Future<void> downloadNovel(
    NovelSource source,
    String workId,
    int totalEpisodes,
  ) async {
    final progressController =
        _progressControllers[_progressKey(
          source,
          workId,
        )];
    var successCount = 0;
    var failureCount = 0;

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
        final info = await apiService.fetchNovelInfo(workId);
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

      // 各エピソードをダウンロード
      for (var i = 1; i <= totalEpisodes; i++) {
        final revised = revisedMap[i];
        final success = await downloadSingleEpisode(
          source,
          workId,
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
      progressController?.add(
        DownloadProgress(
          currentEpisode: successCount,
          totalEpisodes: totalEpisodes,
          isDownloading: false,
          errorMessage: e.toString(),
        ),
      );
      // エラーを再スロー
      rethrow;
    } finally {
      await progressController?.close();
      _progressControllers.remove(_progressKey(source, workId));
    }
  }

  /// ダウンロード済みエピソードを削除するメソッド。
  Future<void> deleteDownloadedEpisode(
    NovelSource source,
    String workId,
    int episode,
  ) async {
    // コンテンツをNULLに更新
    await (_db.update(_db.episodeContents)..where(
          (e) =>
              e.source.equalsValue(source) &
              e.workId.equals(workId) &
              e.episodeId.equals(episode),
        ))
        .write(
          const EpisodeContentsCompanion(
            content: Value<List<NovelContentElement>?>(null),
          ),
        );
  }

  /// ダウンロード済み小説を削除するメソッド。
  ///
  /// 該当作品のすべてのダウンロード済みエピソードを一括削除する。
  Future<void> deleteDownloadedNovel(
    NovelSource source,
    String workId,
  ) async {
    // コンテンツをNULLに更新する。
    await (_db.update(
          _db.episodeContents,
        )..where(
          (e) => e.source.equalsValue(source) & e.workId.equals(workId),
        ))
        .write(
          const EpisodeContentsCompanion(
            content: Value<List<NovelContentElement>?>(null),
          ),
        );
  }

  /// ダウンロードパスを取得するメソッド。
  Stream<bool> isEpisodeDownloaded(
    NovelSource source,
    String workId,
    int episode,
  ) async* {
    final cached = await _db.getEpisodeData(source, workId, episode);
    yield cached != null &&
        cached.content != null &&
        cached.content!.isNotEmpty;
  }

  /// 小説のダウンロードを行うメソッド。
  ///
  /// 戻り値の[DownloadResult]によって、UIでの処理を判断する。
  Future<DownloadResult> downloadNovelWithResult(
    NovelSource source,
    String workId,
    int totalEpisodes,
  ) async {
    try {
      await downloadNovel(source, workId, totalEpisodes);

      // ライブラリに追加されているかをチェック
      final isInLibrary = await _db.isInLibrary(source, workId);

      return DownloadResult.success(needsLibraryAddition: !isInLibrary);
    } on Exception catch (e) {
      return DownloadResult.error(e.toString());
    }
  }

  /// エピソードリストを取得する
  Future<List<Episode>> fetchEpisodeList(
    NovelSource source,
    String workId,
    int page,
  ) async {
    final start = (page - 1) * 100 + 1;
    final end = page * 100;

    // ネットワーク接続状態を確認
    final isOffline = ref.read(isOfflineModeProvider);

    // オフラインの場合はDBから取得
    if (isOffline) {
      final cachedEpisodes = await _db.getEpisodesRange(
        source,
        workId,
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
      final episodes = await apiService.fetchEpisodeList(workId, page);

      // DBに保存
      final episodesCompanions = episodes.map((e) {
        return EpisodeListEntriesCompanion(
          source: Value(source),
          workId: Value(workId),
          episodeId: Value(e.index ?? 0),
          subtitle: Value(e.subtitle),
          url: Value(e.url),
          publishedAt: Value(e.update),
          revisedAt: Value(e.revised),
          // 本文はここでは更新しない
        );
      }).toList();
      await _db.upsertEpisodes(episodesCompanions);

      return episodes;
    } catch (e) {
      // API取得失敗時はDBから取得を試みる
      final cachedEpisodes = await _db.getEpisodesRange(
        source,
        workId,
        start,
        end,
      );
      if (cachedEpisodes.isNotEmpty) {
        return cachedEpisodes;
      }
      rethrow;
    }
  }

  /// 小説情報を監視する
  ///
  /// DBにキャッシュがあれば即座に返し、最新情報を取得して更新する。
  /// キャッシュが無くて取得に失敗した場合はストリームエラーとして伝播する。
  Stream<NovelInfo> watchNovelInfo(NovelSource source, String workId) {
    return Stream.fromFuture(_db.getNovel(source, workId)).asyncExpand(
      (cached) {
        if (cached != null) {
          // キャッシュが存在する場合は即座に発行し、裏で再取得する
          _refreshNovelInfo(source, workId).ignore();
          return _db
              .watchNovel(source, workId)
              .where((novel) => novel != null)
              .map((novel) => novel!.toModel());
        }
        // キャッシュが無い場合は再取得に成功するまで待つ
        return Stream.fromFuture(
          _refreshNovelInfo(source, workId),
        ).asyncExpand(
          (_) => _db
              .watchNovel(source, workId)
              .where((novel) => novel != null)
              .map((novel) => novel!.toModel()),
        );
      },
    );
  }

  /// 小説情報を明示的に再取得する
  Future<void> refreshNovelInfo(NovelSource source, String workId) async {
    await _refreshNovelInfo(source, workId);
  }

  /// 小説情報をAPIから取得しDBに保存する。
  /// 取得失敗時はキャッシュがあればフォールバックイベントを発行し、
  /// キャッシュが無い場合はエラーを呼び出し元に伝える。
  Future<void> _refreshNovelInfo(NovelSource source, String workId) async {
    final isOffline = ref.read(isOfflineModeProvider);
    if (isOffline) {
      final cached = await _db.getNovel(source, workId);
      if (cached == null) {
        throw const OfflineException();
      }
      return;
    }

    try {
      // P1時点ではなろうのみ対応（workId = ncode）
      final info = await apiService.fetchNovelInfo(workId);
      await _db.insertNovel(info.toDbCompanion());
    } on NovelNotFoundException {
      // 非公開・削除された作品はプレースホルダーとして扱う
      await _db.ensureNovelFetchState(
        source,
        workId,
        isPrivate: true,
        cachedAt: DateTime.now().millisecondsSinceEpoch,
      );
    } on Exception {
      // ネットワークエラー等はキャッシュがあればフォールバックし、
      // キャッシュが無い場合はエラーを呼び出し元に伝える
      final cached = await _db.getNovel(source, workId);
      if (cached != null) {
        _emitFallbackEvent('最新の作品情報を取得できませんでした。キャッシュを表示しています。');
        await _db.ensureNovelFetchState(
          source,
          workId,
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        );
      } else {
        rethrow;
      }
    }
  }

  /// エピソードリストを監視する
  ///
  /// DBにキャッシュがあれば即座に返し、最新の目次を取得して更新する。
  /// キャッシュが無くて取得に失敗した場合はストリームエラーとして伝播する。
  Stream<List<Episode>> watchEpisodeList(
    NovelSource source,
    String workId,
    int page,
  ) {
    final start = (page - 1) * 100 + 1;
    final end = start + 99;

    return Stream.fromFuture(
      _db.getEpisodesRange(source, workId, start, end),
    ).asyncExpand((cached) {
      if (cached.isNotEmpty) {
        // キャッシュが存在する場合は即座に発行し、裏で再取得する
        _refreshEpisodeList(source, workId, page, start).ignore();
        return _db.watchEpisodesRange(source, workId, start, end);
      }
      // キャッシュが無い場合は再取得に成功するまで待つ
      return Stream.fromFuture(
        _refreshEpisodeList(source, workId, page, start),
      ).asyncExpand(
        (_) => _db.watchEpisodesRange(source, workId, start, end),
      );
    });
  }

  /// エピソードリストを明示的に再取得する
  Future<void> refreshEpisodeList(
    NovelSource source,
    String workId,
    int page,
  ) async {
    final start = (page - 1) * 100 + 1;
    await _refreshEpisodeList(source, workId, page, start);
  }

  /// エピソード目次をAPIから取得しDBに保存する。
  /// 取得失敗時はキャッシュがあればフォールバックイベントを発行し、
  /// キャッシュが無い場合はエラーを呼び出し元に伝える。
  Future<void> _refreshEpisodeList(
    NovelSource source,
    String workId,
    int page,
    int start,
  ) async {
    final isOffline = ref.read(isOfflineModeProvider);
    if (isOffline) {
      final cached = await _db.getEpisodesRange(
        source,
        workId,
        start,
        start + 99,
      );
      if (cached.isEmpty) {
        throw const OfflineException();
      }
      return;
    }

    try {
      final episodes = await apiService.fetchEpisodeList(workId, page);
      final companions = episodes.map((e) {
        return EpisodeListEntriesCompanion(
          source: Value(source),
          workId: Value(workId),
          episodeId: Value(e.index ?? 0),
          subtitle: Value(e.subtitle ?? ''),
          url: Value(e.url ?? ''),
          publishedAt: Value(e.update ?? ''),
          revisedAt: Value(e.revised ?? ''),
        );
      }).toList();
      await _db.upsertEpisodes(companions);
    } on Exception {
      // ネットワークエラー等はキャッシュがあればフォールバックし、
      // キャッシュが無い場合はエラーを呼び出し元に伝える
      final cached = await _db.getEpisodesRange(
        source,
        workId,
        start,
        start + 99,
      );
      if (cached.isNotEmpty) {
        _emitFallbackEvent('最新の目次を取得できませんでした。キャッシュを表示しています。');
      } else {
        rethrow;
      }
    }
  }

  /// 最後に読んだエピソード番号を監視する
  Stream<int?> watchLastReadEpisode(NovelSource source, String workId) {
    return (_db.select(_db.readingHistory)..where(
          (t) => t.source.equalsValue(source) & t.workId.equals(workId),
        ))
        .watchSingleOrNull()
        .map((history) => history?.lastEpisodeId);
  }

  /// フォールバックイベントを発行する。
  void _emitFallbackEvent(String message) {
    try {
      ref.read(networkFallbackEventProvider.notifier).emit(message);
    } on Exception catch (e) {
      debugPrint('フォールバックイベントの発行に失敗: $e');
    }
  }
}

// ==================== Providers ====================

@riverpod
/// 小説の情報を取得し、DBにキャッシュするプロバイダー。
Stream<NovelInfo> novelInfoWithCache(
  Ref ref,
  NovelSource source,
  String workId,
) {
  ref.keepAlive();
  final repository = ref.watch(novelRepositoryProvider);

  return repository.watchNovelInfo(source, workId);
}

@riverpod
/// 小説のコンテンツを取得するプロバイダー。
Future<List<NovelContentElement>> novelContent(
  Ref ref, {
  required NovelSource source,
  required String workId,
  required int episode,
  String? revised,
}) async {
  final repository = ref.read(novelRepositoryProvider);
  return repository.getEpisode(
    source,
    workId,
    episode,
    revised: revised,
  );
}

@riverpod
/// 小説のライブラリ状態を管理するプロバイダー。
class LibraryStatus extends _$LibraryStatus {
  @override
  Stream<bool> build(NovelSource source, String workId) {
    final db = ref.watch(appDatabaseProvider);
    return db.watchIsInLibrary(source, workId);
  }

  /// ライブラリの状態をトグルするメソッド。
  Future<void> toggle(NovelInfo novelInfo) async {
    final db = ref.read(appDatabaseProvider);
    final isInLibrary = state.value ?? false;
    final newStatus = !isInLibrary;

    state = const AsyncValue.loading();
    try {
      if (newStatus) {
        // 事前にNovelsテーブルに小説情報が存在することを保証する必要がある。
        // 通常はfetchNovelInfoによって挿入済み。
        await db.insertNovel(novelInfo.toDbCompanion());
        await db.addToLibrary(
          novelInfo.source,
          novelInfo.workId ?? novelInfo.ncode!,
        );
      } else {
        await db.removeFromLibrary(
          novelInfo.source,
          novelInfo.workId ?? novelInfo.ncode!,
        );
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
  NovelSource source,
  String workId,
) {
  final repo = ref.watch(novelRepositoryProvider);
  return repo.watchDownloadProgress(source, workId);
}

@riverpod
/// 小説のダウンロード状態を管理するプロバイダー。
///
/// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。
class DownloadStatus extends _$DownloadStatus {
  @override
  Stream<bool> build(NovelInfo novelInfo) {
    // ダウンロード状態の監視は不要になったため、ダミーを返す
    return Stream.value(false);
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
      final result = await repo.downloadNovelWithResult(
        novelInfo.source,
        novelInfo.workId ?? novelInfo.ncode!,
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
      await repo.deleteDownloadedNovel(
        novelInfo.source,
        novelInfo.workId ?? novelInfo.ncode!,
      );
      ref.invalidateSelf();
      return const DownloadResult.success();
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
      return DownloadResult.error(e.toString());
    }
  }
}

@riverpod
/// エピソードリストをページ単位で取得するプロバイダー。
Stream<List<Episode>> episodeList(
  Ref ref,
  NovelSource source,
  String workId,
  int page,
) {
  ref.keepAlive();
  final repository = ref.watch(novelRepositoryProvider);

  return repository.watchEpisodeList(source, workId, page);
}

@Riverpod(keepAlive: true)
/// 最後に読んだエピソード番号を取得するプロバイダー
Stream<int?> lastReadEpisode(Ref ref, NovelSource source, String workId) {
  final repository = ref.watch(novelRepositoryProvider);
  return repository.watchLastReadEpisode(source, workId);
}
