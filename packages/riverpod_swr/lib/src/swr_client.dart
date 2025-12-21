// ignore_for_file: unawaited_futures // Fire-and-forget logic used in validate is intentional
import 'dart:async';

import 'package:riverpod_swr/src/swr_options.dart';

/// Core client for handling SWR operations.
///
/// This class manages the state of inflight requests, caching (stale time),
/// and error reporting.
class SwrClient {
  /// Creates a new [SwrClient].
  SwrClient();

  // Key -> Future mapping for inflight requests (Deduplication)
  final _inflightRequests = <String, Future<void>>{};

  // Key -> Last fetch success time (Throttling / Stale Time)
  final _lastFetched = <String, DateTime>{};

  // Key -> Loading state (exposed via provider)
  final _loadingStates = <String, bool>{};

  // Stream controller for internal loading state updates
  final _loadingController = StreamController<(String, bool)>.broadcast();

  /// A stream of loading state updates.
  ///
  /// Emits a record containing the key and the boolean loading status.
  Stream<(String, bool)> get loadingUpdates => _loadingController.stream;

  /// Returns whether a fetch is currently in progress for the given [key].
  bool isLoading(String key) => _loadingStates[key] ?? false;

  /// Validates the data for [key].
  ///
  /// 1. Emits local data from [watch] immediately (unless [SwrOptions.awaitForInitialData] holds it).
  /// 2. Checks if a fetch is needed based on [options].
  /// 3. If needed, triggers [fetch] and [persist].
  Stream<T> validate<T>({
    required String key,
    required Stream<T> Function() watch,
    required Future<T> Function() fetch,
    required Future<void> Function(T) persist,
    SwrOptions options = const SwrOptions(),
  }) async* {
    // 1. Check local data availability check
    // We need to peek at the stream to see if it has data without consuming it permanently
    // But streams are standard here.
    // Instead, we delegate "waiting" logic to the caller's stream construction or handle it here via yielding.

    // Actually, "awaitForInitialData" usually implies we wait for the FETCH if local is empty.
    // Detecting "empty" depends on the implementation of `watch()`.
    // For drift, it might emit 'null' or empty list.
    // Since T is generic, we can't easily check "isEmpty".
    // A simplified approach: If existing data is likely missing (e.g. we've never fetched), we might block?
    // Better: let's start listening to `watch`.

    // For this implementation, we will yield the stream from `watch()` directly.
    // If `awaitForInitialData` is true, we should *pause* yielding from `watch`?
    // No, `watch` IS the source of truth.
    // If `awaitForInitialData` is true, it means we await the *Fetch Future* BEFORE returning the stream?
    // Or we yield nothing until fetch completes if watch is empty?

    // Strategy:
    // Fire the validation logic.
    // If `awaitForInitialData` is true and we determine we MUST fetch,
    // we await that fetch before yielding the stream.

    final shouldFetch = _shouldFetch(key, options);

    if (shouldFetch) {
      // If we need to wait for initial data, we assume the user WANTS to wait for the fetch result
      // to be persisted before showing anything.
      // NOTE: This assumes `persist` triggers `watch` updates.

      final fetchFuture = _executeFetch(key, fetch, persist, options);

      if (options.awaitForInitialData) {
        // We try to wait. But `shouldFetch` might rely on stale time.
        // If we have stale data, we might not truly "need" to wait if we just want *some* data.
        // `awaitForInitialData` usually means "I have NO data, please wait".
        // But here we rely on the caller to know if they have data?
        // Let's rely on `_lastFetched`? If we never fetched, it's null.
        if (_lastFetched[key] == null) {
          await fetchFuture;
        } else {
          // We have stale data. Don't block. Fire and forget.
          unawaited(fetchFuture);
        }
      } else {
        unawaited(fetchFuture);
      }
    }

    yield* watch();
  }

  bool _shouldFetch(String key, SwrOptions options) {
    final now = DateTime.now();
    final last = _lastFetched[key];

    // 1. If currently loading (inflight), don't trigger another unless strictly needed?
    // Actually `_executeFetch` handles dedup.

    // 2. Check Stale Duration
    if (last != null) {
      final age = now.difference(last);
      if (age < options.staleDuration) {
        return false; // Fresh enough
      }
    }

    return true;
  }

  Future<void> _executeFetch<T>(
    String key,
    Future<T> Function() fetch,
    Future<void> Function(T) persist,
    SwrOptions options,
  ) {
    // 1. Deduplication
    if (_inflightRequests.containsKey(key)) {
      return _inflightRequests[key]!;
    }

    // 2. Throttling (Dedup Interval) checks could be done here too,
    // but `_lastFetched` check in `_shouldFetch` covers the "freshness".
    // The `dedupInterval` is specifically to avoid rapid re-fetches even if stale duration is 0.
    final last = _lastFetched[key];
    if (last != null) {
      final timeSinceLast = DateTime.now().difference(last);
      if (timeSinceLast < options.dedupInterval) {
        return Future.value();
      }
    }

    final future = Future(() async {
      _setLoading(key, true);
      try {
        var attempts = 0;
        while (true) {
          try {
            attempts++;
            final data = await fetch();
            await persist(data);
            _lastFetched[key] = DateTime.now();
            break; // Success
          } on Object catch (e) {
            if (attempts >= options.retryCount) {
              // TODO(developer): Use proper logger
              // ignore: avoid_print // Logs to console as fallback
              print('SWR Fetch Error [$key] after $attempts attempts: $e');
              // We don't rethrow to avoid crashing the unawaited future,
              // but maybe we should expose error state?
              break;
            }
            // Exponential backoff or simple delay?
            await Future<void>.delayed(Duration(milliseconds: 500 * attempts));
          }
        }
      } finally {
        _inflightRequests.remove(key);
        _setLoading(key, false);
      }
    });

    _inflightRequests[key] = future;
    return future;
  }

  void _setLoading(String key, bool loading) {
    if (_loadingStates[key] != loading) {
      _loadingStates[key] = loading;
      _loadingController.add((key, loading));
    }
  }
}
