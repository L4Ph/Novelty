// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// ライブラリ検索プロバイダー
@ProviderFor(LibrarySearch)
const librarySearchProvider = LibrarySearchProvider._();

/// ライブラリ検索プロバイダー
final class LibrarySearchProvider
    extends $AsyncNotifierProvider<LibrarySearch, List<Novel>> {
  /// ライブラリ検索プロバイダー
  const LibrarySearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'librarySearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySearchHash();

  @$internal
  @override
  LibrarySearch create() => LibrarySearch();
}

String _$librarySearchHash() => r'56581291fc913a7ba8c607552a8277bacc3c63a0';

abstract class _$LibrarySearch extends $AsyncNotifier<List<Novel>> {
  FutureOr<List<Novel>> build();
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
