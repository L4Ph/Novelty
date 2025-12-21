// ignore_for_file: unawaited_futures, discarded_futures // SWRの検証（Validation）ロジックにおいて、バックグラウンドでのフェッチ実行は意図的な設計です。
import 'dart:async';

import 'package:riverpod_swr/src/swr_options.dart';

/// SWR操作を処理するコアクライアント。
///
/// このクラスは実行中のリクエストの状態、キャッシュ（stale time）、
/// およびエラー報告を管理します。
class SwrClient {
  /// [SwrClient]を新しく作成します。
  SwrClient();

  // キー -> リクエストのFutureのマッピング（重複排除用）
  final _inflightRequests = <String, Future<Object?>>{};

  // キー -> 最後にフェッチに成功した時刻（スロットリング / Stale Time用）
  final _lastFetched = <String, DateTime>{};

  // キー -> ローディング状態（プロバイダー経由で公開）
  final _loadingStates = <String, bool>{};

  // 内部のローディング状態更新用のストリームコントローラー
  final _loadingController = StreamController<(String, bool)>.broadcast();

  /// ローディング状態の更新ストリーム。
  ///
  /// キーとローディング状態（bool）を含むレコードを発行します。
  Stream<(String, bool)> get loadingUpdates => _loadingController.stream;

  /// 指定された[key]のフェッチが現在進行中かどうかを返します。
  bool isLoading(String key) => _loadingStates[key] ?? false;

  // キー -> アクティブなストリームコントローラーのマッピング
  final _activeControllers = <String, StreamController<Object?>>{};

  /// [key]のデータを検証（validate）します。
  ///
  /// 1. [watch]からローカルデータを即座に発行します。
  /// 2. [options]に基づいてフェッチが必要かどうかを確認します。
  /// 3. 必要に応じて、[fetch]と[persist]を実行します。
  Stream<T> validate<T>({
    required String key,
    required Stream<T> Function() watch,
    required Future<T> Function() fetch,
    required Future<void> Function(T) persist,
    SwrOptions options = const SwrOptions(),
  }) {
    return _activeControllers
        .putIfAbsent(key, () {
          late StreamController<Object?> c;
          StreamSubscription<T>? subscription;

          Future<void> start() async {
            try {
              final shouldFetch = _shouldFetch(key, options);
              Future<T?>? fetchFuture;
              if (shouldFetch) {
                fetchFuture = _executeFetch(key, fetch, persist, options);
              }

              // 初回取得を待機する必要がある場合
              if (options.awaitForInitialData &&
                  _lastFetched[key] == null &&
                  fetchFuture != null) {
                final data = await fetchFuture;
                if (data != null && !c.isClosed) {
                  c.add(data);
                }
              }

              if (c.isClosed) {
                return;
              }

              // debugPrint('[SwrClient] starting watch() for $key');
              subscription = watch().listen(
                (data) {
                  if (!c.isClosed) {
                    c.add(data);
                  }
                },
                onError: (Object e, StackTrace? st) {
                  if (!c.isClosed) {
                    c.addError(e, st);
                  }
                },
                onDone: () {
                  if (!c.isClosed) {
                    c.close();
                  }
                },
              );
            } on Object catch (e, st) {
              if (!c.isClosed) {
                c.addError(e, st);
              }
            }
          }

          return c = StreamController<Object?>.broadcast(
            onListen: () {
              unawaited(start());
            },
            onCancel: () {
              subscription?.cancel();
              subscription = null;
              _activeControllers.remove(key);
              c.close();
            },
          );
        })
        .stream
        .cast<T>();
  }

  bool _shouldFetch(String key, SwrOptions options) {
    final now = DateTime.now();
    final last = _lastFetched[key];

    // 1. 現在読み込み中（実行中）の場合、重複排除が働くのでOK
    // ただし、前回失敗した場合は再試行したいかもしれない

    // 2. ステール期間のチェック
    if (last != null) {
      final age = now.difference(last);
      if (age < options.staleDuration) {
        return false; // 十分に新しい
      }
    }

    return true;
  }

  Future<T?> _executeFetch<T>(
    String key,
    Future<T> Function() fetch,
    Future<void> Function(T) persist,
    SwrOptions options,
  ) async {
    // 1. 重複排除
    if (_inflightRequests.containsKey(key)) {
      final result = await _inflightRequests[key];
      return result as T?;
    }

    // 2. スロットリング（重複排除間隔）
    final last = _lastFetched[key];
    if (last != null) {
      final timeSinceLast = DateTime.now().difference(last);
      if (timeSinceLast < options.dedupInterval) {
        return null;
      }
    }

    final future = Future<T?>(() async {
      _setLoading(key, true);
      try {
        T? result;
        var attempts = 0;
        while (true) {
          try {
            attempts++;
            final data = await fetch();
            await persist(data);
            _lastFetched[key] = DateTime.now();
            result = data;
            break; // 成功
          } on Object {
            if (attempts >= options.retryCount) {
              break;
            }
            // 指数バックオフまたは単純な遅延？
            await Future<void>.delayed(Duration(milliseconds: 500 * attempts));
          }
        }
        return result;
      } finally {
        _inflightRequests.remove(key);
        _setLoading(key, false);
      }
    });

    return _inflightRequests[key] = future;
  }

  void _setLoading(String key, bool loading) {
    if (_loadingStates[key] != loading) {
      _loadingStates[key] = loading;
      _loadingController.add((key, loading));
    }
  }
}
