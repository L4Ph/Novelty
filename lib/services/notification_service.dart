import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 通知サービスのプロバイダー。
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// 通知を管理するサービスクラス。
class NotificationService {
  static const String _downloadChannelId = 'download_channel';
  static const String _downloadChannelName = 'ダウンロード通知';
  static const String _downloadChannelDescription = '小説ダウンロードの進捗を表示します';
  
  late FlutterLocalNotificationsPlugin _plugin;
  
  /// 通知サービスを初期化するメソッド。
  Future<void> initialize() async {
    _plugin = FlutterLocalNotificationsPlugin();
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    
    await _plugin.initialize(initSettings);
    
    // ダウンロード用通知チャンネルを作成
    const androidChannel = AndroidNotificationChannel(
      _downloadChannelId,
      _downloadChannelName,
      description: _downloadChannelDescription,
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
    );
    
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }
  
  /// ダウンロード開始通知を表示するメソッド。
  Future<void> showDownloadStartNotification({
    required int notificationId,
    required String novelTitle,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _downloadChannelId,
      _downloadChannelName,
      channelDescription: _downloadChannelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showProgress: true,
      maxProgress: 100,
      progress: 0,
      playSound: false,
      enableVibration: false,
    );
    
    const notificationDetails = NotificationDetails(android: androidDetails);
    
    await _plugin.show(
      notificationId,
      '小説ダウンロード中',
      '$novelTitle のダウンロードを開始しました',
      notificationDetails,
    );
  }
  
  /// ダウンロード進捗通知を更新するメソッド。
  Future<void> updateDownloadProgress({
    required int notificationId,
    required String novelTitle,
    required int progress,
    required int maxProgress,
    String? currentEpisode,
  }) async {
    final progressPercent = ((progress / maxProgress) * 100).round();
    
    final androidDetails = AndroidNotificationDetails(
      _downloadChannelId,
      _downloadChannelName,
      channelDescription: _downloadChannelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showProgress: true,
      maxProgress: 100,
      progress: progressPercent,
      playSound: false,
      enableVibration: false,
    );
    
    final notificationDetails = NotificationDetails(android: androidDetails);
    
    final subtitle = currentEpisode != null 
        ? '$currentEpisode ($progress/$maxProgress)'
        : '$progress/$maxProgress 完了';
    
    await _plugin.show(
      notificationId,
      '$novelTitle ($progressPercent%)',
      subtitle,
      notificationDetails,
    );
  }
  
  /// ダウンロード完了通知を表示するメソッド。
  Future<void> showDownloadCompleteNotification({
    required int notificationId,
    required String novelTitle,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _downloadChannelId,
      _downloadChannelName,
      channelDescription: _downloadChannelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ongoing: false,
      autoCancel: true,
      playSound: true,
      enableVibration: true,
    );
    
    final notificationDetails = NotificationDetails(android: androidDetails);
    
    await _plugin.show(
      notificationId,
      'ダウンロード完了',
      '$novelTitle のダウンロードが完了しました',
      notificationDetails,
    );
  }
  
  /// ダウンロードエラー通知を表示するメソッド。
  Future<void> showDownloadErrorNotification({
    required int notificationId,
    required String novelTitle,
    required String errorMessage,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _downloadChannelId,
      _downloadChannelName,
      channelDescription: _downloadChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ongoing: false,
      autoCancel: true,
      playSound: true,
      enableVibration: true,
    );
    
    final notificationDetails = NotificationDetails(android: androidDetails);
    
    await _plugin.show(
      notificationId,
      'ダウンロードエラー',
      '$novelTitle: $errorMessage',
      notificationDetails,
    );
  }
  
  /// 通知をキャンセルするメソッド。
  Future<void> cancelNotification(int notificationId) async {
    await _plugin.cancel(notificationId);
  }
}