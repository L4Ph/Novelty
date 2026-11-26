import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/domain/library_filter_state.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/sites/novel_site_registry.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/widgets/app_bar_source_dropdown.dart';
import 'package:novelty/widgets/novel_list_tile.dart';
import 'package:novelty/widgets/ranking_filter_sheet.dart';
import 'package:novelty/widgets/remove_from_library_dialog.dart';
import 'package:novelty/widgets/search_modal.dart';
import 'package:tiny_state/tiny_state.dart';

/// "ライブラリ"ページのウィジェット。
class LibraryPage extends StatefulWidget {
  /// コンストラクタ。
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final _filter = LibraryFilterController();
  Stream<List<dynamic>>? _novels;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _novels ??= watchLibraryNovels(context.services.db);
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  bool _matches(Novel novel, LibraryFilterState filter) {
    if (filter.source != null && novel.source != filter.source) return false;
    if (filter.showOnlyOngoing && novel.end != 1) return false;
    if (filter.selectedGenreId != null &&
        novel.genreId != filter.selectedGenreId) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _filter,
      builder: (context, _) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final repository = context.services.repository;
    final filter = _filter.state;

    void showFilterSheet() {
      // ジャンル一覧は選択中のサイトのマスタデータを使用する
      final genres =
          defaultNovelSiteRegistry[filter.source ?? NovelSource.narou]!.genres;
      unawaited(
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => RankingFilterSheet(
            genres: genres,
            initialShowOnlyOngoing: filter.showOnlyOngoing,
            initialSelectedGenreId: filter.selectedGenreId,
            onApply: ({required showOnlyOngoing, required selectedGenreId}) {
              _filter
                ..setShowOnlyOngoing(value: showOnlyOngoing)
                ..setSelectedGenreId(selectedGenreId);
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('ライブラリ'),
            // プロバイダ絞り込み（探索画面と同一のAppBarドロップダウン）
            // タイトルの残り領域で中央に配置する
            Expanded(
              child: Center(
                child: AppBarSourceDropdown(
                  sources: NovelSource.values,
                  selected: filter.source,
                  allLabel: 'すべて',
                  onChanged: _filter.setSource,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              unawaited(
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => SearchModal(
                    initialQuery: const NovelSearchQuery(),
                    onSearch: (query) {
                      Navigator.pop(context);
                      appRouter.push(SearchDest(query: query));
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: showFilterSheet,
          ),
        ],
      ),
      body: StreamLoader<List<dynamic>>(
        stream: _novels!,
        builder: (context, state) => state.when(
          data: (novels) {
            final all = novels.cast<Novel>();
            // Materialised: a lazy WhereIterable re-runs the predicate for
            // every elementAt, which is quadratic over the rows on screen.
            final filtered = all
                .where((novel) => _matches(novel, filter))
                .toList();
            if (filtered.isEmpty) {
              return Center(
                child: Text(
                  all.isEmpty ? 'ライブラリに小説がありません' : '条件に一致する小説がありません',
                ),
              );
            }
            return ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final novel = filtered[index];

                return NovelListTile(
                  item: novel.toModel(),
                  onLongPress: () =>
                      _removeFromLibrary(context, repository, novel),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stackTrace) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Future<void> _removeFromLibrary(
    BuildContext context,
    NovelRepository repository,
    Novel novel,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final action = await showRemoveFromLibraryDialog(
      context,
      novelTitle: novel.title ?? 'タイトルなし',
    );
    if (action == null || action == RemoveFromLibraryAction.cancel) {
      return;
    }

    try {
      await repository.removeFromLibrary(
        novel.source,
        novel.workId,
        deleteDownloads: action == RemoveFromLibraryAction.deleteDownloads,
      );

      if (!messenger.mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('ライブラリから削除しました')),
      );
    } on Object catch (e) {
      if (!messenger.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('ライブラリから削除できませんでした: $e')),
      );
    }
  }
}
