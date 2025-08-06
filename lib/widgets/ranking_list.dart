import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/providers/enriched_novel_provider.dart';
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

    // スクロールリスナーの関数
    void onScroll() {
      if (isLoadingMore.value || !context.mounted) return;

      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      const delta = 200.0;

      if (currentScroll >= maxScroll - delta) {
        _loadMore(
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
      }
    }

    // useEffectでスクロールリスナーの設定・解除
    useEffect(() {
      scrollController.addListener(onScroll);
      return () {
        scrollController
          ..removeListener(onScroll)
          ..dispose();
      };
    }, [scrollController]);

    // フィルタ変更時の処理
    useEffect(() {
      _applyFiltersAndReset(
        allNovelData,
        filteredNovelData,
        isInitialLoad,
        isLoadingMore,
        context,
        ref,
        rankingType,
        showOnlyOngoing,
        selectedGenre,
      );
      return null;
    }, [showOnlyOngoing, selectedGenre]);

    return _buildWidget(
      context,
      ref,
      allNovelData,
      filteredNovelData,
      isLoadingMore,
      isInitialLoad,
      scrollController,
      rankingType,
      showOnlyOngoing,
      selectedGenre,
    );
  }

  static void _applyFiltersAndReset(
    ValueNotifier<List<EnrichedNovelData>> allNovelData,
    ValueNotifier<List<EnrichedNovelData>> filteredNovelData,
    ValueNotifier<bool> isInitialLoad,
    ValueNotifier<bool> isLoadingMore,
    BuildContext context,
    WidgetRef ref,
    String rankingType,
    bool showOnlyOngoing,
    int? selectedGenre,
  ) {
    _applyFilters(allNovelData, filteredNovelData, showOnlyOngoing, selectedGenre);
    if (context.mounted) {
      isInitialLoad.value = true;
      _loadMore(
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
    }
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
      _applyFilters(allNovelData, filteredNovelData, showOnlyOngoing, selectedGenre);
    }
  }

  static Widget _buildWidget(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<List<EnrichedNovelData>> allNovelData,
    ValueNotifier<List<EnrichedNovelData>> filteredNovelData,
    ValueNotifier<bool> isLoadingMore,
    ValueNotifier<bool> isInitialLoad,
    ScrollController scrollController,
    String rankingType,
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
          _applyFiltersAndReset(
            allNovelData,
            filteredNovelData,
            isInitialLoad,
            isLoadingMore,
            context,
            ref,
            rankingType,
            showOnlyOngoing,
            selectedGenre,
          );
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
