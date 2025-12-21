import 'package:novelty/database/database.dart';
import 'package:novelty/utils/history_grouping.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_providers.g.dart';

/// 小説リストのエイリアス
typedef NovelList = List<Novel>;

@riverpod
/// ライブラリの小説リストを提供するプロバイダー
Stream<NovelList> libraryNovels(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchLibraryNovels();
}

@riverpod
/// 閲覧履歴を提供するプロバイダー
Stream<List<HistoryData>> history(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchHistory();
}

@riverpod
/// 現在時刻を提供するプロバイダー
DateTime currentTime(Ref ref) => DateTime.now();

@riverpod
/// 日付ごとにグループ化された閲覧履歴を提供するプロバイダー
Stream<List<HistoryGroup>> groupedHistory(Ref ref) {
  final now = ref.watch(currentTimeProvider);
  final db = ref.watch(appDatabaseProvider);
  return db.watchHistory().map((historyItems) {
    return HistoryGrouping.groupByDate(historyItems, now);
  });
}
