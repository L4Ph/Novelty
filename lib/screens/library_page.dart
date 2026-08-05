import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/domain/library_filter_state.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/screens/search_page.dart';
import 'package:novelty/sites/novel_site_registry.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/widgets/app_bar_source_dropdown.dart';
import 'package:novelty/widgets/novel_list_tile.dart';
import 'package:novelty/widgets/ranking_filter_sheet.dart';
import 'package:novelty/widgets/search_modal.dart';

/// "ライブラリ"ページのウィジェット。
class LibraryPage extends ConsumerWidget {
  /// コンストラクタ。
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryNovelsAsync = ref.watch(libraryNovelsProvider);
    final filter = ref.watch(libraryFilterStateProvider);

    // フィルタリング処理
    final filteredNovelsAsync = libraryNovelsAsync.whenData((novels) {
      return novels.cast<Novel>().where((novel) {
        // サイト絞り込みフィルタ
        if (filter.source != null && novel.source != filter.source) {
          return false;
        }

        // 連載中のみフィルタ
        if (filter.showOnlyOngoing) {
          // end: 1 = 連載中, 0 = 完結/短編
          if (novel.end != 1) {
            return false;
          }
        }

        // ジャンルフィルタ
        if (filter.selectedGenreId != null) {
          if (novel.genreId != filter.selectedGenreId) {
            return false;
          }
        }

        return true;
      }).toList();
    });

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
            onApply:
                ({
                  required showOnlyOngoing,
                  required selectedGenreId,
                }) {
                  ref
                      .read(libraryFilterStateProvider.notifier)
                      .setShowOnlyOngoing(value: showOnlyOngoing);
                  ref
                      .read(libraryFilterStateProvider.notifier)
                      .setSelectedGenreId(selectedGenreId);
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
                  onChanged: (source) {
                    ref
                        .read(libraryFilterStateProvider.notifier)
                        .setSource(source);
                  },
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
                      unawaited(
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                SearchPage(initialQuery: query),
                          ),
                        ),
                      );
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
      body: Column(
        children: [
          Expanded(
            child: filteredNovelsAsync.when(
              data: (novels) {
                if (novels.isEmpty) {
                  // フィルタ適用中の場合はメッセージを変えるなどの配慮も可能だが、
                  // シンプルに「見つかりません」でも良い。
                  // ここでは元のメッセージを維持しつつ、フィルタ時は「条件に一致する小説がありません」とするのが親切。
                  if (libraryNovelsAsync.asData?.value.isNotEmpty ?? false) {
                    return const Center(child: Text('条件に一致する小説がありません'));
                  }
                  return const Center(child: Text('ライブラリに小説がありません'));
                }
                return ListView.builder(
                  itemCount: novels.length,
                  itemBuilder: (context, index) {
                    final novel = novels[index];

                    // NovelListTileを使用するため、NovelInfoに変換
                    final novelData = novel.toModel();

                    return NovelListTile(
                      item: novelData,
                      onLongPress: () {
                        unawaited(
                          showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('削除の確認'),
                              content: Text('"${novel.title}"をライブラリから削除しますか？'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('キャンセル'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await ref
                                        .read(novelRepositoryProvider)
                                        .removeFromLibrary(
                                          novel.source,
                                          novel.workId,
                                        );
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('ライブラリから削除しました'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('削除'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
