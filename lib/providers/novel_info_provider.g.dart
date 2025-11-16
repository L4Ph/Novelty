// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 小説の情報を取得するプロバイダー（シンプル版）。

@ProviderFor(novelInfo)
const novelInfoProvider = NovelInfoFamily._();

/// 小説の情報を取得するプロバイダー（シンプル版）。

final class NovelInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<NovelInfo>,
          NovelInfo,
          FutureOr<NovelInfo>
        >
    with $FutureModifier<NovelInfo>, $FutureProvider<NovelInfo> {
  /// 小説の情報を取得するプロバイダー（シンプル版）。
  const NovelInfoProvider._({
    required NovelInfoFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'novelInfoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$novelInfoHash();

  @override
  String toString() {
    return r'novelInfoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<NovelInfo> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<NovelInfo> create(Ref ref) {
    final argument = this.argument as String;
    return novelInfo(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NovelInfoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$novelInfoHash() => r'7e388f18037f9f1e3328f59630ea6434481550cb';

/// 小説の情報を取得するプロバイダー（シンプル版）。

final class NovelInfoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<NovelInfo>, String> {
  const NovelInfoFamily._()
    : super(
        retry: null,
        name: r'novelInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説の情報を取得するプロバイダー（シンプル版）。

  NovelInfoProvider call(String ncode) =>
      NovelInfoProvider._(argument: ncode, from: this);

  @override
  String toString() => r'novelInfoProvider';
}

/// 小説の情報を取得し、DBにキャッシュするプロバイダー。
///
/// APIから小説情報を取得し、既存のfavステータスを保持しながらDBに保存する。

@ProviderFor(novelInfoWithCache)
const novelInfoWithCacheProvider = NovelInfoWithCacheFamily._();

/// 小説の情報を取得し、DBにキャッシュするプロバイダー。
///
/// APIから小説情報を取得し、既存のfavステータスを保持しながらDBに保存する。

final class NovelInfoWithCacheProvider
    extends
        $FunctionalProvider<
          AsyncValue<NovelInfo>,
          NovelInfo,
          FutureOr<NovelInfo>
        >
    with $FutureModifier<NovelInfo>, $FutureProvider<NovelInfo> {
  /// 小説の情報を取得し、DBにキャッシュするプロバイダー。
  ///
  /// APIから小説情報を取得し、既存のfavステータスを保持しながらDBに保存する。
  const NovelInfoWithCacheProvider._({
    required NovelInfoWithCacheFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'novelInfoWithCacheProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$novelInfoWithCacheHash();

  @override
  String toString() {
    return r'novelInfoWithCacheProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<NovelInfo> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<NovelInfo> create(Ref ref) {
    final argument = this.argument as String;
    return novelInfoWithCache(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NovelInfoWithCacheProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$novelInfoWithCacheHash() =>
    r'3fdc34b01b2df86f8a7e53127026d0789625a4c1';

/// 小説の情報を取得し、DBにキャッシュするプロバイダー。
///
/// APIから小説情報を取得し、既存のfavステータスを保持しながらDBに保存する。

final class NovelInfoWithCacheFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<NovelInfo>, String> {
  const NovelInfoWithCacheFamily._()
    : super(
        retry: null,
        name: r'novelInfoWithCacheProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説の情報を取得し、DBにキャッシュするプロバイダー。
  ///
  /// APIから小説情報を取得し、既存のfavステータスを保持しながらDBに保存する。

  NovelInfoWithCacheProvider call(String ncode) =>
      NovelInfoWithCacheProvider._(argument: ncode, from: this);

  @override
  String toString() => r'novelInfoWithCacheProvider';
}
