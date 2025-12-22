import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_swr/src/types.dart';

/// The core client for SWR operations.
/// It manages in-flight requests, cache, and revalidation logic.
class SwrClient {
  /// Creates a new [SwrClient] instance.
  SwrClient();

  // Cache: key -> data
  final Map<String, Object?> _cache = {};

  // Last fetched timestamp: key -> timestamp
  final Map<String, DateTime> _lastFetched = {};

  // In-flight requests: key -> future
  final Map<String, Future<Object?>> _inflightRequests = {};

  // Active controllers: key -> controller
  final Map<String, _SwrSubscription<Object?>> _subscriptions = {};

  /// Watches a resource and triggers revalidation if necessary.
  Stream<AsyncValue<T>> watch<T>({
    required String key,
    required Future<T> Function() fetcher,
    Stream<T> Function()? watcher,
    Future<void> Function(T data)? onPersist,
    SwrOptions options = const SwrOptions(),
  }) {
    final subscription = _subscriptions.putIfAbsent(key, () {
      return _SwrSubscription<T>(
        key: key,
        fetcher: fetcher,
        watcher: watcher,
        onPersist: onPersist,
        options: options,
        client: this,
      );
    }) as _SwrSubscription<T>;

    return subscription.stream;
  }

  /// Manually invalidates a cache entry.
  void invalidate(String key) {
    _lastFetched.remove(key);
    final sub = _subscriptions[key];
    if (sub != null) {
      unawaited(sub.revalidate());
    }
  }

  /// Revalidates all active subscriptions.
  void revalidateAll({bool onlyStale = true}) {
    for (final key in _subscriptions.keys) {
      final sub = _subscriptions[key]!;
      if (!onlyStale || _shouldFetch(key, sub.options)) {
        unawaited(sub.revalidate());
      }
    }
  }

  /// Manually sets data for a key (e.g., for optimistic updates).
  void setData<T>(String key, T data) {
    _cache[key] = data;
    _lastFetched[key] = DateTime.now();
    _subscriptions[key]?.emit(AsyncData(data));
  }

  bool _shouldFetch(String key, SwrOptions options) {
    final last = _lastFetched[key];
    if (last == null) return true;

    final now = DateTime.now();
    return now.difference(last) >= options.staleTime;
  }

  Future<T> _executeFetch<T>(
    String key,
    Future<T> Function() fetcher,
    Future<void> Function(T)? onPersist,
    SwrOptions options,
  ) async {
    // Deduplication
    if (_inflightRequests.containsKey(key)) {
      return (await _inflightRequests[key]) as T;
    }

    final future = Future<T>(() async {
      try {
        var attempts = 0;
        late T data;
        while (true) {
          try {
            attempts++;
            data = await fetcher();
            break;
          } on Object catch (_) {
            if (attempts >= options.retryCount) rethrow;
            await Future<void>.delayed(options.retryDelay * attempts);
          }
        }

        _cache[key] = data;
        _lastFetched[key] = DateTime.now();
        if (onPersist != null) {
          await onPersist(data);
        }
        return data;
      } finally {
        // ignore: unawaited_futures, Cleanup of in-flight request.
        _inflightRequests.remove(key);
      }
    });

    _inflightRequests[key] = future;
    return future;
  }
}

class _SwrSubscription<T> {
  _SwrSubscription({
    required this.key,
    required this.fetcher,
    required this.watcher,
    required this.onPersist,
    required this.options,
    required this.client,
  }) {
    _controller = StreamController<AsyncValue<T>>.broadcast(
      onListen: _onListen,
      onCancel: _onCancel,
    );
  }
  final String key;
  final Future<T> Function() fetcher;
  final Stream<T> Function()? watcher;
  final Future<void> Function(T data)? onPersist;
  final SwrOptions options;
  final SwrClient client;

  late final StreamController<AsyncValue<T>> _controller;
  StreamSubscription<T>? _watcherSubscription;
  Timer? _gcTimer;
  bool _isRevalidating = false;

  Stream<AsyncValue<T>> get stream => _controller.stream;

  void _onListen() {
    _gcTimer?.cancel();
    _gcTimer = null;

    // 1. Emit cached data or loading
    final cachedData = client._cache[key];
    final shouldFetch = client._shouldFetch(key, options);

    if (cachedData != null) {
      _controller.add(AsyncData(cachedData as T));
    } else {
      // Only emit AsyncLoading here if we are NOT going to fetch immediately.
      // If we fetch, revalidate() will emit AsyncLoading, avoiding duplicate events.
      if (!shouldFetch) {
        _controller.add(AsyncLoading<T>());
      }
    }

    // 2. Start watching if provided
    _startWatcher();

    // 3. Trigger initial revalidation if stale
    if (shouldFetch) {
      unawaited(revalidate());
    }
  }

  void _onCancel() {
    if (_controller.hasListener) return;

    unawaited(_watcherSubscription?.cancel());
    _watcherSubscription = null;

    _gcTimer = Timer(options.gcTime, () {
      client._subscriptions.remove(key);
      unawaited(_controller.close());
    });
  }

  void _startWatcher() {
    if (watcher == null || _watcherSubscription != null) return;

    _watcherSubscription = watcher!().listen(
      (data) {
        client._cache[key] = data;
        _controller.add(AsyncData(data));
      },
      onError: (Object e, StackTrace st) {
        _controller.add(AsyncError(e, st));
      },
    );
  }

  Future<void> revalidate() async {
    if (_isRevalidating) return;
    _isRevalidating = true;

    final currentData = client._cache[key] as T?;
    if (currentData != null) {
      // ignore: SWR logic requires manual state transition.
      _controller
          // ignore: invalid_use_of_internal_member
          .add(AsyncLoading<T>().copyWithPrevious(AsyncData(currentData)));
    } else {
      _controller.add(AsyncLoading<T>());
    }

    try {
      final newData =
          await client._executeFetch(key, fetcher, onPersist, options);
      if (watcher == null) {
        _controller.add(AsyncData(newData));
      }
    } on Object catch (e, st) {
      if (currentData != null) {
        _controller
            // ignore: invalid_use_of_internal_member
            .add(AsyncError<T>(e, st).copyWithPrevious(AsyncData(currentData)));
      } else {
        _controller.add(AsyncError(e, st));
      }
    } finally {
      _isRevalidating = false;
    }
  }

  void emit(AsyncValue<T> value) {
    _controller.add(value);
  }
}
