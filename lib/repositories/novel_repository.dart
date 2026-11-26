import 'dart:async';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:kakuyomu_parser/kakuyomu_parser.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/models/download_result.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/providers/network_fallback_event_provider.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_site_registry.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:tiny_http/tiny_http.dart';

/// 小説のダウンロードと管理を行うリポジトリクラス。
class NovelRepository {
  /// コンストラクタ。
  ///
  /// [sites] はテスト時にサイト実装を差し替えるために注入できる。
  /// 省略時は [defaultNovelSiteRegistry] を使用する。
  NovelRepository({
    required this.apiService,
    required this.settings,
    required AppDatabase db,
    NetworkFallbackBus? fallback,
    Map<NovelSource, NovelSite>? sites,
  }) : _db = db,
       _fallback = fallback ?? NetworkFallbackBus(),
       _sites = sites ?? defaultNovelSiteRegistry;

  /// APIサービスを通じて小説データを取得するためのサービス。
  final ApiService apiService;

  /// アプリケーションの設定。
  final SettingsController settings;

  /// Where cache-fallback events are reported.
  final NetworkFallbackBus _fallback;

  final AppDatabase _db;

  /// サイト実装のレジストリ（テスト時に差し替え可能）。
  final Map<NovelSource, NovelSite> _sites;

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

    // ライブラリに追加（sourceに応じてサイト実装へ振り分け）
    final novelInfo = await _fetchNovelInfo(source, workId);

    // Novelテーブルに保存
    await _db.insertNovel(novelInfo.toDbCompanion());

    // LibraryEntriesテーブルに追加
    await _db.addToLibrary(source, workId);

    return true;
  }

  /// 小説をライブラリから削除する。
  ///
  /// [deleteDownloads] が true の場合は、ダウンロード済みの本文も削除する。
  /// 作品情報・目次・閲覧履歴は残す。
  Future<void> removeFromLibrary(
    NovelSource source,
    String workId, {
    bool deleteDownloads = false,
  }) async {
    // ライブラリ登録とダウンロード本文の削除を不可分に行う
    await _db.transaction(() async {
      await _db.removeFromLibrary(source, workId);

      if (deleteDownloads) {
        await deleteDownloadedNovel(source, workId);
      }
    });
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
  ///
  /// なろうは [ApiService]、カクヨムはサイト実装（[NovelSite]）へ振り分ける。
  Future<Episode> _fetchEpisode(
    NovelSource source,
    String workId,
    int episode,
  ) async {
    if (source == NovelSource.narou) {
      return apiService.fetchEpisode(
        workId,
        episode,
      );
    }
    final site = _sites[source]!;
    // カクヨムはURL（エピソードID）が必須のため、目次キャッシュから解決する
    final url = await _db.getEpisodeUrl(source, workId, episode);
    return site.fetchEpisode(workId, episode, url: url);
  }

  /// 作品情報を取得するヘルパーメソッド。
  ///
  /// なろうは [ApiService]、カクヨムはサイト実装（[NovelSite]）へ振り分ける。
  Future<NovelInfo> _fetchNovelInfo(
    NovelSource source,
    String workId,
  ) {
    if (source == NovelSource.narou) {
      return apiService.fetchNovelInfo(workId);
    }
    return _sites[source]!.fetchNovelInfo(workId);
  }

  /// エピソードリスト（目次）を取得するヘルパーメソッド。
  ///
  /// なろうはページングAPI、カクヨムは全件目次（`episode_sidebar`）を
  /// ページ単位にスライスして返す。
  Future<List<Episode>> _fetchEpisodeList(
    NovelSource source,
    String workId,
    int page,
  ) async {
    if (source == NovelSource.narou) {
      return apiService.fetchEpisodeList(workId, page);
    }
    final all = await _sites[source]!.fetchToc(workId);
    final start = (page - 1) * 100;
    final end = math.min(start + 100, all.length);
    if (start >= all.length) {
      return const <Episode>[];
    }
    return all.sublist(start, end);
  }

  /// エピソード本文をコンテンツ要素へパースするヘルパーメソッド。
  List<NovelContentElement> _parseEpisodeBody(
    NovelSource source,
    String body,
  ) {
    if (source == NovelSource.narou) {
      return parseNovelContent(body);
    }
    return parseKakuyomuEpisodeBody(body);
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
      final ep = await _fetchEpisode(source, workId, episode);
      final content = ep.body != null
          ? _parseEpisodeBody(source, ep.body!)
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
    } on Object catch (error) {
      if (!_isRetrievalFailure(error)) {
        rethrow;
      }

      // 取得に失敗した話は、空の本文で失敗記録として残す。
      // subtitle/urlは指定せず、既存の目次メタデータを上書きしない。
      try {
        await _db.updateEpisodeContent(
          source: source,
          workId: workId,
          episodeId: episode,
          content: const [],
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
    final isOffline = settings.isOfflineMode;

    // 1. オフラインの場合はキャッシュを強制的に使用
    if (isOffline) {
      if (cached != null &&
          cached.content != null &&
          cached.content!.isNotEmpty) {
        return cached.content!;
      }
      throw const OfflineException();
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
      final ep = await _fetchEpisode(source, workId, episode);
      final content = ep.body != null
          ? _parseEpisodeBody(source, ep.body!)
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
    } on Object catch (error) {
      if (!_isRetrievalFailure(error)) {
        rethrow;
      }

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
        final info = await _fetchNovelInfo(source, workId);
        final episodes = info.episodes ?? [];
        for (final ep in episodes) {
          if (ep.index != null) {
            revisedMap[ep.index!] = ep.revised;
          }
        }
      } on Object catch (error) {
        if (!_isRetrievalFailure(error)) {
          rethrow;
        }
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
    final isOffline = settings.isOfflineMode;

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
      throw const OfflineException();
    }

    try {
      // オンラインの場合はAPI（サイト実装）から取得
      final episodes = await _fetchEpisodeList(source, workId, page);

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
    final isOffline = settings.isOfflineMode;
    if (isOffline) {
      final cached = await _db.getNovel(source, workId);
      if (cached == null) {
        throw const OfflineException();
      }
      return;
    }

    try {
      // sourceに応じたサイト実装から作品情報を取得
      final info = await _fetchNovelInfo(source, workId);
      await _db.insertNovel(info.toDbCompanion());
    } on NovelNotFoundException {
      // 非公開・削除された作品はプレースホルダーとして扱う
      await _db.ensureNovelFetchState(
        source,
        workId,
        isPrivate: true,
        cachedAt: DateTime.now().millisecondsSinceEpoch,
      );
    } on Object catch (error) {
      if (!_isRetrievalFailure(error)) {
        rethrow;
      }

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
    final isOffline = settings.isOfflineMode;
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
      final episodes = await _fetchEpisodeList(source, workId, page);
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
    } on Object catch (error) {
      if (!_isRetrievalFailure(error)) {
        rethrow;
      }

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

  /// 取得の過程で想定される失敗かどうか。
  ///
  /// これ以外（DB障害やプログラミングエラー）は握り潰さず伝播させる。
  bool _isRetrievalFailure(Object error) =>
      error is TinyHttpException ||
      error is FormatException ||
      error is NovelNotFoundException ||
      error is EpisodeNotFoundException;

  /// フォールバックイベントを発行する。
  void _emitFallbackEvent(String message) {
    try {
      _fallback.emit(message);
    } on Object catch (e) {
      debugPrint('フォールバックイベントの発行に失敗: $e');
    }
  }

  /// Adds the novel to the library.
  ///
  /// 登録は冪等なので、登録済みでも呼び出して問題ない。
  /// 登録解除はダウンロード済み本文の削除を伴う確認が必要なため、
  /// 画面からは [NovelRepository.removeFromLibrary] を
  /// 確認ダイアログ経由で呼ぶこと。
  Future<void> addNovelInfoToLibrary(NovelInfo novelInfo) async {
    // The novels row has to exist first. It usually does: fetchNovelInfo
    // inserts it before the user can ask for the library.
    await _db.insertNovel(novelInfo.toDbCompanion());
    await _db.addToLibrary(
      novelInfo.source,
      novelInfo.resolvedWorkId ??
          (throw StateError('NovelInfo has neither workId nor ncode')),
    );
  }

  /// Downloads a whole work from its novel info.
  ///
  /// Permissions and result display belong to the caller.
  Future<DownloadResult> downloadNovelInfo(NovelInfo novelInfo) async {
    final workId = novelInfo.resolvedWorkId;
    final totalEpisodes = novelInfo.generalAllNo;
    if (workId == null) {
      return const DownloadResult.error('作品IDを取得できませんでした');
    }
    if (totalEpisodes == null) {
      return const DownloadResult.error('話数を取得できませんでした');
    }

    try {
      return await downloadNovelWithResult(
        novelInfo.source,
        workId,
        totalEpisodes,
      );
    } on Exception catch (e) {
      return DownloadResult.error(e.toString());
    }
  }
}
