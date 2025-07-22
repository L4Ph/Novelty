import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/screens/data_storage_page.dart';
import 'package:novelty/services/backup_service.dart';
import 'package:novelty/utils/settings_provider.dart';
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

    testWidgets('ページタイトルが正しく表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DataStoragePage(backupService: mockBackupService),
          ),
        ),
      );

      expect(find.text('データとストレージ'), findsOneWidget);
    });

    testWidgets('バックアップセクションが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DataStoragePage(backupService: mockBackupService),
          ),
        ),
      );

      expect(find.text('バックアップ'), findsOneWidget);
      expect(find.text('ライブラリデータをエクスポート'), findsOneWidget);
      expect(find.text('履歴データをエクスポート'), findsOneWidget);
    });

    testWidgets('復元セクションが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DataStoragePage(backupService: mockBackupService),
          ),
        ),
      );

      expect(find.text('復元'), findsOneWidget);
      expect(find.text('ライブラリデータをインポート'), findsOneWidget);
      expect(find.text('履歴データをインポート'), findsOneWidget);
    });

    testWidgets('ダウンロードデータ復元セクションが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DataStoragePage(backupService: mockBackupService),
          ),
        ),
      );

      // プロバイダーが読み込まれるまで待機
      await tester.pumpAndSettle();

      // ダウンロードデータ復元セクションの存在を確認
      expect(find.text('ダウンロードデータの復元'), findsOneWidget);
      expect(find.text('ダウンロードデータを復元'), findsOneWidget);
      expect(find.text('現在のダウンロードフォルダから小説データをライブラリに復元'), findsOneWidget);
    });

    testWidgets('ライブラリエクスポートボタンをタップできる', (WidgetTester tester) async {
      when(mockBackupService.exportLibraryToFile()).thenAnswer(
        (_) async => '/test/path/backup.json',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DataStoragePage(backupService: mockBackupService),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final exportButton = find.text('ライブラリデータをエクスポート');
      expect(exportButton, findsOneWidget);

      await tester.tap(exportButton);
      await tester.pumpAndSettle();

      // バックアップサービスが呼び出されることを確認
      verify(mockBackupService.exportLibraryToFile()).called(1);
    });

    testWidgets('履歴エクスポートボタンをタップできる', (WidgetTester tester) async {
      when(mockBackupService.exportHistoryToFile()).thenAnswer(
        (_) async => '/test/path/history.json',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DataStoragePage(backupService: mockBackupService),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final exportButton = find.text('履歴データをエクスポート');
      expect(exportButton, findsOneWidget);

      await tester.tap(exportButton);
      await tester.pumpAndSettle();

      verify(mockBackupService.exportHistoryToFile()).called(1);
    });

    testWidgets('ダウンロードデータ復元ボタンをタップできる', (WidgetTester tester) async {
      // SharedPreferencesのモック設定
      SharedPreferences.setMockInitialValues({
        'novel_download_path': '/test/path',
      });
      
      // モックの設定
      when(mockBackupService.validateDownloadPath(any)).thenAnswer(
        (_) async => const DownloadPathValidationResult(
          isValid: false,
          foundNovelsCount: 0,
          sampleNcodes: [],
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DataStoragePage(backupService: mockBackupService),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // ダウンロードデータ復元ボタンをタップ
      final restoreButton = find.text('ダウンロードデータを復元');
      
      await tester.tap(restoreButton);
      await tester.pumpAndSettle();

      // バリデーションメソッドが呼ばれたことを確認
      verify(mockBackupService.validateDownloadPath(any)).called(1);
    });
  });
}
