import 'package:novelty/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_search_provider.g.dart';

/// ライブラリ検索プロバイダー
@riverpod
class LibrarySearch extends _$LibrarySearch {
  @override
  Future<List<Novel>> build() async {
    // 初期状態では空の検索結果を返す
    return [];
  }

  /// 検索を実行
  Future<void> searchNovels(String query) async {
    final db = ref.read(appDatabaseProvider);
    state = const AsyncValue.loading();
    
    try {
      final results = await db.searchLibraryNovels(query);
      state = AsyncValue.data(results);
    } on Exception catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 検索結果をクリア
  void clearSearch() {
    state = const AsyncValue.data([]);
  }
}
