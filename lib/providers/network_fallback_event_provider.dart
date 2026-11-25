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

/// キャッシュフォールバックイベントを配るバス。
///
/// リポジトリが [emit] し、UI側は [event] を購読して、表示中のデータが
/// 最新でない可能性があることをユーザーに伝える。
class NetworkFallbackBus extends ChangeNotifier {
  NetworkFallbackEventData? _event;

  /// 最後に発行されたイベント。未消費なら非null。
  NetworkFallbackEventData? get event => _event;

  /// イベントを発行する。
  void emit(String message) {
    _event = NetworkFallbackEventData(message: message);
    notifyListeners();
  }

  /// イベントをクリアする。
  void clear() {
    if (_event == null) return;
    _event = null;
    notifyListeners();
  }
}
