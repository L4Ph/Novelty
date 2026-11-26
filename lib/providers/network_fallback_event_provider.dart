import 'package:flutter/foundation.dart';

/// ネットワーク取得失敗時のキャッシュフォールバックを通知するイベントデータ。
@immutable
class NetworkFallbackEventData {
  /// コンストラクタ。
  const NetworkFallbackEventData({required this.message});

  /// ユーザーに表示するメッセージ。
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkFallbackEventData && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

/// Delivers cache-fallback events.
///
/// The repository [emit]s one; the UI watches [event] and tells the user that
/// what is on screen may be stale.
class NetworkFallbackBus extends ChangeNotifier {
  NetworkFallbackEventData? _event;

  /// The last published event, non-null until it is consumed.
  NetworkFallbackEventData? get event => _event;

  /// Publishes an event.
  void emit(String message) {
    _event = NetworkFallbackEventData(message: message);
    notifyListeners();
  }

  /// Clears the event.
  void clear() {
    if (_event == null) return;
    _event = null;
    notifyListeners();
  }
}
