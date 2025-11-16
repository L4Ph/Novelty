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

String _$novelContentHash() => r'bbb3060ae5dc4ee6701daaf77eb1c3a030ad973a';

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

String _$libraryStatusHash() => r'0a620c55b174e9c76c65870591352f0ff57b674a';

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

String _$downloadProgressHash() => r'e808e1ee1982745b6ac4e0cc6c44b2f7a8847a38';

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

/// 現在のエピソード番号を管理するプロバイダー。

@ProviderFor(CurrentEpisode)
const currentEpisodeProvider = CurrentEpisodeProvider._();

/// 現在のエピソード番号を管理するプロバイダー。
final class CurrentEpisodeProvider
    extends $NotifierProvider<CurrentEpisode, int> {
  /// 現在のエピソード番号を管理するプロバイダー。
  const CurrentEpisodeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentEpisodeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentEpisodeHash();

  @$internal
  @override
  CurrentEpisode create() => CurrentEpisode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$currentEpisodeHash() => r'b524bb5851aa7661c96937fb4f8c96a303eded20';

/// 現在のエピソード番号を管理するプロバイダー。

abstract class _$CurrentEpisode extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
