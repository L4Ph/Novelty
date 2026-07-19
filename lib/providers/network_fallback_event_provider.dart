import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_fallback_event_provider.g.dart';

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

/// キャッシュフォールバックイベントを提供するプロバイダー。
///
/// UI側はこのプロバイダーを購読し、イベント発生時にスナックバー等を表示して、
/// 表示中のデータが最新でない可能性があることをユーザーに伝える。
@Riverpod(keepAlive: true)
class NetworkFallbackEvent extends _$NetworkFallbackEvent {
  @override
  NetworkFallbackEventData? build() => null;

  /// イベントを発行する。
  void emit(String message) =>
      state = NetworkFallbackEventData(message: message);

  /// イベントをクリアする。
  void clear() => state = null;
}
