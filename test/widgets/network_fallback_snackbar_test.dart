import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/widgets/network_fallback_snackbar.dart';

import '../support/test_services.dart';

void main() {
  group('NetworkFallbackSnackbar', () {
    testWidgets('ヘッダーバナーを表示しない', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final services = buildTestServices(db: db);

      await tester.pumpWidget(
        withServices(
          services,
          MaterialApp(
            home: NetworkFallbackSnackbar(
              bus: services.fallback,
              child: const Scaffold(body: Placeholder()),
            ),
          ),
        ),
      );

      expect(find.text('オフラインモード'), findsNothing);
      expect(find.byIcon(Icons.cloud_off), findsNothing);
    });

    testWidgets('フォールバックイベント発生時にスナックバーを表示する', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final services = buildTestServices(db: db);

      await tester.pumpWidget(
        withServices(
          services,
          MaterialApp(
            home: NetworkFallbackSnackbar(
              bus: services.fallback,
              child: const Scaffold(body: Placeholder()),
            ),
          ),
        ),
      );

      services.fallback.emit('通信失敗のテストメッセージ');
      await tester.pumpAndSettle();

      expect(find.text('通信失敗のテストメッセージ'), findsOneWidget);
    });
  });
}
