import 'dart:async';

import 'package:novelty/database/database.dart';
import 'package:novelty/utils/history_grouping.dart';

final _closeFutures = <AppDatabase, Future<void>>{};

/// DBのクローズをインスタンスごとに一度だけ実行し、その完了を待つ。
///
/// アプリルートの破棄時と、インポート適用時の明示的なクローズが競合しない
/// よう、進行中のクローズがあればそれを返す。
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

/// ライブラリに登録されている小説のリスト。
Stream<List<dynamic>> watchLibraryNovels(AppDatabase db) =>
    db.watchLibraryNovels();

/// 日付ごとにグループ化された閲覧履歴のリスト。
///
/// `now` を受け取るのは、日付ラベルの境界が呼び出し側（とテスト）の時計で
/// 決まるようにするため。UI は `StreamLoader` でこれを購読する。
Stream<List<HistoryGroup>> watchGroupedHistory(AppDatabase db, DateTime now) {
  return db.watchHistory().map(
    (historyItems) => HistoryGrouping.groupByDate(historyItems, now),
  );
}
