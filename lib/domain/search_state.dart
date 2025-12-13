import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_state.freezed.dart';
part 'search_state.g.dart';

/// 検索状態を表すクラス。
@freezed
abstract class SearchState with _$SearchState {
  /// [SearchState]のコンストラクタ
  const factory SearchState({
    /// 現在の検索クエリ
    @Default(NovelSearchQuery()) NovelSearchQuery query,

    /// 検索結果の小説リスト
    @Default([]) List<NovelInfo> results,

    /// 検索条件に一致する全件数
    @Default(0) int allCount,

    /// ローディング中かどうか
    @Default(false) bool isLoading,

    /// 検索中かどうか（検索結果を表示中）
    @Default(false) bool isSearching,
  }) = _SearchState;
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
