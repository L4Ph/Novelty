import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/app_constants.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

class RankingList extends ConsumerStatefulWidget {
  const RankingList({super.key, required this.rankingType});
  final String rankingType;

  @override
  ConsumerState<RankingList> createState() => _RankingListState();
}

class _RankingListState extends ConsumerState<RankingList>
    with AutomaticKeepAliveClientMixin<RankingList> {
  List<RankingResponse> _allNovelData = [];
  List<RankingResponse> _filteredNovelData = [];
  final _itemsPerPage = 50;
  var _currentPage = 1;

  var _showOnlyOngoing = false;
  int? _selectedGenre;

  @override
  bool get wantKeepAlive => true;

  void _applyFilters() {
    var filtered = List<RankingResponse>.from(_allNovelData);

    if (_showOnlyOngoing) {
      filtered = filtered.where((novel) => novel.end == 1).toList();
    }

    if (_selectedGenre != null) {
      filtered = filtered
          .where((novel) => novel.genre == _selectedGenre)
          .toList();
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

  void _showFilterDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('検索条件'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CheckboxListTile(
                    title: const Text('連載中のみ'),
                    value: _showOnlyOngoing,
                    onChanged: (bool? value) {
                      setState(() {
                        _showOnlyOngoing = value ?? false;
                      });
                    },
                  ),
                  DropdownButton<int?>(
                    value: _selectedGenre,
                    hint: const Text('ジャンルを選択'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<int?>(
                        child: Text('すべて'),
                      ),
                      ...genreList.map((genre) {
                        return DropdownMenuItem<int?>(
                          value: genre['id'] as int?,
                          child: Text(genre['name'] as String),
                        );
                      }),
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedGenre = newValue;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('適用'),
              onPressed: () {
                _applyFilters();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: _showFilterDialog,
            child: const Icon(Icons.filter_list),
          ),
          body: RefreshIndicator(
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
