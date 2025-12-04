// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConnectivityStatus)
const connectivityStatusProvider = ConnectivityStatusProvider._();

final class ConnectivityStatusProvider
    extends
        $AsyncNotifierProvider<ConnectivityStatus, List<ConnectivityResult>> {
  const ConnectivityStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityStatusHash();

  @$internal
  @override
  ConnectivityStatus create() => ConnectivityStatus();
}

String _$connectivityStatusHash() =>
    r'4a45974c1fccf6881c80b98c7312e7f8a358bf16';

abstract class _$ConnectivityStatus
    extends $AsyncNotifier<List<ConnectivityResult>> {
  FutureOr<List<ConnectivityResult>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ConnectivityResult>>,
              List<ConnectivityResult>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ConnectivityResult>>,
                List<ConnectivityResult>
              >,
              AsyncValue<List<ConnectivityResult>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(isOffline)
const isOfflineProvider = IsOfflineProvider._();

final class IsOfflineProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsOfflineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOfflineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOfflineHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isOffline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isOfflineHash() => r'2191bab0a3714f3e50818cfa9604f9e67b1d58a6';
