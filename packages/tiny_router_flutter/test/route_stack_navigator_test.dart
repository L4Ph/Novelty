import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_router/tiny_router.dart';
import 'package:tiny_router_flutter/tiny_router_flutter.dart';

/// A screen that counts its own taps, so tests can tell whether its state
/// survived a rebuild of the navigator.
class _Counter extends StatefulWidget {
  const _Counter(this.label);

  final String label;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int taps = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => setState(() => taps++),
      child: Text('${widget.label}:$taps'),
    ),
  );
}

Widget _app(RouteStack<String> stack, {bool handlesSystemPop = true}) =>
    MaterialApp(
      home: RouteStackNavigator<String>(
        stack: stack,
        handlesSystemPop: handlesSystemPop,
        builder: (context, destination) => _Counter(destination),
      ),
    );

void main() {
  group('RouteStackNavigator', () {
    testWidgets('renders the stack', (tester) async {
      final stack = RouteStack<String>(['root'])..push('a');
      await tester.pumpWidget(_app(stack));

      expect(find.text('a:0'), findsOneWidget);
      expect(find.text('root:0'), findsNothing);
    });

    testWidgets('push adds a screen and pop removes it', (tester) async {
      final stack = RouteStack<String>(['root']);
      await tester.pumpWidget(_app(stack));
      expect(find.text('root:0'), findsOneWidget);

      stack.push('a');
      await tester.pumpAndSettle();
      expect(find.text('a:0'), findsOneWidget);

      stack.pop();
      await tester.pumpAndSettle();
      expect(find.text('a:0'), findsNothing);
      expect(find.text('root:0'), findsOneWidget);
    });

    testWidgets('keeps the state of the screen below across push and pop', (
      tester,
    ) async {
      final stack = RouteStack<String>(['root']);
      await tester.pumpWidget(_app(stack));
      await tester.tap(find.text('root:0'));
      await tester.pump();
      expect(find.text('root:1'), findsOneWidget);

      stack.push('a');
      await tester.pumpAndSettle();
      stack.pop();
      await tester.pumpAndSettle();

      expect(find.text('root:1'), findsOneWidget);
    });

    testWidgets('gives distinct keys when a destination appears twice', (
      tester,
    ) async {
      final stack = RouteStack<String>(['root'])
        ..push('a')
        ..push('root');
      await tester.pumpWidget(_app(stack));
      await tester.pumpAndSettle();

      expect(find.text('root:0'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('syncs the stack when a screen pops itself', (tester) async {
      final stack = RouteStack<String>(['root'])..push('a');
      await tester.pumpWidget(_app(stack));

      Navigator.of(tester.element(find.text('a:0'))).pop();
      await tester.pumpAndSettle();

      expect(stack.entries, ['root']);
      expect(find.text('root:0'), findsOneWidget);
    });

    testWidgets('system back pops this navigator', (tester) async {
      final stack = RouteStack<String>(['root'])..push('a');
      await tester.pumpWidget(_app(stack));
      // The pop scope follows a navigation notification, delivered one frame
      // after the navigator is built.
      await tester.pump();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(stack.entries, ['root']);
    });

    testWidgets('does not consume system back when handlesSystemPop is false', (
      tester,
    ) async {
      final stack = RouteStack<String>(['root'])..push('a');
      await tester.pumpWidget(_app(stack, handlesSystemPop: false));
      await tester.pump();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(stack.entries, ['root', 'a']);
    });
  });
}
