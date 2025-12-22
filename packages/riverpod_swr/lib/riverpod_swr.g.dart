// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod_swr.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(swrClient)
const swrClientProvider = SwrClientProvider._();

final class SwrClientProvider
    extends $FunctionalProvider<SwrClient, SwrClient, SwrClient>
    with $Provider<SwrClient> {
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
