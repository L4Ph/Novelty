import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';

/// 履歴データをリアルタイムで提供するプロバイダー
/// 
/// データベースの履歴テーブルを監視し、変更があるたびに最新のデータを配信する。
/// Pull Refreshを使用せずに、常にリアルタイムで更新される。
final historyProvider = StreamProvider<List<HistoryData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchHistory();
});
