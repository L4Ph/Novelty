// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_fallback_event_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// キャッシュフォールバックイベントを提供するプロバイダー。
///
/// UI側はこのプロバイダーを購読し、イベント発生時にスナックバー等を表示して、
/// 表示中のデータが最新でない可能性があることをユーザーに伝える。

@ProviderFor(NetworkFallbackEvent)
const networkFallbackEventProvider = NetworkFallbackEventProvider._();

/// キャッシュフォールバックイベントを提供するプロバイダー。
///
/// UI側はこのプロバイダーを購読し、イベント発生時にスナックバー等を表示して、
/// 表示中のデータが最新でない可能性があることをユーザーに伝える。
final class NetworkFallbackEventProvider
    extends $NotifierProvider<NetworkFallbackEvent, NetworkFallbackEventData?> {
  /// キャッシュフォールバックイベントを提供するプロバイダー。
  ///
  /// UI側はこのプロバイダーを購読し、イベント発生時にスナックバー等を表示して、
  /// 表示中のデータが最新でない可能性があることをユーザーに伝える。
  const NetworkFallbackEventProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkFallbackEventProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkFallbackEventHash();

  @$internal
  @override
  NetworkFallbackEvent create() => NetworkFallbackEvent();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkFallbackEventData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkFallbackEventData?>(value),
    );
  }
}

String _$networkFallbackEventHash() =>
    r'653a3ff06796678cbe338d1b9646ef472769e909';

/// キャッシュフォールバックイベントを提供するプロバイダー。
///
/// UI側はこのプロバイダーを購読し、イベント発生時にスナックバー等を表示して、
/// 表示中のデータが最新でない可能性があることをユーザーに伝える。

abstract class _$NetworkFallbackEvent
    extends $Notifier<NetworkFallbackEventData?> {
  NetworkFallbackEventData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<NetworkFallbackEventData?, NetworkFallbackEventData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkFallbackEventData?, NetworkFallbackEventData?>,
              NetworkFallbackEventData?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
