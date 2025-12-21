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
        dependencies: const <ProviderOrFamily>[
          apiServiceProvider,
          appDatabaseProvider,
          settingsProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          NovelRepositoryProvider.$allTransitiveDependencies0,
          NovelRepositoryProvider.$allTransitiveDependencies1,
          NovelRepositoryProvider.$allTransitiveDependencies2,
        ],
      );

  static const $allTransitiveDependencies0 = apiServiceProvider;
  static const $allTransitiveDependencies1 = appDatabaseProvider;
  static const $allTransitiveDependencies2 = settingsProvider;

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

String _$novelRepositoryHash() => r'a0a8162a93a68d29f7fd5880cdb95b3c38bf9028';

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

  static const $allTransitiveDependencies0 = novelRepositoryProvider;
  static const $allTransitiveDependencies1 =
      NovelRepositoryProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 =
      NovelRepositoryProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 =
      NovelRepositoryProvider.$allTransitiveDependencies2;

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

String _$novelContentHash() => r'101d1862e824c2d3ae7370f7990f24a36f06df23';

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
        dependencies: const <ProviderOrFamily>[novelRepositoryProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          NovelContentProvider.$allTransitiveDependencies0,
          NovelContentProvider.$allTransitiveDependencies1,
          NovelContentProvider.$allTransitiveDependencies2,
          NovelContentProvider.$allTransitiveDependencies3,
        },
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
    extends $FunctionalProvider<AsyncValue<int?>, int?, Stream<int?>>
    with $FutureModifier<int?>, $StreamProvider<int?> {
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
  $StreamProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int?> create(Ref ref) {
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
    r'd35b31e59af860b089466eb79f5808081d5ebf90';

/// エピソードのダウンロード状態を監視するプロバイダー。
///
/// 戻り値: ダウンロード状態を表すint値（2=成功、3=失敗、null=未ダウンロード）

final class EpisodeDownloadStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<Stream<int?>, ({String ncode, int episode})> {
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

/// エピソードリストを取得するプロバイダー（SWR）

@ProviderFor(episodeList)
const episodeListProvider = EpisodeListFamily._();

/// エピソードリストを取得するプロバイダー（SWR）

final class EpisodeListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Episode>>,
          List<Episode>,
          Stream<List<Episode>>
        >
    with $FutureModifier<List<Episode>>, $StreamProvider<List<Episode>> {
  /// エピソードリストを取得するプロバイダー（SWR）
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

  static const $allTransitiveDependencies0 = apiServiceProvider;
  static const $allTransitiveDependencies1 = novelRepositoryProvider;
  static const $allTransitiveDependencies2 =
      NovelRepositoryProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 =
      NovelRepositoryProvider.$allTransitiveDependencies2;

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

String _$episodeListHash() => r'95ab83d6a1b0b85ba0fd4b56b887cd31b9c802b8';

/// エピソードリストを取得するプロバイダー（SWR）

final class EpisodeListFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Episode>>, String> {
  const EpisodeListFamily._()
    : super(
        retry: null,
        name: r'episodeListProvider',
        dependencies: const <ProviderOrFamily>[
          apiServiceProvider,
          novelRepositoryProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          EpisodeListProvider.$allTransitiveDependencies0,
          EpisodeListProvider.$allTransitiveDependencies1,
          EpisodeListProvider.$allTransitiveDependencies2,
          EpisodeListProvider.$allTransitiveDependencies3,
        },
        isAutoDispose: true,
      );

  /// エピソードリストを取得するプロバイダー（SWR）

  EpisodeListProvider call(String ncodeAndPage) =>
      EpisodeListProvider._(argument: ncodeAndPage, from: this);

  @override
  String toString() => r'episodeListProvider';
}

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

  static const $allTransitiveDependencies0 = apiServiceProvider;
  static const $allTransitiveDependencies1 = novelRepositoryProvider;
  static const $allTransitiveDependencies2 =
      NovelRepositoryProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 =
      NovelRepositoryProvider.$allTransitiveDependencies2;

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
    r'245ff24882f6f172ec3ae0e7b79adca2f6b62503';

/// 小説の情報を取得し、DBにキャッシュするプロバイダー（SWR）。

final class NovelInfoWithCacheFamily extends $Family
    with $FunctionalFamilyOverride<Stream<NovelInfo>, String> {
  const NovelInfoWithCacheFamily._()
    : super(
        retry: null,
        name: r'novelInfoWithCacheProvider',
        dependencies: const <ProviderOrFamily>[
          apiServiceProvider,
          novelRepositoryProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          NovelInfoWithCacheProvider.$allTransitiveDependencies0,
          NovelInfoWithCacheProvider.$allTransitiveDependencies1,
          NovelInfoWithCacheProvider.$allTransitiveDependencies2,
          NovelInfoWithCacheProvider.$allTransitiveDependencies3,
        },
        isAutoDispose: true,
      );

  /// 小説の情報を取得し、DBにキャッシュするプロバイダー（SWR）。

  NovelInfoWithCacheProvider call(String ncode) =>
      NovelInfoWithCacheProvider._(argument: ncode, from: this);

  @override
  String toString() => r'novelInfoWithCacheProvider';
}
