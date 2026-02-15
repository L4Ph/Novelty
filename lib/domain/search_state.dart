import 'package:flutter/foundation.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_state.g.dart';

/// 検索状態を表すクラス。
@immutable
class SearchState {
  /// [SearchState]のコンストラクタ
  const SearchState({
    this.query = const NovelSearchQuery(),
    this.results = const [],
    this.allCount = 0,
    this.isLoading = false,
    this.isSearching = false,
  });

  /// 現在の検索クエリ
  final NovelSearchQuery query;

  /// 検索結果の小説リスト
  final List<NovelInfo> results;

  /// 検索条件に一致する全件数
  final int allCount;

  /// ローディング中かどうか
  final bool isLoading;

  /// 検索中かどうか（検索結果を表示中）
  final bool isSearching;

  /// フィールドを変更した新しいインスタンスを作成する
  SearchState copyWith({
    NovelSearchQuery? query,
    List<NovelInfo>? results,
    int? allCount,
    bool? isLoading,
    bool? isSearching,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      allCount: allCount ?? this.allCount,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchState &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          results == other.results &&
          allCount == other.allCount &&
          isLoading == other.isLoading &&
          isSearching == other.isSearching;

  @override
  int get hashCode => Object.hash(
    query,
    results,
    allCount,
    isLoading,
    isSearching,
  );

  @override
  String toString() =>
      'SearchState(query: $query, results: ${results.length} items, '
      'allCount: $allCount, isLoading: $isLoading, '
      'isSearching: $isSearching)';
}

/// [SearchState]の拡張メソッド。
extension SearchStateEx on SearchState {
  /// さらにデータを読み込めるかどうか。
  bool get hasMore => results.length < allCount;
}

/// 検索状態を管理するNotifierプロバイダー。
@riverpod
class SearchStateNotifier extends _$SearchStateNotifier {
  @override
  SearchState build() => const SearchState();

  /// 検索を実行する。
  ///
  /// 新しい検索条件で検索を開始し、結果をリセットする。
  Future<void> search(NovelSearchQuery query) async {
    state = SearchState(query: query, isLoading: true, isSearching: true);

    final apiService = ref.read(apiServiceProvider);
    final result = await apiService.searchNovels(query);

    state = state.copyWith(
      results: result.novels,
      allCount: result.allCount,
      isLoading: false,
    );
  }

  /// 追加データを読み込む。
  ///
  /// 現在の検索条件で次のページを取得し、結果に追加する。
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final nextQuery = state.query.copyWith(
      st: state.results.length + 1,
    );

    final apiService = ref.read(apiServiceProvider);
    final result = await apiService.searchNovels(nextQuery);

    final newResults = [...state.results, ...result.novels];

    state = state.copyWith(
      results: newResults,
      isLoading: false,
    );
  }

  /// 検索状態をリセットする。
  void reset() {
    state = const SearchState();
  }
}
