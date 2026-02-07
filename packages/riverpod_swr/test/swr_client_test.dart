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

    test('revalidate should not emit fetcher data when watcher exists',
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

      // しかし、watcherが存在するため、fetcherのデータは送出されない
      // historyには'fetcher-data-2'が含まれてはいけない
      expect(history, isNot(contains('fetcher-data-2')));

      // watcherのデータは含まれる
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

    test('watcher data should take precedence over fetcher data', () async {
      const key = 'test';
      final watcherController = StreamController<String>.broadcast();

      final stream = client.watch<String>(
        key: key,
        fetcher: () async {
          // fetcherは間違ったデータを返す
          return 'incorrect-data';
        },
        watcher: () => watcherController.stream,
        onPersist: (data) async {
          // DB保存後、watcherが正しいデータを送出する
          await Future<void>.delayed(const Duration(milliseconds: 10));
          watcherController.add('correct-data-from-db');
        },
      );

      final history = <String>[];
      final sub = stream.listen(history.add);

      // 初回のfetcher + watcherの反応を待つ
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // 最終的なデータはwatcherからの正しいデータであるべき
      expect(history.last, equals('correct-data-from-db'));

      // fetcherの間違ったデータは送出されない（watcherが存在するため）
      expect(history, isNot(contains('incorrect-data')));

      await sub.cancel();
      await watcherController.close();
    });
  });
}
