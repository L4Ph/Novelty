// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ライブラリの小説リストを提供するプロバイダー

@ProviderFor(libraryNovels)
const libraryNovelsProvider = LibraryNovelsProvider._();

/// ライブラリの小説リストを提供するプロバイダー

final class LibraryNovelsProvider
    extends
        $FunctionalProvider<AsyncValue<NovelList>, NovelList, Stream<NovelList>>
    with $FutureModifier<NovelList>, $StreamProvider<NovelList> {
  /// ライブラリの小説リストを提供するプロバイダー
  const LibraryNovelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryNovelsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryNovelsHash();

  @$internal
  @override
  $StreamProviderElement<NovelList> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<NovelList> create(Ref ref) {
    return libraryNovels(ref);
  }
}

String _$libraryNovelsHash() => r'4b0a3482a1b21159250abf1676f76b2adcd83265';

/// 閲覧履歴を提供するプロバイダー

@ProviderFor(history)
const historyProvider = HistoryProvider._();

/// 閲覧履歴を提供するプロバイダー

final class HistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HistoryData>>,
          List<HistoryData>,
          Stream<List<HistoryData>>
        >
    with
        $FutureModifier<List<HistoryData>>,
        $StreamProvider<List<HistoryData>> {
  /// 閲覧履歴を提供するプロバイダー
  const HistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyHash();

  @$internal
  @override
  $StreamProviderElement<List<HistoryData>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<HistoryData>> create(Ref ref) {
    return history(ref);
  }
}

String _$historyHash() => r'd793d980061255cbc26364bb0e20d92252403a72';

/// 現在時刻を提供するプロバイダー

@ProviderFor(currentTime)
const currentTimeProvider = CurrentTimeProvider._();

/// 現在時刻を提供するプロバイダー

final class CurrentTimeProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
  /// 現在時刻を提供するプロバイダー
  const CurrentTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentTimeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentTimeHash();

  @$internal
  @override
  $ProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime create(Ref ref) {
    return currentTime(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$currentTimeHash() => r'0447979bc20456d337c44a22640bc32ac172824f';

/// 日付ごとにグループ化された閲覧履歴を提供するプロバイダー

@ProviderFor(groupedHistory)
const groupedHistoryProvider = GroupedHistoryProvider._();

/// 日付ごとにグループ化された閲覧履歴を提供するプロバイダー

final class GroupedHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HistoryGroup>>,
          List<HistoryGroup>,
          Stream<List<HistoryGroup>>
        >
    with
        $FutureModifier<List<HistoryGroup>>,
        $StreamProvider<List<HistoryGroup>> {
  /// 日付ごとにグループ化された閲覧履歴を提供するプロバイダー
  const GroupedHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupedHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupedHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<HistoryGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<HistoryGroup>> create(Ref ref) {
    return groupedHistory(ref);
  }
}

String _$groupedHistoryHash() => r'978b1a1579be3f3e0a811a86e0787dbadb9080f2';
