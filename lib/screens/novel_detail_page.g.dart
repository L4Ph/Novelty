// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_detail_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(IsInLibrary)
const isInLibraryProvider = IsInLibraryFamily._();

final class IsInLibraryProvider
    extends $AsyncNotifierProvider<IsInLibrary, bool> {
  const IsInLibraryProvider._({
    required IsInLibraryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isInLibraryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isInLibraryHash();

  @override
  String toString() {
    return r'isInLibraryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  IsInLibrary create() => IsInLibrary();

  @override
  bool operator ==(Object other) {
    return other is IsInLibraryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isInLibraryHash() => r'badb88bb5bf0bdd4e052992854bd0312c046283c';

final class IsInLibraryFamily extends $Family
    with
        $ClassFamilyOverride<
          IsInLibrary,
          AsyncValue<bool>,
          bool,
          FutureOr<bool>,
          String
        > {
  const IsInLibraryFamily._()
    : super(
        retry: null,
        name: r'isInLibraryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsInLibraryProvider call(String ncode) =>
      IsInLibraryProvider._(argument: ncode, from: this);

  @override
  String toString() => r'isInLibraryProvider';
}

abstract class _$IsInLibrary extends $AsyncNotifier<bool> {
  late final _$args = ref.$arg as String;
  String get ncode => _$args;

  FutureOr<bool> build(String ncode);
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
