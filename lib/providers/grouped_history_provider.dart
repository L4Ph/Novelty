import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/utils/history_grouping.dart';

/// 現在時刻を提供するプロバイダー（テスト時にオーバーライド可能）
final currentTimeProvider = Provider<DateTime>((ref) => DateTime.now());

/// 日付でグルーピングされた履歴データをリアルタイムで提供するプロバイダー
///
/// keepAlive: アプリ起動中ずっとStreamを保持し、画面遷移時の再ロードを防ぐ
final groupedHistoryProvider = StreamProvider<List<HistoryGroup>>((ref) {
  // 現在の日時を取得
  final now = ref.watch(currentTimeProvider);

  // データベースのwatchHistory()を直接使用し、グルーピング処理を適用
  final db = ref.watch(appDatabaseProvider);
  ref.keepAlive();
  return db.watchHistory().map((historyItems) {
    return HistoryGrouping.groupByDate(historyItems, now);
  });
});
