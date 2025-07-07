import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/main.dart';

void main() {
  testWidgets('App should start without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Wait for settings provider to load
    await tester.pumpAndSettle();

    // Should find MaterialApp.router after settings load
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App should have provider scope', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    expect(find.byType(ProviderScope), findsOneWidget);
    expect(find.byType(MyApp), findsOneWidget);
  });
}
