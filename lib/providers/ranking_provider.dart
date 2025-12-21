import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking_provider.freezed.dart';
part 'ranking_provider.g.dart';

@freezed
/// ランキングの状態を管理するクラス
abstract class RankingState with _$RankingState {
  /// コンストラクタ
  const factory RankingState({
    @Default([]) List<NovelInfo> novels,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default(1) int page,
    Object? error,
  }) = _RankingState;
}

@riverpod
/// ランキングのロジックを管理するNotifier
class RankingNotifier extends _$RankingNotifier {
  @override
  RankingState build(String rankingType) {
    // Watch filter state to trigger rebuild when it changes
    ref.watch(rankingFilterStateProvider(rankingType));

    // Initial fetch
    unawaited(Future.microtask(fetchNextPage));
    return const RankingState();
  }

  /// 次のページを取得する
  Future<void> fetchNextPage() async {
    final currentState = state;
    if (currentState.isLoading ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    final isFirstPage = currentState.page == 1;
    state = currentState.copyWith(
      isLoading: isFirstPage,
      isLoadingMore: !isFirstPage,
      error: null,
    );

    try {
      final filter = ref.read(rankingFilterStateProvider(rankingType));
      final apiService = ref.read(apiServiceProvider);
      final order = _mapRankingTypeToOrder(rankingType);

      final newNovels = <NovelInfo>[];
      var currentPageToFetch = currentState.page;
      var hasMoreOnServer = true;

      // Fetch loop to ensure we get enough items after filtering
      // Limit to fetching at most 5 pages at a time to prevent excessive API calls
      var pagesFetched = 0;
      const maxPagesToFetch = 5;

      while (newNovels.length < 20 &&
          hasMoreOnServer &&
          pagesFetched < maxPagesToFetch) {
        final query = _buildQuery(filter, order, currentPageToFetch);

        final result = await apiService.searchNovels(query);

        final fetchedNovels = result.novels;
        hasMoreOnServer = fetchedNovels.length >= 20;

        // Apply client-side filtering
        final filtered = fetchedNovels.where((novel) {
          if (filter.showOnlyOngoing) {
            // end: 1 = 連載中, 0 = 短編または完結
            // API仕様: https://dev.syosetu.com/man/api/#end
            if (novel.end != 1) return false;
          }
          return true;
        }).toList();

        newNovels.addAll(filtered);
        currentPageToFetch++;
        pagesFetched++;
      }

      state = currentState.copyWith(
        novels: [...currentState.novels, ...newNovels],
        isLoading: false,
        isLoadingMore: false,
        page: currentPageToFetch, // Update to the next page to fetch
        hasMore: hasMoreOnServer || newNovels.length >= 20,
      );
    } on Object catch (e) {
      state = currentState.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e,
      );
    }
  }

  /// データをリフレッシュする
  Future<void> refresh() async {
    state = const RankingState();
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
      order: order,
      st: (page - 1) * 20 + 1, // 1-based start
      genre: filter.selectedGenre != 0 && filter.selectedGenre != null
          ? [filter.selectedGenre!]
          : null,
    );
  }
}
