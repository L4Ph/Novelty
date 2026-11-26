import 'package:flutter/foundation.dart';

/// The state of a maintenance operation (import/export) that stops the DB.
///
/// Treated as a global state while it runs: the app root watches it and
/// shows a blocking screen on top.
sealed class DatabaseMaintenanceState {
  /// Creates the state.
  const DatabaseMaintenanceState();
}

/// Nothing is running.
class DatabaseMaintenanceIdle extends DatabaseMaintenanceState {
  /// Creates the state.
  const DatabaseMaintenanceIdle();
}

/// What an import swap (replacing the database file) needs.
class ImportSwapPayload {
  /// Creates the payload.
  const ImportSwapPayload({required this.pendingFilePath});

  /// Path of the staged replacement file.
  final String pendingFilePath;
}

/// A maintenance operation is running.
///
/// [operationLabel] is the user-facing description, e.g. "Importing the
/// database…".
class DatabaseMaintenanceBusy extends DatabaseMaintenanceState {
  /// Creates the state.
  const DatabaseMaintenanceBusy(this.operationLabel, {this.importSwap});

  /// User-facing description of the operation.
  final String operationLabel;

  /// Details of an import swap.
  ///
  /// When non-null, the app root unmounts every screen below and shows only
  /// the blocking screen, which cancels every stream subscription on the DB
  /// so it can be closed safely.
  /// (Drift's close() never completes while a paused subscription is attached.)
  final ImportSwapPayload? importSwap;
}

/// Result of an import swap.
///
/// Shown once in a snackbar after re-initialisation, then consumed.
class ImportSwapResult {
  /// Creates the result.
  const ImportSwapResult({required this.success, this.error});

  /// Whether the swap succeeded.
  final bool success;

  /// The failure, when it did not.
  final String? error;
}

/// Owns the state of database maintenance operations.
///
/// The app root creates one and hands it out through the `Scope`. Whenever the
/// database file is touched directly, set `busy` to [DatabaseMaintenanceBusy]
/// so other operations are blocked.
class DatabaseMaintenanceController extends ChangeNotifier {
  DatabaseMaintenanceState _state = const DatabaseMaintenanceIdle();

  /// The current state.
  DatabaseMaintenanceState get state => _state;

  ImportSwapResult? _importSwapResult;

  /// Unconsumed import result. Consumed by `takeImportSwapResult`.
  ImportSwapResult? get importSwapResult => _importSwapResult;

  /// Takes the import result and consumes it.
  ImportSwapResult? takeImportSwapResult() {
    final result = _importSwapResult;
    _importSwapResult = null;
    return result;
  }

  void _setState(DatabaseMaintenanceState next) {
    _state = next;
    notifyListeners();
  }

  /// Runs an operation while blocking the app.
  ///
  /// Sets [DatabaseMaintenanceBusy] while it runs and returns to
  /// [DatabaseMaintenanceIdle] afterwards, whether it succeeded or not.
  ///
  /// [label] is the user-facing description, e.g. "Importing the database…".
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

  /// Starts the import swap phase.
  ///
  /// The app root unmounts the screens below and, once every stream
  /// subscription is cancelled, replaces the file. The calling screen is
  /// unmounted too, so it must not show feedback after this call.
  /// The calling screen is gone, so it must not show feedback afterwards.
  /// The result lands in `importSwapResult`.
  void startImportSwap({required ImportSwapPayload payload}) {
    _setState(
      DatabaseMaintenanceBusy(
        'データベースを切り替えています…',
        importSwap: payload,
      ),
    );
  }

  /// Ends the import swap phase and stores the result.
  void finishImportSwap({required ImportSwapResult result}) {
    _importSwapResult = result;
    _setState(const DatabaseMaintenanceIdle());
  }
}
