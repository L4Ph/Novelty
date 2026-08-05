// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_site_registry.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// サイト種別とサイト実装の対応を提供するプロバイダ。
///
/// テスト時は [novelSiteRegistryProvider] をオーバーライドして
/// カクヨム等のサイト実装を差し替えられるようにする。

@ProviderFor(novelSiteRegistry)
final novelSiteRegistryProvider = NovelSiteRegistryProvider._();

/// サイト種別とサイト実装の対応を提供するプロバイダ。
///
/// テスト時は [novelSiteRegistryProvider] をオーバーライドして
/// カクヨム等のサイト実装を差し替えられるようにする。

final class NovelSiteRegistryProvider
    extends
        $FunctionalProvider<
          Map<NovelSource, NovelSite>,
          Map<NovelSource, NovelSite>,
          Map<NovelSource, NovelSite>
        >
    with $Provider<Map<NovelSource, NovelSite>> {
  /// サイト種別とサイト実装の対応を提供するプロバイダ。
  ///
  /// テスト時は [novelSiteRegistryProvider] をオーバーライドして
  /// カクヨム等のサイト実装を差し替えられるようにする。
  NovelSiteRegistryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'novelSiteRegistryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$novelSiteRegistryHash();

  @$internal
  @override
  $ProviderElement<Map<NovelSource, NovelSite>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<NovelSource, NovelSite> create(Ref ref) {
    return novelSiteRegistry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<NovelSource, NovelSite> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<NovelSource, NovelSite>>(value),
    );
  }
}

String _$novelSiteRegistryHash() => r'1a7b49b0404465cb5945750af5d07dcf3710d82a';
