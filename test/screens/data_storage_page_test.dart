import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/screens/data_storage_page.dart';
import 'package:novelty/services/backup_service.dart';

import 'data_storage_page_test.mocks.dart';

@GenerateMocks([BackupService])
void main() {
  group('DataStoragePage', () {
    late MockBackupService mockBackupService;

    setUp(() {
      mockBackupService = MockBackupService();
    });

    testWidgets('ページタイトルが正しく表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DataStoragePage(backupService: mockBackupService),
        ),
      );

      expect(find.text('データとストレージ'), findsOneWidget);
    });

    testWidgets('バックアップセクションが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DataStoragePage(backupService: mockBackupService),
        ),
      );

      expect(find.text('バックアップ'), findsOneWidget);
      expect(find.text('ライブラリデータをエクスポート'), findsOneWidget);
      expect(find.text('履歴データをエクスポート'), findsOneWidget);
    });

    testWidgets('復元セクションが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DataStoragePage(backupService: mockBackupService),
        ),
      );

      expect(find.text('復元'), findsOneWidget);
      expect(find.text('ライブラリデータをインポート'), findsOneWidget);
      expect(find.text('履歴データをインポート'), findsOneWidget);
    });

    testWidgets('ライブラリエクスポートボタンをタップできる', (WidgetTester tester) async {
      when(mockBackupService.exportLibraryData()).thenAnswer(
        (_) async => {'version': '1.0', 'data': <dynamic>[]},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DataStoragePage(backupService: mockBackupService),
        ),
      );

      final exportButton = find.text('ライブラリデータをエクスポート');
      expect(exportButton, findsOneWidget);

      await tester.tap(exportButton);
      await tester.pump();

      // バックアップサービスが呼び出されることを確認
      verify(mockBackupService.exportLibraryData()).called(1);
    });

    testWidgets('履歴エクスポートボタンをタップできる', (WidgetTester tester) async {
      when(mockBackupService.exportHistoryData()).thenAnswer(
        (_) async => {'version': '1.0', 'data': <dynamic>[]},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DataStoragePage(backupService: mockBackupService),
        ),
      );

      final exportButton = find.text('履歴データをエクスポート');
      expect(exportButton, findsOneWidget);

      await tester.tap(exportButton);
      await tester.pump();

      verify(mockBackupService.exportHistoryData()).called(1);
    });
  });
}
