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
  List<RankingResponse> _displayedData = [];
  final _itemsPerPage = 50;
  var _currentPage = 1;
  final _scrollController = ScrollController();
  var _isLoadingMore = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _applyFilters();
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
      _applyFilters();
    }
  }

  void _applyFilters() {
    if (_allNovelData.isEmpty) {
      return;
    }

    var filtered = List<RankingResponse>.from(_allNovelData);

    if (widget.showOnlyOngoing) {
      filtered = filtered.where((novel) => novel.end == 1).toList();
    }

    if (widget.selectedGenre != null) {
      filtered =
          filtered.where((novel) => novel.genre == widget.selectedGenre).toList();
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _filteredNovelData = filtered;
      _currentPage = 1;
      _updateDisplayedData();
    });
  }

  void _updateDisplayedData() {
    final totalItems = _filteredNovelData.length;
    var displayItemCount = _currentPage * _itemsPerPage;
    if (displayItemCount > totalItems) {
      displayItemCount = totalItems;
    }
    
    _displayedData = _filteredNovelData.take(displayItemCount).toList();
  }

  void _onScroll() {
    if (_isLoadingMore || !mounted) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const delta = 200.0; // Load more when within 200 pixels of bottom
    
    if (currentScroll >= maxScroll - delta) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoadingMore || !mounted) {
      return;
    }
    
    final totalItems = _filteredNovelData.length;
    final currentDisplayed = _displayedData.length;
    
    if (currentDisplayed >= totalItems) {
      return; // All items are already displayed
    }
    
    setState(() {
      _isLoadingMore = true;
      _currentPage++;
      _updateDisplayedData();
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final rankingDataAsync = ref.watch(rankingDataProvider(widget.rankingType));

    return rankingDataAsync.when<Widget>(
      data: (allNovelData) {
        _allNovelData = allNovelData;
        _applyFilters();

        final hasMore = _displayedData.length < _filteredNovelData.length;

        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(rankingDataProvider(widget.rankingType)),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _displayedData.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _displayedData.length) {
                // Loading indicator at the bottom
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = _displayedData[index];
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
