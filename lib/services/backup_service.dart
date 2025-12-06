// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:novelty/database/database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// バックアップ・復元サービス
/// データベース全体のエクスポート・インポート機能を提供
class BackupService {
  /// コンストラクタ
  const BackupService(this._database);

  /// データベースインスタンス
  final AppDatabase _database;

  /// 現在のスキーマバージョン
  static const int currentSchemaVersion = 11;

  /// データベース全体をエクスポートする
  ///
  /// すべてのテーブル(Novels, LibraryNovels, History, CachedEpisodes)を
  /// 含むデータベースファイルをバックアップする
  ///
  /// 戻り値: エクスポートされたファイルのパス。キャンセルされた場合はnull
  Future<String?> exportDatabaseToFile() async {
    // 保存先ディレクトリを選択
    final selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'バックアップ先のディレクトリを選択',
    );

    if (selectedDirectory == null) {
      return null;
    }

    // データベース接続を閉じる
    await _database.close();

    try {
      // データベースファイルのパスを取得
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dbFolder.path, 'novelty.db'));

      // バックアップファイル名を生成(スキーマバージョンを含める)
      final fileName =
          'novelty_backup_${_formatDateTime(DateTime.now())}_v$currentSchemaVersion.db';
      final backupPath = p.join(selectedDirectory, fileName);

      // データベースファイルをコピー
      await dbFile.copy(backupPath);

      return backupPath;
    } finally {
      // データベースを再初期化するため、何もしない
      // 呼び出し側でプロバイダーをinvalidateする必要がある
    }
  }

  /// データベース全体をインポートする
  ///
  /// バックアップファイルからデータベース全体を復元する
  /// 既存のデータベースは上書きされる
  ///
  /// 戻り値: インポート結果
  Future<ImportResult> importDatabaseFromFile() async {
    // バックアップファイルを選択
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db'],
      dialogTitle: 'バックアップファイルを選択',
    );

    if (result == null || result.files.isEmpty) {
      return const ImportResult(success: false);
    }

    // ファイル名からスキーマバージョンを抽出
    final fileName = result.files.single.name;
    final backupVersion = _extractVersionFromFileName(fileName);

    // データベース接続を閉じる
    await _database.close();

    try {
      // データベースファイルのパスを取得
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dbFolder.path, 'novelty.db'));

      // 既存のデータベースをバックアップ(念のため)
      if (await dbFile.exists()) {
        final backupFile = File('${dbFile.path}.bak');
        await dbFile.copy(backupFile.path);
      }

      // 選択したバックアップファイルで置き換え
      final selectedFile = File(result.files.single.path!);
      await selectedFile.copy(dbFile.path);

      return ImportResult(
        success: true,
        backupVersion: backupVersion,
        requiresMigration:
            backupVersion != null && backupVersion < currentSchemaVersion,
      );
    } finally {
      // データベースを再初期化するため、何もしない
      // 呼び出し側でプロバイダーをinvalidateする必要がある
    }
  }

  /// ファイル名からスキーマバージョンを抽出
  ///
  /// ファイル名の形式: novelty_backup_YYYYMMDD_HHMMSS_vN.db
  /// 戻り値: バージョン番号、抽出できない場合はnull
  int? _extractVersionFromFileName(String fileName) {
    final versionPattern = RegExp(r'_v(\d+)\.db$');
    final match = versionPattern.firstMatch(fileName);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  /// 日時をファイル名用にフォーマットする
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}_${dateTime.hour.toString().padLeft(2, '0')}${dateTime.minute.toString().padLeft(2, '0')}${dateTime.second.toString().padLeft(2, '0')}';
  }
}

/// データベースインポートの結果
class ImportResult {
  /// コンストラクタ
  const ImportResult({
    required this.success,
    this.backupVersion,
    this.requiresMigration = false,
  });

  /// インポートが成功したかどうか
  final bool success;

  /// バックアップファイルのスキーマバージョン
  final int? backupVersion;

  /// マイグレーションが必要かどうか
  final bool requiresMigration;
}
