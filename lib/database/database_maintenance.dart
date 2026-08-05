import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart' show StateProvider;

/// DBを停止して行う保守操作(インポート/エクスポート)の実行状態。
///
/// 実行中はアプリ全体の操作をブロックするための状態として扱い、
/// アプリルートで監視してブロッキング画面を重ねて表示する。
sealed class DatabaseMaintenanceState {
  /// コンストラクタ
  const DatabaseMaintenanceState();
}

/// 保守操作が実行されていない通常状態。
class DatabaseMaintenanceIdle extends DatabaseMaintenanceState {
  /// コンストラクタ
  const DatabaseMaintenanceIdle();
}

/// インポート適用(DBファイルの置き換え)に必要な情報。
class ImportSwapPayload {
  /// コンストラクタ
  const ImportSwapPayload({required this.pendingFilePath, this.backupVersion});

  /// ステージング済みの新しいDBファイルのパス
  final String pendingFilePath;

  /// バックアップファイルのスキーマバージョン
  final int? backupVersion;
}

/// 保守操作の実行中。
///
/// [operationLabel] には「データベースをインポートしています…」のような
/// ユーザー向けの操作説明を設定する。
class DatabaseMaintenanceBusy extends DatabaseMaintenanceState {
  /// コンストラクタ
  const DatabaseMaintenanceBusy(this.operationLabel, {this.importSwap});

  /// ユーザー向けの操作説明
  final String operationLabel;

  /// インポート適用(DBファイル置き換え)の情報。
  ///
  /// 非nullの場合、アプリルートは配下の画面を全てアンマウントして
  /// ブロッキング画面のみを表示する。これによりDBへのストリーム購読が
  /// 全てキャンセルされ、安全にDBをクローズできる。
  /// (pause状態の購読が残っているとDriftのclose()は完了しない)
  final ImportSwapPayload? importSwap;
}

/// インポート適用(DBファイル置き換え)の結果。
///
/// 再初期化後に一度だけスナックバーで通知して消費する。
class ImportSwapResult {
  /// コンストラクタ
  const ImportSwapResult({required this.success, this.error});

  /// 置き換えに成功したかどうか
  final bool success;

  /// 失敗時のエラー内容
  final String? error;
}

/// データベース保守操作の実行状態を管理するプロバイダー。
///
/// インポート/エクスポートなど、DBファイルを直接操作する間は
/// 必ず [DatabaseMaintenanceBusy] にして他の操作をブロックすること。
final StateProvider<DatabaseMaintenanceState> databaseMaintenanceProvider =
    StateProvider<DatabaseMaintenanceState>(
      (ref) => const DatabaseMaintenanceIdle(),
    );

/// インポート適用の結果を保持するプロバイダー。
///
/// 適用処理がセットし、再初期化後のUIが一度だけ消費する。
final StateProvider<ImportSwapResult?> importSwapResultProvider =
    StateProvider<ImportSwapResult?>((ref) => null);

/// 保守操作をブロッキング状態で実行するガードヘルパー。
///
/// 実行中は [DatabaseMaintenanceBusy] にしてアプリ全体の操作をブロックし、
/// 完了・失敗に関わらず終了時に [DatabaseMaintenanceIdle] へ戻す。
///
/// [label] には「データベースをインポートしています…」のような
/// ユーザー向けの操作説明を指定する。
Future<T> runWithDatabaseMaintenance<T>(
  WidgetRef ref, {
  required String label,
  required Future<T> Function() task,
}) async {
  ref.read(databaseMaintenanceProvider.notifier).state =
      DatabaseMaintenanceBusy(label);
  try {
    return await task();
  } finally {
    ref.read(databaseMaintenanceProvider.notifier).state =
        const DatabaseMaintenanceIdle();
  }
}

/// インポート適用(DBファイルの置き換え)フェーズを開始する。
///
/// 呼び出すとアプリルートが配下の画面をアンマウントし、DBへの
/// ストリーム購読が全てキャンセルされたうえでファイル置き換えが
/// 実行される。呼び出し元の画面もアンマウントされるため、
/// この呼び出し以降に画面側でフィードバックを表示してはいけない。
/// 結果は [importSwapResultProvider] にセットされる。
void startImportSwap(WidgetRef ref, {required ImportSwapPayload payload}) {
  ref
      .read(databaseMaintenanceProvider.notifier)
      .state = DatabaseMaintenanceBusy(
    'データベースを切り替えています…',
    importSwap: payload,
  );
}

/// インポート適用フェーズを終了し、結果をセットする。
void finishImportSwap(WidgetRef ref, {required ImportSwapResult result}) {
  ref.read(importSwapResultProvider.notifier).state = result;
  ref.read(databaseMaintenanceProvider.notifier).state =
      const DatabaseMaintenanceIdle();
}
