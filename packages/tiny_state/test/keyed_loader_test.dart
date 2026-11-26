import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_state/tiny_state.dart';

/// Records what the loader asked for and lets the test release results.
class _Probe<T> {
  final List<CancelToken> tokens = <CancelToken>[];
  final List<Completer<T>> pending = <Completer<T>>[];
  int get calls => tokens.length;

  Future<T> load(CancelToken token) {
    tokens.add(token);
    final completer = Completer<T>();
    pending.add(completer);
    return completer.future;
  }
}

Widget _host(Widget child) => WidgetsApp(
  color: const Color(0xFF000000),
  builder: (context, _) => Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(data: const MediaQueryData(), child: child),
  ),
);

void main() {
  group('KeyedLoader', () {
    testWidgets('loads once and rebuilds with data', (tester) async {
      final probe = _Probe<int>();
      final seen = <Async<int>>[];

      await tester.pumpWidget(
        _host(
          KeyedLoader<int>(
            loadKey: 'a',
            load: probe.load,
            builder: (context, state) {
              seen.add(state);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(probe.calls, equals(1));
      expect(seen.last.isLoading, isTrue);

      probe.pending.single.complete(42);
      await tester.pumpAndSettle();

      expect(seen.last.valueOrNull, equals(42));
    });

    testWidgets('does not reload when rebuilt with the same key', (
      tester,
    ) async {
      final probe = _Probe<int>();

      Widget build() => _host(
        KeyedLoader<int>(
          loadKey: 'a',
          load: probe.load,
          builder: (context, state) => const SizedBox.shrink(),
        ),
      );

      await tester.pumpWidget(build());
      probe.pending.single.complete(1);
      await tester.pumpAndSettle();

      await tester.pumpWidget(build());
      await tester.pump();

      expect(probe.calls, equals(1));
    });

    testWidgets('cancels the previous attempt when the key changes', (
      tester,
    ) async {
      final probe = _Probe<int>();
      final seen = <Async<int>>[];

      Widget build(String key) => _host(
        KeyedLoader<int>(
          loadKey: key,
          load: probe.load,
          builder: (context, state) {
            seen.add(state);
            return const SizedBox.shrink();
          },
        ),
      );

      await tester.pumpWidget(build('a'));
      final firstToken = probe.tokens.single;

      await tester.pumpWidget(build('b'));

      expect(firstToken.isCancelled, isTrue);
      expect(probe.calls, equals(2));
      expect(seen.last.isLoading, isTrue);
    });

    testWidgets('ignores a result whose attempt was superseded', (
      tester,
    ) async {
      final probe = _Probe<int>();
      final seen = <Async<int>>[];

      Widget build(String key) => _host(
        KeyedLoader<int>(
          loadKey: key,
          load: probe.load,
          builder: (context, state) {
            seen.add(state);
            return const SizedBox.shrink();
          },
        ),
      );

      await tester.pumpWidget(build('a'));
      await tester.pumpWidget(build('b'));

      // The slow first attempt finishes after the second one started.
      probe.pending[1].complete(2);
      await tester.pumpAndSettle();
      probe.pending[0].complete(1);
      await tester.pumpAndSettle();

      expect(seen.last.valueOrNull, equals(2));
    });

    testWidgets('reports a failure and keeps it until reloaded', (
      tester,
    ) async {
      final probe = _Probe<int>();
      final seen = <Async<int>>[];

      await tester.pumpWidget(
        _host(
          KeyedLoader<int>(
            loadKey: 'a',
            load: probe.load,
            builder: (context, state) {
              seen.add(state);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      probe.pending.single.completeError(StateError('boom'));
      await tester.pumpAndSettle();

      expect(seen.last.errorOrNull, isA<StateError>());
    });

    testWidgets('cancels on dispose and never touches state afterwards', (
      tester,
    ) async {
      final probe = _Probe<int>();

      await tester.pumpWidget(
        _host(
          KeyedLoader<int>(
            loadKey: 'a',
            load: probe.load,
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ),
      );
      final token = probe.tokens.single;

      await tester.pumpWidget(_host(const SizedBox.shrink()));

      expect(token.isCancelled, isTrue);

      // A result arriving after disposal must not call setState.
      probe.pending.single.complete(1);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('swallows LoadCancelled when the work bails out', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          KeyedLoader<int>(
            loadKey: 'a',
            load: (token) async {
              token.throwIfCancelled();
              return 1;
            },
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
