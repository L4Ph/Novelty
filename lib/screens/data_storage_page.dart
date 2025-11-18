import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/services/backup_service.dart';

/// データとストレージページ
/// データベース全体のバックアップ・復元機能を提供
class DataStoragePage extends ConsumerStatefulWidget {
  /// コンストラクタ
  const DataStoragePage({super.key, this.backupService});

  /// バックアップサービス
  final BackupService? backupService;

  @override
  ConsumerState<DataStoragePage> createState() => _DataStoragePageState();
}

class _DataStoragePageState extends ConsumerState<DataStoragePage> {
  late BackupService _backupService;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _backupService =
        widget.backupService ?? BackupService(ref.read(appDatabaseProvider));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('データとストレージ'),
      ),
      body: ListView(
        children: [
          _buildDatabaseBackupSection(),
        ],
      ),
    );
  }

  /// データベースバックアップセクションを構築
  Widget _buildDatabaseBackupSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'データベースのバックアップ',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'すべてのデータ(ライブラリ、履歴、ダウンロード済み小説)をバックアップ・復元します',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.save_alt),
          title: const Text('データベースをエクスポート'),
          subtitle: const Text('すべてのデータをバックアップファイルに保存'),
          enabled: !_isProcessing,
          onTap: _exportDatabase,
        ),
        ListTile(
          leading: const Icon(Icons.upload_file),
          title: const Text('データベースをインポート'),
          subtitle: const Text('バックアップファイルからすべてのデータを復元'),
          enabled: !_isProcessing,
          onTap: _importDatabase,
        ),
      ],
    );
  }

  /// データベース全体をエクスポート
  Future<void> _exportDatabase() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final filePath = await _backupService.exportDatabaseToFile();
      if (filePath != null && mounted) {
        // データベースプロバイダーを再初期化
        ref.invalidate(appDatabaseProvider);

        _showSuccessDialog(
          'データベースのエクスポートが完了しました',
          'バックアップファイルを保存しました:\n$filePath',
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        _showErrorDialog('エクスポートに失敗しました', e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  /// データベース全体をインポート
  Future<void> _importDatabase() async {
    // 確認ダイアログを表示
    final confirmed = await _showImportConfirmDialog();
    if (confirmed != true) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final result = await _backupService.importDatabaseFromFile();
      if (result.success && mounted) {
        // データベースプロバイダーを再初期化
        ref.invalidate(appDatabaseProvider);

        // マイグレーション情報を含めて再起動ダイアログを表示
        _showRestartRequiredDialog(
          requiresMigration: result.requiresMigration,
          backupVersion: result.backupVersion,
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        _showErrorDialog('インポートに失敗しました', e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  /// インポート確認ダイアログを表示
  Future<bool?> _showImportConfirmDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('データベースを復元しますか?'),
        content: const Text(
          '現在のすべてのデータが置き換えられます。\n'
          'この操作は取り消せません。\n\n'
          '続行しますか?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('復元する'),
          ),
        ],
      ),
    );
  }

  /// 成功ダイアログを表示
  void _showSuccessDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// エラーダイアログを表示
  void _showErrorDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// 再起動が必要なことを通知するダイアログを表示
  void _showRestartRequiredDialog({
    bool requiresMigration = false,
    int? backupVersion,
  }) {
    // メッセージを構築
    String message = 'すべてのデータが復元されました。\n\n';

    if (requiresMigration && backupVersion != null) {
      message +=
          '※ このバックアップは古いバージョン(v$backupVersion)のものです。\n'
          'アプリ起動時に自動的に最新バージョンへ移行されます。\n\n';
    }

    message += '変更を反映するため、アプリを終了して再起動してください。';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('復元が完了しました'),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
