// ignore_for_file: cascade_invocations

import 'package:test/test.dart';
import 'package:tiny_router/tiny_router.dart';

void main() {
  group('branch stack (one initial entry)', () {
    late RouteStack<String> stack;

    setUp(() => stack = RouteStack<String>(['root']));

    test('starts at the initial entries', () {
      expect(stack.entries, ['root']);
      expect(stack.top, 'root');
      expect(stack.length, 1);
      expect(stack.canPop, isFalse);
      expect(stack.isAtFloor, isTrue);
    });

    test('push adds a destination and pop removes it', () {
      stack.push('a');
      expect(stack.entries, ['root', 'a']);
      expect(stack.canPop, isTrue);
      expect(stack.pop(), isTrue);
      expect(stack.entries, ['root']);
    });

    test('pushing the destination already on top is ignored', () {
      stack.push('a');
      var notified = 0;
      stack.addListener(() => notified++);

      stack.push('a');

      expect(stack.entries, ['root', 'a']);
      expect(notified, 0);
    });

    test('never pops below the initial entries', () {
      expect(stack.pop(), isFalse);
      expect(stack.entries, ['root']);
    });

    test('popToRoot returns to the initial entries', () {
      stack
        ..push('a')
        ..push('b')
        ..popToRoot();
      expect(stack.entries, ['root']);
      expect(stack.isAtFloor, isTrue);
    });

    test('replaceTop swaps the top instead of stacking', () {
      stack
        ..push('a')
        ..replaceTop('b');
      expect(stack.entries, ['root', 'b']);
      expect(stack.length, 2);
    });

    test('replaceTop on an empty stack does nothing', () {
      final empty = RouteStack<String>();
      empty.replaceTop('a');
      expect(empty.entries, isEmpty);
    });

    test('clear restores the initial entries', () {
      stack
        ..push('a')
        ..push('b')
        ..clear();
      expect(stack.entries, ['root']);
    });

    test('does not notify when nothing changes', () {
      var notified = 0;
      stack.addListener(() => notified++);

      stack.clear();
      stack.popToRoot();

      expect(notified, 0);
    });

    test('entries is an unmodifiable view', () {
      expect(() => stack.entries.add('b'), throwsUnsupportedError);
    });
  });

  group('overlay stack (no initial entry)', () {
    late RouteStack<String> overlays;

    setUp(() => overlays = RouteStack<String>());

    test('pops its last entry and removes nothing after', () {
      overlays.push('a');
      expect(overlays.pop(), isTrue);
      expect(overlays.entries, isEmpty);
      expect(overlays.pop(), isFalse);
      expect(overlays.top, isNull);
    });

    test('popToRoot empties it', () {
      overlays
        ..push('a')
        ..push('b')
        ..popToRoot();
      expect(overlays.entries, isEmpty);
    });
  });

  group('listeners', () {
    test('a removed listener is not called', () {
      final stack = RouteStack<String>(['root']);
      var notified = 0;
      void listener() => notified++;

      stack.addListener(listener);
      stack.push('a');
      stack.removeListener(listener);
      stack.push('b');

      expect(notified, 1);
    });

    test('removing a listener during a notification keeps the others', () {
      final stack = RouteStack<String>(['root']);
      var other = 0;
      void first() => stack.removeListener(first);

      stack
        ..addListener(first)
        ..addListener(() => other++)
        ..push('a');

      expect(other, 1);
    });
  });
}
