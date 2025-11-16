// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_enrichment.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 豊富な小説データをデータベースから取得するプロバイダー

@ProviderFor(enrichedRankingData)
const enrichedRankingDataProvider = EnrichedRankingDataFamily._();

/// 豊富な小説データをデータベースから取得するプロバイダー

final class EnrichedRankingDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EnrichedNovelData>>,
          List<EnrichedNovelData>,
          FutureOr<List<EnrichedNovelData>>
        >
    with
        $FutureModifier<List<EnrichedNovelData>>,
        $FutureProvider<List<EnrichedNovelData>> {
  /// 豊富な小説データをデータベースから取得するプロバイダー
  const EnrichedRankingDataProvider._({
    required EnrichedRankingDataFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'enrichedRankingDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$enrichedRankingDataHash();

  @override
  String toString() {
    return r'enrichedRankingDataProvider'
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
    final argument = this.argument as String;
    return enrichedRankingData(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EnrichedRankingDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$enrichedRankingDataHash() =>
    r'14e1c49dcac0b6121160d0a3a0026e00ca810022';

/// 豊富な小説データをデータベースから取得するプロバイダー

final class EnrichedRankingDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<EnrichedNovelData>>, String> {
  const EnrichedRankingDataFamily._()
    : super(
        retry: null,
        name: r'enrichedRankingDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 豊富な小説データをデータベースから取得するプロバイダー

  EnrichedRankingDataProvider call(String rankingType) =>
      EnrichedRankingDataProvider._(argument: rankingType, from: this);

  @override
  String toString() => r'enrichedRankingDataProvider';
}

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
    required List<RankingResponse> super.argument,
  }) : super(
         retry: null,
         name: r'enrichedSearchDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

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
    final argument = this.argument as List<RankingResponse>;
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
    r'6adb71f25751588363eb0157fc81c6c8fe177a12';

/// 検索結果をデータベースのライブラリ状態で強化するプロバイダー

final class EnrichedSearchDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<EnrichedNovelData>>,
          List<RankingResponse>
        > {
  const EnrichedSearchDataFamily._()
    : super(
        retry: null,
        name: r'enrichedSearchDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 検索結果をデータベースのライブラリ状態で強化するプロバイダー

  EnrichedSearchDataProvider call(List<RankingResponse> searchResults) =>
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

String _$enrichedNovelHash() => r'0ddc46911e861761ca6bc791a005e9b5219bd377';

/// ncodeから単一の豊富な小説データを取得するプロバイダー

final class EnrichedNovelFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EnrichedNovelData>, String> {
  const EnrichedNovelFamily._()
    : super(
        retry: null,
        name: r'enrichedNovelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ncodeから単一の豊富な小説データを取得するプロバイダー

  EnrichedNovelProvider call(String ncode) =>
      EnrichedNovelProvider._(argument: ncode, from: this);

  @override
  String toString() => r'enrichedNovelProvider';
}
