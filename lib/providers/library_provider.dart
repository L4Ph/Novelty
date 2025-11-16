import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_provider.g.dart';

@riverpod
/// 小説のライブラリを表示するためのプロバイダー。
///
/// JOINクエリを使用してN+1クエリ問題を回避している。
Future<List<Novel>> libraryNovels(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.getLibraryNovelsWithDetails();
}
