import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/database/database_initialization.dart';
import 'package:novelty/screens/data_storage_page.dart';
import 'package:novelty/services/backup_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    Future<void> pumpPage(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseInitializationProvider.overrideWith(
              (ref) async => AppDatabase.memory(),
            ),
          ],
          child: MaterialApp(
            home: DataStoragePage(backupService: mockBackupService),
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
        when(mockBackupService.importDatabaseFromFile()).thenAnswer(
          (_) async => const ImportResult(success: true),
        );

        await pumpPage(tester);
        await tester.tap(find.text('データベースをインポート'));
        await tester.pumpAndSettle();

        expect(find.text('データベースを復元しますか?'), findsOneWidget);
        expect(find.text('キャンセル'), findsOneWidget);
        expect(find.text('復元する'), findsOneWidget);
      });

      testWidgets('成功すると復元完了ダイアログが表示される', (tester) async {
        when(mockBackupService.importDatabaseFromFile()).thenAnswer(
          (_) async => const ImportResult(success: true),
        );

        await pumpPage(tester);
        await tester.tap(find.text('データベースをインポート'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('復元する'));
        await tester.pumpAndSettle();

        expect(find.text('復元が完了しました'), findsOneWidget);
        verify(mockBackupService.importDatabaseFromFile()).called(1);
      });

      testWidgets('キャンセルするとスナックバーが表示される', (tester) async {
        when(mockBackupService.importDatabaseFromFile()).thenAnswer(
          (_) async => const ImportResult(cancelled: true),
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
          mockBackupService.importDatabaseFromFile(),
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
