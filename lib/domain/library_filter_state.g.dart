// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_filter_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ライブラリのフィルタ状態を管理するNotifier。

@ProviderFor(LibraryFilterStateNotifier)
const libraryFilterStateProvider = LibraryFilterStateNotifierProvider._();

/// ライブラリのフィルタ状態を管理するNotifier。
final class LibraryFilterStateNotifierProvider
    extends $NotifierProvider<LibraryFilterStateNotifier, LibraryFilterState> {
  /// ライブラリのフィルタ状態を管理するNotifier。
  const LibraryFilterStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryFilterStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryFilterStateNotifierHash();

  @$internal
  @override
  LibraryFilterStateNotifier create() => LibraryFilterStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryFilterState>(value),
    );
  }
}

String _$libraryFilterStateNotifierHash() =>
    r'cbb87365978b499378b48439775fcd051fb5593a';

/// ライブラリのフィルタ状態を管理するNotifier。

abstract class _$LibraryFilterStateNotifier
    extends $Notifier<LibraryFilterState> {
  LibraryFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LibraryFilterState, LibraryFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibraryFilterState, LibraryFilterState>,
              LibraryFilterState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
