import 'package:flutter/material.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/app_constants.dart';
import 'package:novelty/widgets/novel_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService _apiService = ApiService();
  final _searchQuery = NovelSearchQuery();
  List<RankingResponse> _searchResults = [];
  bool _isLoading = false;

  void _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    final results = await _apiService.searchNovels(_searchQuery);

    setState(() {
      _searchResults = results;
      _isLoading = false;
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
                  TextField(
                    decoration: const InputDecoration(labelText: 'キーワード'),
                    onChanged: (value) {
                      _searchQuery.word = value;
                    },
                  ),
                  DropdownButton<int?>(
                    value: _searchQuery.genre?.first,
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
                        _searchQuery.genre = newValue == null ? null : [newValue];
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
              child: const Text('検索'),
              onPressed: () {
                _performSearch();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('小説検索'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : NovelList(
              novels: _searchResults,
              isRanking: false,
            ),
    );
  }
}
