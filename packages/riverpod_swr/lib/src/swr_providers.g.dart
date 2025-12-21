// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swr_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A provider that exposes the [SwrClient] instance.
///
/// This client manages the SWR state, including inflight requests,
/// caching, and deduplication.

@ProviderFor(swrClient)
const swrClientProvider = SwrClientProvider._();

/// A provider that exposes the [SwrClient] instance.
///
/// This client manages the SWR state, including inflight requests,
/// caching, and deduplication.

final class SwrClientProvider
    extends $FunctionalProvider<SwrClient, SwrClient, SwrClient>
    with $Provider<SwrClient> {
  /// A provider that exposes the [SwrClient] instance.
  ///
  /// This client manages the SWR state, including inflight requests,
  /// caching, and deduplication.
  const SwrClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swrClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swrClientHash();

  @$internal
  @override
  $ProviderElement<SwrClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SwrClient create(Ref ref) {
    return swrClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwrClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwrClient>(value),
    );
  }
}

String _$swrClientHash() => r'35075e4ceb345f0905fd6d08a671bb186cd97b75';

/// Returns whether a fetch is currently in progress for the given [key].

@ProviderFor(swrLoading)
const swrLoadingProvider = SwrLoadingFamily._();

/// Returns whether a fetch is currently in progress for the given [key].

final class SwrLoadingProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Returns whether a fetch is currently in progress for the given [key].
  const SwrLoadingProvider._({
    required SwrLoadingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'swrLoadingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$swrLoadingHash();

  @override
  String toString() {
    return r'swrLoadingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    final argument = this.argument as String;
    return swrLoading(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SwrLoadingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$swrLoadingHash() => r'5f368e7b3c50faeb74f341cf3b5c56df8c4e751d';

/// Returns whether a fetch is currently in progress for the given [key].

final class SwrLoadingFamily extends $Family
    with $FunctionalFamilyOverride<Stream<bool>, String> {
  const SwrLoadingFamily._()
    : super(
        retry: null,
        name: r'swrLoadingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Returns whether a fetch is currently in progress for the given [key].

  SwrLoadingProvider call(String key) =>
      SwrLoadingProvider._(argument: key, from: this);

  @override
  String toString() => r'swrLoadingProvider';
}
