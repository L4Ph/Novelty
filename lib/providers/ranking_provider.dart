import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking_provider.g.dart';

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
    Object? error,
  }) {
    return RankingState(
      novels: novels ?? this.novels,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingState &&
          runtimeType == other.runtimeType &&
          novels == other.novels &&
          isLoading == other.isLoading &&
          isLoadingMore == other.isLoadingMore &&
          hasMore == other.hasMore &&
          page == other.page &&
          error == other.error;

  @override
  int get hashCode => Object.hash(
    novels,
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
    );

    try {
      final filter = ref.read(rankingFilterStateProvider(rankingType));
      final apiService = ref.read(apiServiceProvider);
      final order = _mapRankingTypeToOrder(rankingType);

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
