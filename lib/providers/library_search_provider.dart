import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:novelty/database/database.dart';

part 'library_search_provider.g.dart';

@riverpod
class LibrarySearchQuery extends _$LibrarySearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }
}

@riverpod
class LibrarySearchResults extends _$LibrarySearchResults {
  @override
  Stream<List<Novel>> build() {
    final db = ref.watch(appDatabaseProvider);
    final query = ref.watch(librarySearchQueryProvider);
    return db.novelDao.searchFavoriteNovels(query);
  }
}
