import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/screens/novel_page.dart';
import 'package:novelty/screens/toc_page.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/app_constants.dart';

class RankingList extends StatefulWidget {
  final String rankingType;

  const RankingList({super.key, required this.rankingType});

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList>
    with AutomaticKeepAliveClientMixin<RankingList> {
  final ApiService _apiService = ApiService();
  List<RankingResponse> _allNovelData = [];
  List<RankingResponse> _filteredNovelData = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final int _itemsPerPage = 50;
  int _currentPage = 1;

  bool _showOnlyOngoing = false;
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
      final allData =
          await _apiService.fetchRankingAndDetails(widget.rankingType);

      if (!mounted) return;
      setState(() {
        _allNovelData = allData;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<RankingResponse> filtered = List.from(_allNovelData);

    if (_showOnlyOngoing) {
      filtered = filtered.where((novel) => novel.end == 0).toList();
    }

    if (_selectedGenre != null) {
      filtered =
          filtered.where((novel) => novel.genre == _selectedGenre).toList();
    }

    if (!mounted) return;
    setState(() {
      _filteredNovelData = filtered;
      _currentPage = 1;
    });
  }

  void _loadMore() {
    if (!mounted) return;
    setState(() {
      _currentPage++;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Options'),
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
                          value: genre['id'],
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

    final int totalItems = _filteredNovelData.length;
    int displayItemCount = _currentPage * _itemsPerPage;
    if (displayItemCount > totalItems) {
      displayItemCount = totalItems;
    }
    final bool hasMore = displayItemCount < totalItems;

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
          final title = item.title ?? 'タイトルなし';
          final genreName = item.genre != null && item.genre != -1
              ? genreList.firstWhere((g) => g['id'] == item.genre,
                  orElse: () => {'name': '不明'})['name'] as String
              : '不明';
          final status = item.end == null || item.end == -1
              ? '情報取得失敗'
              : (item.end == 0 ? '連載中' : '完結済');

          return ListTile(
            leading: Text('${item.rank ?? ''}'),
            title: Text(title),
            subtitle: Text(
                'Nコード: ${item.ncode} - ${item.pt ?? 0}pt\nジャンル: $genreName - $status'),
            onTap: () async {
              final ncode = item.ncode.toLowerCase();

              if (item.novelType == 2) {
                // This is a short story, navigate to NovelPage directly
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NovelPage(
                      ncode: ncode,
                      title: item.title ?? '',
                      episode: 1,
                      novelType: 2, // Explicitly set as short story
                    ),
                  ),
                );
              } else {
                // This is a series, fetch novel info for episodes
                final novelInfo = await _apiService.fetchNovelInfo(ncode);

                if (novelInfo.episodes != null &&
                    novelInfo.episodes!.isNotEmpty) {
                  // Navigate to TocPage
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => TocPage(
                        ncode: ncode,
                        title: novelInfo.title ?? '',
                        episodes: novelInfo.episodes!,
                        novelType: 1, // Explicitly set as series
                      ),
                    ),
                  );
                } else {
                  // Fallback to NovelPage if it's a series with no episodes
                  // or failed to fetch details
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => NovelPage(
                        ncode: ncode,
                        title: novelInfo.title ?? item.title ?? '',
                        episode: 1,
                        novelType: 2, // Treat as short story
                      ),
                    ),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}