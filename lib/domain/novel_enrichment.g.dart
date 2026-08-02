// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_enrichment.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 検索結果をデータベースのライブラリ状態で強化するプロバイダー

@ProviderFor(enrichedSearchData)
final enrichedSearchDataProvider = EnrichedSearchDataFamily._();

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
  EnrichedSearchDataProvider._({
    required EnrichedSearchDataFamily super.from,
    required List<NovelInfo> super.argument,
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
    r'1a964dc4b75a73aebebbc74bfd836019577575e3';

/// 検索結果をデータベースのライブラリ状態で強化するプロバイダー

final class EnrichedSearchDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<EnrichedNovelData>>,
          List<NovelInfo>
        > {
  EnrichedSearchDataFamily._()
    : super(
        retry: null,
        name: r'enrichedSearchDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 検索結果をデータベースのライブラリ状態で強化するプロバイダー

  EnrichedSearchDataProvider call(List<NovelInfo> searchResults) =>
      EnrichedSearchDataProvider._(argument: searchResults, from: this);

  @override
  String toString() => r'enrichedSearchDataProvider';
}

/// 作品IDから単一の豊富な小説データを取得するプロバイダー

@ProviderFor(enrichedNovel)
final enrichedNovelProvider = EnrichedNovelFamily._();

/// 作品IDから単一の豊富な小説データを取得するプロバイダー

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
  /// 作品IDから単一の豊富な小説データを取得するプロバイダー
  EnrichedNovelProvider._({
    required EnrichedNovelFamily super.from,
    required (NovelSource, String) super.argument,
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
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<EnrichedNovelData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EnrichedNovelData> create(Ref ref) {
    final argument = this.argument as (NovelSource, String);
    return enrichedNovel(ref, argument.$1, argument.$2);
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

String _$enrichedNovelHash() => r'e216c1636d96187097128df2c3277d722b03c497';

/// 作品IDから単一の豊富な小説データを取得するプロバイダー

final class EnrichedNovelFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<EnrichedNovelData>,
          (NovelSource, String)
        > {
  EnrichedNovelFamily._()
    : super(
        retry: null,
        name: r'enrichedNovelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 作品IDから単一の豊富な小説データを取得するプロバイダー

  EnrichedNovelProvider call(NovelSource source, String workId) =>
      EnrichedNovelProvider._(argument: (source, workId), from: this);

  @override
  String toString() => r'enrichedNovelProvider';
}
