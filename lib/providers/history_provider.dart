import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';

/// 履歴データを日付でグルーピングして提供するプロバイダー
final historyProvider = FutureProvider<List<HistoryData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.getHistory();
});
