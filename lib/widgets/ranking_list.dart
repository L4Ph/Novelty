import 'package:flutter/material.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/app_constants.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

class RankingList extends StatefulWidget {
  const RankingList({super.key, required this.rankingType});
  final String rankingType;

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList>
    with AutomaticKeepAliveClientMixin<RankingList> {
  final _apiService = ApiService();
  List<RankingResponse> _allNovelData = [];
  List<RankingResponse> _filteredNovelData = [];
  var _isLoading = true;
  var _errorMessage = '';
  final _itemsPerPage = 50;
  var _currentPage = 1;

  var _showOnlyOngoing = false;
  int? _selectedGenre;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final allData = await _apiService.fetchRankingAndDetails(
        widget.rankingType,
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _allNovelData = allData;
        _applyFilters();
        _isLoading = false;
      });
    } on Exception catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    var filtered = List<RankingResponse>.from(_allNovelData);

    if (_showOnlyOngoing) {
      filtered = filtered.where((novel) => novel.end == 0).toList();
    }

    if (_selectedGenre != null) {
      filtered =
          filtered.where((novel) => novel.genre == _selectedGenre).toList();
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
                        value: null,
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

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
      body: ListView.builder(
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
  }
}
