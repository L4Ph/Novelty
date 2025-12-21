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
        dependencies: const <ProviderOrFamily>[appDatabaseProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          LibraryNovelsProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = appDatabaseProvider;

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

String _$libraryNovelsHash() => r'5f9c5c30fcfda38dbe999d20658680ec931df8ab';

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
        dependencies: const <ProviderOrFamily>[appDatabaseProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          HistoryProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = appDatabaseProvider;

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

String _$historyHash() => r'b539384484ab9b62af3fad72d7b7135cf3e65beb';

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
        dependencies: const <ProviderOrFamily>[],
        $allTransitiveDependencies: const <ProviderOrFamily>[],
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

String _$currentTimeHash() => r'36e44b77a675f60533a16f3832d550740da21647';

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
        dependencies: const <ProviderOrFamily>[
          appDatabaseProvider,
          currentTimeProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          GroupedHistoryProvider.$allTransitiveDependencies0,
          GroupedHistoryProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = appDatabaseProvider;
  static const $allTransitiveDependencies1 = currentTimeProvider;

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

String _$groupedHistoryHash() => r'b2e92d0849acfa124050ac43abaef7eccf083c41';
