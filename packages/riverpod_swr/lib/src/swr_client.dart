import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_swr/src/types.dart';

/// SWR 操作を行うためのコアクライアント。
/// リクエストの重複排除、キャッシュ管理、および再検証ロジックを制御します。
class SwrClient {
  /// [SwrClient] インスタンスを作成します。
  SwrClient();

  // キャッシュ: key -> data
  final Map<String, Object?> _cache = {};

  // 最終フェッチ日時: key -> timestamp
  final Map<String, DateTime> _lastFetched = {};

  // 実行中のリクエスト: key -> future
  final Map<String, Future<Object?>> _inflightRequests = {};

  // アクティブなサブスクリプション: key -> controller
  final Map<String, _SwrSubscription<Object?>> _subscriptions = {};

  /// リソースを監視（watch）し、必要に応じて再検証をトリガーします。
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

  /// キャッシュエントリを手動で無効化します。
  void invalidate(String key) {
    _lastFetched.remove(key);
    final sub = _subscriptions[key];
    if (sub != null) {
      unawaited(sub.revalidate());
    }
  }

  /// すべてのアクティブなサブスクリプションを再検証します。
  void revalidateAll({bool onlyStale = true}) {
    for (final key in _subscriptions.keys) {
      final sub = _subscriptions[key]!;
      if (!onlyStale || _shouldFetch(key, sub.options)) {
        unawaited(sub.revalidate());
      }
    }
  }

  /// 特定のキーに対してデータを手動で設定します（例: 楽観的アップデートなど）。
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
    // 重複排除
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
        // ignore: unawaited_futures, 実行中リクエストのクリーンアップ。
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

    // 1. キャッシュデータまたはローディング状態を送出
    final cachedData = client._cache[key];
    final shouldFetch = client._shouldFetch(key, options);

    if (cachedData != null) {
      _controller.add(AsyncData(cachedData as T));
    } else {
      // 直ちにフェッチを開始しない場合のみ、ここで Loading を送出します。
      // フェッチを行う場合、revalidate() 内で Loading が送出されるため、重複を避けます。
      if (!shouldFetch) {
        _controller.add(AsyncLoading<T>());
      }
    }

    // 2. watcher が指定されている場合は監視を開始
    _startWatcher();

    // 3. stale（古い）状態であれば初期再検証をトリガー
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
      // SWRパターン（読み込み中も以前のデータを表示）を実装するため、
      // AsyncValueの状態遷移を手動で行う必要があります。
      // 現状のRiverpod 3には以前のデータを引き継いでLoading状態を生成する公開APIがないため、
      // 内部メンバであるcopyWithPreviousを使用しています。
      _controller
          // ignore: invalid_use_of_internal_member, SWRパターン実装のため以前の状態を引き継ぐ必要があります
          .add(AsyncLoading<T>().copyWithPrevious(AsyncData(currentData)));
    } else {
      _controller.add(AsyncLoading<T>());
    }

    try {
      final newData =
          await client._executeFetch(key, fetcher, onPersist, options);
      // watcher が存在しない場合は、手動でデータを送出する必要があります。
      // （watcher がある場合は DB アップデート経由でデータが送出されます）
      if (watcher == null) {
        _controller.add(AsyncData(newData));
      }
    } on Object catch (e, st) {
      if (currentData != null) {
        // エラー発生時も以前のデータを保持しつつエラーを表示するため、
        // 内部メンバであるcopyWithPreviousを使用して以前の状態を引き継ぎます。
        _controller
            // ignore: invalid_use_of_internal_member, エラー時も以前の状態を引き継ぐ必要があります
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
