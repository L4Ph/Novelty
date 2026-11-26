import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('App should start without crashing', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Pump a few frames to allow initial rendering
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Should find MaterialApp after initial pump
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App should own its services', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyApp), findsOneWidget);
  });
}
