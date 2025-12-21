import 'package:novelty/database/database.dart';
import 'package:novelty/utils/history_grouping.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_providers.g.dart';

@Riverpod(keepAlive: true)
/// アプリケーションデータベースのインスタンスを提供するプロバイダー。
AppDatabase appDatabase(Ref ref) => AppDatabase();

@riverpod
/// ライブラリに登録されている小説のリストを監視するプロバイダー。
Stream<List<dynamic>> libraryNovels(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchLibraryNovels();
}

@riverpod
/// 閲覧履歴のリストを監視するプロバイダー。
Stream<List<HistoryData>> history(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchHistory();
}

@riverpod
/// 現在時刻を提供するプロバイダー。主に履歴のグループ化に使用される。
DateTime currentTime(Ref ref) => DateTime.now();

@riverpod
/// 日付ごとにグループ化された閲覧履歴のリストを監視するプロバイダー。
Stream<List<HistoryGroup>> groupedHistory(Ref ref) {
  final now = ref.watch(currentTimeProvider);
  final db = ref.watch(appDatabaseProvider);
  return db.watchHistory().map((historyItems) {
    return HistoryGrouping.groupByDate(historyItems, now);
  });
}
