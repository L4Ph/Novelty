import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';

/// 小説のライブラリを表示するためのプロバイダー。
///
/// JOINクエリを使用してN+1クエリ問題を回避している。
/// keepAlive: アプリ起動中ずっとStreamを保持し、画面遷移時の再ロードを防ぐ
final libraryNovelsProvider = StreamProvider<List<Novel>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  ref.keepAlive();
  return db.watchLibraryNovelsWithDetails();
});
