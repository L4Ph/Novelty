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
  });
}
