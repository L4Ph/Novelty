import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';

final historyProvider = FutureProvider<List<HistoryData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.getHistory();
});
