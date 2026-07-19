import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/screens/migration_progress_splash.dart';
import 'package:novelty/screens/migration_recovery_screen.dart';

void main() {
  group('MigrationProgressSplash', () {
    testWidgets('更新メッセージが表示されること', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MigrationProgressSplash()),
      );

      expect(find.text('読書データを最新の状態に更新しています。'), findsOneWidget);
      expect(
        find.text('時間がかかる場合がありますが、画面を閉じずにお待ちください。'),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('MigrationRecoveryScreen', () {
    testWidgets('エラーメッセージと各ボタンが表示されること', (tester) async {
      const errorMessage = 'Exception: test error';
      await tester.pumpWidget(
        MaterialApp(
          home: MigrationRecoveryScreen(
            error: Exception('test error'),
          ),
        ),
      );

      expect(find.text('データベースの更新に失敗しました'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('もう一度試す'), findsOneWidget);
      expect(find.text('データベースをエクスポート'), findsOneWidget);
      expect(find.text('エラーレポートを共有'), findsOneWidget);
    });

    testWidgets('リトライボタンを押すとコールバックが呼ばれること', (tester) async {
      var retryCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: MigrationRecoveryScreen(
            error: Exception('test error'),
            onRetry: () {
              retryCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('もう一度試す'));
      await tester.pump();

      expect(retryCalled, isTrue);
    });

    testWidgets('エクスポートボタンを押すとコールバックが呼ばれること', (tester) async {
      var exportCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: MigrationRecoveryScreen(
            error: Exception('test error'),
            onExportDatabase: () async {
              exportCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('データベースをエクスポート'));
      await tester.pump();

      expect(exportCalled, isTrue);
    });
  });
}
