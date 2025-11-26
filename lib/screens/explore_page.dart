import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/domain/search_state.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/utils/app_constants.dart';
import 'package:novelty/widgets/novel_list_tile.dart';
import 'package:novelty/widgets/ranking_list.dart';

/// "見つける"ページのウィジェット。
class ExplorePage extends ConsumerStatefulWidget {
  /// コンストラクタ。
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var _searchQuery = const NovelSearchQuery();
  late final VoidCallback _tabListener;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabListener = () {
      if (_tabController.indexIsChanging) {
        return;
      }

      final searchState = ref.read(searchStateProvider);
      if (searchState.isSearching) {
        ref.read(searchStateProvider.notifier).reset();
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
    await ref.read(searchStateProvider.notifier).search(_searchQuery);
  }

  void _showSearchDialog() {
    unawaited(showDialog<void>(
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
                unawaited(_performSearch());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ));
  }

  void _showRankingFilterDialog() {
    // 現在のタブのランキングタイプを取得
    final rankingTypes = ['d', 'w', 'm', 'q', 'all'];
    final currentRankingType = rankingTypes[_tabController.index];

    // 現在のフィルタ状態を取得
    final currentFilter = ref.read(
      rankingFilterStateProvider(currentRankingType),
    );

    unawaited(showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        var tempShowOnlyOngoing = currentFilter.showOnlyOngoing;
        var tempSelectedGenre = currentFilter.selectedGenre;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 300,
              child: Column(
                children: <Widget>[
                  CheckboxListTile(
                    title: const Text('連載中のみ'),
                    value: tempShowOnlyOngoing,
                    onChanged: (bool? value) {
                      setState(() {
                        tempShowOnlyOngoing = value ?? false;
                      });
                    },
                  ),
                  DropdownButton<int?>(
                    value: tempSelectedGenre,
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
                        tempSelectedGenre = newValue;
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
                            // Providerの状態を更新
                            ref
                                .read(
                                  rankingFilterStateProvider(currentRankingType)
                                      .notifier,
                                )
                                .setShowOnlyOngoing(value: tempShowOnlyOngoing);
                            ref
                                .read(
                                  rankingFilterStateProvider(currentRankingType)
                                      .notifier,
                                )
                                .setSelectedGenre(tempSelectedGenre);
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
    ));
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchStateProvider);

    return PopScope(
      canPop: !searchState.isSearching,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        ref.read(searchStateProvider.notifier).reset();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('見つける'),
          actions: [
            if (searchState.isSearching)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  ref.read(searchStateProvider.notifier).reset();
                },
              ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _showSearchDialog,
            ),
            if (!searchState.isSearching)
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showRankingFilterDialog,
              ),
          ],
          bottom: searchState.isSearching
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
        body: searchState.isSearching
            ? searchState.isLoading && searchState.results.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : const _EnrichedSearchResults()
            : TabBarView(
                controller: _tabController,
                children: const [
                  RankingList(
                    rankingType: 'd',
                    key: PageStorageKey('d'),
                  ),
                  RankingList(
                    rankingType: 'w',
                    key: PageStorageKey('w'),
                  ),
                  RankingList(
                    rankingType: 'm',
                    key: PageStorageKey('m'),
                  ),
                  RankingList(
                    rankingType: 'q',
                    key: PageStorageKey('q'),
                  ),
                  RankingList(
                    rankingType: 'all',
                    key: PageStorageKey('all'),
                  ),
                ],
              ),
      ),
    );
  }
}

/// 検索結果を表示するヘルパーウィジェット
class _EnrichedSearchResults extends ConsumerWidget {
  const _EnrichedSearchResults();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchStateProvider);
    final enrichedResults = ref.watch(
      enrichedSearchDataProvider(searchState.results),
    );

    return enrichedResults.when(
      skipLoadingOnReload: true,
      data: (data) {
        // リストの最後に「もっと見る」ボタンを追加するため、itemCountを調整
        final hasMore = searchState.hasMore;
        final itemCount = data.length + (hasMore ? 1 : 0);

        return ListView.builder(
          key: const PageStorageKey('search_results'),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // 最後のアイテムは「もっと見る」ボタン
            if (hasMore && index == data.length) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: searchState.isLoading
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: () {
                            unawaited(
                              ref
                                  .read(searchStateProvider.notifier)
                                  .loadMore(),
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('もっと見る'),
                              SizedBox(width: 4),
                              Icon(Icons.expand_more, size: 20),
                            ],
                          ),
                        ),
                ),
              );
            }

            // 通常の小説アイテム
            final enrichedItem = data[index];
            return NovelListTile(
              item: enrichedItem.novel,
              enrichedData: enrichedItem,
              isRanking: false,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
