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
  });

  /// 移行前のスキーマバージョン
  final int? fromVersion;

  /// 移行後のスキーマバージョン
  final int toVersion;

  /// 失敗したマイグレーションステップの識別子
  final String step;

  /// 元のエラー
  final Object cause;

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
    this.dbFilePath,
  });

  /// 例外からレポートを生成する。
  factory MigrationErrorReport.fromException(
    MigrationException exception, {
    String? dbFilePath,
  }) {
    return MigrationErrorReport(
      formatVersion: 1,
      timestamp: DateTime.now().toIso8601String(),
      schemaVersionBefore: exception.fromVersion,
      schemaVersionAfter: exception.toVersion,
      failedStep: exception.step,
      errorMessage: exception.cause.toString(),
      dbFilePath: dbFilePath,
    );
  }

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
        if (dbFilePath != null) 'dbFilePath': dbFilePath,
      };
}

/// マイグレーションエラーレポートファイル名の接頭辞。
const String _migrationReportFilePrefix = 'novelty_migration_error_report_';

/// [Migrator] に冪等・原子なマイグレーションを支援するための拡張メソッド。
extension MigratorHelpers on Migrator {
  /// 指定したアクションをトランザクション内で実行する。
  /// マイグレーション内の全操作を原子化するために使用する。
  Future<void> runInTransaction(Future<void> Function() action) async {
    await database.transaction(action);
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
      '$_migrationReportFilePrefix$timestamp.json',
    ),
  );
  await file.writeAsString(jsonEncode(report.toJson()));
}

/// 保存されているマイグレーションエラーレポートファイルを一覧返す。
/// 更新日時が新しい順にソートされる。
Future<List<File>> listMigrationErrorReports() async {
  final docsDir = await getApplicationDocumentsDirectory();
  return docsDir
      .listSync()
      .whereType<File>()
      .where(
        (file) =>
            p.basename(file.path).startsWith(_migrationReportFilePrefix) &&
            p.basename(file.path).endsWith('.json'),
      )
      .toList()
    ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
}

/// 既存のマイグレーションエラーレポートファイルをすべて削除する。
/// マイグレーション成功後に呼び出すことを想定している。
Future<void> clearMigrationErrorReports() async {
  final files = await listMigrationErrorReports();
  for (final file in files) {
    await file.delete();
  }
}
