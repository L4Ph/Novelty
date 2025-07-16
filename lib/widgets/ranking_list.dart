import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

class RankingList extends ConsumerStatefulWidget {
  const RankingList({
    super.key,
    required this.rankingType,
    this.showOnlyOngoing = false,
    this.selectedGenre,
  });
  final String rankingType;
  final bool showOnlyOngoing;
  final int? selectedGenre;

  @override
  ConsumerState<RankingList> createState() => _RankingListState();
}

class _RankingListState extends ConsumerState<RankingList>
    with AutomaticKeepAliveClientMixin<RankingList> {
  List<RankingResponse> _allNovelData = [];
  List<RankingResponse> _filteredNovelData = [];
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

    var filtered = List<RankingResponse>.from(_allNovelData);

    if (widget.showOnlyOngoing) {
      filtered = filtered.where((novel) => novel.end == 0).toList();
    }

    if (widget.selectedGenre != null) {
      filtered =
          filtered.where((novel) => novel.genre == widget.selectedGenre).toList();
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
    final currentLoadedCount =
        _filteredNovelData.where((n) => n.title != null).length;

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
        .where((n) => n.title == null)
        .take(itemsToLoad)
        .map((n) => n.ncode)
        .toList();

    if (nextNcodeSlice.isEmpty) {
      setState(() {
        _isLoadingMore = false;
      });
      return;
    }

    final apiService = ref.read(apiServiceProvider);
    final novelDetails = await apiService.fetchMultipleNovelsInfo(nextNcodeSlice);

    if (!mounted) return;

    setState(() {
      _filteredNovelData = _filteredNovelData.map((novel) {
        if (novelDetails.containsKey(novel.ncode)) {
          final details = novelDetails[novel.ncode]!;
          return novel.copyWith(
            title: details.title,
            writer: details.writer,
            story: details.story,
            novelType: details.novelType,
            end: details.end,
            genre: details.genre,
            generalAllNo: details.generalAllNo,
            keyword: details.keyword,
            allPoint: details.allPoint,
          );
        }
        return novel;
      }).toList();
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final rankingDataAsync = ref.watch(rankingDataProvider(widget.rankingType));

    return rankingDataAsync.when<Widget>(
      data: (rankingData) {
        if (_allNovelData
            .map((e) => e.ncode)
            .join() !=
            rankingData.map((e) => e.ncode).join()) {
          _allNovelData = rankingData;
          _applyFiltersAndReset();
        }

        final displayData = _filteredNovelData.where((n) => n.title != null).toList();
        final hasMore = displayData.length < _filteredNovelData.length;

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(rankingDataProvider(widget.rankingType));
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: displayData.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == displayData.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final item = displayData[index];
              return NovelListTile(item: item, isRanking: true);
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

