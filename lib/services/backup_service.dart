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

  /// データベース全体をエクスポートする
  ///
  /// すべてのテーブル(Novels, LibraryNovels, History, Episodes, DownloadedEpisodes)を
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

      // バックアップファイル名を生成
      final fileName = 'novelty_backup_${_formatDateTime(DateTime.now())}.db';
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
  /// 戻り値: 復元が成功した場合はtrue
  Future<bool> importDatabaseFromFile() async {
    // バックアップファイルを選択
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db'],
      dialogTitle: 'バックアップファイルを選択',
    );

    if (result == null || result.files.isEmpty) {
      return false;
    }

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

      return true;
    } finally {
      // データベースを再初期化するため、何もしない
      // 呼び出し側でプロバイダーをinvalidateする必要がある
    }
  }

  /// 日時をファイル名用にフォーマットする
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}_${dateTime.hour.toString().padLeft(2, '0')}${dateTime.minute.toString().padLeft(2, '0')}${dateTime.second.toString().padLeft(2, '0')}';
  }
}
