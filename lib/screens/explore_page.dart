import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/domain/search_state.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/router/router.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_site_registry.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/novel_list_tile.dart';
import 'package:novelty/widgets/ranking_filter_sheet.dart';
import 'package:novelty/widgets/ranking_list.dart';
import 'package:novelty/widgets/search_modal.dart';
import 'package:novelty/widgets/source_selector.dart';

/// "見つける"ページのウィジェット。
class ExplorePage extends ConsumerStatefulWidget {
  /// コンストラクタ。
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage>
    with TickerProviderStateMixin {
  NovelSource _source = NovelSource.narou;
  late TabController _tabController;
  NovelSearchQuery _searchQuery = const NovelSearchQuery();
  late final VoidCallback _tabListener;

  /// 現在のサイトのランキング種別一覧。
  List<RankingTypeMaster> get _rankingTypes =>
      novelSiteRegistry[_source]!.rankingTypes;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _rankingTypes.length,
      vsync: this,
    );
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

  /// プロバイダを切り替える。
  void _switchSource(NovelSource source) {
    if (source == _source) {
      return;
    }
    setState(() {
      _source = source;
      _tabController
        ..removeListener(_tabListener)
        ..dispose();
      _tabController = TabController(
        length: _rankingTypes.length,
        vsync: this,
      )..addListener(_tabListener);
    });
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
    final currentRankingType = _rankingTypes[_tabController.index].id;
    final site = novelSiteRegistry[_source]!;

    // 現在のフィルタ状態を取得
    final currentFilter = ref.read(
      rankingFilterStateProvider(_source, currentRankingType),
    );

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => RankingFilterSheet(
          genres: site.genres,
          initialShowOnlyOngoing: currentFilter.showOnlyOngoing,
          initialSelectedGenreId: currentFilter.selectedGenreId,
          onApply: ({required showOnlyOngoing, required selectedGenreId}) {
            // Providerの状態を更新
            ref.read(
                rankingFilterStateProvider(
                  _source,
                  currentRankingType,
                ).notifier,
              )
              ..setShowOnlyOngoing(value: showOnlyOngoing)
              ..setSelectedGenreId(selectedGenreId);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchStateProvider);
    final isOfflineMode = ref.watch(isOfflineModeProvider);

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
              onPressed: isOfflineMode
                  ? () => _showOfflineDisabledSnackBar(context)
                  : _showSearchModal,
            ),
            if (!searchState.isSearching)
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: isOfflineMode
                    ? () => _showOfflineDisabledSnackBar(context)
                    : _showRankingFilterDialog,
              ),
          ],
          bottom: searchState.isSearching
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(112),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // プロバイダ切替
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: SourceSelector(
                          sources: NovelSource.values,
                          selected: _source,
                          onChanged: (source) {
                            if (source != null) {
                              _switchSource(source);
                            }
                          },
                        ),
                      ),
                      TabBar(
                        controller: _tabController,
                        isScrollable: _rankingTypes.length > 5,
                        tabs: [
                          for (final type in _rankingTypes)
                            Tab(text: type.label),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
        body: searchState.isSearching
            ? searchState.isLoading && searchState.results.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _EnrichedSearchResults(
                      onModifySearch: _showSearchModal,
                    )
            : isOfflineMode
            ? const _OfflineExploreBody()
            : TabBarView(
                controller: _tabController,
                children: [
                  for (final type in _rankingTypes)
                    RankingList(
                      source: _source,
                      rankingType: type.id,
                      key: PageStorageKey<String>(
                        '${_source.dbId}_${type.id}',
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  void _showOfflineDisabledSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('オフラインモード中は検索・ランキングを利用できません'),
      ),
    );
  }
}

class _OfflineExploreBody extends StatelessWidget {
  const _OfflineExploreBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'オフラインモード中は検索・ランキングを利用できません',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => const LibraryRoute().go(context),
            child: const Text('ライブラリに戻る'),
          ),
        ],
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
            final libraryWorkIds = libraryNovels
                .map((novel) => novel.workId)
                .toSet();

            // 新しい結果のみを強化
            final newResults = results.sublist(alreadyEnriched);
            final newEnrichedData = newResults.map((novel) {
              final isInLibrary = libraryWorkIds.contains(novel.workId);
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
