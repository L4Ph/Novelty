import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/screens/migration_progress_splash.dart';
import 'package:novelty/screens/migration_recovery_screen.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../helpers/clipboard.dart';

/// path_providerのモック実装
class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  FakePathProviderPlatform(this.path);

  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return path;
  }
}

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
      expect(find.text('エラーレポートを共有'), findsNothing);
      expect(find.text('エラーレポートのパスをコピー'), findsOneWidget);
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
              return null;
            },
          ),
        ),
      );

      await tester.tap(find.text('データベースをエクスポート'));
      await tester.pump();

      expect(exportCalled, isTrue);
    });

    testWidgets('パスコピーボタンを押すと最新レポートのパスがクリップボードにコピーされる', (
      tester,
    ) async {
      late Directory docsDir;
      late File reportFile;
      await tester.runAsync(() async {
        docsDir = await Directory.systemTemp.createTemp(
          'novelty_migration_test',
        );
        reportFile = File(
          '${docsDir.path}/novelty_migration_error_report_test.json',
        );
        await reportFile.writeAsString('{"formatVersion":1}');
      });
      addTearDown(() {
        docsDir.deleteSync(recursive: true);
      });
      PathProviderPlatform.instance = FakePathProviderPlatform(docsDir.path);

      final clipboardMock = installClipboardMock(tester);
      addTearDown(clipboardMock.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: MigrationRecoveryScreen(
            error: Exception('test error'),
          ),
        ),
      );

      await tester.runAsync(() async {
        await tester.tap(find.text('エラーレポートのパスをコピー'));
        // 実ファイルI/Oが完了するまで少し待つ
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle();

      clipboardMock.expectCopiedText(reportFile.path);
      expect(find.text('エラーレポートのパスをコピーしました'), findsOneWidget);
    });
  });
}
