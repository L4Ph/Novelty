import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/domain/library_filter_state.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/screens/search_page.dart';
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
      return novels.where((novel) {
        // 連載中のみフィルタ
        if (filter.showOnlyOngoing) {
          // end: 1 = 連載中, 0 = 完結/短編
          if (novel.end != 1) {
            return false;
          }
        }

        // ジャンルフィルタ
        if (filter.selectedGenre != null) {
          if (novel.genre != filter.selectedGenre) {
            return false;
          }
        }

        return true;
      }).toList();
    });

    void showFilterSheet() {
      unawaited(
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => RankingFilterSheet(
            initialShowOnlyOngoing: filter.showOnlyOngoing,
            initialSelectedGenre: filter.selectedGenre,
            onApply: ({required showOnlyOngoing, required selectedGenre}) {
              ref
                  .read(libraryFilterStateProvider.notifier)
                  .setShowOnlyOngoing(value: showOnlyOngoing);
              ref
                  .read(libraryFilterStateProvider.notifier)
                  .setSelectedGenre(selectedGenre);
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ライブラリ'),
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
      body: filteredNovelsAsync.when(
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
                                  .removeFromLibrary(novel.ncode);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
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
    );
  }
}
