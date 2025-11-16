import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/domain/novel_enrichment.dart';
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

    // ScrollControllerをuseMemoizedで管理
    final scrollController = useMemoized(ScrollController.new, []);

    // Providerからフィルタリングされたデータを取得
    final filteredDataAsync = ref.watch(
      filteredEnrichedRankingDataProvider(rankingType),
    );

    // ローディング処理
    Future<void> loadMore(List<EnrichedNovelData> filteredData) async {
      if (isLoadingMore.value || !context.mounted) return;

      final itemsToLoad = isInitialLoad.value ? 20 : 10;

      // フィルタリングされたデータから未ロードのアイテムを取得
      final unloadedItems = filteredData
          .where((n) => n.novel.title == null && !loadedData.value.containsKey(n.novel.ncode))
          .take(itemsToLoad)
          .toList();

      if (unloadedItems.isEmpty) {
        return; // All items loaded
      }

      isLoadingMore.value = true;
      if (isInitialLoad.value) {
        isInitialLoad.value = false;
      }

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

        // Providerを更新して再フィルタリングを促す
        ref.invalidate(enrichedRankingDataProvider(rankingType));
      } finally {
        isLoadingMore.value = false;
      }
    }

    // スクロールリスナー
    useEffect(
      () {
        void onScroll() {
          if (isLoadingMore.value || !context.mounted) return;

          final maxScroll = scrollController.position.maxScrollExtent;
          final currentScroll = scrollController.position.pixels;
          const delta = 200.0;

          if (currentScroll >= maxScroll - delta) {
            filteredDataAsync.whenData((filteredData) {
              unawaited(loadMore(filteredData));
            });
          }
        }

        scrollController.addListener(onScroll);
        return () => scrollController.removeListener(onScroll);
      },
      [isLoadingMore],
    );

    return filteredDataAsync.when(
      data: (filteredData) {
        // 初回ロードを実行
        if (isInitialLoad.value && !isLoadingMore.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              unawaited(loadMore(filteredData));
            }
          });
        }

        // 表示するデータ：フィルタリングされたデータのうち、詳細がロード済みのもの
        final displayData = filteredData
            .where((n) => loadedData.value.containsKey(n.novel.ncode))
            .map((n) => loadedData.value[n.novel.ncode]!)
            .toList();

        final hasMore = displayData.length < filteredData.where((n) => n.novel.title != null || loadedData.value.containsKey(n.novel.ncode)).length;

        return RefreshIndicator(
          onRefresh: () async {
            loadedData.value = {};
            isInitialLoad.value = true;
            ref.invalidate(enrichedRankingDataProvider(rankingType));
          },
          child: ListView.builder(
            controller: scrollController,
            itemCount: displayData.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == displayData.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final enrichedItem = displayData[index];
              return NovelListTile(
                item: enrichedItem.novel,
                enrichedData: enrichedItem,
                isRanking: true,
              );
            },
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
