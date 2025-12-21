// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// APIサービスのプロバイダー

@ProviderFor(apiService)
const apiServiceProvider = ApiServiceProvider._();

/// APIサービスのプロバイダー

final class ApiServiceProvider
    extends $FunctionalProvider<ApiService, ApiService, ApiService>
    with $Provider<ApiService> {
  /// APIサービスのプロバイダー
  const ApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiServiceProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[],
        $allTransitiveDependencies: const <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$apiServiceHash();

  @$internal
  @override
  $ProviderElement<ApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiService create(Ref ref) {
    return apiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiService>(value),
    );
  }
}

String _$apiServiceHash() => r'd8a9cf67a08249ea1f590a1d16fea7a883a0523e';

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

  static const $allTransitiveDependencies0 = apiServiceProvider;
  static const $allTransitiveDependencies1 = appDatabaseProvider;

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

String _$novelInfoHash() => r'7b355fc1a9ea34d9ee85f74cfaf27810f3de8bd9';

/// 小説の情報を取得するプロバイダー（シンプル版）。

final class NovelInfoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<NovelInfo>, String> {
  const NovelInfoFamily._()
    : super(
        retry: null,
        name: r'novelInfoProvider',
        dependencies: const <ProviderOrFamily>[
          apiServiceProvider,
          appDatabaseProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          NovelInfoProvider.$allTransitiveDependencies0,
          NovelInfoProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  /// 小説の情報を取得するプロバイダー（シンプル版）。

  NovelInfoProvider call(String ncode) =>
      NovelInfoProvider._(argument: ncode, from: this);

  @override
  String toString() => r'novelInfoProvider';
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

  static const $allTransitiveDependencies0 = apiServiceProvider;
  static const $allTransitiveDependencies1 = appDatabaseProvider;

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

String _$episodeHash() => r'701f6c1faf3f3d78a0a5334bed7a289b7493a6e6';

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
        dependencies: const <ProviderOrFamily>[
          apiServiceProvider,
          appDatabaseProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          EpisodeProvider.$allTransitiveDependencies0,
          EpisodeProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  /// 小説のエピソードを取得するプロバイダー。

  EpisodeProvider call({required String ncode, required int episode}) =>
      EpisodeProvider._(argument: (ncode: ncode, episode: episode), from: this);

  @override
  String toString() => r'episodeProvider';
}
