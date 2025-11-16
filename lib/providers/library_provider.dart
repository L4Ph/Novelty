import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';

/// 小説のライブラリを表示するためのプロバイダー。
///
/// JOINクエリを使用してN+1クエリ問題を回避している。
final libraryNovelsProvider = FutureProvider<List<Novel>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.getLibraryNovelsWithDetails();
});
