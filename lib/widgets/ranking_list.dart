import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/providers/enriched_novel_provider.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// ランキングリストを表示するウィジェット。
class RankingList extends ConsumerStatefulWidget {
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
  ConsumerState<RankingList> createState() => _RankingListState();
}

class _RankingListState extends ConsumerState<RankingList>
    with AutomaticKeepAliveClientMixin<RankingList> {
  List<EnrichedNovelData> _allNovelData = [];
  List<EnrichedNovelData> _filteredNovelData = [];
  final _scrollController = ScrollController();
  var _isLoadingMore = false;
  var _isInitialLoad = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RankingList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showOnlyOngoing != oldWidget.showOnlyOngoing ||
        widget.selectedGenre != oldWidget.selectedGenre) {
      _applyFiltersAndReset();
    }
  }

  void _applyFiltersAndReset() {
    _applyFilters();
    if (mounted) {
      setState(() {
        _isInitialLoad = true;
      });
      _loadMore();
    }
  }

  void _applyFilters() {
    if (_allNovelData.isEmpty) {
      if (mounted) {
        setState(() {
          _filteredNovelData = [];
        });
      }
      return;
    }

    var filtered = List<EnrichedNovelData>.from(_allNovelData);

    if (widget.showOnlyOngoing) {
      filtered = filtered.where((enrichedNovel) {
        final novel = enrichedNovel.novel;
        // Allow items with null end status to pass through initially
        // They will be filtered properly after details are loaded
        return novel.end == null || novel.end == 1;
      }).toList();
    }

    if (widget.selectedGenre != null) {
      filtered = filtered.where((enrichedNovel) {
        final novel = enrichedNovel.novel;
        // Allow items with null genre to pass through initially
        // They will be filtered properly after details are loaded
        return novel.genre == null || novel.genre == widget.selectedGenre;
      }).toList();
    }

    if (mounted) {
      setState(() {
        _filteredNovelData = filtered;
      });
    }
  }

  void _onScroll() {
    if (_isLoadingMore || !mounted) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const delta = 200.0;

    if (currentScroll >= maxScroll - delta) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !mounted) return;

    final itemsToLoad = _isInitialLoad ? 20 : 10;
    final currentLoadedCount = _filteredNovelData
        .where((n) => n.novel.title != null)
        .length;

    if (currentLoadedCount >= _filteredNovelData.length) {
      return; // All items loaded
    }

    setState(() {
      _isLoadingMore = true;
      if (_isInitialLoad) {
        _isInitialLoad = false;
      }
    });

    final nextNcodeSlice = _filteredNovelData
        .where((n) => n.novel.title == null)
        .take(itemsToLoad)
        .map((n) => n.novel.ncode)
        .toList();

    if (nextNcodeSlice.isEmpty) {
      setState(() {
        _isLoadingMore = false;
      });
      return;
    }

    final apiService = ref.read(apiServiceProvider);
    final novelDetails = await apiService.fetchMultipleNovelsInfo(
      nextNcodeSlice,
    );

    if (!mounted) return;

    // Update both _filteredNovelData and _allNovelData with complete information
    setState(() {
      _filteredNovelData = _filteredNovelData.map((enrichedNovel) {
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
      _allNovelData = _allNovelData.map((enrichedNovel) {
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

      _isLoadingMore = false;
    });

    // Reapply filters after loading details if filters are active
    final hasActiveFilters =
        widget.showOnlyOngoing || widget.selectedGenre != null;
    if (hasActiveFilters) {
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final enrichedRankingDataAsync = ref.watch(
      enrichedRankingDataProvider(widget.rankingType),
    );

    return enrichedRankingDataAsync.when<Widget>(
      data: (enrichedRankingData) {
        if (_allNovelData.map((e) => e.novel.ncode).join() !=
            enrichedRankingData.map((e) => e.novel.ncode).join()) {
          _allNovelData = enrichedRankingData;
          _applyFiltersAndReset();
        }

        final displayData = _filteredNovelData
            .where((n) => n.novel.title != null)
            .toList();
        final hasMore = displayData.length < _filteredNovelData.length;

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(enrichedRankingDataProvider(widget.rankingType));
          },
          child: ListView.builder(
            controller: _scrollController,
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
