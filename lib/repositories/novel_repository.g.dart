// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 小説のダウンロードと管理を行うリポジトリ。

@ProviderFor(novelRepository)
final novelRepositoryProvider = NovelRepositoryProvider._();

/// 小説のダウンロードと管理を行うリポジトリ。

final class NovelRepositoryProvider
    extends
        $FunctionalProvider<NovelRepository, NovelRepository, NovelRepository>
    with $Provider<NovelRepository> {
  /// 小説のダウンロードと管理を行うリポジトリ。
  NovelRepositoryProvider._()
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

/// 小説の情報を取得し、DBにキャッシュするプロバイダー。

@ProviderFor(novelInfoWithCache)
final novelInfoWithCacheProvider = NovelInfoWithCacheFamily._();

/// 小説の情報を取得し、DBにキャッシュするプロバイダー。

final class NovelInfoWithCacheProvider
    extends
        $FunctionalProvider<AsyncValue<NovelInfo>, NovelInfo, Stream<NovelInfo>>
    with $FutureModifier<NovelInfo>, $StreamProvider<NovelInfo> {
  /// 小説の情報を取得し、DBにキャッシュするプロバイダー。
  NovelInfoWithCacheProvider._({
    required NovelInfoWithCacheFamily super.from,
    required (NovelSource, String) super.argument,
  }) : super(
         retry: null,
         name: r'novelInfoWithCacheProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$novelInfoWithCacheHash();

  @override
  String toString() {
    return r'novelInfoWithCacheProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<NovelInfo> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<NovelInfo> create(Ref ref) {
    final argument = this.argument as (NovelSource, String);
    return novelInfoWithCache(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is NovelInfoWithCacheProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$novelInfoWithCacheHash() =>
    r'01fd12f5092542253e8ea492945e2a5be891c096';

/// 小説の情報を取得し、DBにキャッシュするプロバイダー。

final class NovelInfoWithCacheFamily extends $Family
    with $FunctionalFamilyOverride<Stream<NovelInfo>, (NovelSource, String)> {
  NovelInfoWithCacheFamily._()
    : super(
        retry: null,
        name: r'novelInfoWithCacheProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説の情報を取得し、DBにキャッシュするプロバイダー。

  NovelInfoWithCacheProvider call(NovelSource source, String workId) =>
      NovelInfoWithCacheProvider._(argument: (source, workId), from: this);

  @override
  String toString() => r'novelInfoWithCacheProvider';
}

/// 小説のコンテンツを取得するプロバイダー。

@ProviderFor(novelContent)
final novelContentProvider = NovelContentFamily._();

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
  NovelContentProvider._({
    required NovelContentFamily super.from,
    required ({NovelSource source, String workId, int episode, String? revised})
    super.argument,
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
    final argument =
        this.argument
            as ({
              NovelSource source,
              String workId,
              int episode,
              String? revised,
            });
    return novelContent(
      ref,
      source: argument.source,
      workId: argument.workId,
      episode: argument.episode,
      revised: argument.revised,
    );
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

String _$novelContentHash() => r'8a7a1d4373913c3b9e3a726cf7ff32f51e902029';

/// 小説のコンテンツを取得するプロバイダー。

final class NovelContentFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<NovelContentElement>>,
          ({NovelSource source, String workId, int episode, String? revised})
        > {
  NovelContentFamily._()
    : super(
        retry: null,
        name: r'novelContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説のコンテンツを取得するプロバイダー。

  NovelContentProvider call({
    required NovelSource source,
    required String workId,
    required int episode,
    String? revised,
  }) => NovelContentProvider._(
    argument: (
      source: source,
      workId: workId,
      episode: episode,
      revised: revised,
    ),
    from: this,
  );

  @override
  String toString() => r'novelContentProvider';
}

/// 小説のライブラリ状態を管理するプロバイダー。

@ProviderFor(LibraryStatus)
final libraryStatusProvider = LibraryStatusFamily._();

/// 小説のライブラリ状態を管理するプロバイダー。
final class LibraryStatusProvider
    extends $StreamNotifierProvider<LibraryStatus, bool> {
  /// 小説のライブラリ状態を管理するプロバイダー。
  LibraryStatusProvider._({
    required LibraryStatusFamily super.from,
    required (NovelSource, String) super.argument,
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
        '$argument';
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

String _$libraryStatusHash() => r'7789ad4534cb893cc9fbcfd86a8d471524effc49';

/// 小説のライブラリ状態を管理するプロバイダー。

final class LibraryStatusFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryStatus,
          AsyncValue<bool>,
          bool,
          Stream<bool>,
          (NovelSource, String)
        > {
  LibraryStatusFamily._()
    : super(
        retry: null,
        name: r'libraryStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説のライブラリ状態を管理するプロバイダー。

  LibraryStatusProvider call(NovelSource source, String workId) =>
      LibraryStatusProvider._(argument: (source, workId), from: this);

  @override
  String toString() => r'libraryStatusProvider';
}

/// 小説のライブラリ状態を管理するプロバイダー。

abstract class _$LibraryStatus extends $StreamNotifier<bool> {
  late final _$args = ref.$arg as (NovelSource, String);
  NovelSource get source => _$args.$1;
  String get workId => _$args.$2;

  Stream<bool> build(NovelSource source, String workId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

/// 小説のダウンロード進捗を監視するプロバイダー。

@ProviderFor(downloadProgress)
final downloadProgressProvider = DownloadProgressFamily._();

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
  DownloadProgressProvider._({
    required DownloadProgressFamily super.from,
    required (NovelSource, String) super.argument,
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
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<DownloadProgress?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<DownloadProgress?> create(Ref ref) {
    final argument = this.argument as (NovelSource, String);
    return downloadProgress(ref, argument.$1, argument.$2);
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

String _$downloadProgressHash() => r'2c23c5e435f8440a6c44a27f4160fc6c56305c93';

/// 小説のダウンロード進捗を監視するプロバイダー。

final class DownloadProgressFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<DownloadProgress?>,
          (NovelSource, String)
        > {
  DownloadProgressFamily._()
    : super(
        retry: null,
        name: r'downloadProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説のダウンロード進捗を監視するプロバイダー。

  DownloadProgressProvider call(NovelSource source, String workId) =>
      DownloadProgressProvider._(argument: (source, workId), from: this);

  @override
  String toString() => r'downloadProgressProvider';
}

/// 小説のダウンロード状態を管理するプロバイダー。
///
/// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。

@ProviderFor(DownloadStatus)
final downloadStatusProvider = DownloadStatusFamily._();

/// 小説のダウンロード状態を管理するプロバイダー。
///
/// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。
final class DownloadStatusProvider
    extends $StreamNotifierProvider<DownloadStatus, bool> {
  /// 小説のダウンロード状態を管理するプロバイダー。
  ///
  /// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。
  DownloadStatusProvider._({
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

String _$downloadStatusHash() => r'b502bb55d3d695bda32e6a54b7db4a40c235945f';

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
  DownloadStatusFamily._()
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
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// エピソードリストをページ単位で取得するプロバイダー。

@ProviderFor(episodeList)
final episodeListProvider = EpisodeListFamily._();

/// エピソードリストをページ単位で取得するプロバイダー。

final class EpisodeListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Episode>>,
          List<Episode>,
          Stream<List<Episode>>
        >
    with $FutureModifier<List<Episode>>, $StreamProvider<List<Episode>> {
  /// エピソードリストをページ単位で取得するプロバイダー。
  EpisodeListProvider._({
    required EpisodeListFamily super.from,
    required (NovelSource, String, int) super.argument,
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
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<Episode>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Episode>> create(Ref ref) {
    final argument = this.argument as (NovelSource, String, int);
    return episodeList(ref, argument.$1, argument.$2, argument.$3);
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

String _$episodeListHash() => r'c55b839d020312f7f2bdf18ee029b1908c40e274';

/// エピソードリストをページ単位で取得するプロバイダー。

final class EpisodeListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<Episode>>,
          (NovelSource, String, int)
        > {
  EpisodeListFamily._()
    : super(
        retry: null,
        name: r'episodeListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// エピソードリストをページ単位で取得するプロバイダー。

  EpisodeListProvider call(NovelSource source, String workId, int page) =>
      EpisodeListProvider._(argument: (source, workId, page), from: this);

  @override
  String toString() => r'episodeListProvider';
}

/// 最後に読んだエピソード番号を取得するプロバイダー

@ProviderFor(lastReadEpisode)
final lastReadEpisodeProvider = LastReadEpisodeFamily._();

/// 最後に読んだエピソード番号を取得するプロバイダー

final class LastReadEpisodeProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, Stream<int?>>
    with $FutureModifier<int?>, $StreamProvider<int?> {
  /// 最後に読んだエピソード番号を取得するプロバイダー
  LastReadEpisodeProvider._({
    required LastReadEpisodeFamily super.from,
    required (NovelSource, String) super.argument,
  }) : super(
         retry: null,
         name: r'lastReadEpisodeProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lastReadEpisodeHash();

  @override
  String toString() {
    return r'lastReadEpisodeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int?> create(Ref ref) {
    final argument = this.argument as (NovelSource, String);
    return lastReadEpisode(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is LastReadEpisodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lastReadEpisodeHash() => r'57fa3006957320a743b6178304ef533eff6c485f';

/// 最後に読んだエピソード番号を取得するプロバイダー

final class LastReadEpisodeFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int?>, (NovelSource, String)> {
  LastReadEpisodeFamily._()
    : super(
        retry: null,
        name: r'lastReadEpisodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// 最後に読んだエピソード番号を取得するプロバイダー

  LastReadEpisodeProvider call(NovelSource source, String workId) =>
      LastReadEpisodeProvider._(argument: (source, workId), from: this);

  @override
  String toString() => r'lastReadEpisodeProvider';
}
