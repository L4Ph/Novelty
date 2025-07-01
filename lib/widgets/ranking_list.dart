import 'package:flutter/material.dart';
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

class _RankingListState extends State<RankingList> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _allNovelData = [];
  List<Map<String, dynamic>> _filteredNovelData = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _itemsPerPage = 50;
  int _currentPage = 1;

  bool _showOnlyOngoing = false;
  int? _selectedGenre;

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
    List<Map<String, dynamic>> filtered = List.from(_allNovelData);

    if (_showOnlyOngoing) {
      filtered = filtered.where((novel) => novel['end'] == 0).toList();
    }

    if (_selectedGenre != null) {
      filtered =
          filtered.where((novel) => novel['genre'] == _selectedGenre).toList();
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
          title: Text('Filter Options'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CheckboxListTile(
                    title: Text('連載中のみ'),
                    value: _showOnlyOngoing,
                    onChanged: (bool? value) {
                      setState(() {
                        _showOnlyOngoing = value ?? false;
                      });
                    },
                  ),
                  DropdownButton<int?>(
                    value: _selectedGenre,
                    hint: Text('ジャンルを選択'),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text('すべて'),
                      ),
                      ...genreList.map((genre) {
                        return DropdownMenuItem<int?>(
                          value: genre['id'],
                          child: Text(genre['name']),
                        );
                      }).toList(),
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
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('適用'),
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    final int totalItems = _filteredNovelData.length;
    final int endIndex = _currentPage * _itemsPerPage;
    final List<Map<String, dynamic>> visibleData = _filteredNovelData.sublist(
        0, endIndex > totalItems ? totalItems : endIndex);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        child: const Icon(Icons.filter_list),
      ),
      body: ListView.builder(
        itemCount: visibleData.length + 1,
        itemBuilder: (context, index) {
          if (index == visibleData.length) {
            return totalItems > visibleData.length
                ? TextButton(
                    onPressed: _loadMore,
                    child: const Text('さらに読み込む'),
                  )
                : const SizedBox.shrink();
          }
          final item = visibleData[index];
          final title = item['title'] ?? 'No title';
          final genreName = item['genre'] != -1
              ? genreList.firstWhere((g) => g['id'] == item['genre'],
                  orElse: () => {'name': '不明'})['name']
              : '不明';
          final status = item['end'] == -1
              ? '情報取得失敗'
              : (item['end'] == 0 ? '連載中' : '完結済');

          return ListTile(
            leading: Text('${item['rank']}'),
            title: Text(title),
            subtitle: Text(
                'Nコード: ${item['ncode'] ?? 'N/A'} - ${item['pt'] ?? 0}pt\nジャンル: $genreName - $status'),
            onTap: () {
              final novelType = item['novel_type'] ?? 1;
              if (novelType == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TocPage(
                      ncode: (item['ncode'] as String).toLowerCase(),
                      title: title,
                      novelType: novelType,
                    ),
                  ),
                );
              } else if (novelType == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NovelPage(
                      ncode: (item['ncode'] as String).toLowerCase(),
                      title: title,
                      novelType: novelType,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
