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

String _$novelRepositoryHash() => r'4daeeb4416e0a2340591856b406a4724344c0f5c';

/// 小説の情報を取得し、DBにキャッシュするプロバイダー（SWR）。

@ProviderFor(novelInfoWithCache)
const novelInfoWithCacheProvider = NovelInfoWithCacheFamily._();

/// 小説の情報を取得し、DBにキャッシュするプロバイダー（SWR）。

final class NovelInfoWithCacheProvider
    extends
        $FunctionalProvider<AsyncValue<NovelInfo>, NovelInfo, Stream<NovelInfo>>
    with $FutureModifier<NovelInfo>, $StreamProvider<NovelInfo> {
  /// 小説の情報を取得し、DBにキャッシュするプロバイダー（SWR）。
  const NovelInfoWithCacheProvider._({
    required NovelInfoWithCacheFamily super.from,
    required String super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<NovelInfo> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<NovelInfo> create(Ref ref) {
    final argument = this.argument as String;
    return novelInfoWithCache(ref, argument);
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
    r'85c561a8aa25cc764fb0c76d7f65d3eed8b24b92';

/// 小説の情報を取得し、DBにキャッシュするプロバイダー（SWR）。

final class NovelInfoWithCacheFamily extends $Family
    with $FunctionalFamilyOverride<Stream<NovelInfo>, String> {
  const NovelInfoWithCacheFamily._()
    : super(
        retry: null,
        name: r'novelInfoWithCacheProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小説の情報を取得し、DBにキャッシュするプロバイダー（SWR）。

  NovelInfoWithCacheProvider call(String ncode) =>
      NovelInfoWithCacheProvider._(argument: ncode, from: this);

  @override
  String toString() => r'novelInfoWithCacheProvider';
}

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
    required ({String ncode, int episode, String? revised}) super.argument,
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
        this.argument as ({String ncode, int episode, String? revised});
    return novelContent(
      ref,
      ncode: argument.ncode,
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

String _$novelContentHash() => r'946148ce819d122abf573b303eddb7fb79334a2e';

/// 小説のコンテンツを取得するプロバイダー。

final class NovelContentFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<NovelContentElement>>,
          ({String ncode, int episode, String? revised})
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

  NovelContentProvider call({
    required String ncode,
    required int episode,
    String? revised,
  }) => NovelContentProvider._(
    argument: (ncode: ncode, episode: episode, revised: revised),
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

String _$libraryStatusHash() => r'74d14ac181e29d196f392de4ed9e13fdc957459c';

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

String _$downloadStatusHash() => r'5bdc30ed540eeb4c0a14400e350a22604ac23c82';

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

/// エピソードリストをページ単位で取得するプロバイダー（SWR）

@ProviderFor(episodeList)
const episodeListProvider = EpisodeListFamily._();

/// エピソードリストをページ単位で取得するプロバイダー（SWR）

final class EpisodeListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Episode>>,
          List<Episode>,
          Stream<List<Episode>>
        >
    with $FutureModifier<List<Episode>>, $StreamProvider<List<Episode>> {
  /// エピソードリストをページ単位で取得するプロバイダー（SWR）
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
  $StreamProviderElement<List<Episode>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Episode>> create(Ref ref) {
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

String _$episodeListHash() => r'729c91da200730b7686dc58033503a05891e5a32';

/// エピソードリストをページ単位で取得するプロバイダー（SWR）

final class EpisodeListFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Episode>>, String> {
  const EpisodeListFamily._()
    : super(
        retry: null,
        name: r'episodeListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// エピソードリストをページ単位で取得するプロバイダー（SWR）

  EpisodeListProvider call(String ncodeAndPage) =>
      EpisodeListProvider._(argument: ncodeAndPage, from: this);

  @override
  String toString() => r'episodeListProvider';
}

/// 最後に読んだエピソード番号を取得するプロバイダー

@ProviderFor(lastReadEpisode)
const lastReadEpisodeProvider = LastReadEpisodeFamily._();

/// 最後に読んだエピソード番号を取得するプロバイダー

final class LastReadEpisodeProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, Stream<int?>>
    with $FutureModifier<int?>, $StreamProvider<int?> {
  /// 最後に読んだエピソード番号を取得するプロバイダー
  const LastReadEpisodeProvider._({
    required LastReadEpisodeFamily super.from,
    required String super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int?> create(Ref ref) {
    final argument = this.argument as String;
    return lastReadEpisode(ref, argument);
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

String _$lastReadEpisodeHash() => r'7af911f1a41e9fe29eb6db2205f8178a5fce803a';

/// 最後に読んだエピソード番号を取得するプロバイダー

final class LastReadEpisodeFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int?>, String> {
  const LastReadEpisodeFamily._()
    : super(
        retry: null,
        name: r'lastReadEpisodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// 最後に読んだエピソード番号を取得するプロバイダー

  LastReadEpisodeProvider call(String ncode) =>
      LastReadEpisodeProvider._(argument: ncode, from: this);

  @override
  String toString() => r'lastReadEpisodeProvider';
}
