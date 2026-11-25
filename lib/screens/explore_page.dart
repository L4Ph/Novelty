import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/domain/search_state.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_site_registry.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/widgets/app_bar_source_dropdown.dart';
import 'package:novelty/widgets/novel_list_tile.dart';
import 'package:novelty/widgets/ranking_filter_sheet.dart';
import 'package:novelty/widgets/ranking_list.dart';
import 'package:novelty/widgets/search_modal.dart';

/// "見つける"ページのウィジェット。
class ExplorePage extends StatefulWidget {
  /// コンストラクタ。
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  NovelSource _source = NovelSource.narou;
  late TabController _tabController;
  NovelSearchQuery _searchQuery = const NovelSearchQuery();
  late final VoidCallback _tabListener;
  NovelSearchController? _search;

  /// ランキング種別ごとのフィルタ。タブを切り替えても状態を保つ。
  final _filters = <String, RankingFilterController>{};

  RankingFilterController _filterFor(String rankingType) =>
      _filters.putIfAbsent(
        rankingType,
        () => RankingFilterController(source: _source),
      );

  /// 現在のサイトのランキング種別一覧。
  List<RankingTypeMaster> get _rankingTypes =>
      defaultNovelSiteRegistry[_source]!.rankingTypes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _search ??= NovelSearchController(
      api: context.services.api,
      settings: context.services.settings,
      sites: context.services.sites,
    );
  }

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

      if (_search?.state.isSearching ?? false) {
        _search!.reset();
      }
    };
    _tabController.addListener(_tabListener);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_tabListener)
      ..dispose();
    for (final filter in _filters.values) {
      filter.dispose();
    }
    _search?.dispose();
    super.dispose();
  }

  /// プロバイダを切り替える。
  void _switchSource(NovelSource source) {
    if (source == _source) {
      return;
    }
    for (final filter in _filters.values) {
      filter.dispose();
    }
    _filters.clear();
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
    await _search!.search(_searchQuery);
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
    final site = defaultNovelSiteRegistry[_source]!;

    // 現在のフィルタ状態を取得
    final currentFilter = _filterFor(currentRankingType).state;

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
            _filterFor(currentRankingType)
              ..setShowOnlyOngoing(value: showOnlyOngoing)
              ..setSelectedGenreId(selectedGenreId);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _search!,
      builder: (context, _) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final searchState = _search!.state;
    final isOfflineMode = context.services.settings.isOfflineMode;

    return PopScope(
      canPop: !searchState.isSearching,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        _search!.reset();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('見つける'),
              // プロバイダ切替（AppBar用コンパクトドロップダウン）
              // タイトルの残り領域で中央に配置する
              if (!searchState.isSearching)
                Expanded(
                  child: Center(
                    child: AppBarSourceDropdown(
                      sources: NovelSource.values,
                      selected: _source,
                      onChanged: (source) {
                        if (source != null) {
                          _switchSource(source);
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            if (searchState.isSearching)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _search!.reset,
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
                  preferredSize: const Size.fromHeight(48),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: _rankingTypes.length > 5,
                    tabs: [
                      for (final type in _rankingTypes) Tab(text: type.label),
                    ],
                  ),
                ),
        ),
        body: searchState.isSearching
            ? searchState.isLoading && searchState.results.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _EnrichedSearchResults(
                      search: _search!,
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
                      filter: _filterFor(type.id),
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
            onPressed: () => appRouter.select(AppTab.library),
            child: const Text('ライブラリに戻る'),
          ),
        ],
      ),
    );
  }
}

/// 検索結果を表示するヘルパーウィジェット
class _EnrichedSearchResults extends StatefulWidget {
  const _EnrichedSearchResults({
    required this.search,
    required this.onModifySearch,
  });

  final NovelSearchController search;
  final VoidCallback onModifySearch;

  @override
  State<_EnrichedSearchResults> createState() => _EnrichedSearchResultsState();
}

class _EnrichedSearchResultsState extends State<_EnrichedSearchResults> {
  // ローカル状態で強化済みデータを管理（フラッシュ防止）
  final _enriched = <EnrichedNovelData>[];
  var _isEnriching = false;
  var _lastEnrichedCount = 0;
  Future<void> _enrichQueue = Future<void>.value();

  @override
  void initState() {
    super.initState();
    widget.search.addListener(_onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleEnrich();
  }

  @override
  void dispose() {
    widget.search.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() => _scheduleEnrich();

  /// 結果の取りこぼしを避けるため、前の強化処理の後に続ける。
  void _scheduleEnrich() {
    _enrichQueue = _enrichQueue.then((_) => _enrichNewResults());
  }

  /// 新しい結果が追加されたときに強化処理を実行する。
  Future<void> _enrichNewResults() async {
    if (!mounted) return;
    final results = widget.search.state.results;

    // 新しい結果がない場合はスキップ（リセット時は捨てる）
    if (results.length <= _lastEnrichedCount) {
      if (results.isEmpty && _enriched.isNotEmpty) {
        setState(() {
          _enriched.clear();
          _lastEnrichedCount = 0;
        });
      }
      return;
    }

    setState(() => _isEnriching = true);

    try {
      // データベースからライブラリ状態を取得
      final libraryNovels = await context.services.db.getLibraryNovels();
      final libraryWorkIds = libraryNovels.map((novel) => novel.workId).toSet();
      if (!mounted) return;

      // 新しい結果のみを強化
      final newResults = results.sublist(_lastEnrichedCount);
      setState(() {
        _enriched.addAll(
          newResults.map(
            (novel) => EnrichedNovelData(
              novel: novel,
              isInLibrary: libraryWorkIds.contains(novel.workId),
            ),
          ),
        );
        _lastEnrichedCount = results.length;
      });
    } finally {
      if (mounted) setState(() => _isEnriching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = widget.search.state;

    // 初回ローディング中
    if (searchState.isLoading && _enriched.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // データがない場合
    if (_enriched.isEmpty && !_isEnriching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('検索結果がありません'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: widget.onModifySearch,
              child: const Text('検索条件を変更'),
            ),
          ],
        ),
      );
    }

    final hasMore = searchState.hasMore;
    final totalCount = searchState.allCount;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
              ..._enriched.map(
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
                            onPressed: () =>
                                unawaited(widget.search.loadMore()),
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
