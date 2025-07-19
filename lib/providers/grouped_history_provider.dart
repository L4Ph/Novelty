import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/utils/history_grouping.dart';

/// 現在時刻を提供するプロバイダー（テスト時にオーバーライド可能）
final currentTimeProvider = Provider<DateTime>((ref) => DateTime.now());

/// 日付でグルーピングされた履歴データを提供するプロバイダー
final groupedHistoryProvider = FutureProvider<List<HistoryGroup>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final historyItems = await db.getHistory();
  
  // 現在の日時を取得
  final now = ref.watch(currentTimeProvider);
  
  // 履歴アイテムを日付でグルーピング
  return HistoryGrouping.groupByDate(historyItems, now);
});
