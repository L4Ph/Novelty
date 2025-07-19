// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(LibrarySearchQuery)
const librarySearchQueryProvider = LibrarySearchQueryProvider._();

final class LibrarySearchQueryProvider
    extends $NotifierProvider<LibrarySearchQuery, String> {
  const LibrarySearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'librarySearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySearchQueryHash();

  @$internal
  @override
  LibrarySearchQuery create() => LibrarySearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$librarySearchQueryHash() =>
    r'0da7ada0c9617dd8236d2ad1b6dc63acd5fd99fd';

abstract class _$LibrarySearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(LibrarySearchResults)
const librarySearchResultsProvider = LibrarySearchResultsProvider._();

final class LibrarySearchResultsProvider
    extends $StreamNotifierProvider<LibrarySearchResults, List<Novel>> {
  const LibrarySearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'librarySearchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySearchResultsHash();

  @$internal
  @override
  LibrarySearchResults create() => LibrarySearchResults();
}

String _$librarySearchResultsHash() =>
    r'219c67bd71aefa4164cae1a9387f66c284770e80';

abstract class _$LibrarySearchResults extends $StreamNotifier<List<Novel>> {
  Stream<List<Novel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Novel>>, List<Novel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Novel>>, List<Novel>>,
              AsyncValue<List<Novel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
