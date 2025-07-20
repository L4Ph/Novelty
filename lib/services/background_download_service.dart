import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/notification_service.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

/// バックグラウンドダウンロードサービスのプロバイダー。
final backgroundDownloadServiceProvider = Provider<BackgroundDownloadService>((ref) {
  return BackgroundDownloadService(ref);
});

/// バックグラウンドでのダウンロード処理を管理するサービスクラス。
class BackgroundDownloadService {
  /// コンストラクタ。
  BackgroundDownloadService(this.ref);

  /// リファレンス。
  final Ref ref;

  static const String _portName = 'downloadProgress';

  /// バックグラウンドサービスを初期化するメソッド。
  static Future<void> initialize() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'download_service',
        initialNotificationTitle: 'ダウンロードサービス',
        initialNotificationContent: '小説のダウンロード準備中...',
        foregroundServiceNotificationId: 888,
      ),
    );
  }

  /// ダウンロードを開始するメソッド。
  Future<void> startDownload(NovelInfo novelInfo) async {
    final service = FlutterBackgroundService();
    
    // ダウンロード情報をSharedPreferencesに保存
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('download_novel', jsonEncode(novelInfo.toJson()));
    
    await service.startService();
  }

  /// ダウンロードを停止するメソッド。
  Future<void> stopDownload() async {
    final service = FlutterBackgroundService();
    service.invoke('stop');
  }

  /// ダウンロード進捗を監視するためのStreamを取得するメソッド。
  Stream<Map<String, dynamic>> getDownloadProgressStream() {
    final port = ReceivePort();
    
    IsolateNameServer.removePortNameMapping(_portName);
    IsolateNameServer.registerPortWithName(port.sendPort, _portName);
    
    return port.cast<Map<String, dynamic>>();
  }
}

/// バックグラウンドサービスの開始時に呼び出される関数。
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

/// バックグラウンドサービスの開始時に呼び出される関数。
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  service.on('stop').listen((event) {
    service.stopSelf();
  });

  // ダウンロード処理の開始
  final prefs = await SharedPreferences.getInstance();
  final novelJson = prefs.getString('download_novel');
  
  if (novelJson != null) {
    final novelData = jsonDecode(novelJson) as Map<String, dynamic>;
    final novelInfo = NovelInfo.fromJson(novelData);
    
    await _performDownload(service, notificationService, novelInfo);
  }
}

/// 実際のダウンロード処理を実行する関数。
Future<void> _performDownload(
  ServiceInstance service,
  NotificationService notificationService,
  NovelInfo novelInfo,
) async {
  const int notificationId = 1001;
  final String novelTitle = novelInfo.title ?? 'Unknown';
  final String ncode = novelInfo.ncode!.toLowerCase();
  
  try {
    // ダウンロード開始通知
    await notificationService.showDownloadStartNotification(
      notificationId: notificationId,
      novelTitle: novelTitle,
    );

    // 設定からダウンロードパスを取得
    final prefs = await SharedPreferences.getInstance();
    final downloadPath = prefs.getString('novel_download_path') ?? '/storage/emulated/0/Download/Novelty';
    
    // 小説ディレクトリの作成
    final novelDir = p.join(downloadPath, ncode);
    await _createDirectoryIfNotExists(novelDir);
    
    // 小説情報を保存
    await _saveNovelInfo(novelDir, novelInfo);
    
    if (novelInfo.novelType == 2) {
      // 短編小説の場合
      await _downloadEpisode(
        service,
        notificationService,
        novelDir,
        ncode,
        1,
        notificationId,
        novelTitle,
        '第1話',
        1,
        1,
      );
    } else {
      // 連載小説の場合
      final episodes = novelInfo.episodes ?? [];
      final totalEpisodes = episodes.length;
      
      for (var i = 0; i < episodes.length; i++) {
        final episode = episodes[i];
        if (episode.index != null) {
          await _downloadEpisode(
            service,
            notificationService,
            novelDir,
            ncode,
            episode.index!,
            notificationId,
            novelTitle,
            episode.subtitle ?? '第${episode.index}話',
            i + 1,
            totalEpisodes,
          );
        }
        
        // 少し待機（サーバーへの負荷を軽減）
        await Future<void>.delayed(const Duration(milliseconds: 1000));
      }
    }
    
    // ダウンロード完了通知
    await notificationService.showDownloadCompleteNotification(
      notificationId: notificationId,
      novelTitle: novelTitle,
    );
    
    // 進捗を送信
    _sendProgress({
      'status': 'completed',
      'novelTitle': novelTitle,
    });
    
  } on Exception catch (e) {
    // エラー通知
    await notificationService.showDownloadErrorNotification(
      notificationId: notificationId,
      novelTitle: novelTitle,
      errorMessage: e.toString(),
    );
    
    // エラー進捗を送信
    _sendProgress({
      'status': 'error',
      'novelTitle': novelTitle,
      'error': e.toString(),
    });
  } finally {
    // サービス停止
    service.stopSelf();
  }
}

/// エピソードをダウンロードする関数。
Future<void> _downloadEpisode(
  ServiceInstance service,
  NotificationService notificationService,
  String novelDir,
  String ncode,
  int episodeIndex,
  int notificationId,
  String novelTitle,
  String episodeTitle,
  int currentProgress,
  int totalProgress,
) async {
  // 進捗通知の更新
  await notificationService.updateDownloadProgress(
    notificationId: notificationId,
    novelTitle: novelTitle,
    progress: currentProgress,
    maxProgress: totalProgress,
    currentEpisode: episodeTitle,
  );
  
  // 進捗を送信
  _sendProgress({
    'status': 'downloading',
    'novelTitle': novelTitle,
    'progress': currentProgress,
    'total': totalProgress,
    'currentEpisode': episodeTitle,
  });
  
  // エピソードディレクトリの作成
  final episodeDir = p.join(novelDir, episodeIndex.toString());
  await _createDirectoryIfNotExists(episodeDir);
  
  // 既にダウンロード済みかチェック
  final contentFile = p.join(episodeDir, 'content.json');
  if (await _fileExists(contentFile)) {
    return; // 既にダウンロード済み
  }
  
  try {
    // エピソードデータを取得
    final episodeData = await _fetchEpisode(ncode, episodeIndex);
    if (episodeData == null || episodeData.isEmpty) {
      throw Exception('Failed to fetch episode content');
    }
    
    // 小説内容をパース
    final parsedContent = _parseNovel(episodeData);
    final encodedContent = jsonEncode(
      parsedContent.map((e) => e.toJson()).toList(),
    );
    
    // ファイルに保存
    await _writeFile(contentFile, encodedContent);
    
  } on Exception catch (e) {
    throw Exception('Failed to download episode $episodeIndex: $e');
  }
}

/// エピソードデータを取得する関数。
Future<String?> _fetchEpisode(String ncode, int episode) async {
  try {
    final url = 'https://ncode.syosetu.com/$ncode/$episode/';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  } on Exception {
    return null;
  }
}

/// 小説内容をパースする関数。
List<NovelContentElement> _parseNovel(String html) {
  final document = parser.parse(html);
  final contentElements = <NovelContentElement>[];
  
  // 本文を取得
  final bodyElement = document.querySelector('#novel_honbun');
  if (bodyElement != null) {
    for (final node in bodyElement.nodes) {
      if (node.nodeType == 3) { // テキストノード
        final text = node.text?.trim();
        if (text != null && text.isNotEmpty) {
          contentElements.add(NovelContentElement.plainText(text));
        }
      } else if (node.nodeType == 1) { // 要素ノード
        final elementText = node.text?.trim();
        if (elementText != null && elementText.isNotEmpty) {
          contentElements.add(NovelContentElement.plainText(elementText));
        }
      }
    }
  }
  
  return contentElements;
}

/// 小説情報を保存する関数。
Future<void> _saveNovelInfo(String novelDir, NovelInfo novelInfo) async {
  await _createDirectoryIfNotExists(novelDir);
  final infoFile = p.join(novelDir, 'info.json');
  await _writeFile(infoFile, jsonEncode(novelInfo.toJson()));
}

/// ディレクトリを作成する関数（存在しない場合）。
Future<void> _createDirectoryIfNotExists(String path) async {
  final directory = Directory(path);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
}

/// ファイルが存在するかチェックする関数。
Future<bool> _fileExists(String path) async {
  final file = File(path);
  return file.exists();
}

/// ファイルに書き込む関数。
Future<void> _writeFile(String path, String content) async {
  final file = File(path);
  await file.writeAsString(content);
}

/// 進捗をメインアプリに送信する関数。
void _sendProgress(Map<String, dynamic> progress) {
  final port = IsolateNameServer.lookupPortByName(BackgroundDownloadService._portName);
  port?.send(progress);
}