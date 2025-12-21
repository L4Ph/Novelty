// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
const appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  const AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'98a09c6cfd43966155dfbdb0787fa18c85438e13';

@ProviderFor(libraryNovels)
const libraryNovelsProvider = LibraryNovelsProvider._();

final class LibraryNovelsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<dynamic>>,
          List<dynamic>,
          Stream<List<dynamic>>
        >
    with $FutureModifier<List<dynamic>>, $StreamProvider<List<dynamic>> {
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
  $StreamProviderElement<List<dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<dynamic>> create(Ref ref) {
    return libraryNovels(ref);
  }
}

String _$libraryNovelsHash() => r'9240a1adc6761ec1bb34bcb6c44a554966f61d04';

@ProviderFor(history)
const historyProvider = HistoryProvider._();

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

@ProviderFor(currentTime)
const currentTimeProvider = CurrentTimeProvider._();

final class CurrentTimeProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
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

@ProviderFor(groupedHistory)
const groupedHistoryProvider = GroupedHistoryProvider._();

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
