// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_detail_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// 小説の情報を取得するプロバイダー。
@ProviderFor(novelInfo)
const novelInfoProvider = NovelInfoFamily._();

/// 小説の情報を取得するプロバイダー。
final class NovelInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<NovelInfo>,
          NovelInfo,
          FutureOr<NovelInfo>
        >
    with $FutureModifier<NovelInfo>, $FutureProvider<NovelInfo> {
  /// 小説の情報を取得するプロバイダー。
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

String _$novelInfoHash() => r'64cf469eb7e46427b32ccfb68391bf202ae7e2a9';

/// 小説の情報を取得するプロバイダー。
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

  /// 小説の情報を取得するプロバイダー。
  NovelInfoProvider call(String ncode) =>
      NovelInfoProvider._(argument: ncode, from: this);

  @override
  String toString() => r'novelInfoProvider';
}

/// 小説のエピソードを取得するプロバイダー。
@ProviderFor(episodeList)
const episodeListProvider = EpisodeListFamily._();

/// 小説のエピソードを取得するプロバイダー。
final class EpisodeListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Episode>>,
          List<Episode>,
          FutureOr<List<Episode>>
        >
    with $FutureModifier<List<Episode>>, $FutureProvider<List<Episode>> {
  /// 小説のエピソードを取得するプロバイダー。
  const EpisodeListProvider._({
    required EpisodeListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'episodeListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodeListHash();

  @override
  String toString() {
    return r'episodeListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Episode>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Episode>> create(Ref ref) {
    final argument = this.argument as String;
    return episodeList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodeListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodeListHash() => r'db416a99e1efe708c8478e021196c75d03808ffc';

/// 小説のエピソードを取得するプロバイダー。
final class EpisodeListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Episode>>, String> {
  const EpisodeListFamily._()
    : super(
        retry: null,
        name: r'episodeListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説のエピソードを取得するプロバイダー。
  EpisodeListProvider call(String key) =>
      EpisodeListProvider._(argument: key, from: this);

  @override
  String toString() => r'episodeListProvider';
}

/// 小説のお気に入り状態を管理するプロバイダー。
@ProviderFor(FavoriteStatus)
const favoriteStatusProvider = FavoriteStatusFamily._();

/// 小説のお気に入り状態を管理するプロバイダー。
final class FavoriteStatusProvider
    extends $AsyncNotifierProvider<FavoriteStatus, bool> {
  /// 小説のお気に入り状態を管理するプロバイダー。
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

String _$favoriteStatusHash() => r'b0ca148131c21e996980eb29d4bda6e4976f3c42';

/// 小説のお気に入り状態を管理するプロバイダー。
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

  /// 小説のお気に入り状態を管理するプロバイダー。
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

/// 小説のダウンロード状態を管理するプロバイダー。
/// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。
@ProviderFor(DownloadStatus)
const downloadStatusProvider = DownloadStatusFamily._();

/// 小説のダウンロード状態を管理するプロバイダー。
/// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。
final class DownloadStatusProvider
    extends $StreamNotifierProvider<DownloadStatus, bool> {
  /// 小説のダウンロード状態を管理するプロバイダー。
  /// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。
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

String _$downloadStatusHash() => r'802dc20c13f978fe13a721af0783d28fc878012e';

/// 小説のダウンロード状態を管理するプロバイダー。
/// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。
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

  /// 小説のダウンロード状態を管理するプロバイダー。
  /// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。
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
