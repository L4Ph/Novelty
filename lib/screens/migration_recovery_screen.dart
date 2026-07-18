import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// マイグレーション失敗時に表示するリカバリー画面。
/// リトライ、DBのエクスポート、エラーレポートの共有を提供する。
class MigrationRecoveryScreen extends StatelessWidget {
  /// コンストラクタ
  const MigrationRecoveryScreen({
    required this.error,
    super.key,
    this.stackTrace,
    this.onRetry,
    this.onExportDatabase,
  });

  /// マイグレーション失敗の原因となった例外
  final Object error;

  /// スタックトレース
  final StackTrace? stackTrace;

  /// リトライボタンが押されたときに呼ばれるコールバック
  final VoidCallback? onRetry;

  /// DBエクスポートボタンが押されたときに呼ばれるコールバック
  final VoidCallback? onExportDatabase;

  @override
  Widget build(BuildContext context) {
    final errorMessage = error.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('データベースの更新に失敗しました'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              '読書データの更新中に問題が発生しました。',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              '同じ問題が続く場合は、以下のボタンから'
              'エラーレポートを送付してください。',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('もう一度試す'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onExportDatabase,
              icon: const Icon(Icons.save_alt),
              label: const Text('データベースをエクスポート'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _shareLatestReport(context),
              icon: const Icon(Icons.share),
              label: const Text('エラーレポートを共有'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareLatestReport(BuildContext context) async {
    try {
      final latestReport = await _findLatestMigrationReport();
      if (latestReport != null) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(latestReport.path)],
            subject: 'Novelty マイグレーションエラーレポート',
          ),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('エラーレポートが見つかりませんでした')),
          );
        }
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('レポートの共有に失敗しました: $e')),
        );
      }
    }
  }

  Future<File?> _findLatestMigrationReport() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final files = docsDir
        .listSync()
        .whereType<File>()
        .where(
          (file) =>
              p.basename(file.path)
                  .startsWith('novelty_migration_error_report_') &&
              p.basename(file.path).endsWith('.json'),
        )
        .toList();
    if (files.isEmpty) {
      return null;
    }
    files.sort(
      (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
    );
    return files.first;
  }
}
