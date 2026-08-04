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

/// 保守操作の実行中。
///
/// [operationLabel] には「データベースをインポートしています…」のような
/// ユーザー向けの操作説明を設定する。
class DatabaseMaintenanceBusy extends DatabaseMaintenanceState {
  /// コンストラクタ
  const DatabaseMaintenanceBusy(this.operationLabel);

  /// ユーザー向けの操作説明
  final String operationLabel;
}

/// データベース保守操作の実行状態を管理するプロバイダー。
///
/// インポート/エクスポートなど、DBファイルを直接操作する間は
/// 必ず [DatabaseMaintenanceBusy] にして他の操作をブロックすること。
final StateProvider<DatabaseMaintenanceState> databaseMaintenanceProvider =
    StateProvider<DatabaseMaintenanceState>(
      (ref) => const DatabaseMaintenanceIdle(),
    );

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
