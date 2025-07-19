import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/services/backup_service.dart';

/// データとストレージページ
/// ライブラリと履歴データのバックアップ・復元機能を提供
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
        padding: const EdgeInsets.all(16),
        children: [
          _buildBackupSection(),
          const SizedBox(height: 24),
          _buildRestoreSection(),
        ],
      ),
    );
  }

  /// バックアップセクションを構築
  Widget _buildBackupSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'バックアップ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'データをJSONファイルとしてエクスポートします',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text('ライブラリデータをエクスポート'),
              subtitle: const Text('購読中の小説データを保存'),
              enabled: !_isProcessing,
              onTap: _exportLibraryData,
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('履歴データをエクスポート'),
              subtitle: const Text('閲覧履歴データを保存'),
              enabled: !_isProcessing,
              onTap: _exportHistoryData,
            ),
          ],
        ),
      ),
    );
  }

  /// 復元セクションを構築
  Widget _buildRestoreSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '復元',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'バックアップファイルからデータを復元します',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('ライブラリデータをインポート'),
              subtitle: const Text('ライブラリバックアップファイルを選択'),
              enabled: !_isProcessing,
              onTap: _importLibraryData,
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('履歴データをインポート'),
              subtitle: const Text('履歴バックアップファイルを選択'),
              enabled: !_isProcessing,
              onTap: _importHistoryData,
            ),
          ],
        ),
      ),
    );
  }

  /// ライブラリデータをエクスポート
  Future<void> _exportLibraryData() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final filePath = await _backupService.exportLibraryToFile();
      if (filePath != null && mounted) {
        _showSuccessDialog('ライブラリデータのエクスポートが完了しました', filePath);
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

  /// 履歴データをエクスポート
  Future<void> _exportHistoryData() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final filePath = await _backupService.exportHistoryToFile();
      if (filePath != null && mounted) {
        _showSuccessDialog('履歴データのエクスポートが完了しました', filePath);
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

  /// ライブラリデータをインポート
  Future<void> _importLibraryData() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final count = await _backupService.importLibraryFromFile();
      if (mounted) {
        _showSuccessDialog(
          'ライブラリデータのインポートが完了しました',
          '$count件の小説を復元しました',
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

  /// 履歴データをインポート
  Future<void> _importHistoryData() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final count = await _backupService.importHistoryFromFile();
      if (mounted) {
        _showSuccessDialog(
          '履歴データのインポートが完了しました',
          '$count件の履歴を復元しました',
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
}
