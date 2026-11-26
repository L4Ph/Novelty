import 'dart:async';

import 'package:novelty/database/database.dart';
import 'package:novelty/utils/history_grouping.dart';

final _closeFutures = <AppDatabase, Future<void>>{};

/// DBのクローズをインスタンスごとに一度だけ実行し、その完了を待つ。
///
/// Returns the in-flight close when there is one, so the shutdown at the app
/// root and the explicit close during an import swap cannot collide.
/// (Driftのclose()には二重呼び出しのガードがないため)
Future<void> closeAppDatabaseSafely(AppDatabase db) {
  final existing = _closeFutures[db];
  if (existing != null) {
    return existing;
  }

  final future = () async {
    try {
      await db.close();
    } on Object {
      // 既にクローズ済みの場合などは無視する
    }
  }();
  _closeFutures[db] = future;
  unawaited(future.whenComplete(() => _closeFutures.remove(db)));
  return future;
}

/// The novels in the library.
Stream<List<dynamic>> watchLibraryNovels(AppDatabase db) =>
    db.watchLibraryNovels();

/// Reading history grouped by day.
///
/// Takes `now` so the day boundaries follow the caller's clock (and a test can
/// pin it). The UI subscribes through `StreamLoader`.
Stream<List<HistoryGroup>> watchGroupedHistory(AppDatabase db, DateTime now) {
  return db.watchHistory().map(
    (historyItems) => HistoryGrouping.groupByDate(historyItems, now),
  );
}
