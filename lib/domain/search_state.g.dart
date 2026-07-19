// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 検索状態を管理するNotifierプロバイダー。

@ProviderFor(SearchStateNotifier)
const searchStateProvider = SearchStateNotifierProvider._();

/// 検索状態を管理するNotifierプロバイダー。
final class SearchStateNotifierProvider
    extends $NotifierProvider<SearchStateNotifier, SearchState> {
  /// 検索状態を管理するNotifierプロバイダー。
  const SearchStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchStateNotifierHash();

  @$internal
  @override
  SearchStateNotifier create() => SearchStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchState>(value),
    );
  }
}

String _$searchStateNotifierHash() =>
    r'6b81472a785aadfac25576628d9c0196143eb1b7';

/// 検索状態を管理するNotifierプロバイダー。

abstract class _$SearchStateNotifier extends $Notifier<SearchState> {
  SearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SearchState, SearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchState, SearchState>,
              SearchState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
