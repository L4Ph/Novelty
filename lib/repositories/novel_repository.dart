import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  String _getNovelDirectory(String downloadPath, String ncode) =>
      p.join(downloadPath, ncode);

  String _getEpisodeDirectory(String downloadPath, String ncode, int episode) =>
      p.join(_getNovelDirectory(downloadPath, ncode), episode.toString());

  File _getEpisodeContentFile(String downloadPath, String ncode, int episode) =>
      File(
        p.join(
          _getEpisodeDirectory(downloadPath, ncode, episode),
          'content.json',
        ),
      );

  File _getNovelInfoFile(String downloadPath, String ncode) =>
      File(p.join(_getNovelDirectory(downloadPath, ncode), 'info.json'));

  /// 小説のエピソードを取得するメソッド。
  Future<List<NovelContentElement>> getEpisode(
    String ncode,
    int episode,
  ) async {
    final downloadPath = await _getDownloadPath();
    final contentFile = _getEpisodeContentFile(downloadPath, ncode, episode);

    if (await contentFile.exists()) {
      final content = await contentFile.readAsString();
      final decoded = jsonDecode(content) as List<dynamic>;
      return decoded
          .map((e) => NovelContentElement.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final episodeData = await apiService.fetchEpisode(ncode, episode);
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
      _getEpisodeDirectory(downloadPath, ncode, episode),
    );
    if (!await episodeDir.exists()) {
      await episodeDir.create(recursive: true);
    }

    final contentFile = _getEpisodeContentFile(downloadPath, ncode, episode);
    if (await contentFile.exists()) {
      return; // Already downloaded
    }

    final episodeData = await apiService.fetchEpisode(ncode, episode);
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
    final ncode = novelInfo.ncode!;
    final downloadPath = await _getDownloadPath();

    final novelDir = Directory(_getNovelDirectory(downloadPath, ncode));
    if (!await novelDir.exists()) {
      await novelDir.create(recursive: true);
    }

    final infoFile = _getNovelInfoFile(downloadPath, ncode);
    await infoFile.writeAsString(jsonEncode(novelInfo.toJson()));

    if (novelInfo.novelType == 2) {
      await downloadEpisode(ncode, 1);
      return;
    }

    if (novelInfo.episodes == null) {
      return;
    }
    for (final episode in novelInfo.episodes!) {
      if (episode.index != null) {
        await downloadEpisode(ncode, episode.index!);
      }
    }
  }

  /// ダウンロード済みエピソードを削除するメソッド。
  Future<void> deleteDownloadedEpisode(String ncode, int episode) async {
    final downloadPath = await _getDownloadPath();
    final episodeDir = Directory(
      _getEpisodeDirectory(downloadPath, ncode, episode),
    );
    if (await episodeDir.exists()) {
      await episodeDir.delete(recursive: true);
    }
  }

  /// ダウンロード済み小説を削除するメソッド。
  Future<void> deleteDownloadedNovel(NovelInfo novelInfo) async {
    final ncode = novelInfo.ncode!;
    final downloadPath = await _getDownloadPath();
    final novelDir = Directory(_getNovelDirectory(downloadPath, ncode));
    if (await novelDir.exists()) {
      await novelDir.delete(recursive: true);
    }
  }

  /// ダウンロードパスを取得するメソッド。
  Stream<bool> isEpisodeDownloaded(String ncode, int episode) async* {
    final downloadPath = await _getDownloadPath();
    final contentFile = _getEpisodeContentFile(downloadPath, ncode, episode);
    yield await contentFile.exists();
  }

  /// 小説がダウンロードされているかを確認するメソッド。
  Stream<bool> isNovelDownloaded(NovelInfo novelInfo) async* {
    final ncode = novelInfo.ncode!;
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
