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
  final _itemsPerPage = 50;
  var _currentPage = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _applyFilters();
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
    });
  }

  void _loadMore() {
    if (!mounted) {
      return;
    }
    setState(() {
      _currentPage++;
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

        final totalItems = _filteredNovelData.length;
        var displayItemCount = _currentPage * _itemsPerPage;
        if (displayItemCount > totalItems) {
          displayItemCount = totalItems;
        }
        final hasMore = displayItemCount < totalItems;

        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(rankingDataProvider(widget.rankingType)),
          child: ListView.builder(
            itemCount: displayItemCount + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == displayItemCount) {
                return TextButton(
                  onPressed: _loadMore,
                  child: const Text('さらに読み込む'),
                );
              }

              final item = _filteredNovelData[index];
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
