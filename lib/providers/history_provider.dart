import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';

/// 履歴データをリアルタイムで提供するプロバイダー
///
/// keepAlive: アプリ起動中ずっとStreamを保持し、画面遷移時の再ロードを防ぐ
final historyProvider = StreamProvider<List<HistoryData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  ref.keepAlive();
  return db.watchHistory();
});
