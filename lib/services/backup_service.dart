import 'dart:async';
import 'dart:io';

import 'package:novelty/database/database.dart';
import 'package:novelty/services/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// バックアップ・復元サービス
/// データベース全体のエクスポート・インポート機能を提供
class BackupService {
  /// コンストラクタ
  BackupService(this._database, {FilePicker? picker})
    : _picker = picker ?? FilePicker();

  /// データベースインスタンス
  final AppDatabase _database;

  /// 保存先/復元元を選ぶプラットフォーム実装。
  final FilePicker _picker;

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
  ///
  /// SQLiteの `VACUUM INTO` を使い、DBを閉じずに整合性のある
  /// コピーを取得する(DBクローズはアクティブなストリームを
  /// 待機して完了しないことがあるため、クリティカルパスから外す)。
  Future<String?> exportDatabaseToFile() async {
    final fileName = _backupFileName();

    // VACUUM INTO cannot write to a content URI, so the copy is produced in
    // the app's own cache and then streamed out by the platform picker.
    final cacheDirectory = await getTemporaryDirectory();
    final tempFile = File(p.join(cacheDirectory.path, fileName));
    try {
      final escapedPath = tempFile.path.replaceAll("'", "''");
      await _database.customStatement("VACUUM INTO '$escapedPath'");
      return await _picker.saveFile(
        sourcePath: tempFile.path,
        suggestedName: fileName,
        dialogTitle: 'バックアップの保存先を選択',
      );
    } finally {
      await _deleteQuietly(tempFile);
    }
  }

  /// データベースファイルを直接コピーしてエクスポートする
  ///
  /// マイグレーション失敗時など、DBが開けない状態でもファイルとして
  /// コピーできることが利点。リカバリ画面からのエクスポートに使用する。
  /// (DBを開けている通常経路では [exportDatabaseToFile] を使うこと)
  ///
  /// 戻り値: エクスポートされたファイルのパス。キャンセルされた場合はnull
  Future<String?> exportDatabaseFileDirectly() async {
    // 開いているDBをクローズしてからコピーする(WALの内容を
    // 本体に反映させるため)。マイグレーション失敗直後など接続が
    // 不安定な状態でもコピーは試行する(ベストエフォート)。
    try {
      await _database.close();
    } on Object {
      // クローズに失敗してもコピーは継続する
    }

    final dbFile = await databaseFile();
    final fileName = _backupFileName();
    final cacheDirectory = await getTemporaryDirectory();
    final tempFile = File(p.join(cacheDirectory.path, fileName));

    try {
      await dbFile.copy(tempFile.path);
      return await _picker.saveFile(
        sourcePath: tempFile.path,
        suggestedName: fileName,
        dialogTitle: 'バックアップの保存先を選択',
      );
    } finally {
      await _deleteQuietly(tempFile);
    }
  }

  /// インポートのステージング(バックアップファイルの読み込み)
  ///
  /// 選択したバックアップファイルをアプリ内の一時ファイル
  /// (`novelty.db.import_pending`)にコピーする。
  /// この段階ではDB接続も既存のDBファイルも変更しない。
  ///
  /// 戻り値: ステージング結果(キャンセル時は
  /// [ImportStagedResult.cancelled] がtrue)
  ///
  /// 成功後は [applyImportSwap] でファイルを置き換えること。
  Future<ImportStagedResult> stageImport() async {
    // The platform copies the picked document into the cache directory we hand
    // it, so the caller owns a real path and deletes it afterwards.
    final cacheDirectory = await getTemporaryDirectory();
    final pickedPath = await _picker.pickFile(
      cacheDirectory: cacheDirectory.path,
      extensions: const <String>['db'],
      dialogTitle: 'バックアップファイルを選択',
    );

    if (pickedPath == null) {
      return const ImportStagedResult(cancelled: true);
    }

    final picked = File(pickedPath);
    try {
      // The swap is the one operation that can destroy a library, so never
      // accept a file that is not a readable Novelty database.
      _validateBackup(picked);

      final dbFolder = await getApplicationDocumentsDirectory();
      final pendingFile = File(
        p.join(dbFolder.path, 'novelty.db.import_pending'),
      );
      if (pendingFile.existsSync()) {
        await pendingFile.delete();
      }

      try {
        await picked.copy(pendingFile.path);
      } on Object {
        // 書き込み途中のファイルを残さない
        if (pendingFile.existsSync()) {
          await pendingFile.delete();
        }
        rethrow;
      }

      return ImportStagedResult(pendingFilePath: pendingFile.path);
    } finally {
      await _deleteQuietly(picked);
    }
  }

  /// Throws [FormatException] when [file] cannot be a Novelty backup.
  ///
  /// Checks the SQLite header, the schema version, the required tables and the
  /// page structure. A newer schema is rejected because opening it would run no
  /// migration and silently misread columns.
  void _validateBackup(File file) {
    if (!file.existsSync() || file.lengthSync() < 100) {
      throw const FormatException('ファイルが空か壊れています');
    }

    final handle = file.openSync()..setPositionSync(0);
    final magic = handle.readSync(16);
    handle.closeSync();
    if (magic.length < 16 || String.fromCharCodes(magic) != _sqliteMagic) {
      throw const FormatException('SQLiteのデータベースではありません');
    }

    Database? db;
    try {
      db = sqlite3.open(file.path, mode: OpenMode.readOnly);
      final version = db.userVersion;
      if (version > currentSchemaVersion) {
        throw FormatException(
          'このバックアップは新しいバージョンのアプリで作成されています'
          '（v$version、現在は v$currentSchemaVersion）',
        );
      }

      final tables = db
          .select("SELECT name FROM sqlite_master WHERE type = 'table'")
          .map((row) => row['name'] as String)
          .toSet();
      if (!tables.containsAll(_requiredTables)) {
        throw const FormatException('このアプリのバックアップではありません');
      }

      if (db.select('PRAGMA quick_check').first.values.first != 'ok') {
        throw const FormatException('データベースが壊れています');
      }
    } on SqliteException catch (e) {
      throw FormatException('データベースを開けません: ${e.message}');
    } finally {
      db?.close();
    }
  }

  /// A table every schema this app can migrate from has.
  ///
  /// Only `novels` qualifies: `episode_list_entries` and `episode_contents`
  /// were split out of `episodes` in v16, and v12 and earlier used
  /// `library_novels` / `history`. Requiring the newer names would reject
  /// backups that `onUpgrade` can still migrate, so the schema version and the
  /// migration itself stay responsible for the rest.
  static const _requiredTables = <String>{'novels'};

  /// SQLite のファイル先頭16バイト。
  static const _sqliteMagic = 'SQLite format 3\u0000';

  /// ステージング済みのファイルでデータベースを置き換える
  ///
  /// 既存のDBファイルを `.bak` に退避したうえで、DB接続をクローズし、
  /// ステージング済みファイルにリネームで置き換える。
  /// 失敗時は `.bak` から元のDBファイルを復元して例外をスローする。
  /// いずれの場合も、呼び出し側でプロバイダーを再初期化して
  /// データベースを開き直すこと。
  ///
  /// 注意: 呼び出し前に `appDatabaseProvider` をinvalidateして
  /// DB依存プロバイダを全て破棄(ストリーム購読をキャンセル)しておくこと。
  /// 購読がpause状態で残っているとDriftのclose()は完了しない
  /// (実測で確認済み)。
  Future<void> applyImportSwap(String pendingFilePath) async {
    final dbFile = await databaseFile();
    final backupFile = File('${dbFile.path}.bak');
    final pendingFile = File(pendingFilePath);

    if (!pendingFile.existsSync()) {
      throw StateError('ステージング済みファイルが見つかりません: ${pendingFile.path}');
    }

    // 既存のデータベースをバックアップ(復元用)
    if (dbFile.existsSync()) {
      await dbFile.copy(backupFile.path);
    }

    var renamed = false;
    try {
      // ファイルを置き換える前にDB接続をクローズする。
      // Windowsでは開いているファイルをリネームできないため必須。
      // プロバイダー破棄時のクローズと競合しないよう単一実行化し、
      // 万が一完了しない場合に備えてタイムアウトを設ける。
      await closeAppDatabaseSafely(_database).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('データベースのクローズがタイムアウトしました'),
      );

      // 置き換え前にジャーナル/WAL等のサイドカーファイルを削除する。
      // 残存していると新しいDBファイルに旧データが復旧適用されてしまう。
      for (final suffix in ['-journal', '-wal', '-shm']) {
        final sidecar = File('${dbFile.path}$suffix');
        if (sidecar.existsSync()) {
          await sidecar.delete();
        }
      }

      // リネームで原子的に置き換える
      await pendingFile.rename(dbFile.path);
      renamed = true;
    } on Object {
      // 失敗時は元のデータベースファイルを復元し、
      // ステージング済みファイルを破棄する
      if (!renamed && backupFile.existsSync()) {
        await backupFile.copy(dbFile.path);
      }
      if (pendingFile.existsSync()) {
        await pendingFile.delete();
      }
      rethrow;
    }
  }

  /// バックアップのファイル名。
  String _backupFileName() =>
      'novelty_backup_${_formatDateTime(DateTime.now())}'
      '_v$currentSchemaVersion.db';

  /// Deletes [file] without failing the operation when it is already gone.
  Future<void> _deleteQuietly(File file) async {
    try {
      if (file.existsSync()) {
        await file.delete();
      }
    } on Object {
      // A leftover cache file is harmless; the OS reclaims it.
    }
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

/// インポートのステージング結果
class ImportStagedResult {
  /// コンストラクタ
  const ImportStagedResult({
    this.cancelled = false,
    this.pendingFilePath,
  });

  /// ファイル選択がキャンセルされたかどうか
  final bool cancelled;

  /// ステージング済みファイルのパス(キャンセル時はnull)
  final String? pendingFilePath;
}
