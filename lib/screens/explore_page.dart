import 'package:flutter/material.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/app_constants.dart';
import 'package:novelty/widgets/novel_list.dart';
import 'package:novelty/widgets/ranking_list.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _apiService = ApiService();
  var _searchQuery = const NovelSearchQuery();
  List<RankingResponse> _searchResults = [];
  var _isLoading = false;
  var _isSearching = false;
  late final VoidCallback _tabListener;

  var _showOnlyOngoing = false;
  int? _selectedGenre;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabListener = () {
      if (_tabController.indexIsChanging) {
        return;
      }

      if (_isSearching) {
        setState(() {
          _isSearching = false;
          _searchResults = [];
        });
      }
    };
    _tabController.addListener(_tabListener);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_tabListener)
      ..dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
      _isSearching = true;
    });

    final results = await _apiService.searchNovels(_searchQuery);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  void _showSearchDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('検索条件'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      decoration: const InputDecoration(labelText: 'キーワード'),
                      onChanged: (value) {
                        _searchQuery = _searchQuery.copyWith(word: value);
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: '除外キーワード'),
                      onChanged: (value) {
                        _searchQuery = _searchQuery.copyWith(notword: value);
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('タイトル'),
                      value: _searchQuery.title,
                      onChanged: (bool? value) {
                        setState(() {
                          _searchQuery = _searchQuery.copyWith(
                            title: value ?? false,
                          );
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('あらすじ'),
                      value: _searchQuery.ex,
                      onChanged: (bool? value) {
                        setState(() {
                          _searchQuery = _searchQuery.copyWith(
                            ex: value ?? false,
                          );
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('キーワード'),
                      value: _searchQuery.keyword,
                      onChanged: (bool? value) {
                        setState(() {
                          _searchQuery = _searchQuery.copyWith(
                            keyword: value ?? false,
                          );
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('作者名'),
                      value: _searchQuery.wname,
                      onChanged: (bool? value) {
                        setState(() {
                          _searchQuery = _searchQuery.copyWith(
                            wname: value ?? false,
                          );
                        });
                      },
                    ),
                    DropdownButton<String?>(
                      value: _searchQuery.type,
                      hint: const Text('小説タイプ'),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<String?>(
                          child: Text('すべて'),
                        ),
                        ...novelTypes.entries.map((entry) {
                          return DropdownMenuItem<String?>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _searchQuery = _searchQuery.copyWith(type: newValue);
                        });
                      },
                    ),
                    DropdownButton<int?>(
                      value: _searchQuery.genre?.first,
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
                          _searchQuery = _searchQuery.copyWith(
                            genre: newValue == null ? null : [newValue],
                          );
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: _searchQuery.order,
                      hint: const Text('並び替え'),
                      isExpanded: true,
                      items: novelOrders.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _searchQuery = _searchQuery.copyWith(
                            order: newValue ?? 'new',
                          );
                        });
                      },
                    ),
                  ],
                ),
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

  void _showRankingFilterDialog() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 300,
              child: Column(
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
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('キャンセル'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text('適用'),
                          onPressed: () {
                            this.setState(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSearching,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        setState(() {
          _isSearching = false;
          _searchResults = [];
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('見つける'),
          actions: [
            if (_isSearching)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchResults = [];
                  });
                },
              ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _showSearchDialog,
            ),
            if (!_isSearching)
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showRankingFilterDialog,
              ),
          ],
          bottom: _isSearching
              ? null
              : TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: '日間'),
                    Tab(text: '週間'),
                    Tab(text: '月間'),
                    Tab(text: '四半期'),
                    Tab(text: '累計'),
                  ],
                ),
        ),
        body: _isSearching
            ? _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : NovelList(novels: _searchResults, isRanking: false)
            : TabBarView(
                controller: _tabController,
                children: [
                  RankingList(
                    rankingType: 'd',
                    key: const PageStorageKey('d'),
                    showOnlyOngoing: _showOnlyOngoing,
                    selectedGenre: _selectedGenre,
                  ),
                  RankingList(
                    rankingType: 'w',
                    key: const PageStorageKey('w'),
                    showOnlyOngoing: _showOnlyOngoing,
                    selectedGenre: _selectedGenre,
                  ),
                  RankingList(
                    rankingType: 'm',
                    key: const PageStorageKey('m'),
                    showOnlyOngoing: _showOnlyOngoing,
                    selectedGenre: _selectedGenre,
                  ),
                  RankingList(
                    rankingType: 'q',
                    key: const PageStorageKey('q'),
                    showOnlyOngoing: _showOnlyOngoing,
                    selectedGenre: _selectedGenre,
                  ),
                  RankingList(
                    rankingType: 'all',
                    key: const PageStorageKey('all'),
                    showOnlyOngoing: _showOnlyOngoing,
                    selectedGenre: _selectedGenre,
                  ),
                ],
              ),
      ),
    );
  }
}
