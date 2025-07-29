import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/utils/history_grouping.dart';

/// 現在時刻を提供するプロバイダー（テスト時にオーバーライド可能）
final currentTimeProvider = Provider<DateTime>((ref) => DateTime.now());

/// 日付でグルーピングされた履歴データを提供するプロバイダー
/// 
/// データベースの履歴テーブルを監視し、変更があるたびに最新のデータを
/// 日付ごとにグルーピングして配信する。
/// Pull Refreshを使用せずに、常にリアルタイムで更新される。
final groupedHistoryProvider = StreamProvider<List<HistoryGroup>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final now = ref.watch(currentTimeProvider);
  
  // 履歴データの変更を監視し、変更があるたびにグルーピングして配信
  return db.watchHistory().map((historyItems) {
    return HistoryGrouping.groupByDate(historyItems, now);
  });
});
