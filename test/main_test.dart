import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database_maintenance.dart';
import 'package:novelty/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// DBを停止して行う保守操作(import/export)中に、
/// アプリ全体がブロッキング画面で覆われることを検証する。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Pumps the real app with a database that never finishes opening, and
  /// returns nothing: the maintenance controller is the root's own instance, so
  /// these tests drive the overlay widget directly instead.
  Future<void> pumpMyApp(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  }

  group('データベースメンテナンスのブロッキング', () {
    testWidgets('Busy状態ではDB初期化中でもブロッキング画面が表示される', (
      tester,
    ) async {
      final maintenance = DatabaseMaintenanceController();
      addTearDown(maintenance.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: DatabaseMaintenanceOverlay(
            maintenance: maintenance,
            child: const Scaffold(body: Center(child: Text('配下の画面'))),
          ),
        ),
      );

      maintenance.startImportSwap(
        payload: const ImportSwapPayload(
          pendingFilePath: '/tmp/novelty.db.import_pending',
        ),
      );
      await tester.pump();

      expect(find.text('データベースを切り替えています…'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Busy状態ではオーバーレイが配下の画面を覆い、操作を遮断する', (
      tester,
    ) async {
      var tapped = 0;
      final maintenance = DatabaseMaintenanceController();
      addTearDown(maintenance.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: DatabaseMaintenanceOverlay(
            maintenance: maintenance,
            child: Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => tapped++,
                  child: const Text('配下のボタン'),
                ),
              ),
            ),
          ),
        ),
      );

      final task = Completer<void>();
      unawaited(
        maintenance.run<void>(
          label: 'データベースをエクスポートしています…',
          task: () => task.future,
        ),
      );
      await tester.pump();

      // ブロッキング画面が表示され、配下の画面は破棄されずに維持される
      expect(find.text('データベースをエクスポートしています…'), findsOneWidget);
      expect(find.text('配下のボタン'), findsOneWidget);

      // 配下のボタン位置をタップしても、ブロッキング画面に遮断される
      await tester.tap(find.text('配下のボタン'), warnIfMissed: false);
      await tester.pump();
      expect(tapped, 0);

      // Idleに戻すと配下が再び操作できる
      task.complete();
      await tester.pump();
      expect(find.text('データベースをエクスポートしています…'), findsNothing);
      await tester.tap(find.text('配下のボタン'));
      await tester.pump();
      expect(tapped, 1);
    });

    testWidgets('Idle状態ではブロッキング画面は表示されない', (tester) async {
      final maintenance = DatabaseMaintenanceController();
      addTearDown(maintenance.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: DatabaseMaintenanceOverlay(
            maintenance: maintenance,
            child: const Scaffold(body: Center(child: Text('配下の画面'))),
          ),
        ),
      );

      expect(find.text('配下の画面'), findsOneWidget);
      expect(find.text('データベースをエクスポートしています…'), findsNothing);
    });

    testWidgets('インポート適用中は配下の画面がアンマウントされる', (tester) async {
      final maintenance = DatabaseMaintenanceController();
      addTearDown(maintenance.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: DatabaseMaintenanceOverlay(
            maintenance: maintenance,
            child: const Scaffold(body: Center(child: Text('配下の画面'))),
          ),
        ),
      );

      // 通常のBusy状態では配下の画面は維持される
      unawaited(
        maintenance.run<void>(
          label: 'データベースをエクスポートしています…',
          task: () => Completer<void>().future,
        ),
      );
      await tester.pump();
      expect(find.text('配下の画面'), findsOneWidget);

      // インポート適用(payload付き)では配下の画面がアンマウントされる。
      // DBへのストリーム購読を全てキャンセルさせるため。
      maintenance.startImportSwap(
        payload: const ImportSwapPayload(
          pendingFilePath: '/tmp/novelty.db.import_pending',
        ),
      );
      await tester.pump();
      expect(find.text('データベースを切り替えています…'), findsOneWidget);
      expect(find.text('配下の画面'), findsNothing);
    });
  });

  group('テーマ', () {
    test('ダークテーマは暗い配色で生成される', () {
      expect(appTheme(Brightness.light).brightness, Brightness.light);
      expect(appTheme(Brightness.dark).brightness, Brightness.dark);
    });

    testWidgets('起動中の画面もダークテーマを持つ', (tester) async {
      await pumpMyApp(tester);
      await tester.pump();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.darkTheme?.brightness, Brightness.dark);
    });
  });
}
