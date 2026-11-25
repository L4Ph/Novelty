import 'package:flutter/foundation.dart';

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
  const ImportSwapPayload({required this.pendingFilePath});

  /// ステージング済みの新しいDBファイルのパス
  final String pendingFilePath;
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

/// データベース保守操作(インポート/エクスポート)の実行状態を管理する。
///
/// アプリルートが1つ生成して `Scope` 経由で配る。インポート/エクスポートなど
/// DBファイルを直接操作する間は必ず `busy` を [DatabaseMaintenanceBusy] に
/// して他の操作をブロックすること。
class DatabaseMaintenanceController extends ChangeNotifier {
  DatabaseMaintenanceState _state = const DatabaseMaintenanceIdle();

  /// 現在の実行状態。
  DatabaseMaintenanceState get state => _state;

  ImportSwapResult? _importSwapResult;

  /// 未消費のインポート適用結果。表示後に `takeImportSwapResult` で消費する。
  ImportSwapResult? get importSwapResult => _importSwapResult;

  /// インポート適用結果を取り出して消費する。
  ImportSwapResult? takeImportSwapResult() {
    final result = _importSwapResult;
    _importSwapResult = null;
    return result;
  }

  void _setState(DatabaseMaintenanceState next) {
    _state = next;
    notifyListeners();
  }

  /// 保守操作をブロッキング状態で実行する。
  ///
  /// 実行中は [DatabaseMaintenanceBusy] にしてアプリ全体の操作をブロックし、
  /// 完了・失敗に関わらず終了時に [DatabaseMaintenanceIdle] へ戻す。
  ///
  /// [label] には「データベースをインポートしています…」のような
  /// ユーザー向けの操作説明を指定する。
  Future<T> run<T>({
    required String label,
    required Future<T> Function() task,
  }) async {
    _setState(DatabaseMaintenanceBusy(label));
    try {
      return await task();
    } finally {
      _setState(const DatabaseMaintenanceIdle());
    }
  }

  /// インポート適用(DBファイルの置き換え)フェーズを開始する。
  ///
  /// 呼び出すとアプリルートが配下の画面をアンマウントし、DBへの
  /// ストリーム購読が全てキャンセルされたうえでファイル置き換えが
  /// 実行される。呼び出し元の画面もアンマウントされるため、
  /// この呼び出し以降に画面側でフィードバックを表示してはいけない。
  /// 結果は `importSwapResult` にセットされる。
  void startImportSwap({required ImportSwapPayload payload}) {
    _setState(
      DatabaseMaintenanceBusy(
        'データベースを切り替えています…',
        importSwap: payload,
      ),
    );
  }

  /// インポート適用フェーズを終了し、結果をセットする。
  void finishImportSwap({required ImportSwapResult result}) {
    _importSwapResult = result;
    _setState(const DatabaseMaintenanceIdle());
  }
}
