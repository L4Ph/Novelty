import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// ランキングリストを表示するウィジェット。
class RankingList extends HookConsumerWidget {
  /// コンストラクタ。
  const RankingList({
    required this.rankingType,
    super.key,
    this.showOnlyOngoing = false,
    this.selectedGenre,
  });

  /// ランキングの種類。
  final String rankingType;

  /// 連載中の作品のみを表示するかどうか。
  final bool showOnlyOngoing;

  /// 選択されたジャンル。
  final int? selectedGenre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooksでローカル状態管理
    final allNovelData = useState<List<EnrichedNovelData>>([]);
    final filteredNovelData = useState<List<EnrichedNovelData>>([]);
    final isLoadingMore = useState(false);
    final isInitialLoad = useState(true);

    // ScrollControllerをuseMemoizedで管理
    final scrollController = useMemoized(ScrollController.new, []);

    // フィルタ適用関数
    final applyFilters = useCallback(() {
      _applyFilters(
        allNovelData,
        filteredNovelData,
        showOnlyOngoing,
        selectedGenre,
      );
    }, [allNovelData, filteredNovelData, showOnlyOngoing, selectedGenre]);

    // ローディング処理
    final loadMore = useCallback(
      () async {
        await _loadMore(
          context,
          ref,
          filteredNovelData,
          isLoadingMore,
          isInitialLoad,
          allNovelData,
          rankingType,
          showOnlyOngoing,
          selectedGenre,
        );
      },
      [
        filteredNovelData,
        isLoadingMore,
        isInitialLoad,
        allNovelData,
        rankingType,
        showOnlyOngoing,
        selectedGenre,
      ],
    );

    // フィルタ適用とリセット処理
    final applyFiltersAndReset = useCallback(() {
      applyFilters();
      if (context.mounted) {
        isInitialLoad.value = true;
        loadMore();
      }
    }, [applyFilters, loadMore]);

    // スクロールリスナー
    final onScroll = useCallback(() {
      if (isLoadingMore.value || !context.mounted) return;

      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      const delta = 200.0;

      if (currentScroll >= maxScroll - delta) {
        loadMore();
      }
    }, [isLoadingMore, loadMore]);

    // フィルタ変更の検知と処理
    final previousShowOnlyOngoing = usePrevious(showOnlyOngoing);
    final previousSelectedGenre = usePrevious(selectedGenre);

    // フィルタ変更時の自動処理
    if (previousShowOnlyOngoing != null &&
        (previousShowOnlyOngoing != showOnlyOngoing ||
            previousSelectedGenre != selectedGenre)) {
      // フィルタが変更された場合、次のフレームで処理を実行
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          applyFiltersAndReset();
        }
      });
    }

    // スクロールリスナーの管理
    final hasRegisteredListener = useState(false);

    // スクロールリスナーを一度だけ登録
    if (!hasRegisteredListener.value) {
      scrollController.addListener(onScroll);
      hasRegisteredListener.value = true;
    }

    return _buildWidget(
      context,
      ref,
      allNovelData,
      filteredNovelData,
      isLoadingMore,
      scrollController,
      rankingType,
      applyFiltersAndReset,
      showOnlyOngoing,
      selectedGenre,
    );
  }

  static void _applyFilters(
    ValueNotifier<List<EnrichedNovelData>> allNovelData,
    ValueNotifier<List<EnrichedNovelData>> filteredNovelData,
    bool showOnlyOngoing,
    int? selectedGenre,
  ) {
    if (allNovelData.value.isEmpty) {
      filteredNovelData.value = [];
      return;
    }

    var filtered = List<EnrichedNovelData>.from(allNovelData.value);

    if (showOnlyOngoing) {
      filtered = filtered.where((enrichedNovel) {
        final novel = enrichedNovel.novel;
        // Allow items with null end status to pass through initially
        // They will be filtered properly after details are loaded
        return novel.end == null || novel.end == 1;
      }).toList();
    }

    if (selectedGenre != null) {
      filtered = filtered.where((enrichedNovel) {
        final novel = enrichedNovel.novel;
        // Allow items with null genre to pass through initially
        // They will be filtered properly after details are loaded
        return novel.genre == null || novel.genre == selectedGenre;
      }).toList();
    }

    filteredNovelData.value = filtered;
  }

  static Future<void> _loadMore(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<List<EnrichedNovelData>> filteredNovelData,
    ValueNotifier<bool> isLoadingMore,
    ValueNotifier<bool> isInitialLoad,
    ValueNotifier<List<EnrichedNovelData>> allNovelData,
    String rankingType,
    bool showOnlyOngoing,
    int? selectedGenre,
  ) async {
    if (isLoadingMore.value || !context.mounted) return;

    final itemsToLoad = isInitialLoad.value ? 20 : 10;
    final currentLoadedCount = filteredNovelData.value
        .where((n) => n.novel.title != null)
        .length;

    if (currentLoadedCount >= filteredNovelData.value.length) {
      return; // All items loaded
    }

    isLoadingMore.value = true;
    if (isInitialLoad.value) {
      isInitialLoad.value = false;
    }

    final nextNcodeSlice = filteredNovelData.value
        .where((n) => n.novel.title == null)
        .take(itemsToLoad)
        .map((n) => n.novel.ncode)
        .toList();

    if (nextNcodeSlice.isEmpty) {
      isLoadingMore.value = false;
      return;
    }

    final apiService = ref.read(apiServiceProvider);
    final novelDetails = await apiService.fetchMultipleNovelsInfo(
      nextNcodeSlice,
    );

    if (!context.mounted) return;

    // Update both filteredNovelData and allNovelData with complete information
    filteredNovelData.value = filteredNovelData.value.map((enrichedNovel) {
      final novel = enrichedNovel.novel;
      if (novelDetails.containsKey(novel.ncode)) {
        final details = novelDetails[novel.ncode]!;
        return EnrichedNovelData(
          novel: novel.copyWith(
            title: details.title,
            writer: details.writer,
            story: details.story,
            novelType: details.novelType,
            end: details.end,
            genre: details.genre,
            generalAllNo: details.generalAllNo,
            keyword: details.keyword,
            allPoint: details.allPoint,
          ),
          isInLibrary: enrichedNovel.isInLibrary,
        );
      }
      return enrichedNovel;
    }).toList();

    // Also update the source data
    allNovelData.value = allNovelData.value.map((enrichedNovel) {
      final novel = enrichedNovel.novel;
      if (novelDetails.containsKey(novel.ncode)) {
        final details = novelDetails[novel.ncode]!;
        return EnrichedNovelData(
          novel: novel.copyWith(
            title: details.title,
            writer: details.writer,
            story: details.story,
            novelType: details.novelType,
            end: details.end,
            genre: details.genre,
            generalAllNo: details.generalAllNo,
            keyword: details.keyword,
            allPoint: details.allPoint,
          ),
          isInLibrary: enrichedNovel.isInLibrary,
        );
      }
      return enrichedNovel;
    }).toList();

    isLoadingMore.value = false;

    // Reapply filters after loading details if filters are active
    final hasActiveFilters = showOnlyOngoing || selectedGenre != null;
    if (hasActiveFilters) {
      _applyFilters(
        allNovelData,
        filteredNovelData,
        showOnlyOngoing,
        selectedGenre,
      );
    }
  }

  static Widget _buildWidget(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<List<EnrichedNovelData>> allNovelData,
    ValueNotifier<List<EnrichedNovelData>> filteredNovelData,
    ValueNotifier<bool> isLoadingMore,
    ScrollController scrollController,
    String rankingType,
    VoidCallback applyFiltersAndReset,
    bool showOnlyOngoing,
    int? selectedGenre,
  ) {
    final enrichedRankingDataAsync = ref.watch(
      enrichedRankingDataProvider(rankingType),
    );

    return enrichedRankingDataAsync.when<Widget>(
      data: (enrichedRankingData) {
        if (allNovelData.value.map((e) => e.novel.ncode).join() !=
            enrichedRankingData.map((e) => e.novel.ncode).join()) {
          allNovelData.value = enrichedRankingData;
          applyFiltersAndReset();
        }

        final displayData = filteredNovelData.value
            .where((n) => n.novel.title != null)
            .toList();
        final hasMore = displayData.length < filteredNovelData.value.length;

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(enrichedRankingDataProvider(rankingType));
          },
          child: ListView.builder(
            controller: scrollController,
            itemCount: displayData.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == displayData.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final enrichedItem = displayData[index];
              return NovelListTile(
                item: enrichedItem.novel,
                enrichedData: enrichedItem,
                isRanking: true,
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('エラーが発生しました: $error'),
      ),
    );
  }
}
