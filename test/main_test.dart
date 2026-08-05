import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/database/database_maintenance.dart';
import 'package:novelty/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// DBを停止して行う保守操作(import/export)中に、
/// アプリ全体がブロッキング画面で覆われることを検証する。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpMyApp(
    WidgetTester tester, {
    required Future<AppDatabase> Function() dbInit,
  }) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseInitializationProvider.overrideWith((ref) => dbInit()),
        ],
        child: const MyApp(),
      ),
    );
    return ProviderScope.containerOf(tester.element(find.byType(MyApp)));
  }

  group('データベースメンテナンスのブロッキング', () {
    testWidgets('Busy状態ではDB初期化中でもブロッキング画面が表示される', (
      tester,
    ) async {
      final container = await pumpMyApp(
        tester,
        dbInit: () => Completer<AppDatabase>().future,
      );

      container.read(databaseMaintenanceProvider.notifier).state =
          const DatabaseMaintenanceBusy('データベースをインポートしています…');
      await tester.pump();

      expect(find.text('データベースをインポートしています…'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Busy状態ではオーバーレイが配下の画面を覆い、操作を遮断する', (
      tester,
    ) async {
      var tapped = 0;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DatabaseMaintenanceOverlay(
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
        ),
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(DatabaseMaintenanceOverlay)),
      );

      container.read(databaseMaintenanceProvider.notifier).state =
          const DatabaseMaintenanceBusy('データベースをエクスポートしています…');
      await tester.pump();

      // ブロッキング画面が表示され、配下の画面は破棄されずに維持される
      expect(find.text('データベースをエクスポートしています…'), findsOneWidget);
      expect(find.text('配下のボタン'), findsOneWidget);

      // 配下のボタン位置をタップしても、ブロッキング画面に遮断される
      await tester.tap(find.text('配下のボタン'), warnIfMissed: false);
      await tester.pump();
      expect(tapped, 0);

      // Idleに戻すと配下が再び操作できる
      container.read(databaseMaintenanceProvider.notifier).state =
          const DatabaseMaintenanceIdle();
      await tester.pump();
      expect(find.text('データベースをエクスポートしています…'), findsNothing);
      await tester.tap(find.text('配下のボタン'));
      await tester.pump();
      expect(tapped, 1);
    });

    testWidgets('Idle状態ではブロッキング画面は表示されない', (tester) async {
      await pumpMyApp(
        tester,
        dbInit: () => Completer<AppDatabase>().future,
      );
      await tester.pump();

      // ブロッキング画面ではなく、通常のマイグレーションスプラッシュが表示される
      expect(find.text('データベースをインポートしています…'), findsNothing);
      expect(find.text('読書データを最新の状態に更新しています。'), findsOneWidget);
    });

    testWidgets('インポート適用中は配下の画面がアンマウントされる', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DatabaseMaintenanceOverlay(
              child: Scaffold(body: Center(child: Text('配下の画面'))),
            ),
          ),
        ),
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(DatabaseMaintenanceOverlay)),
      );

      // 通常のBusy状態では配下の画面は維持される
      container.read(databaseMaintenanceProvider.notifier).state =
          const DatabaseMaintenanceBusy('データベースをエクスポートしています…');
      await tester.pump();
      expect(find.text('配下の画面'), findsOneWidget);

      // インポート適用(payload付き)では配下の画面がアンマウントされる。
      // DBへのストリーム購読を全てキャンセルさせるため。
      container
          .read(databaseMaintenanceProvider.notifier)
          .state = const DatabaseMaintenanceBusy(
        'データベースを切り替えています…',
        importSwap: ImportSwapPayload(
          pendingFilePath: '/tmp/novelty.db.import_pending',
        ),
      );
      await tester.pump();
      expect(find.text('データベースを切り替えています…'), findsOneWidget);
      expect(find.text('配下の画面'), findsNothing);
    });
  });
}
