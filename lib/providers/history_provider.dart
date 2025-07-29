import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';

/// 履歴データをリアルタイムで提供するプロバイダー
final historyProvider = StreamProvider<List<HistoryData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchHistory();
});
