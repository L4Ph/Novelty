// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

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

String _$novelInfoHash() => r'faa886cdc0b0b0768f8e698e85f614ea429c4d85';

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

/// 小説のエピソードを取得するプロバイダー。

@ProviderFor(episode)
const episodeProvider = EpisodeFamily._();

/// 小説のエピソードを取得するプロバイダー。

final class EpisodeProvider
    extends $FunctionalProvider<AsyncValue<Episode>, Episode, FutureOr<Episode>>
    with $FutureModifier<Episode>, $FutureProvider<Episode> {
  /// 小説のエピソードを取得するプロバイダー。
  const EpisodeProvider._({
    required EpisodeFamily super.from,
    required ({String ncode, int episode}) super.argument,
  }) : super(
         retry: null,
         name: r'episodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodeHash();

  @override
  String toString() {
    return r'episodeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Episode> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Episode> create(Ref ref) {
    final argument = this.argument as ({String ncode, int episode});
    return episode(ref, ncode: argument.ncode, episode: argument.episode);
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodeHash() => r'599f924ab4a3a39558afa3de6713f2b2edd4ec9d';

/// 小説のエピソードを取得するプロバイダー。

final class EpisodeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Episode>,
          ({String ncode, int episode})
        > {
  const EpisodeFamily._()
    : super(
        retry: null,
        name: r'episodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説のエピソードを取得するプロバイダー。

  EpisodeProvider call({required String ncode, required int episode}) =>
      EpisodeProvider._(argument: (ncode: ncode, episode: episode), from: this);

  @override
  String toString() => r'episodeProvider';
}

/// 小説のエピソードリストを取得するプロバイダー。

@ProviderFor(episodeList)
const episodeListProvider = EpisodeListFamily._();

/// 小説のエピソードリストを取得するプロバイダー。

final class EpisodeListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Episode>>,
          List<Episode>,
          FutureOr<List<Episode>>
        >
    with $FutureModifier<List<Episode>>, $FutureProvider<List<Episode>> {
  /// 小説のエピソードリストを取得するプロバイダー。
  const EpisodeListProvider._({
    required EpisodeListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'episodeListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodeListHash();

  @override
  String toString() {
    return r'episodeListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Episode>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Episode>> create(Ref ref) {
    final argument = this.argument as String;
    return episodeList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodeListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodeListHash() => r'db416a99e1efe708c8478e021196c75d03808ffc';

/// 小説のエピソードリストを取得するプロバイダー。

final class EpisodeListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Episode>>, String> {
  const EpisodeListFamily._()
    : super(
        retry: null,
        name: r'episodeListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説のエピソードリストを取得するプロバイダー。

  EpisodeListProvider call(String key) =>
      EpisodeListProvider._(argument: key, from: this);

  @override
  String toString() => r'episodeListProvider';
}
