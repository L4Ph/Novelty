import 'package:flutter/foundation.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/novel_search_result.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_site_registry.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/utils/value_wrapper.dart';

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
    this.error,
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

  /// エラー（ある場合）
  final Object? error;

  /// フィールドを変更した新しいインスタンスを作成する
  SearchState copyWith({
    NovelSearchQuery? query,
    List<NovelInfo>? results,
    int? allCount,
    bool? isLoading,
    bool? isSearching,
    Value<Object?>? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      allCount: allCount ?? this.allCount,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      error: error != null ? error.value : this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchState &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          sameWorks(results, other.results) &&
          allCount == other.allCount &&
          isLoading == other.isLoading &&
          isSearching == other.isSearching &&
          error == other.error;

  @override
  int get hashCode => Object.hash(
    query,
    Object.hashAll(results.map((e) => e.resolvedWorkId)),
    allCount,
    isLoading,
    isSearching,
    error,
  );

  @override
  String toString() =>
      'SearchState(query: $query, results: ${results.length} items, '
      'allCount: $allCount, isLoading: $isLoading, '
      'isSearching: $isSearching, error: $error)';
}

/// [SearchState]の拡張メソッド。
extension SearchStateEx on SearchState {
  /// さらにデータを読み込めるかどうか。
  bool get hasMore => results.length < allCount;
}

/// 検索状態を保持し、変更を購読者へ通知する。
///
/// 画面が1つ生成して保持する。検索の実行とページングもここが担う。
class NovelSearchController extends ChangeNotifier {
  /// Creates the controller.
  NovelSearchController({
    required ApiService api,
    required SettingsController settings,
    Map<NovelSource, NovelSite>? sites,
  }) : _api = api,
       _settings = settings,
       _sites = sites ?? defaultNovelSiteRegistry;

  final ApiService _api;
  final SettingsController _settings;
  final Map<NovelSource, NovelSite> _sites;
  bool _disposed = false;

  SearchState _state = const SearchState();

  /// The current search state.
  SearchState get state => _state;

  void _setState(SearchState next) {
    _state = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// 検索を実行する。
  ///
  /// 新しい検索条件で検索を開始し、結果をリセットする。
  Future<void> search(NovelSearchQuery query) async {
    _setState(SearchState(query: query, isLoading: true, isSearching: true));

    if (_settings.isOfflineMode) {
      _setState(
        _state.copyWith(
          isLoading: false,
          error: const Value<Object?>(OfflineException()),
        ),
      );
      return;
    }

    try {
      final result = await _searchBySource(query);

      // 画面離脱等でプロバイダが破棄された場合は状態を更新しない
      if (_disposed) {
        debugPrint(
          '[Novelty][Search] search: コントローラ破棄のため中断 '
          '(source=${query.source})',
        );
        return;
      }
      _setState(
        _state.copyWith(
          results: result.novels,
          allCount: result.allCount,
          isLoading: false,
          error: const Value<Object?>(null),
        ),
      );
    } on Object catch (e, stackTrace) {
      debugPrint(
        '[Novelty][Search] search: ERROR source=${query.source} '
        'active=${!_disposed} error=$e\n$stackTrace',
      );
      if (_disposed) {
        return;
      }
      _setState(
        _state.copyWith(isLoading: false, error: Value<Object?>(e)),
      );
    }
  }

  /// 追加データを読み込む。
  ///
  /// 現在の検索条件で次のページを取得し、結果に追加する。
  Future<void> loadMore() async {
    if (_state.isLoading || !_state.hasMore) return;

    if (_settings.isOfflineMode) {
      _setState(
        _state.copyWith(
          isLoading: false,
          error: const Value<Object?>(OfflineException()),
        ),
      );
      return;
    }

    _setState(
      _state.copyWith(isLoading: true, error: const Value<Object?>(null)),
    );

    try {
      final nextQuery = _state.query.copyWith(
        st: _state.results.length + 1,
      );

      final result = await _searchBySource(nextQuery);

      // 画面離脱等でプロバイダが破棄された場合は状態を更新しない
      if (_disposed) {
        debugPrint(
          '[Novelty][Search] loadMore: コントローラ破棄のため中断',
        );
        return;
      }
      final newResults = [..._state.results, ...result.novels];

      _setState(
        _state.copyWith(
          results: newResults,
          isLoading: false,
          error: const Value<Object?>(null),
        ),
      );
    } on Object catch (e, stackTrace) {
      debugPrint(
        '[Novelty][Search] loadMore: ERROR active=${!_disposed} '
        'error=$e\n$stackTrace',
      );
      if (_disposed) {
        return;
      }
      _setState(
        _state.copyWith(isLoading: false, error: Value<Object?>(e)),
      );
    }
  }

  /// 検索状態をリセットする。
  void reset() {
    _setState(const SearchState());
  }

  /// sourceに応じて検索を実行する。
  ///
  /// なろうは [ApiService]、カクヨムはサイト実装へ振り分ける。
  Future<NovelSearchResult> _searchBySource(NovelSearchQuery query) async {
    if (query.source == NovelSource.narou) {
      final apiService = _api;
      return apiService.searchNovels(query);
    }
    return _sites[query.source]!.searchNovels(query);
  }
}
