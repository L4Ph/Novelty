import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_state/tiny_state.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: child,
);

void main() {
  group('Async', () {
    test('folds each state into the matching branch', () {
      expect(
        const AsyncLoading<int>().when(
          loading: () => 'loading',
          data: (v) => 'data $v',
          error: (e, _) => 'error $e',
        ),
        equals('loading'),
      );
      expect(
        const AsyncData<int>(1).when(
          loading: () => 'loading',
          data: (v) => 'data $v',
          error: (e, _) => 'error $e',
        ),
        equals('data 1'),
      );
      expect(
        AsyncError<int>(StateError('x'), StackTrace.empty).when(
          loading: () => 'loading',
          data: (v) => 'data $v',
          error: (e, _) => 'error $e',
        ),
        equals('error Bad state: x'),
      );
    });

    test('exposes the value and the error separately', () {
      const Async<int> data = AsyncData<int>(7);
      final Async<int> error = AsyncError<int>(
        StateError('x'),
        StackTrace.empty,
      );

      expect(data.valueOrNull, equals(7));
      expect(data.errorOrNull, isNull);
      expect(data.isLoading, isFalse);
      expect(error.valueOrNull, isNull);
      expect(error.errorOrNull, isA<StateError>());
    });
  });

  group('CancelToken', () {
    test('runs listeners immediately when already cancelled', () {
      final token = CancelToken()..cancel();
      var called = 0;
      token.onCancel(() => called++);

      expect(called, equals(1));
      expect(token.isCancelled, isTrue);
    });

    test('completes whenCancelled once cancelled', () async {
      final token = CancelToken();
      final pending = token.whenCancelled;
      token.cancel();
      await pending;
      expect(token.isCancelled, isTrue);
    });

    test('throws from throwIfCancelled only after cancellation', () {
      final live = CancelToken();
      expect(live.throwIfCancelled, returnsNormally);

      final cancelled = CancelToken()..cancel();
      expect(cancelled.throwIfCancelled, throwsA(isA<LoadCancelled>()));
    });
  });

  group('Scope', () {
    testWidgets('resolves services by type', (tester) async {
      final api = _FakeApi();
      late _FakeApi found;

      await tester.pumpWidget(
        _host(
          Scope(
            services: <Type, Object>{_FakeApi: api},
            child: Builder(
              builder: (context) {
                found = Scope.of(context).get<_FakeApi>();
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(identical(found, api), isTrue);
    });

    testWidgets('names the missing type when a service is absent', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Scope(
            services: const <Type, Object>{},
            child: Builder(
              builder: (context) {
                expect(
                  () => Scope.of(context).get<_FakeApi>(),
                  throwsA(
                    isA<StateError>().having(
                      (e) => e.message,
                      'message',
                      contains('_FakeApi'),
                    ),
                  ),
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
  });

  group('StreamLoader', () {
    testWidgets('walks loading to data', (tester) async {
      final controller = StreamController<int>();
      addTearDown(controller.close);
      final seen = <Async<int>>[];

      await tester.pumpWidget(
        _host(
          StreamLoader<int>(
            stream: controller.stream,
            builder: (context, state) {
              seen.add(state);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(seen.last.isLoading, isTrue);

      controller.add(1);
      await tester.pumpAndSettle();

      expect(seen.last.valueOrNull, equals(1));
    });

    testWidgets('reports an error and recovers on the next event', (
      tester,
    ) async {
      final controller = StreamController<int>();
      addTearDown(controller.close);
      final seen = <Async<int>>[];

      await tester.pumpWidget(
        _host(
          StreamLoader<int>(
            stream: controller.stream,
            builder: (context, state) {
              seen.add(state);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      controller.addError(StateError('boom'));
      await tester.pumpAndSettle();
      expect(seen.last.errorOrNull, isA<StateError>());

      controller.add(2);
      await tester.pumpAndSettle();
      expect(seen.last.valueOrNull, equals(2));
    });
  });
}

class _FakeApi {}
