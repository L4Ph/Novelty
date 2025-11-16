// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 小説のライブラリ状態を管理するプロバイダー。

@ProviderFor(LibraryStatus)
const libraryStatusProvider = LibraryStatusFamily._();

/// 小説のライブラリ状態を管理するプロバイダー。
final class LibraryStatusProvider
    extends $StreamNotifierProvider<LibraryStatus, bool> {
  /// 小説のライブラリ状態を管理するプロバイダー。
  const LibraryStatusProvider._({
    required LibraryStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'libraryStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryStatusHash();

  @override
  String toString() {
    return r'libraryStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LibraryStatus create() => LibraryStatus();

  @override
  bool operator ==(Object other) {
    return other is LibraryStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryStatusHash() => r'7fd298025f27a721e544ed2e844d6a06cd487c45';

/// 小説のライブラリ状態を管理するプロバイダー。

final class LibraryStatusFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryStatus,
          AsyncValue<bool>,
          bool,
          Stream<bool>,
          String
        > {
  const LibraryStatusFamily._()
    : super(
        retry: null,
        name: r'libraryStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説のライブラリ状態を管理するプロバイダー。

  LibraryStatusProvider call(String ncode) =>
      LibraryStatusProvider._(argument: ncode, from: this);

  @override
  String toString() => r'libraryStatusProvider';
}

/// 小説のライブラリ状態を管理するプロバイダー。

abstract class _$LibraryStatus extends $StreamNotifier<bool> {
  late final _$args = ref.$arg as String;
  String get ncode => _$args;

  Stream<bool> build(String ncode);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
