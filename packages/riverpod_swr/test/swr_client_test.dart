import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_swr/riverpod_swr.dart';

void main() {
  group('SwrClient', () {
    late SwrClient client;

    setUp(() {
      client = SwrClient();
    });

    test('should fetch data using fetcher', () async {
      const key = 'test';
      final stream = client.watch<String>(
        key: key,
        fetcher: () async => 'data',
      );

      // Wait for data
      final result = await stream.first;
      expect(result, equals('data'));
    });

    test('should handle errors from fetcher', () async {
      const key = 'test';
      final stream = client.watch<String>(
        key: key,
        fetcher: () async => throw Exception('Fetch failed'),
      );

      expect(stream, emitsError(isA<Exception>()));
    });

    test('should use watcher for real-time updates', () async {
      const key = 'test';
      final controller = StreamController<String>.broadcast();

      final stream = client.watch<String>(
        key: key,
        fetcher: () async => 'initial',
        watcher: () => controller.stream,
      );

      // Start listening
      final history = <String>[];
      final sub = stream.listen(history.add);

      // Wait for initial data
      await Future<void>.delayed(const Duration(milliseconds: 50));

      controller.add('updated');

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(history, contains('updated'));

      await sub.cancel();
      await controller.close();
    });

    test('revalidate should emit fetcher data even when watcher exists',
        () async {
      const key = 'test';
      final watcherController = StreamController<String>.broadcast();
      var fetcherCallCount = 0;

      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'fetcher-data-$fetcherCallCount';
        },
        watcher: () => watcherController.stream,
        onPersist: (data) async {
          // DB保存のシミュレーション
        },
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      // 初回のfetcher呼び出しを待つ
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // watcherから正しいデータを送出
      watcherController.add('watcher-data-correct');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // revalidateを手動で実行
      await client.mutate<String>(key);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // fetcherは2回呼ばれるべき（初回 + revalidate）
      expect(fetcherCallCount, 2);

      // watcherが存在しても、fetcherのデータは送出される（#204修正）
      expect(history, contains('fetcher-data-2'));

      // watcherのデータも含まれる
      expect(history, contains('watcher-data-correct'));

      await sub.cancel();
      await watcherController.close();
    });

    test('revalidate should emit fetcher data when watcher does not exist',
        () async {
      const key = 'test';
      var fetcherCallCount = 0;

      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'fetcher-data-$fetcherCallCount';
        },
        // watcherなし
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      // 初回のfetcher呼び出しを待つ
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // revalidateを手動で実行
      await client.mutate<String>(key);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // fetcherは2回呼ばれるべき
      expect(fetcherCallCount, 2);

      // watcherがないため、両方のfetcherの結果が送出される
      expect(history, contains('fetcher-data-1'));
      expect(history, contains('fetcher-data-2'));

      await sub.cancel();
    });

    test('watcherの後続データが最終的な値として反映される', () async {
      const key = 'test';
      final watcherController = StreamController<String>.broadcast();

      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          // fetcherはデータを返す
          return 'fetcher-data';
        },
        watcher: () => watcherController.stream,
        onPersist: (data) async {
          // DB保存後、watcherが新しいデータを送出する
          await Future<void>.delayed(const Duration(milliseconds: 10));
          watcherController.add('watcher-updated-data');
        },
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      // 初回のfetcher + watcherの反応を待つ
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // 最終的なデータはwatcherからのデータであるべき
      expect(history.last, equals('watcher-updated-data'));

      // fetcherのデータも送出される（#204修正）
      expect(history, contains('fetcher-data'));

      await sub.cancel();
      await watcherController.close();
    });

    test('revalidate中にfetcherがエラーを投げた場合、watcherの有無に関わらずエラーを送出', () async {
      const key = 'test';
      final watcherController = StreamController<String>.broadcast();
      var fetcherCallCount = 0;

      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          if (fetcherCallCount > 1) {
            throw Exception('Network error');
          }
          return 'initial-data';
        },
        watcher: () => watcherController.stream,
      );

      final errors = <Object>[];
      final sub = stream.listen(
        (_) {},
        onError: errors.add,
      );

      // 初回のfetcher呼び出しを待つ
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // revalidateを実行（エラーが発生するはず）
      await client.mutate<String>(key);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // エラーが送出されることを確認
      expect(errors, isNotEmpty);
      expect(errors.first.toString(), contains('Network error'));

      await sub.cancel();
      await watcherController.close();
    });

    test('onPersistが失敗してもwatcherは正常にデータを送出できる', () async {
      const key = 'test';
      final watcherController = StreamController<String>.broadcast();

      final stream = client.watch<String>(
        key: key,
        fetcher: () async => 'fetcher-data',
        watcher: () => watcherController.stream,
        onPersist: (data) async {
          // DB保存に失敗する
          throw Exception('Database write failed');
        },
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      // 初回のfetcher呼び出しを待つ（onPersistは失敗するがエラーは無視される）
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // watcherから正しいデータを送出
      watcherController.add('watcher-data');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // watcherのデータは正常に送出される
      expect(history, contains('watcher-data'));

      await sub.cancel();
      await watcherController.close();
    });

    test('watcherがない場合、fetcherのエラーは正しく送出される', () async {
      const key = 'test';

      final stream = client.watch<String>(
        key: key,
        fetcher: () async => throw Exception('Fetch failed'),
      );

      expect(stream, emitsError(isA<Exception>()));
    });

    test(
        'watcher存在時もfetcherデータがemitされる（#204 バグ修正）',
        () async {
      const key = 'test';
      final watcherController = StreamController<String>.broadcast();
      var fetcherCallCount = 0;

      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'fetcher-data-$fetcherCallCount';
        },
        watcher: () => watcherController.stream,
        onPersist: (data) async {
          // DB保存をシミュレーション
          // watcherは自動では新しいデータをemitしない
        },
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      // 初回のfetcher呼び出しを待つ
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // watcherが空リストを返す（DBにデータがない状態）
      watcherController.add('watcher-empty');

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // 期待: fetcherのデータがemitされる
      // バグがある場合はこのテストが失敗する
      expect(history, contains('fetcher-data-1'));

      // fetcherは1回だけ呼ばれる
      expect(fetcherCallCount, 1);

      await sub.cancel();
      await watcherController.close();
    });

    test('重複するデータはemitされない（distinctチェック）', () async {
      const key = 'test';
      final watcherController = StreamController<String>.broadcast();

      final stream = client.watch<String>(
        key: key,
        fetcher: () async => 'same-data', // 常に同じデータを返す
        watcher: () => watcherController.stream,
        onPersist: (data) async {
          // DB保存後、watcherが同じデータをemit
          await Future<void>.delayed(const Duration(milliseconds: 10));
          watcherController.add('same-data');
        },
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      // 初回のfetcher + watcherの反応を待つ
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // revalidateを手動で実行
      await client.mutate<String>(key);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // 同じデータは重複してemitされないはず
      expect(history.where((d) => d == 'same-data').length, 1);

      await sub.cancel();
      await watcherController.close();
    });

    test('staleTimeが設定されている場合、キャッシュが新鮮ならfetcherは呼ばれない', () async {
      const key = 'test';
      var fetcherCallCount = 0;

      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'data-$fetcherCallCount';
        },
        options: const SwrOptions(staleTime: Duration(seconds: 1)),
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      // 初回のfetcher呼び出しを待つ
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(fetcherCallCount, 1);
      expect(history, contains('data-1'));

      // 同じキーで別のstreamを作成（staleTime内）
      final stream2 = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'data-$fetcherCallCount';
        },
        options: const SwrOptions(staleTime: Duration(seconds: 1)),
      );

      final history2 = <String>[];
      final sub2 = stream2.listen(history2.add);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // staleTime内なのでfetcherは呼ばれない
      expect(fetcherCallCount, 1);

      await sub.cancel();
      await sub2.cancel();
    });

    test('staleTimeが期限切れになると再リスン時にfetcherが呼ばれる', () async {
      const key = 'test';
      var fetcherCallCount = 0;

      // staleTimeを非常に短く設定（50ms）
      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'data-$fetcherCallCount';
        },
        options: const SwrOptions(staleTime: Duration(milliseconds: 50)),
      );

      final history = <String>[];
      var sub = stream.listen(history.add);

      // 初回のfetcher呼び出しを待つ
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(fetcherCallCount, 1);

      // リスナーを解除（ブロードキャストストリームのリスナー数が0→次のlistenでonListenが再発火）
      await sub.cancel();

      // staleTimeが切れるのを待つ（合計100ms以上経過）
      await Future<void>.delayed(const Duration(milliseconds: 80));

      // 再リスン → _onListen → _shouldFetch(true, stale) → revalidate → fetch
      final history2 = <String>[];
      sub = stream.listen(history2.add);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // staleTimeが切れたためfetcherが再度呼ばれる
      expect(fetcherCallCount, 2);
      expect(history2, contains('data-2'));

      await sub.cancel();
    });

    test('clear()後はstaleTime内でも再リスン時にfetcherが呼ばれる', () async {
      const key = 'test';
      var fetcherCallCount = 0;

      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'data-$fetcherCallCount';
        },
        options: const SwrOptions(staleTime: Duration(seconds: 10)),
      );

      final history = <String>[];
      var sub = stream.listen(history.add);

      // 初回のfetcher呼び出しを待つ
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(fetcherCallCount, 1);

      // clear()でキャッシュとタイムスタンプをリセット
      client.clear(key);

      // リスナーを一度解除し、再リスンで_onListenを再発火させる
      await sub.cancel();
      final history2 = <String>[];
      sub = stream.listen(history2.add);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // staleTime内でもclear()によりタイムスタンプが削除されたのでfetcherが呼ばれる
      expect(fetcherCallCount, 2);
      expect(history2, contains('data-2'));

      await sub.cancel();
    });

    test('clearAll()後はすべてのキーでstaleTime内でも再リスン時にfetcherが呼ばれる',
        () async {
      const key1 = 'key1';
      const key2 = 'key2';
      var fetcherCount1 = 0;
      var fetcherCount2 = 0;

      final stream1 = client.watch<String>(
        key: key1,
        fetcher: () async {
          fetcherCount1++;
          return 'data1-$fetcherCount1';
        },
        options: const SwrOptions(staleTime: Duration(seconds: 10)),
      );

      final stream2 = client.watch<String>(
        key: key2,
        fetcher: () async {
          fetcherCount2++;
          return 'data2-$fetcherCount2';
        },
        options: const SwrOptions(staleTime: Duration(seconds: 10)),
      );

      final history1 = <String>[];
      final history2 = <String>[];
      var sub1 = stream1.listen(history1.add);
      var sub2 = stream2.listen(history2.add);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(fetcherCount1, 1);
      expect(fetcherCount2, 1);

      // clearAll()で全キャッシュ・タイムスタンプをリセット
      client.clearAll();

      // リスナーを解除して再リスンで_onListenを再発火させる
      await sub1.cancel();
      await sub2.cancel();

      final history1b = <String>[];
      final history2b = <String>[];
      sub1 = stream1.listen(history1b.add);
      sub2 = stream2.listen(history2b.add);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // clearAll()によりタイムスタンプが削除されたので両方のfetcherが再度呼ばれる
      expect(fetcherCount1, 2);
      expect(fetcherCount2, 2);

      await sub1.cancel();
      await sub2.cancel();
    });

    test('invalidate()後はstaleTime内でも新しいwatchでfetcherが呼ばれる', () async {
      const key = 'test';
      var fetcherCallCount = 0;

      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'data-$fetcherCallCount';
        },
        options: const SwrOptions(staleTime: Duration(seconds: 10)),
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(fetcherCallCount, 1);

      // リスナーをキャンセルしてからinvalidate
      await sub.cancel();
      client.invalidate(key);

      // invalidate後は購読・キャッシュ・タイムスタンプがすべて削除される
      // 新しいwatchでfetcherが呼ばれるべき
      final stream2 = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'data-$fetcherCallCount';
        },
        options: const SwrOptions(staleTime: Duration(seconds: 10)),
      );

      final history2 = <String>[];
      final sub2 = stream2.listen(history2.add);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // invalidateによりタイムスタンプが削除されたのでfetcherが再度呼ばれる
      expect(fetcherCallCount, 2);
      expect(history2, contains('data-2'));

      await sub2.cancel();
    });

    test('異なるデータは重複チェック後も正しくemitされる', () async {
      const key = 'test';
      final watcherController = StreamController<String>.broadcast();

      final stream = client.watch<String>(
        key: key,
        fetcher: () async => 'initial',
        watcher: () => watcherController.stream,
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // 同じデータをemit（重複するのでスキップされるはず）
      watcherController.add('initial');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      // 異なるデータをemit（これは通るべき）
      watcherController.add('updated');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      // 'initial'は一度だけ、'updated'は一度含まれる
      expect(history.where((d) => d == 'initial').length, 1);
      expect(history, contains('updated'));
      // 'updated'の後に'initial'と同じ内容を送ると再度スキップされる
      watcherController.add('updated');
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(history.where((d) => d == 'updated').length, 1);

      await sub.cancel();
      await watcherController.close();
    });

    test('clear()を存在しないキーに呼び出してもエラーにならない', () {
      // 存在しないキーに対してclear()を呼んでも例外は発生しない
      expect(() => client.clear('nonexistent-key'), returnsNormally);
    });

    test('clearAll()が空のクライアントでエラーにならない', () {
      // キャッシュが空の状態でclearAll()を呼んでも例外は発生しない
      expect(() => client.clearAll(), returnsNormally);
    });

    test('invalidate()を存在しないキーに呼び出してもエラーにならない', () {
      // 存在しないキーに対してinvalidate()を呼んでも例外は発生しない
      expect(() => client.invalidate('nonexistent-key'), returnsNormally);
    });

    test('staleTime=Duration.zeroは常にfetcherを呼ぶ（デフォルト動作の回帰テスト）', () async {
      const key = 'test';
      var fetcherCallCount = 0;

      // staleTime=Duration.zero（デフォルト）
      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'data-$fetcherCallCount';
        },
        // staleTimeはデフォルト（Duration.zero）
      );

      final history = <String>[];
      var sub = stream.listen(history.add);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(fetcherCallCount, 1);

      // リスナーを解除し再リスン → _onListen → staleTime=0 → 常にfetch
      await sub.cancel();
      final history2 = <String>[];
      sub = stream.listen(history2.add);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Duration.zeroなのでfetcherは再度呼ばれる
      expect(fetcherCallCount, 2);

      await sub.cancel();
    });

    test('fetcherとwatcherが同じデータを返す場合、重複emit防止が機能する', () async {
      const key = 'test';
      final watcherController = StreamController<String>.broadcast();

      final stream = client.watch<String>(
        key: key,
        fetcher: () async => 'same-value',
        watcher: () => watcherController.stream,
        onPersist: (data) async {
          // DB保存後watcherが同じ値を送出
          watcherController.add('same-value');
        },
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      // fetcherとwatcherが同じ値を返しても、historyには1件のみ
      expect(history.where((d) => d == 'same-value').length, 1);

      await sub.cancel();
      await watcherController.close();
    });

    test('_shouldFetch: タイムスタンプなし（初回アクセス）は常にfetchする', () async {
      const key = 'test';
      var fetcherCallCount = 0;

      // タイムスタンプがない状態（初回）でstaleTimeが設定されていてもfetchされる
      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'data-$fetcherCallCount';
        },
        options: const SwrOptions(staleTime: Duration(seconds: 60)),
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // タイムスタンプがないため、staleTimeが長くてもfetcherは呼ばれる
      expect(fetcherCallCount, 1);
      expect(history, contains('data-1'));

      await sub.cancel();
    });

    test('mutate()でデータを手動設定後、revalidate=trueなら再fetchされる', () async {
      const key = 'test';
      var fetcherCallCount = 0;

      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'fetcher-data-$fetcherCallCount';
        },
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(fetcherCallCount, 1);

      // データを手動設定してrevalidateもトリガー
      await client.mutate<String>(key, data: 'manual-data', revalidate: true);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // 手動データがemitされ、その後fetcherが再度呼ばれる
      expect(history, contains('manual-data'));
      expect(fetcherCallCount, 2);

      await sub.cancel();
    });

    test('mutate()でrevalidate=falseなら手動データのみemitされfetcherは呼ばれない',
        () async {
      const key = 'test';
      var fetcherCallCount = 0;

      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          fetcherCallCount++;
          return 'fetcher-data-$fetcherCallCount';
        },
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(fetcherCallCount, 1);

      // revalidate=falseで手動データのみ設定
      await client.mutate<String>(key, data: 'manual-only', revalidate: false);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(history, contains('manual-only'));
      // fetcherは初回の1回のみ
      expect(fetcherCallCount, 1);

      await sub.cancel();
    });
  });
}