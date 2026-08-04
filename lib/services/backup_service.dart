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
  /// AppDatabase.currentSchemaVersion と常に同期させることで、
  /// バックアップ名とマイグレーション判定の信頼性を保つ。
  static int get currentSchemaVersion => AppDatabase.currentSchemaVersion;

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
          'novelty_backup_${_formatDateTime(DateTime.now())}'
          '_v$currentSchemaVersion.db';
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
  /// 戻り値: インポート結果(キャンセル時は [ImportResult.cancelled] がtrue)
  ///
  /// 失敗時は例外をスローし、元のデータベースファイルを復元する。
  Future<ImportResult> importDatabaseFromFile() async {
    // バックアップファイルを選択
    // AndroidのSAF経由では PlatformFile.path がnull(content:// URI)に
    // なり得るため、readStream経由で読み込む
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db'],
      dialogTitle: 'バックアップファイルを選択',
      withReadStream: true,
    );

    if (result == null || result.files.isEmpty) {
      return const ImportResult(cancelled: true);
    }

    final pickedFile = result.files.single;

    // ファイル名からスキーマバージョンを抽出
    final backupVersion = _extractVersionFromFileName(pickedFile.name);

    final readStream = pickedFile.readStream;
    if (readStream == null) {
      throw StateError('選択したファイルを読み込めませんでした');
    }

    // データベース接続を閉じる
    await _database.close();

    // データベースファイルのパスを取得
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'novelty.db'));
    final backupFile = File('${dbFile.path}.bak');

    var backupCreated = false;
    try {
      // 既存のデータベースをバックアップ(念のため)
      if (dbFile.existsSync()) {
        await dbFile.copy(backupFile.path);
        backupCreated = true;
      }

      // 選択したバックアップファイルの内容で置き換え
      final sink = dbFile.openWrite();
      try {
        await sink.addStream(readStream);
        await sink.flush();
      } finally {
        await sink.close();
      }

      return ImportResult(
        success: true,
        backupVersion: backupVersion,
        requiresMigration:
            backupVersion != null && backupVersion < currentSchemaVersion,
      );
    } on Object {
      // コピー失敗時は元のデータベースファイルを復元する
      if (backupCreated && backupFile.existsSync()) {
        await backupFile.copy(dbFile.path);
      }
      rethrow;
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
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$year$month${day}_$hour$minute$second';
  }
}

/// データベースインポートの結果
class ImportResult {
  /// コンストラクタ
  const ImportResult({
    this.success = false,
    this.cancelled = false,
    this.backupVersion,
    this.requiresMigration = false,
  });

  /// インポートが成功したかどうか
  final bool success;

  /// ファイル選択がキャンセルされたかどうか
  final bool cancelled;

  /// バックアップファイルのスキーマバージョン
  final int? backupVersion;

  /// マイグレーションが必要かどうか
  final bool requiresMigration;
}
