import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/database/database_maintenance.dart';
import 'package:novelty/screens/data_storage_page.dart';
import 'package:novelty/services/backup_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/test_services.dart';
import 'data_storage_page_test.mocks.dart';

@GenerateMocks([BackupService])
void main() {
  group('DataStoragePage', () {
    late MockBackupService mockBackupService;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      mockBackupService = MockBackupService();
    });

    late DatabaseMaintenanceController maintenance;

    Future<void> pumpPage(
      WidgetTester tester, {
      bool canUseFilePicker = true,
    }) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      maintenance = DatabaseMaintenanceController();
      addTearDown(maintenance.dispose);
      await tester.pumpWidget(
        withServices(
          buildTestServices(db: db, maintenance: maintenance),
          MaterialApp(
            home: DataStoragePage(
              backupService: mockBackupService,
              canUseFilePicker: canUseFilePicker,
            ),
          ),
        ),
      );
    }

    testWidgets('ページタイトルが正しく表示される', (tester) async {
      await pumpPage(tester);

      expect(find.text('データとストレージ'), findsOneWidget);
    });

    testWidgets('データベースバックアップセクションが表示される', (tester) async {
      await pumpPage(tester);

      expect(find.text('データベースのバックアップ'), findsOneWidget);
      expect(find.text('データベースをエクスポート'), findsOneWidget);
      expect(find.text('データベースをインポート'), findsOneWidget);
    });

    testWidgets('ファイル選択が使えない環境ではパスの案内を出す', (tester) async {
      await pumpPage(tester, canUseFilePicker: false);

      expect(
        find.text('このプラットフォームではアプリ内バックアップに対応していません'),
        findsOneWidget,
      );
      expect(find.text('データベースをエクスポート'), findsNothing);
      expect(find.text('データベースをインポート'), findsNothing);
    });

    group('エクスポート', () {
      testWidgets('成功すると完了ダイアログが表示される', (tester) async {
        when(mockBackupService.exportDatabaseToFile()).thenAnswer(
          (_) async => '/test/path/novelty_backup.db',
        );

        await pumpPage(tester);
        await tester.tap(find.text('データベースをエクスポート'));
        await tester.pumpAndSettle();

        expect(find.text('データベースのエクスポートが完了しました'), findsOneWidget);
        verify(mockBackupService.exportDatabaseToFile()).called(1);
      });

      testWidgets('キャンセルするとスナックバーが表示される', (tester) async {
        when(
          mockBackupService.exportDatabaseToFile(),
        ).thenAnswer((_) async => null);

        await pumpPage(tester);
        await tester.tap(find.text('データベースをエクスポート'));
        await tester.pumpAndSettle();

        expect(find.text('エクスポートをキャンセルしました'), findsOneWidget);
      });

      testWidgets('失敗すると理由付きのエラーダイアログが表示される', (tester) async {
        when(
          mockBackupService.exportDatabaseToFile(),
        ).thenThrow(Exception('export boom'));

        await pumpPage(tester);
        await tester.tap(find.text('データベースをエクスポート'));
        await tester.pumpAndSettle();

        expect(find.text('エクスポートに失敗しました'), findsOneWidget);
        expect(find.textContaining('export boom'), findsOneWidget);
      });
    });

    group('インポート', () {
      testWidgets('データベースインポート確認ダイアログが表示される', (tester) async {
        when(mockBackupService.stageImport()).thenAnswer(
          (_) async => const ImportStagedResult(cancelled: true),
        );

        await pumpPage(tester);
        await tester.tap(find.text('データベースをインポート'));
        await tester.pumpAndSettle();

        expect(find.text('データベースを復元しますか?'), findsOneWidget);
        expect(find.text('キャンセル'), findsOneWidget);
        expect(find.text('復元する'), findsOneWidget);
      });

      testWidgets('読み込みが成功するとデータベースの切り替えが開始される', (
        tester,
      ) async {
        when(mockBackupService.stageImport()).thenAnswer(
          (_) async => const ImportStagedResult(
            pendingFilePath: '/tmp/novelty.db.import_pending',
          ),
        );

        await pumpPage(tester);
        await tester.tap(find.text('データベースをインポート'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('復元する'));
        await tester.pumpAndSettle();

        verify(mockBackupService.stageImport()).called(1);

        expect(maintenance.state, isA<DatabaseMaintenanceBusy>());
        final swap = (maintenance.state as DatabaseMaintenanceBusy).importSwap;
        expect(swap, isNotNull);
        expect(swap!.pendingFilePath, '/tmp/novelty.db.import_pending');
      });

      testWidgets('キャンセルするとスナックバーが表示される', (tester) async {
        when(mockBackupService.stageImport()).thenAnswer(
          (_) async => const ImportStagedResult(cancelled: true),
        );

        await pumpPage(tester);
        await tester.tap(find.text('データベースをインポート'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('復元する'));
        await tester.pumpAndSettle();

        expect(find.text('インポートをキャンセルしました'), findsOneWidget);
      });

      testWidgets('失敗すると理由付きのエラーダイアログが表示される', (tester) async {
        when(
          mockBackupService.stageImport(),
        ).thenThrow(Exception('import boom'));

        await pumpPage(tester);
        await tester.tap(find.text('データベースをインポート'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('復元する'));
        await tester.pumpAndSettle();

        expect(find.text('インポートに失敗しました'), findsOneWidget);
        expect(find.textContaining('import boom'), findsOneWidget);
      });
    });
  });
}
