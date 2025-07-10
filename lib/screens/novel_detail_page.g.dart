// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_detail_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(novelInfo)
const novelInfoProvider = NovelInfoFamily._();

final class NovelInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<NovelInfo>,
          NovelInfo,
          FutureOr<NovelInfo>
        >
    with $FutureModifier<NovelInfo>, $FutureProvider<NovelInfo> {
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

String _$novelInfoHash() => r'1d505c4d2d026c01b09ae1c404806ec88077ac9f';

final class NovelInfoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<NovelInfo>, String> {
  const NovelInfoFamily._()
    : super(
        retry: null,
        name: r'novelInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NovelInfoProvider call(String ncode) =>
      NovelInfoProvider._(argument: ncode, from: this);

  @override
  String toString() => r'novelInfoProvider';
}

@ProviderFor(shortStoryEpisode)
const shortStoryEpisodeProvider = ShortStoryEpisodeFamily._();

final class ShortStoryEpisodeProvider
    extends $FunctionalProvider<AsyncValue<Episode>, Episode, FutureOr<Episode>>
    with $FutureModifier<Episode>, $FutureProvider<Episode> {
  const ShortStoryEpisodeProvider._({
    required ShortStoryEpisodeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shortStoryEpisodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shortStoryEpisodeHash();

  @override
  String toString() {
    return r'shortStoryEpisodeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Episode> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Episode> create(Ref ref) {
    final argument = this.argument as String;
    return shortStoryEpisode(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShortStoryEpisodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shortStoryEpisodeHash() => r'af11c5555c9c6a2017c7e09dad08008a8b902d31';

final class ShortStoryEpisodeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Episode>, String> {
  const ShortStoryEpisodeFamily._()
    : super(
        retry: null,
        name: r'shortStoryEpisodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShortStoryEpisodeProvider call(String ncode) =>
      ShortStoryEpisodeProvider._(argument: ncode, from: this);

  @override
  String toString() => r'shortStoryEpisodeProvider';
}

@ProviderFor(FavoriteStatus)
const favoriteStatusProvider = FavoriteStatusFamily._();

final class FavoriteStatusProvider
    extends $AsyncNotifierProvider<FavoriteStatus, bool> {
  const FavoriteStatusProvider._({
    required FavoriteStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'favoriteStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$favoriteStatusHash();

  @override
  String toString() {
    return r'favoriteStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FavoriteStatus create() => FavoriteStatus();

  @override
  bool operator ==(Object other) {
    return other is FavoriteStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$favoriteStatusHash() => r'6ce3ffffd08cb80ddfd872b9e0cf5654ffb9385c';

final class FavoriteStatusFamily extends $Family
    with
        $ClassFamilyOverride<
          FavoriteStatus,
          AsyncValue<bool>,
          bool,
          FutureOr<bool>,
          String
        > {
  const FavoriteStatusFamily._()
    : super(
        retry: null,
        name: r'favoriteStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FavoriteStatusProvider call(String ncode) =>
      FavoriteStatusProvider._(argument: ncode, from: this);

  @override
  String toString() => r'favoriteStatusProvider';
}

abstract class _$FavoriteStatus extends $AsyncNotifier<bool> {
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
