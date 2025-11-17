// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 小説のダウンロードと管理を行うリポジトリ。

@ProviderFor(novelRepository)
const novelRepositoryProvider = NovelRepositoryProvider._();

/// 小説のダウンロードと管理を行うリポジトリ。

final class NovelRepositoryProvider
    extends
        $FunctionalProvider<NovelRepository, NovelRepository, NovelRepository>
    with $Provider<NovelRepository> {
  /// 小説のダウンロードと管理を行うリポジトリ。
  const NovelRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'novelRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$novelRepositoryHash();

  @$internal
  @override
  $ProviderElement<NovelRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NovelRepository create(Ref ref) {
    return novelRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NovelRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NovelRepository>(value),
    );
  }
}

String _$novelRepositoryHash() => r'2e5398c23a6f338f7d37b8928e2cce71860f7f06';

/// 小説のコンテンツを取得するプロバイダー。

@ProviderFor(novelContent)
const novelContentProvider = NovelContentFamily._();

/// 小説のコンテンツを取得するプロバイダー。

final class NovelContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NovelContentElement>>,
          List<NovelContentElement>,
          FutureOr<List<NovelContentElement>>
        >
    with
        $FutureModifier<List<NovelContentElement>>,
        $FutureProvider<List<NovelContentElement>> {
  /// 小説のコンテンツを取得するプロバイダー。
  const NovelContentProvider._({
    required NovelContentFamily super.from,
    required ({String ncode, int episode}) super.argument,
  }) : super(
         retry: null,
         name: r'novelContentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$novelContentHash();

  @override
  String toString() {
    return r'novelContentProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<NovelContentElement>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NovelContentElement>> create(Ref ref) {
    final argument = this.argument as ({String ncode, int episode});
    return novelContent(ref, ncode: argument.ncode, episode: argument.episode);
  }

  @override
  bool operator ==(Object other) {
    return other is NovelContentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$novelContentHash() => r'9d6d5b1a548e64a593f40c42cd6a515d11be9949';

/// 小説のコンテンツを取得するプロバイダー。

final class NovelContentFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<NovelContentElement>>,
          ({String ncode, int episode})
        > {
  const NovelContentFamily._()
    : super(
        retry: null,
        name: r'novelContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説のコンテンツを取得するプロバイダー。

  NovelContentProvider call({required String ncode, required int episode}) =>
      NovelContentProvider._(
        argument: (ncode: ncode, episode: episode),
        from: this,
      );

  @override
  String toString() => r'novelContentProvider';
}

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

String _$libraryStatusHash() => r'a6e335ba9000e1de28b7bc25c057c8a4b3026a6c';

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

/// 小説のダウンロード進捗を監視するプロバイダー。

@ProviderFor(downloadProgress)
const downloadProgressProvider = DownloadProgressFamily._();

/// 小説のダウンロード進捗を監視するプロバイダー。

final class DownloadProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<DownloadProgress?>,
          DownloadProgress?,
          Stream<DownloadProgress?>
        >
    with
        $FutureModifier<DownloadProgress?>,
        $StreamProvider<DownloadProgress?> {
  /// 小説のダウンロード進捗を監視するプロバイダー。
  const DownloadProgressProvider._({
    required DownloadProgressFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'downloadProgressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadProgressHash();

  @override
  String toString() {
    return r'downloadProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<DownloadProgress?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<DownloadProgress?> create(Ref ref) {
    final argument = this.argument as String;
    return downloadProgress(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadProgressHash() => r'c336d2d44503f03a40ba05cdff963fdeeab7d305';

/// 小説のダウンロード進捗を監視するプロバイダー。

final class DownloadProgressFamily extends $Family
    with $FunctionalFamilyOverride<Stream<DownloadProgress?>, String> {
  const DownloadProgressFamily._()
    : super(
        retry: null,
        name: r'downloadProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説のダウンロード進捗を監視するプロバイダー。

  DownloadProgressProvider call(String ncode) =>
      DownloadProgressProvider._(argument: ncode, from: this);

  @override
  String toString() => r'downloadProgressProvider';
}

/// 小説のダウンロード状態を管理するプロバイダー。
///
/// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。

@ProviderFor(DownloadStatus)
const downloadStatusProvider = DownloadStatusFamily._();

/// 小説のダウンロード状態を管理するプロバイダー。
///
/// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。
final class DownloadStatusProvider
    extends $StreamNotifierProvider<DownloadStatus, bool> {
  /// 小説のダウンロード状態を管理するプロバイダー。
  ///
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

String _$downloadStatusHash() => r'5f53b64ce5cd55b3a45506cd9ad3843dcf7887f7';

/// 小説のダウンロード状態を管理するプロバイダー。
///
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
  ///
  /// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。

  DownloadStatusProvider call(NovelInfo novelInfo) =>
      DownloadStatusProvider._(argument: novelInfo, from: this);

  @override
  String toString() => r'downloadStatusProvider';
}

/// 小説のダウンロード状態を管理するプロバイダー。
///
/// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。

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

/// エピソードのダウンロード状態を監視するプロバイダー。
///
/// 戻り値: ダウンロード状態を表すint値（2=成功、3=失敗、null=未ダウンロード）

@ProviderFor(episodeDownloadStatus)
const episodeDownloadStatusProvider = EpisodeDownloadStatusFamily._();

/// エピソードのダウンロード状態を監視するプロバイダー。
///
/// 戻り値: ダウンロード状態を表すint値（2=成功、3=失敗、null=未ダウンロード）

final class EpisodeDownloadStatusProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// エピソードのダウンロード状態を監視するプロバイダー。
  ///
  /// 戻り値: ダウンロード状態を表すint値（2=成功、3=失敗、null=未ダウンロード）
  const EpisodeDownloadStatusProvider._({
    required EpisodeDownloadStatusFamily super.from,
    required ({String ncode, int episode}) super.argument,
  }) : super(
         retry: null,
         name: r'episodeDownloadStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodeDownloadStatusHash();

  @override
  String toString() {
    return r'episodeDownloadStatusProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    final argument = this.argument as ({String ncode, int episode});
    return episodeDownloadStatus(
      ref,
      ncode: argument.ncode,
      episode: argument.episode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodeDownloadStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodeDownloadStatusHash() =>
    r'ca2df1351facb21732b51139098dffae2a3435a0';

/// エピソードのダウンロード状態を監視するプロバイダー。
///
/// 戻り値: ダウンロード状態を表すint値（2=成功、3=失敗、null=未ダウンロード）

final class EpisodeDownloadStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<int?>,
          ({String ncode, int episode})
        > {
  const EpisodeDownloadStatusFamily._()
    : super(
        retry: null,
        name: r'episodeDownloadStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// エピソードのダウンロード状態を監視するプロバイダー。
  ///
  /// 戻り値: ダウンロード状態を表すint値（2=成功、3=失敗、null=未ダウンロード）

  EpisodeDownloadStatusProvider call({
    required String ncode,
    required int episode,
  }) => EpisodeDownloadStatusProvider._(
    argument: (ncode: ncode, episode: episode),
    from: this,
  );

  @override
  String toString() => r'episodeDownloadStatusProvider';
}
