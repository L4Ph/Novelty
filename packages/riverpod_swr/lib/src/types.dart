import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show AsyncValue;

/// Configuration options for SWR data fetching.
class SwrOptions {
  /// Creates a new [SwrOptions] instance.
  const SwrOptions({
    this.staleTime = Duration.zero,
    this.gcTime = const Duration(minutes: 5),
    this.retryCount = 3,
    this.retryDelay = const Duration(milliseconds: 500),
    this.revalidateOnFocus = true,
    this.revalidateOnReconnect = true,
    this.dedupInterval = const Duration(seconds: 2),
  });

  /// The duration until a cache entry is considered stale.
  /// If the cache is newer than this, no fetch will be triggered.
  final Duration staleTime;

  /// The duration that an unused cache entry stays in memory before being garbage collected.
  final Duration gcTime;

  /// The number of times to retry a failed fetch.
  final int retryCount;

  /// The delay between retries.
  final Duration retryDelay;

  /// Whether to revalidate the data when the app gains focus.
  final bool revalidateOnFocus;

  /// Whether to revalidate the data when the network reconnects.
  final bool revalidateOnReconnect;

  /// The interval during which duplicate requests for the same key are ignored.
  final Duration dedupInterval;
}

/// A wrapper around [AsyncValue] that can hold extra SWR-specific metadata if needed.
/// For now, we use [AsyncValue] directly as it supports `hasValue`, `hasError`, and `isLoading`.
typedef SwrState<T> = AsyncValue<T>;
