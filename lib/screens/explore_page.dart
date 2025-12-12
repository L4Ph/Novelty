import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/domain/search_state.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/widgets/novel_list_tile.dart';
import 'package:novelty/widgets/ranking_filter_sheet.dart';
import 'package:novelty/widgets/ranking_list.dart';
import 'package:novelty/widgets/search_modal.dart';

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

  void _showSearchModal() {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => SearchModal(
          initialQuery: _searchQuery,
          onSearch: (newQuery) {
            Navigator.pop(context);
            setState(() {
              _searchQuery = newQuery;
            });
            unawaited(_performSearch());
          },
        ),
      ),
    );
  }

  void _showRankingFilterDialog() {
    // 現在のタブのランキングタイプを取得
    final rankingTypes = ['d', 'w', 'm', 'q', 'all'];
    final currentRankingType = rankingTypes[_tabController.index];

    // 現在のフィルタ状態を取得
    final currentFilter = ref.read(
      rankingFilterStateProvider(currentRankingType),
    );

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => RankingFilterSheet(
          initialShowOnlyOngoing: currentFilter.showOnlyOngoing,
          initialSelectedGenre: currentFilter.selectedGenre,
          onApply: ({required showOnlyOngoing, required selectedGenre}) {
            // Providerの状態を更新
            final _ =
                ref.read(
                    rankingFilterStateProvider(currentRankingType).notifier,
                  )
                  ..setShowOnlyOngoing(value: showOnlyOngoing)
                  ..setSelectedGenre(selectedGenre);
          },
        ),
      ),
    );
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
              onPressed: _showSearchModal,
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
                  : _EnrichedSearchResults(
                      onModifySearch: _showSearchModal,
                    )
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
class _EnrichedSearchResults extends HookConsumerWidget {
  const _EnrichedSearchResults({required this.onModifySearch});
  final VoidCallback onModifySearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchStateProvider);

    // ローカル状態で強化済みデータを管理（フラッシュ防止）
    final enrichedData = useState<List<EnrichedNovelData>>([]);
    final isEnriching = useState(false);
    final lastEnrichedCount = useState(0);

    // 新しい結果が追加されたときに強化処理を実行
    useEffect(
      () {
        Future<void> enrichNewResults() async {
          final results = searchState.results;
          final alreadyEnriched = lastEnrichedCount.value;

          // 新しい結果がない場合はスキップ
          if (results.length <= alreadyEnriched) {
            // リセットされた場合（結果が減った場合）
            if (results.isEmpty && enrichedData.value.isNotEmpty) {
              enrichedData.value = [];
              lastEnrichedCount.value = 0;
            }
            return;
          }

          isEnriching.value = true;

          try {
            // データベースからライブラリ状態を取得
            final db = ref.read(appDatabaseProvider);
            final libraryNovels = await db.getLibraryNovels();
            final libraryNcodes = libraryNovels
                .map((novel) => novel.ncode)
                .toSet();

            // 新しい結果のみを強化
            final newResults = results.sublist(alreadyEnriched);
            final newEnrichedData = newResults.map((novel) {
              final isInLibrary = libraryNcodes.contains(novel.ncode);
              return EnrichedNovelData(
                novel: novel,
                isInLibrary: isInLibrary,
              );
            }).toList();

            // 既存のデータに追加
            enrichedData.value = [...enrichedData.value, ...newEnrichedData];
            lastEnrichedCount.value = results.length;
          } finally {
            isEnriching.value = false;
          }
        }

        unawaited(enrichNewResults());
        return null;
      },
      [searchState.results.length],
    );

    // 初回ローディング中
    if (searchState.isLoading && enrichedData.value.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // データがない場合
    if (enrichedData.value.isEmpty && !isEnriching.value) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('検索結果がありません'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onModifySearch,
              child: const Text('検索条件を変更'),
            ),
          ],
        ),
      );
    }

    final hasMore = searchState.hasMore;
    final data = enrichedData.value;
    final totalCount = searchState.allCount;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color:
              Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
          width: double.infinity,
          child: Text(
            '$totalCount 件ヒット',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: ListView(
            key: const PageStorageKey('search_results'),
            children: [
              ...data.map(
                (enrichedItem) => NovelListTile(
                  item: enrichedItem.novel,
                  enrichedData: enrichedItem,
                ),
              ),
              if (hasMore)
                Padding(
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
                ),
            ],
          ),
        ),
      ],
    );
  }
}
