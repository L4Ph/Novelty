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
  });
}
