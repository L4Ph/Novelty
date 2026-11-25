import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_site_registry.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/utils/value_wrapper.dart';

/// ランキング取得フローのデバッグログを出力する。
///
/// `flutter run` 時に `[Novelty][Ranking]` のプレフィックスで
/// フィルタできるようにしている。
void _logRanking(String message) {
  debugPrint('[Novelty][Ranking] $message');
}

/// ランキングの状態を管理するクラス
@immutable
class RankingState {
  /// コンストラクタ
  const RankingState({
    this.novels = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.error,
  });

  /// 小説リスト
  final List<NovelInfo> novels;

  /// ローディング中かどうか
  final bool isLoading;

  /// 追加ローディング中かどうか
  final bool isLoadingMore;

  /// さらにデータがあるかどうか
  final bool hasMore;

  /// 現在のページ
  final int page;

  /// エラー（ある場合）
  final Object? error;

  /// フィールドを変更した新しいインスタンスを作成する
  RankingState copyWith({
    List<NovelInfo>? novels,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    Value<Object?>? error,
  }) {
    return RankingState(
      novels: novels ?? this.novels,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error != null ? error.value : this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingState &&
          runtimeType == other.runtimeType &&
          sameWorks(novels, other.novels) &&
          isLoading == other.isLoading &&
          isLoadingMore == other.isLoadingMore &&
          hasMore == other.hasMore &&
          page == other.page &&
          error == other.error;

  @override
  int get hashCode => Object.hash(
    Object.hashAll(novels.map((e) => e.resolvedWorkId)),
    isLoading,
    isLoadingMore,
    hasMore,
    page,
    error,
  );

  @override
  String toString() =>
      'RankingState(novels: ${novels.length} items, isLoading: $isLoading, '
      'isLoadingMore: $isLoadingMore, hasMore: $hasMore, page: $page, '
      'error: $error)';
}

/// ランキングのロジックを保持し、変更を購読者へ通知する。
///
/// ランキング画面が `(source, rankingType)` ごとに1つ生成して保持する。
/// フィルタが変わると先頭から取り直す。
class RankingController extends ChangeNotifier {
  /// コンストラクタ。
  RankingController({
    required NovelSource source,
    required String rankingType,
    required RankingFilterController filter,
    required ApiService api,
    required SettingsController settings,
    Map<NovelSource, NovelSite>? sites,
  }) : _source = source,
       _rankingType = rankingType,
       _filter = filter,
       _api = api,
       _settings = settings,
       _sites = sites ?? defaultNovelSiteRegistry {
    _filter.addListener(_onFilterChanged);
  }

  final NovelSource _source;
  final String _rankingType;
  final RankingFilterController _filter;
  final ApiService _api;
  final SettingsController _settings;
  final Map<NovelSource, NovelSite> _sites;
  bool _disposed = false;

  RankingState _state = const RankingState();

  /// 現在のランキング状態。
  RankingState get state => _state;

  void _setState(RankingState next) {
    _state = next;
    notifyListeners();
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _filter.removeListener(_onFilterChanged);
    super.dispose();
  }

  void _onFilterChanged() {
    if (_disposed) return;
    unawaited(refresh());
  }

  /// 初回取得を開始する。画面の initState から呼ぶ。
  void start() {
    unawaited(Future.microtask(fetchNextPage));
  }

  /// 次のページを取得する
  Future<void> fetchNextPage() async {
    final currentState = _state;
    _logRanking(
      'fetchNextPage: _source=$_source _rankingType=$_rankingType '
      'page=${currentState.page} isLoading=${currentState.isLoading} '
      'isLoadingMore=${currentState.isLoadingMore} '
      'hasMore=${currentState.hasMore} active=${!_disposed}',
    );
    if (currentState.isLoading ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    if (_settings.isOfflineMode) {
      _setState(
        currentState.copyWith(
          error: const Value<Object?>(OfflineException()),
        ),
      );
      return;
    }

    final isFirstPage = currentState.page == 1;
    _setState(
      currentState.copyWith(
        isLoading: isFirstPage,
        isLoadingMore: !isFirstPage,
      ),
    );

    try {
      final filter = _filter.state;

      if (_source == NovelSource.narou) {
        await _fetchNarouRanking(filter, currentState);
      } else {
        await _fetchSiteRanking(filter, currentState);
      }
    } on Object catch (e, stackTrace) {
      _logRanking(
        'fetchNextPage: ERROR _source=$_source _rankingType=$_rankingType '
        'active=${!_disposed} error=$e\n$stackTrace',
      );
      // タブ切替等でプロバイダが破棄された場合は状態を更新しない
      if (_disposed) {
        return;
      }
      _setState(
        _state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: Value<Object?>(e),
        ),
      );
    }
  }

  /// なろうのランキングを検索APIで取得する（従来フロー）。
  Future<void> _fetchNarouRanking(
    RankingFilterState filter,
    RankingState currentState,
  ) async {
    final order = _mapRankingTypeToOrder(_rankingType);

    final newNovels = <NovelInfo>[];
    var currentPageToFetch = currentState.page;
    var hasMoreOnServer = true;

    // Fetch loop to ensure we get enough items after filtering
    // Limit to fetching at most 5 pages at a time to prevent
    // excessive API calls
    var pagesFetched = 0;
    const maxPagesToFetch = 5;

    while (newNovels.length < 20 &&
        hasMoreOnServer &&
        pagesFetched < maxPagesToFetch) {
      final query = _buildQuery(filter, order, currentPageToFetch);

      _logRanking(
        'fetchNextPage(narou): API page=$currentPageToFetch '
        'active=${!_disposed}',
      );
      final result = await _api.searchNovels(query);

      // タブ切替等でプロバイダが破棄された場合は中断する
      if (_disposed) {
        _logRanking(
          'fetchNextPage(narou): コントローラ破棄のため中断 '
          '(page=$currentPageToFetch)',
        );
        return;
      }

      final fetchedNovels = result.novels;
      _logRanking(
        'fetchNextPage(narou): page=$currentPageToFetch 取得成功 '
        '${fetchedNovels.length}件',
      );
      hasMoreOnServer = fetchedNovels.length >= 20;

      // Apply client-side filtering
      final filtered = fetchedNovels.where((novel) {
        if (filter.showOnlyOngoing) {
          // end: 1 = 連載中, 0 = 短編または完結
          // API仕様: https://dev.syosetu.com/man/api/#end
          if (novel.end != 1) return false;
        }
        if (filter.selectedGenreId != null) {
          if (novel.genreId != filter.selectedGenreId) return false;
        }
        return true;
      }).toList();

      newNovels.addAll(filtered);
      currentPageToFetch++;
      pagesFetched++;
    }

    _setState(
      currentState.copyWith(
        novels: [...currentState.novels, ...newNovels],
        isLoading: false,
        isLoadingMore: false,
        page: currentPageToFetch, // Update to the next page to fetch
        hasMore: hasMoreOnServer || newNovels.length >= 20,
        error: const Value<Object?>(null),
      ),
    );
  }

  /// カクヨム等のサイト実装からランキングを取得する。
  Future<void> _fetchSiteRanking(
    RankingFilterState filter,
    RankingState currentState,
  ) async {
    final site = _sites[_source]!;
    _logRanking(
      'fetchNextPage(${_source.dbId}): ランキング取得 page=${currentState.page} '
      'active=${!_disposed}',
    );
    final result = await site.fetchRanking(
      _rankingType,
      page: currentState.page,
    );

    // タブ切替等でプロバイダが破棄された場合は中断する
    if (_disposed) {
      _logRanking(
        'fetchNextPage(${_source.dbId}): コントローラ破棄のため中断',
      );
      return;
    }
    _logRanking(
      'fetchNextPage(${_source.dbId}): 取得成功 ${result.novels.length}件',
    );

    // クライアントサイドでフィルタを適用
    final filtered = result.novels.where((novel) {
      if (filter.showOnlyOngoing) {
        if (novel.end != 1) return false;
      }
      if (filter.selectedGenreId != null) {
        if (novel.genreId != filter.selectedGenreId) return false;
      }
      return true;
    }).toList();

    // サーバーが返す hasNextPage で次のページ有無を判定する
    final hasMore = result.hasNextPage;
    _setState(
      currentState.copyWith(
        novels: [...currentState.novels, ...filtered],
        isLoading: false,
        isLoadingMore: false,
        page: currentState.page + 1,
        hasMore: hasMore,
        error: const Value<Object?>(null),
      ),
    );
  }

  /// データをリフレッシュする
  Future<void> refresh() async {
    _setState(const RankingState());
    await fetchNextPage();
  }

  String _mapRankingTypeToOrder(String type) {
    switch (type) {
      case 'd':
        return 'dailypoint';
      case 'w':
        return 'weeklypoint';
      case 'm':
        return 'monthlypoint';
      case 'q':
        return 'quarterpoint';
      case 'all':
        return 'hyoka'; // Total points
      default:
        return 'dailypoint';
    }
  }

  NovelSearchQuery _buildQuery(
    RankingFilterState filter,
    String order,
    int page,
  ) {
    return NovelSearchQuery(
      source: _source,
      order: order,
      st: (page - 1) * 20 + 1, // 1-based start
      genreId: filter.selectedGenreId != null
          ? [filter.selectedGenreId!]
          : null,
    );
  }
}
