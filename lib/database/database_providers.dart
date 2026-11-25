import 'dart:async';

import 'package:novelty/database/database.dart';
import 'package:novelty/utils/history_grouping.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_providers.g.dart';

@Riverpod(keepAlive: true)
/// アプリケーションデータベースのインスタンスを提供するプロバイダー。
///
/// 再初期化(invalidate)時に旧インスタンスの接続が残り続けると
/// 同じDBファイルへの接続が多重に開かれるため、破棄時にクローズする。
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() {
    unawaited(closeAppDatabaseSafely(db));
  });
  return db;
}

final _closeFutures = <AppDatabase, Future<void>>{};

/// DBのクローズをインスタンスごとに一度だけ実行し、その完了を待つ。
///
/// プロバイダー破棄時のクローズと、インポート適用時の明示的な
/// クローズが競合しないよう、進行中のクローズがあればそれを返す。
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

@riverpod
/// ライブラリに登録されている小説のリストを監視するプロバイダー。
Stream<List<dynamic>> libraryNovels(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchLibraryNovels();
}

@riverpod
/// 現在時刻を提供するプロバイダー。主に履歴のグループ化に使用される。
DateTime currentTime(Ref ref) => DateTime.now();

/// 日付ごとにグループ化された閲覧履歴のリスト。
///
/// `now` を受け取るのは、日付ラベルの境界が呼び出し側（とテスト）の時計で
/// 決まるようにするため。UI は `StreamLoader` でこれを購読する。
Stream<List<HistoryGroup>> watchGroupedHistory(AppDatabase db, DateTime now) {
  return db.watchHistory().map(
    (historyItems) => HistoryGrouping.groupByDate(historyItems, now),
  );
}
