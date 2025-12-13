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
      final query = _buildQuery(filter, order, currentState.page);

      final result = await apiService.searchNovels(query);

      final newNovels = result.novels;

      state = currentState.copyWith(
        novels: [...currentState.novels, ...newNovels],
        isLoading: false,
        isLoadingMore: false,
        page: currentState.page + 1,
        hasMore: newNovels.length >= 20, // Default limit
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
      // Add other filters from RankingFilterState here
    );
  }
}
