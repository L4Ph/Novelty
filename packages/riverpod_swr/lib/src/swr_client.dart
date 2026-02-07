import 'dart:async';

import 'package:riverpod_swr/src/types.dart';

/// SWR (Stale-While-Revalidate) クライアントのメインクラス。
///
/// このクラスはデータのキャッシュ、フェッチ、再検証、および状態の監視を管理します。
class SwrClient {
  /// Creates a new [SwrClient].
  SwrClient();

  final Map<String, Object?> _cache = {};
  final Map<String, _SwrSubscription<Object?>> _subscriptions = {};

  /// 指定された [key] のリソースを監視します。
  ///
  /// [fetcher] はデータを取得するための関数です。
  /// [watcher] はデータベースなどの永続化層からのリアルタイム更新を監視するための関数です（オプション）。
  /// [onPersist] は新しくフェッチされたデータを永続化するための関数です（オプション）。
  /// [options] でキャッシュ設定や再検証の挙動をカスタマイズできます。
  Stream<T> watch<T>({
    required String key,
    required Future<T> Function() fetcher,
    Stream<T> Function()? watcher,
    Future<void> Function(T data)? onPersist,
    SwrOptions options = const SwrOptions(),
  }) {
    final sub = _subscriptions.putIfAbsent(
      key,
      () => _SwrSubscription<T>(
        client: this,
        key: key,
        fetcher: fetcher,
        onPersist: onPersist != null ? (data) => onPersist(data) : null,
        watcher: watcher != null ? () => watcher() : null,
        options: options,
      ),
    );

    return sub.stream as Stream<T>;
  }

  /// キャッシュされたデータを取得します。
  T? get<T>(String key) => _cache[key] as T?;

  /// データを手動で更新（ミューテーション）します。
  Future<void> mutate<T>(String key, {T? data, bool revalidate = true}) async {
    if (data != null) {
      _cache[key] = data;
      _subscriptions[key]?.emitData(data);
    }

    if (revalidate) {
      await _subscriptions[key]?.revalidate();
    }
  }

  /// 全ての購読を再検証します。
  Future<void> revalidateAll() async {
    final futures = _subscriptions.values.map((sub) => sub.revalidate());
    await Future.wait(futures);
  }

  /// 指定された [key] のキャッシュをクリアします。
  void clear(String key) {
    _cache.remove(key);
  }

  /// 全てのキャッシュをクリアします。
  void clearAll() {
    _cache.clear();
  }

  bool _shouldFetch(String key, SwrOptions options) {
    // 簡易的な実装: 常に再検証するか、有効期限をチェックする
    // 現在は staleTime=0 と同等の挙動
    return true;
  }

  Future<T> _executeFetch<T>(
    String key,
    Future<T> Function() fetcher,
    Future<void> Function(T data)? onPersist,
    SwrOptions options,
  ) async {
    final data = await fetcher();
    _cache[key] = data;

    if (onPersist != null) {
      await onPersist(data);
    }

    return data;
  }
}

class _SwrSubscription<T> {
  _SwrSubscription({
    required this.client,
    required this.key,
    required this.fetcher,
    required this.options,
    this.onPersist,
    this.watcher,
  }) : _controller = StreamController<T>.broadcast() {
    _controller.onListen = _onListen;
    _controller.onCancel = _onCancel;
  }

  final SwrClient client;
  final String key;
  final Future<T> Function() fetcher;
  final Future<void> Function(T data)? onPersist;
  final Stream<T> Function()? watcher;
  final SwrOptions options;

  final StreamController<T> _controller;
  StreamSubscription<T>? _watcherSubscription;
  Timer? _gcTimer;
  bool _isFetching = false;
  bool _isDisposed = false;

  Stream<T> get stream => _controller.stream;

  void _onListen() {
    _gcTimer?.cancel();
    _gcTimer = null;

    scheduleMicrotask(() {
      if (_isDisposed) return;

      // 1. キャッシュデータがあれば送出
      final cachedData = client._cache[key];
      final shouldFetch = client._shouldFetch(key, options);

      if (cachedData != null) {
        emitData(cachedData as T);
      }

      // 2. watcher が指定されている場合は監視を開始
      _startWatcher();

      // 3. stale（古い）状態であれば初期再検証をトリガー
      if (shouldFetch) {
        unawaited(revalidate());
      }
    });
  }

  void _onCancel() {
    if (_controller.hasListener) return;

    // 全てのリスナーが解除されたら、一定時間後にクリーンアップ
    _gcTimer = Timer(options.gcTime, _dispose);
  }

  void _dispose() {
    _isDisposed = true;
    _gcTimer?.cancel();
    unawaited(_watcherSubscription?.cancel());
    _watcherSubscription = null;
    unawaited(_controller.close());
    client._subscriptions.remove(key);
  }

  void _startWatcher() {
    if (watcher == null || _watcherSubscription != null) return;

    _watcherSubscription = watcher!().listen(
      (data) {
        client._cache[key] = data;
        emitData(data);
      },
      onError: (Object e, StackTrace st) {
        emitError(e, st);
      },
    );
  }

  Future<void> revalidate() async {
    if (_isFetching || _isDisposed) return;

    _isFetching = true;
    try {
      final newData =
          await client._executeFetch(key, fetcher, onPersist, options);
      if (_isDisposed) return;

      // watcherが存在する場合は、fetcherのデータを送出しない
      // watcherがDBの正確な状態を監視しているため
      if (watcher == null) {
        emitData(newData);
      }
    } on Object catch (e, st) {
      if (_isDisposed) return;
      emitError(e, st);
    } finally {
      _isFetching = false;
    }
  }

  void emitData(T data) {
    if (_isDisposed || _controller.isClosed) return;
    _controller.add(data);
  }

  void emitError(Object e, StackTrace st) {
    if (_isDisposed || _controller.isClosed) return;
    _controller.addError(e, st);
  }
}
