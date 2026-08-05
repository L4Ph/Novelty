import 'dart:async';
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
  ///
  /// SQLiteの `VACUUM INTO` を使い、DBを閉じずに整合性のある
  /// コピーを取得する(DBクローズはアクティブなストリームを
  /// 待機して完了しないことがあるため、クリティカルパスから外す)。
  Future<String?> exportDatabaseToFile() async {
    // 保存先ディレクトリを選択
    final selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'バックアップ先のディレクトリを選択',
    );

    if (selectedDirectory == null) {
      return null;
    }

    // バックアップファイル名を生成(スキーマバージョンを含める)
    final fileName =
        'novelty_backup_${_formatDateTime(DateTime.now())}'
        '_v$currentSchemaVersion.db';
    final backupPath = p.join(selectedDirectory, fileName);

    // VACUUM INTO で整合性のあるバックアップを作成
    final escapedPath = backupPath.replaceAll("'", "''");
    await _database.customStatement("VACUUM INTO '$escapedPath'");

    return backupPath;
  }

  /// データベースファイルを直接コピーしてエクスポートする
  ///
  /// マイグレーション失敗時など、DBが開けない状態でもファイルとして
  /// コピーできることが利点。リカバリ画面からのエクスポートに使用する。
  /// (DBを開けている通常経路では [exportDatabaseToFile] を使うこと)
  ///
  /// 戻り値: エクスポートされたファイルのパス。キャンセルされた場合はnull
  Future<String?> exportDatabaseFileDirectly() async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'バックアップ先のディレクトリを選択',
    );

    if (selectedDirectory == null) {
      return null;
    }

    // 開いているDBをクローズしてからコピーする(WALの内容を
    // 本体に反映させるため)。マイグレーション失敗直後など接続が
    // 不安定な状態でもコピーは試行する(ベストエフォート)。
    try {
      await _database.close();
    } on Object {
      // クローズに失敗してもコピーは継続する
    }

    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'novelty.db'));

    final fileName =
        'novelty_backup_${_formatDateTime(DateTime.now())}'
        '_v$currentSchemaVersion.db';
    final backupPath = p.join(selectedDirectory, fileName);

    await dbFile.copy(backupPath);

    return backupPath;
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
    // バックアップファイルを選択。
    // 選択されたファイルはFilePickerがアプリのキャッシュにコピーし、
    // 実パスを返してくれる(AndroidのSAF経由でも同様)。
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db'],
      dialogTitle: 'バックアップファイルを選択',
    );

    if (result == null || result.files.isEmpty) {
      return const ImportStagedResult(cancelled: true);
    }

    final pickedFile = result.files.single;

    // ファイル名からスキーマバージョンを抽出
    final backupVersion = _extractVersionFromFileName(pickedFile.name);

    final pickedPath = pickedFile.path;
    if (pickedPath == null) {
      throw StateError('選択したファイルを読み込めませんでした');
    }

    // ステージング先(前回の残骸があれば消してから書き込む)
    final dbFolder = await getApplicationDocumentsDirectory();
    final pendingFile = File(
      p.join(dbFolder.path, 'novelty.db.import_pending'),
    );
    if (pendingFile.existsSync()) {
      await pendingFile.delete();
    }

    try {
      await File(pickedPath).copy(pendingFile.path);
    } on Object {
      // 書き込み途中のファイルを残さない
      if (pendingFile.existsSync()) {
        await pendingFile.delete();
      }
      rethrow;
    }

    // FilePickerのキャッシュは自動削除されず繰り返すと
    // ストレージを圧迫するため、コピー後に消去する
    await _clearFilePickerCache();

    return ImportStagedResult(
      pendingFilePath: pendingFile.path,
      backupVersion: backupVersion,
    );
  }

  /// FilePickerの一時キャッシュを消去する(失敗しても続行する)
  Future<void> _clearFilePickerCache() async {
    try {
      await FilePicker.platform.clearTemporaryFiles();
    } on Object {
      // 消去に失敗しても続行する
    }
  }

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
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'novelty.db'));
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

/// インポートのステージング結果
class ImportStagedResult {
  /// コンストラクタ
  const ImportStagedResult({
    this.cancelled = false,
    this.pendingFilePath,
    this.backupVersion,
  });

  /// ファイル選択がキャンセルされたかどうか
  final bool cancelled;

  /// ステージング済みファイルのパス(キャンセル時はnull)
  final String? pendingFilePath;

  /// バックアップファイルのスキーマバージョン
  final int? backupVersion;
}
