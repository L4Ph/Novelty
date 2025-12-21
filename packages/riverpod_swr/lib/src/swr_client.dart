// ignore_for_file: unawaited_futures // validate内でのFire-and-forgetロジックは意図的なものです
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
  final _inflightRequests = <String, Future<void>>{};

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
  }) async* {
    // 1. ローカルデータの可用性チェック
    // ストリームがデータを消費せずにデータを持っているかを確認する必要があります。
    // しかし、ストリームはここでは標準です。
    // 代わりに、「待機」ロジックは呼び出し元のストリーム構築に委ねるか、ここでyieldを介して処理します。

    // 実際、「awaitForInitialData」は通常、ローカルが空の場合にFETCHを待機することを意味します。
    // 「空」の検出は`watch()`の実装に依存します。
    // Driftの場合、'null'または空のリストを発行するかもしれません。
    // Tはジェネリックなので、「isEmpty」を簡単にチェックすることはできません。
    // 簡略化されたアプローチ：既存のデータが欠落している可能性が高い場合（例：一度もフェッチしていない場合）、ブロックするかもしれません。
    // より良い方法：`watch`のリスニングを開始しましょう。

    // この実装では、`watch()`からのストリームを直接yieldします。
    // `awaitForInitialData`がtrueの場合、`watch`からのyieldを一時停止すべきでしょうか？
    // いいえ、`watch`が真実の源です。
    // `awaitForInitialData`がtrueの場合、ストリームを返す前に*Fetch Future*を待機することを意味しますか？
    // または、watchが空の場合、フェッチが完了するまで何もyieldしませんか？

    // 戦略：
    // 検証ロジックを実行します。
    // `awaitForInitialData`がtrueで、フェッチが必須であると判断した場合、
    // ストリームをyieldする前にそのフェッチを待機します。

    final shouldFetch = _shouldFetch(key, options);

    if (shouldFetch) {
      // 初期データを待機する必要がある場合、フェッチ結果が永続化されるのを待ってから
      // データを表示することを想定しています。
      // 注意: `persist`が`watch`の更新をトリガーすることを前提としています。

      final fetchFuture = _executeFetch(key, fetch, persist, options);

      if (options.awaitForInitialData) {
        // まだ一度もフェッチされていない場合は待機します。
        // すでにデータがある（スタスタなデータがある）場合はブロックせずにバックグラウンドで実行します。
        if (_lastFetched[key] == null) {
          await fetchFuture;
        } else {
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

    // 1. 現在ローディング中（実行中）の場合、厳密に必要でない限り、別のトリガーはしない？
    // 実際には`_executeFetch`が重複排除を処理します。

    // 2. Stale Duration のチェック
    if (last != null) {
      final age = now.difference(last);
      if (age < options.staleDuration) {
        return false; // 十分に新しい
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
    // 1. 重複排除
    if (_inflightRequests.containsKey(key)) {
      return _inflightRequests[key]!;
    }

    // 2. スロットリング (重複排除間隔) のチェック
    // ここでもチェックできますが、`_shouldFetch`の`_lastFetched`チェックが「新鮮さ」をカバーしています。
    // `dedupInterval`は、staleDurationが0であっても、急速な再フェッチを防ぐためのものです。
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
            break; // 成功
          } on Object catch (e) {
            if (attempts >= options.retryCount) {
              // TODO(developer): 適切なロガーを使用する
              // ignore: avoid_print // フォールバックとしてコンソールにログを出力
              print('SWR Fetch Error [$key] after $attempts attempts: $e');
              // unawaitedなFutureをクラッシュさせないために再スローしませんが、
              // エラー状態を公開すべきでしょうか？
              break;
            }
            // 指数バックオフまたは単純な遅延？
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
