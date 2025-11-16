import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// ランキングリストを表示するウィジェット。
class RankingList extends HookConsumerWidget {
  /// コンストラクタ。
  const RankingList({
    required this.rankingType,
    super.key,
  });

  /// ランキングの種類。
  final String rankingType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // プログレッシブローディング用のローカル状態
    final loadedData = useState<Map<String, EnrichedNovelData>>({});
    final isLoadingMore = useState(false);
    final isInitialLoad = useState(true);

    // Providerからデータを取得（フィルタリング前）
    final enrichedDataAsync = ref.watch(
      enrichedRankingDataProvider(rankingType),
    );

    // フィルタ状態を取得
    final filterState = ref.watch(rankingFilterStateProvider(rankingType));

    // ローディング処理
    Future<void> loadMore(List<EnrichedNovelData> enrichedData) async {
      if (isLoadingMore.value || !context.mounted) return;

      final itemsToLoad = isInitialLoad.value ? 20 : 10;

      // 初回ロードフラグをクリア（全時間ランキングなど、すでに詳細データがある場合も対応）
      if (isInitialLoad.value) {
        isInitialLoad.value = false;
      }

      // フィルタ適用後のデータから未ロードのアイテムを取得
      final filteredData = enrichedData.where((n) {
        final novel = n.novel;
        // 連載中フィルタ
        if (filterState.showOnlyOngoing && novel.title != null && novel.end != 1) {
          return false;
        }
        // ジャンルフィルタ
        if (filterState.selectedGenre != null && novel.title != null && novel.genre != filterState.selectedGenre) {
          return false;
        }
        return true;
      }).toList();

      final unloadedItems = filteredData
          .where((n) => n.novel.title == null && !loadedData.value.containsKey(n.novel.ncode))
          .take(itemsToLoad)
          .toList();

      if (unloadedItems.isEmpty) {
        return; // All items loaded
      }

      isLoadingMore.value = true;

      final ncodes = unloadedItems.map((n) => n.novel.ncode).toList();

      try {
        final apiService = ref.read(apiServiceProvider);
        final novelDetails = await apiService.fetchMultipleNovelsInfo(ncodes);

        if (!context.mounted) return;

        // ロード済みデータを更新
        final newLoadedData = Map<String, EnrichedNovelData>.from(loadedData.value);
        for (final item in unloadedItems) {
          if (novelDetails.containsKey(item.novel.ncode)) {
            final details = novelDetails[item.novel.ncode]!;
            newLoadedData[item.novel.ncode] = EnrichedNovelData(
              novel: item.novel.copyWith(
                title: details.title,
                writer: details.writer,
                story: details.story,
                novelType: details.novelType,
                end: details.end,
                genre: details.genre,
                generalAllNo: details.generalAllNo,
                keyword: details.keyword,
                allPoint: details.allPoint,
              ),
              isInLibrary: item.isInLibrary,
            );
          }
        }
        loadedData.value = newLoadedData;
      } finally {
        isLoadingMore.value = false;
      }
    }

    return enrichedDataAsync.when(
      data: (enrichedData) {
        // 初回ロードを実行
        if (isInitialLoad.value && !isLoadingMore.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              unawaited(loadMore(enrichedData));
            }
          });
        }

        // 表示するデータ：
        // 1. 既に詳細データを持つアイテム（title != null）
        // 2. loadedDataに含まれるアイテム（プログレッシブローディング済み）
        // さらに、詳細ロード後にフィルタ条件を再適用
        final displayData = enrichedData
            .map((n) {
              // loadedDataに詳細があればそれを使う、なければ元のデータを使う
              if (loadedData.value.containsKey(n.novel.ncode)) {
                return loadedData.value[n.novel.ncode]!;
              } else if (n.novel.title != null) {
                // 既に詳細データを持っている場合はそのまま使う
                return n;
              }
              // 詳細未ロードのアイテムは除外
              return null;
            })
            .whereType<EnrichedNovelData>()
            .where((enrichedNovel) {
              final novel = enrichedNovel.novel;
              // 連載中フィルタ
              if (filterState.showOnlyOngoing && novel.end != 1) {
                return false;
              }
              // ジャンルフィルタ
              if (filterState.selectedGenre != null &&
                  novel.genre != filterState.selectedGenre) {
                return false;
              }
              return true;
            })
            .toList();

        // フィルタ適用後の総アイテム数を計算（詳細未ロードのアイテムも含む）
        final filteredTotalCount = enrichedData.where((n) {
          final novel = n.novel;
          // 詳細未ロードのアイテムは含める（フィルタ判定できないため）
          if (novel.title == null) return true;
          // 連載中フィルタ
          if (filterState.showOnlyOngoing && novel.end != 1) return false;
          // ジャンルフィルタ
          if (filterState.selectedGenre != null &&
              novel.genre != filterState.selectedGenre) {
            return false;
          }
          return true;
        }).length;

        final hasMore = displayData.length < filteredTotalCount;

        return RefreshIndicator(
          onRefresh: () async {
            loadedData.value = {};
            isInitialLoad.value = true;
            ref.invalidate(enrichedRankingDataProvider(rankingType));
          },
          child: ListView(
            children: [
              ...displayData.map((enrichedItem) => NovelListTile(
                item: enrichedItem.novel,
                enrichedData: enrichedItem,
                isRanking: true,
              )),
              if (hasMore)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: isLoadingMore.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            onPressed: () => loadMore(enrichedData),
                            icon: const Icon(Icons.expand_more),
                            label: const Text('もっと見る'),
                          ),
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('エラーが発生しました: $error'),
      ),
    );
  }
}
