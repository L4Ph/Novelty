import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/novel_parser.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:path/path.dart' as p;

/// 小説のダウンロードと管理を行うリポジトリ。
final novelRepositoryProvider = Provider<NovelRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final settings = ref.watch(settingsProvider);
  return NovelRepository(
    ref: ref,
    apiService: apiService,
    settings: settings,
  );
});

/// 小説のダウンロードと管理を行うリポジトリクラス。
class NovelRepository {
  /// コンストラクタ。
  NovelRepository({
    required this.ref,
    required this.apiService,
    required this.settings,
  });

  /// アプリケーションの設定を取得するためのリファレンス。
  final Ref ref;

  /// APIサービスを通じて小説データを取得するためのサービス。
  final ApiService apiService;

  /// アプリケーションの設定。
  final AsyncValue<AppSettings> settings;

  /// ダウンロード進捗のストリームコントローラー
  final Map<String, StreamController<DownloadProgress>> _progressControllers = {};

  /// ダウンロード進捗を監視するストリーム
  Stream<DownloadProgress> watchDownloadProgress(String ncode) {
    final normalizedNcode = ncode.toLowerCase();
    if (!_progressControllers.containsKey(normalizedNcode)) {
      _progressControllers[normalizedNcode] = StreamController<DownloadProgress>.broadcast();
    }
    return _progressControllers[normalizedNcode]!.stream;
  }

  /// ダウンロード進捗を更新する
  void _updateProgress(String ncode, DownloadProgress progress) {
    final normalizedNcode = ncode.toLowerCase();
    final controller = _progressControllers[normalizedNcode];
    if (controller != null && !controller.isClosed) {
      controller.add(progress);
    }
  }

  /// ダウンロード進捗をクリア
  void _clearProgress(String ncode) {
    final normalizedNcode = ncode.toLowerCase();
    final controller = _progressControllers[normalizedNcode];
    if (controller != null && !controller.isClosed) {
      controller.close();
      _progressControllers.remove(normalizedNcode);
    }
  }

  String _getNovelDirectory(String downloadPath, String ncode) =>
      p.join(downloadPath, ncode.toLowerCase());

  String _getEpisodeDirectory(String downloadPath, String ncode, int episode) =>
      p.join(_getNovelDirectory(downloadPath, ncode.toLowerCase()), episode.toString());

  File _getEpisodeContentFile(String downloadPath, String ncode, int episode) =>
      File(
        p.join(
          _getEpisodeDirectory(downloadPath, ncode.toLowerCase(), episode),
          'content.json',
        ),
      );

  File _getNovelInfoFile(String downloadPath, String ncode) =>
      File(p.join(_getNovelDirectory(downloadPath, ncode.toLowerCase()), 'info.json'));

  /// 小説のエピソードを取得するメソッド。
  Future<List<NovelContentElement>> getEpisode(
    String ncode,
    int episode,
  ) async {
    final downloadPath = await _getDownloadPath();
    final contentFile = _getEpisodeContentFile(downloadPath, ncode.toLowerCase(), episode);

    if (await contentFile.exists()) {
      final content = await contentFile.readAsString();
      final decoded = jsonDecode(content) as List<dynamic>;
      return decoded
          .map((e) => NovelContentElement.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final episodeData = await apiService.fetchEpisode(ncode.toLowerCase(), episode);
    if (episodeData.body == null) {
      return [];
    }

    final parsedContent = parseNovel(episodeData.body!);
    return parsedContent;
  }

  /// 小説の情報を取得するメソッド。
  Future<void> downloadEpisode(String ncode, int episode) async {
    final downloadPath = await _getDownloadPath();
    final episodeDir = Directory(
      _getEpisodeDirectory(downloadPath, ncode.toLowerCase(), episode),
    );
    if (!await episodeDir.exists()) {
      await episodeDir.create(recursive: true);
    }

    final contentFile = _getEpisodeContentFile(downloadPath, ncode.toLowerCase(), episode);
    if (await contentFile.exists()) {
      return; // Already downloaded
    }

    final episodeData = await apiService.fetchEpisode(ncode.toLowerCase(), episode);
    if (episodeData.body == null) {
      throw Exception('Failed to fetch episode content');
    }

    final parsedContent = parseNovel(episodeData.body!);
    final encodedContent = jsonEncode(
      parsedContent.map((e) => e.toJson()).toList(),
    );
    await contentFile.writeAsString(encodedContent);
  }

  /// 小説のダウンロードを行うメソッド。
  Future<void> downloadNovel(NovelInfo novelInfo) async {
    final ncode = novelInfo.ncode!.toLowerCase();
    final downloadPath = await _getDownloadPath();
    
    try {
      final novelDir = Directory(_getNovelDirectory(downloadPath, ncode));
      if (!await novelDir.exists()) {
        await novelDir.create(recursive: true);
      }

      final infoFile = _getNovelInfoFile(downloadPath, ncode);
      await infoFile.writeAsString(jsonEncode(novelInfo.toJson()));

      // 短編小説の場合
      if (novelInfo.novelType == 2 && novelInfo.end == 0 && novelInfo.generalAllNo == 1) {
        _updateProgress(ncode, const DownloadProgress(
          currentEpisode: 0,
          totalEpisodes: 1,
          isDownloading: true,
        ));
        
        await downloadEpisode(ncode, 1);
        
        _updateProgress(ncode, const DownloadProgress(
          currentEpisode: 1,
          totalEpisodes: 1,
          isDownloading: false,
        ));
        
        _clearProgress(ncode);
        return;
      }

      if (novelInfo.episodes == null || novelInfo.episodes!.isEmpty) {
        _updateProgress(ncode, const DownloadProgress(
          currentEpisode: 0,
          totalEpisodes: 0,
          isDownloading: false,
          errorMessage: 'エピソード情報が取得できませんでした',
        ));
        _clearProgress(ncode);
        return;
      }

      final totalEpisodes = novelInfo.episodes!.length;
      _updateProgress(ncode, DownloadProgress(
        currentEpisode: 0,
        totalEpisodes: totalEpisodes,
        isDownloading: true,
      ));

      var currentEpisode = 0;
      for (final episode in novelInfo.episodes!) {
        if (episode.index != null) {
          await downloadEpisode(ncode, episode.index!);
          currentEpisode++;
          _updateProgress(ncode, DownloadProgress(
            currentEpisode: currentEpisode,
            totalEpisodes: totalEpisodes,
            isDownloading: currentEpisode < totalEpisodes,
          ));
        }
      }
      
      _clearProgress(ncode);
    } catch (e) {
      _updateProgress(ncode, DownloadProgress(
        currentEpisode: 0,
        totalEpisodes: novelInfo.episodes?.length ?? 0,
        isDownloading: false,
        errorMessage: e.toString(),
      ));
      _clearProgress(ncode);
      rethrow;
    }
  }

  /// ダウンロード済みエピソードを削除するメソッド。
  Future<void> deleteDownloadedEpisode(String ncode, int episode) async {
    final downloadPath = await _getDownloadPath();
    final episodeDir = Directory(
      _getEpisodeDirectory(downloadPath, ncode.toLowerCase(), episode),
    );
    if (await episodeDir.exists()) {
      await episodeDir.delete(recursive: true);
    }
  }

  /// ダウンロード済み小説を削除するメソッド。
  Future<void> deleteDownloadedNovel(NovelInfo novelInfo) async {
    final ncode = novelInfo.ncode!.toLowerCase();
    final downloadPath = await _getDownloadPath();
    final novelDir = Directory(_getNovelDirectory(downloadPath, ncode));
    if (await novelDir.exists()) {
      await novelDir.delete(recursive: true);
    }
  }

  /// ダウンロードパスを取得するメソッド。
  Stream<bool> isEpisodeDownloaded(String ncode, int episode) async* {
    final downloadPath = await _getDownloadPath();
    final contentFile = _getEpisodeContentFile(downloadPath, ncode.toLowerCase(), episode);
    yield await contentFile.exists();
  }

  /// 小説がダウンロードされているかを確認するメソッド。
  Stream<bool> isNovelDownloaded(NovelInfo novelInfo) async* {
    final ncode = novelInfo.ncode!.toLowerCase();
    final downloadPath = await _getDownloadPath();

    if (novelInfo.novelType == 2) {
      yield* isEpisodeDownloaded(ncode, 1);
      return;
    }

    if (novelInfo.episodes == null || novelInfo.episodes!.isEmpty) {
      yield false;
      return;
    }

    final infoFile = _getNovelInfoFile(downloadPath, ncode);
    if (!await infoFile.exists()) {
      yield false;
      return;
    }

    for (final episode in novelInfo.episodes!) {
      if (episode.index != null) {
        final contentFile = _getEpisodeContentFile(
          downloadPath,
          ncode,
          episode.index!,
        );
        if (!await contentFile.exists()) {
          yield false;
          return;
        }
      }
    }
    yield true;
  }

  Future<String> _getDownloadPath() async {
    return await settings.when(
      data: (data) => data.novelDownloadPath,
      loading: () async =>
          (await ref.read(settingsProvider.future)).novelDownloadPath,
      error: (e, s) => throw e,
    );
  }
}
