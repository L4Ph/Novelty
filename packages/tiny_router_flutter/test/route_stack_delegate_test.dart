import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_router/tiny_router.dart';
import 'package:tiny_router_flutter/tiny_router_flutter.dart';

void main() {
  group('RouteStackDelegate', () {
    test('currentConfiguration is the stack content', () {
      final stack = RouteStack<String>(['root'])..push('a');
      final delegate = RouteStackDelegate<String>(
        stack: stack,
        rootBuilder: (context) => const SizedBox.shrink(),
        builder: (context, destination) => Text(destination),
      );
      addTearDown(delegate.dispose);

      expect(delegate.currentConfiguration, ['root', 'a']);
    });

    test('setNewRoutePath replaces the stack', () async {
      final stack = RouteStack<String>()..push('a');
      final delegate = RouteStackDelegate<String>(
        stack: stack,
        rootBuilder: (context) => const SizedBox.shrink(),
        builder: (context, destination) => Text(destination),
      );
      addTearDown(delegate.dispose);

      await delegate.setNewRoutePath(['x']);

      expect(stack.entries, ['x']);
    });

    testWidgets('stacks the pages over the root page', (tester) async {
      final stack = RouteStack<String>(['root']);
      final delegate = RouteStackDelegate<String>(
        stack: stack,
        rootBuilder: (context) => const Text('shell'),
        builder: (context, destination) => Text(destination),
      );
      addTearDown(delegate.dispose);

      await tester.pumpWidget(
        MaterialApp.router(
          routerDelegate: delegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      );
      expect(find.text('shell', skipOffstage: false), findsOneWidget);

      stack.push('a');
      await tester.pumpAndSettle();
      expect(find.text('a'), findsOneWidget);

      stack.pop();
      await tester.pumpAndSettle();
      expect(find.text('a'), findsNothing);
      expect(find.text('shell', skipOffstage: false), findsOneWidget);
    });
  });
}
