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

String _$novelInfoHash() => r'1049b7a53e99a3b1bfba8543c303cef23779e8d5';

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

@ProviderFor(shortStoryContent)
const shortStoryContentProvider = ShortStoryContentFamily._();

final class ShortStoryContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NovelContentElement>>,
          List<NovelContentElement>,
          FutureOr<List<NovelContentElement>>
        >
    with
        $FutureModifier<List<NovelContentElement>>,
        $FutureProvider<List<NovelContentElement>> {
  const ShortStoryContentProvider._({
    required ShortStoryContentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shortStoryContentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shortStoryContentHash();

  @override
  String toString() {
    return r'shortStoryContentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<NovelContentElement>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NovelContentElement>> create(Ref ref) {
    final argument = this.argument as String;
    return shortStoryContent(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShortStoryContentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shortStoryContentHash() => r'db3924c5e837a96bb7c50ec33d450f83bd1127b8';

final class ShortStoryContentFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<NovelContentElement>>, String> {
  const ShortStoryContentFamily._()
    : super(
        retry: null,
        name: r'shortStoryContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShortStoryContentProvider call(String ncode) =>
      ShortStoryContentProvider._(argument: ncode, from: this);

  @override
  String toString() => r'shortStoryContentProvider';
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

String _$favoriteStatusHash() => r'805f39ffdd62300e9292824a6e4496910ed98585';

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

@ProviderFor(DownloadStatus)
const downloadStatusProvider = DownloadStatusFamily._();

final class DownloadStatusProvider
    extends $StreamNotifierProvider<DownloadStatus, bool> {
  const DownloadStatusProvider._({
    required DownloadStatusFamily super.from,
    required NovelInfo super.argument,
  }) : super(
         retry: null,
         name: r'downloadStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadStatusHash();

  @override
  String toString() {
    return r'downloadStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DownloadStatus create() => DownloadStatus();

  @override
  bool operator ==(Object other) {
    return other is DownloadStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadStatusHash() => r'cdf4684a65906999e83c7d63fb1e9930fb708325';

final class DownloadStatusFamily extends $Family
    with
        $ClassFamilyOverride<
          DownloadStatus,
          AsyncValue<bool>,
          bool,
          Stream<bool>,
          NovelInfo
        > {
  const DownloadStatusFamily._()
    : super(
        retry: null,
        name: r'downloadStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DownloadStatusProvider call(NovelInfo novelInfo) =>
      DownloadStatusProvider._(argument: novelInfo, from: this);

  @override
  String toString() => r'downloadStatusProvider';
}

abstract class _$DownloadStatus extends $StreamNotifier<bool> {
  late final _$args = ref.$arg as NovelInfo;
  NovelInfo get novelInfo => _$args;

  Stream<bool> build(NovelInfo novelInfo);
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
