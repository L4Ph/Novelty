// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_enrichment.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 検索結果をデータベースのライブラリ状態で強化するプロバイダー

@ProviderFor(enrichedSearchData)
const enrichedSearchDataProvider = EnrichedSearchDataFamily._();

/// 検索結果をデータベースのライブラリ状態で強化するプロバイダー

final class EnrichedSearchDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EnrichedNovelData>>,
          List<EnrichedNovelData>,
          FutureOr<List<EnrichedNovelData>>
        >
    with
        $FutureModifier<List<EnrichedNovelData>>,
        $FutureProvider<List<EnrichedNovelData>> {
  /// 検索結果をデータベースのライブラリ状態で強化するプロバイダー
  const EnrichedSearchDataProvider._({
    required EnrichedSearchDataFamily super.from,
    required List<NovelInfo> super.argument,
  }) : super(
         retry: null,
         name: r'enrichedSearchDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = appDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$enrichedSearchDataHash();

  @override
  String toString() {
    return r'enrichedSearchDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<EnrichedNovelData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EnrichedNovelData>> create(Ref ref) {
    final argument = this.argument as List<NovelInfo>;
    return enrichedSearchData(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EnrichedSearchDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$enrichedSearchDataHash() =>
    r'c90011901c2e1c8384dde6143a930247ae6d6d1d';

/// 検索結果をデータベースのライブラリ状態で強化するプロバイダー

final class EnrichedSearchDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<EnrichedNovelData>>,
          List<NovelInfo>
        > {
  const EnrichedSearchDataFamily._()
    : super(
        retry: null,
        name: r'enrichedSearchDataProvider',
        dependencies: const <ProviderOrFamily>[appDatabaseProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          EnrichedSearchDataProvider.$allTransitiveDependencies0,
        ],
        isAutoDispose: true,
      );

  /// 検索結果をデータベースのライブラリ状態で強化するプロバイダー

  EnrichedSearchDataProvider call(List<NovelInfo> searchResults) =>
      EnrichedSearchDataProvider._(argument: searchResults, from: this);

  @override
  String toString() => r'enrichedSearchDataProvider';
}

/// ncodeから単一の豊富な小説データを取得するプロバイダー

@ProviderFor(enrichedNovel)
const enrichedNovelProvider = EnrichedNovelFamily._();

/// ncodeから単一の豊富な小説データを取得するプロバイダー

final class EnrichedNovelProvider
    extends
        $FunctionalProvider<
          AsyncValue<EnrichedNovelData>,
          EnrichedNovelData,
          FutureOr<EnrichedNovelData>
        >
    with
        $FutureModifier<EnrichedNovelData>,
        $FutureProvider<EnrichedNovelData> {
  /// ncodeから単一の豊富な小説データを取得するプロバイダー
  const EnrichedNovelProvider._({
    required EnrichedNovelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'enrichedNovelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = apiServiceProvider;
  static const $allTransitiveDependencies1 = appDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$enrichedNovelHash();

  @override
  String toString() {
    return r'enrichedNovelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EnrichedNovelData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EnrichedNovelData> create(Ref ref) {
    final argument = this.argument as String;
    return enrichedNovel(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EnrichedNovelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$enrichedNovelHash() => r'2912034138e53b5b81b66a7477e6be90e6f2de0b';

/// ncodeから単一の豊富な小説データを取得するプロバイダー

final class EnrichedNovelFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EnrichedNovelData>, String> {
  const EnrichedNovelFamily._()
    : super(
        retry: null,
        name: r'enrichedNovelProvider',
        dependencies: const <ProviderOrFamily>[
          apiServiceProvider,
          appDatabaseProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          EnrichedNovelProvider.$allTransitiveDependencies0,
          EnrichedNovelProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  /// ncodeから単一の豊富な小説データを取得するプロバイダー

  EnrichedNovelProvider call(String ncode) =>
      EnrichedNovelProvider._(argument: ncode, from: this);

  @override
  String toString() => r'enrichedNovelProvider';
}
