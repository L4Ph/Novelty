import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/database/database_maintenance.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/services/backup_service.dart';
import 'package:novelty/services/file_picker.dart';
import 'package:novelty/utils/clipboard_helper.dart';

/// データとストレージページ
/// データベース全体のバックアップ・復元機能を提供
class DataStoragePage extends StatefulWidget {
  /// コンストラクタ
  const DataStoragePage({super.key, this.backupService, this.canUseFilePicker});

  /// バックアップサービス
  final BackupService? backupService;

  /// ファイル選択が使えるかどうか。省略時はプラットフォームから判定する。
  final bool? canUseFilePicker;

  @override
  State<DataStoragePage> createState() => _DataStoragePageState();
}

class _DataStoragePageState extends State<DataStoragePage> {
  /// バックアップサービス。
  /// インポートでDBインスタンスが差し替わるため、
  /// 使用のたびに現在の接続から生成する。
  BackupService get _backupService =>
      widget.backupService ?? BackupService(context.services.db);

  DatabaseMaintenanceController get _maintenance =>
      context.services.maintenance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: appRouter.pop),
        title: const Text('データとストレージ'),
      ),
      body: ListView(
        children: [
          _buildDatabaseBackupSection(),
          const Divider(),
          _buildStorageSection(),
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
        if (widget.canUseFilePicker ?? FilePicker.platformSupports) ...[
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('データベースをエクスポート'),
            subtitle: const Text('すべてのデータをバックアップファイルに保存'),
            onTap: _exportDatabase,
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('データベースをインポート'),
            subtitle: const Text('バックアップファイルからすべてのデータを復元'),
            onTap: _importDatabase,
          ),
        ] else
          _buildManualBackupHint(),
      ],
    );
  }

  /// ファイル選択が使えないプラットフォーム向けの案内。
  ///
  /// デスクトップではデータベースが普通のファイルなので、
  /// アプリを介さずコピーしてもらうほうが早い。
  Widget _buildManualBackupHint() {
    return FutureBuilder<String>(
      future: databaseFilePath(),
      builder: (context, snapshot) {
        final path = snapshot.data;
        return ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('このプラットフォームではアプリ内バックアップに対応していません'),
          subtitle: Text(
            path == null
                ? 'データベースはアプリの Documents にあります'
                : 'データベースは次のファイルです。コピーして保存してください:\n$path',
          ),
          isThreeLine: path != null,
          trailing: path == null
              ? null
              : IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'パスをコピー',
                  onPressed: () async {
                    await copyTextToClipboard(path);
                    if (!context.mounted) return;
                    _showSnackBar('パスをコピーしました');
                  },
                ),
        );
      },
    );
  }

  /// データベース全体をエクスポート
  Future<void> _exportDatabase() async {
    String? filePath;
    Object? error;
    try {
      filePath = await _maintenance.run(
        label: 'データベースをエクスポートしています…',
        task: _backupService.exportDatabaseToFile,
      );
    } on Object catch (e) {
      error = e;
    }

    if (!mounted) return;

    if (error != null) {
      unawaited(_showErrorDialog('エクスポートに失敗しました', error.toString()));
      return;
    }
    if (filePath == null) {
      _showSnackBar('エクスポートをキャンセルしました');
      return;
    }

    // VACUUM INTO は接続を維持したまま整合性のあるコピーを取得
    // できるため、エクスポート後のデータベース再初期化は不要。
    await _showSuccessDialog(
      'データベースのエクスポートが完了しました',
      'バックアップファイルを保存しました:\n$filePath',
    );
  }

  /// ストレージ設定セクションを構築
  Widget _buildStorageSection() {
    final settingsAsync = context.services.settings.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'ストレージ設定',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        settingsAsync.when(
          data: (settings) => const SizedBox.shrink(),
          loading: () => const ListTile(
            title: Text('読み込み中...'),
            leading: CircularProgressIndicator(),
          ),
          error: (err, stack) => ListTile(title: Text('エラー: $err')),
        ),
        ListTile(
          leading: const Icon(Icons.delete_sweep),
          title: const Text('キャッシュを削除'),
          subtitle: const Text('一時ファイルとキャッシュを削除します'),
          enabled: false, // TODO(L4Ph): Implement cache clearing logic
          onTap: _clearCache,
        ),
      ],
    );
  }

  /// キャッシュを削除
  Future<void> _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('キャッシュの削除'),
        content: const Text('一時ファイルを削除しますか？\nダウンロードした小説は削除されません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // TODO(L4Ph): Implement actual cache clearing logic here
      // For now, we simulate a delay
      await Future<void>.delayed(const Duration(seconds: 1));

      if (mounted) {
        unawaited(_showSuccessDialog('完了', 'キャッシュを削除しました'));
      }
    } on Exception catch (e) {
      if (mounted) {
        unawaited(_showErrorDialog('エラー', 'キャッシュの削除に失敗しました: $e'));
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

    // ステージング(バックアップファイルの読み込み)。
    // この段階ではDB接続もDBファイルも変更されない。
    ImportStagedResult? staged;
    Object? error;
    try {
      staged = await _maintenance.run(
        label: 'バックアップファイルを読み込んでいます…',
        task: _backupService.stageImport,
      );
    } on Object catch (e) {
      error = e;
    }

    if (!mounted) return;

    if (error != null) {
      unawaited(_showErrorDialog('インポートに失敗しました', error.toString()));
      return;
    }
    if (staged == null || staged.cancelled) {
      _showSnackBar('インポートをキャンセルしました');
      return;
    }

    // 読み込みが完了したので、データベースを切り替える。
    // 切り替え中は画面全体がアンマウントされて再初期化されるため、
    // 結果は再初期化後にスナックバーで通知される
    // (DatabaseMaintenanceController 経由)。
    _maintenance.startImportSwap(
      payload: ImportSwapPayload(pendingFilePath: staged.pendingFilePath!),
    );
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
  Future<void> _showSuccessDialog(String title, String message) {
    return showDialog<void>(
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

  /// スナックバーを表示
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// エラーダイアログを表示
  Future<void> _showErrorDialog(String title, String message) {
    return showDialog<void>(
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
