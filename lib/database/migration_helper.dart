import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// マイグレーションに失敗した際に発生する例外。
/// サポート用の情報（対象バージョン、失敗ステップ、元エラー）を保持する。
class MigrationException implements Exception {
  /// コンストラクタ
  MigrationException({
    required this.fromVersion,
    required this.toVersion,
    required this.step,
    required this.cause,
    this.stackTrace,
  });

  /// 移行前のスキーマバージョン
  final int? fromVersion;

  /// 移行後のスキーマバージョン
  final int toVersion;

  /// 失敗したマイグレーションステップの識別子
  final String step;

  /// 元のエラー
  final Object cause;

  /// スタックトレース
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'MigrationException(from=$fromVersion, to=$toVersion, step=$step, '
        'cause=$cause)';
  }
}

/// マイグレーション失敗時のレポート情報を保持するモデル。
class MigrationErrorReport {
  /// コンストラクタ
  const MigrationErrorReport({
    required this.formatVersion,
    required this.timestamp,
    required this.schemaVersionBefore,
    required this.schemaVersionAfter,
    required this.failedStep,
    required this.errorMessage,
    this.stackTrace,
    this.appVersion,
    this.dbFilePath,
  });

  /// レポート形式のバージョン
  final int formatVersion;

  /// 発生時刻（ISO 8601）
  final String timestamp;

  /// 移行前のスキーマバージョン
  final int? schemaVersionBefore;

  /// 移行後のスキーマバージョン
  final int schemaVersionAfter;

  /// 失敗したステップ
  final String failedStep;

  /// エラーメッセージ
  final String errorMessage;

  /// スタックトレース（存在する場合）
  final String? stackTrace;

  /// アプリバージョン（存在する場合）
  final String? appVersion;

  /// DBファイルパス（存在する場合）
  final String? dbFilePath;

  /// JSON 形式のマップに変換する
  Map<String, dynamic> toJson() => {
        'formatVersion': formatVersion,
        'timestamp': timestamp,
        'schemaVersionBefore': schemaVersionBefore,
        'schemaVersionAfter': schemaVersionAfter,
        'failedStep': failedStep,
        'errorMessage': errorMessage,
        if (stackTrace != null) 'stackTrace': stackTrace,
        if (appVersion != null) 'appVersion': appVersion,
        if (dbFilePath != null) 'dbFilePath': dbFilePath,
      };
}

/// [Migrator] に冪等・原子なマイグレーションを支援するための拡張メソッド。
extension MigratorHelpers on Migrator {
  /// 指定したアクションをトランザクション内で実行する。
  /// マイグレーション内の全操作を原子化するために使用する。
  Future<void> runInTransaction(Future<void> Function() action) async {
    await database.transaction(action);
  }

  /// テーブルが存在しない場合のみ作成する。
  /// Drift の [createTable] は内部で `CREATE TABLE IF NOT EXISTS` を発行するため、
  /// そのまま委譲する。
  Future<void> createTableIfNotExists<T extends Table, D extends DataClass>(
    TableInfo<T, D> table,
  ) async {
    await createTable(table);
  }

  /// 指定したカラムが存在しない場合のみ追加する。
  Future<void> addColumnIfNotExists<T extends Table, D extends DataClass>(
    TableInfo<T, D> table,
    GeneratedColumn<Object> column,
  ) async {
    final tableName = table.actualTableName;
    final columnName = column.name;
    final existingColumns = await database.customSelect(
      'PRAGMA table_info($tableName)',
    ).get();
    final exists = existingColumns.any(
      (row) => row.read<String>('name') == columnName,
    );
    if (!exists) {
      await addColumn(table, column);
    }
  }

  /// 指定したテーブルが存在するかどうかを確認する。
  Future<bool> tableExists(String tableName) async {
    final result = await database.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      variables: [Variable.withString(tableName)],
    ).get();
    return result.isNotEmpty;
  }
}

/// マイグレーション失敗時のレポートを保存する。
/// アプリドキュメントディレクトリに JSON ファイルとして書き出す。
Future<void> saveMigrationErrorReport(MigrationErrorReport report) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
  final file = File(
    p.join(
      docsDir.path,
      'novelty_migration_error_report_$timestamp.json',
    ),
  );
  await file.writeAsString(jsonEncode(report.toJson()));
}

/// 既存のマイグレーションエラーレポートファイルをすべて削除する。
/// マイグレーション成功後に呼び出すことを想定している。
Future<void> clearMigrationErrorReports() async {
  final docsDir = await getApplicationDocumentsDirectory();
  final files = docsDir
      .listSync()
      .whereType<File>()
      .where(
        (file) =>
            p.basename(file.path).startsWith('novelty_migration_error_report_')
            &&
            p.basename(file.path).endsWith('.json'),
      );
  for (final file in files) {
    await file.delete();
  }
}
