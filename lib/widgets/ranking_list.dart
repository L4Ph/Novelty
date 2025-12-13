import 'dart:async';

import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/providers/ranking_provider.dart';
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
    // RankingNotifierから状態を取得
    final rankingState = ref.watch(rankingProvider(rankingType));

    if (kDebugMode) {
      print(
        'DEBUG: RankingList build ($rankingType). State novels count: ${rankingState.novels.length}',
      );
      if (rankingState.novels.isNotEmpty) {
        print(
          'DEBUG: RankingList first novel: ${rankingState.novels.first.title}',
        );
      }
    }

    // スクロール通知を監視するためのリスナー
    final scrollController = useScrollController();

    // 無限スクロールの検知
    // NotificationListenerを使用しても良いが、ScrollControllerで制御するほうが一般的
    // 下端に近づいたら次のページを読み込む
    useEffect(() {
      void onScroll() {
        if (!scrollController.hasClients) return;
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.offset;

        // 画面の高さの0.8倍手前で読み込み開始
        if (currentScroll >= (maxScroll * 0.8)) {
          unawaited(
            ref.read(rankingProvider(rankingType).notifier).fetchNextPage(),
          );
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    // 初回ロード失敗時のリトライボタン
    if (rankingState.error != null && rankingState.novels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('読み込みに失敗しました'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                unawaited(
                  ref.read(rankingProvider(rankingType).notifier).refresh(),
                );
              },
              child: const Text('リトライ'),
            ),
          ],
        ),
      );
    }

    if (rankingState.isLoading && rankingState.novels.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(rankingProvider(rankingType).notifier).refresh();
      },
      child: ListView.builder(
        controller: scrollController,
        // アイテム数 + ローディングインジケータ（必要な場合）
        itemCount:
            rankingState.novels.length + (rankingState.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == rankingState.novels.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final novel = rankingState.novels[index];
          // 順位は現在のリストのインデックス + 1
          final rank = index + 1;

          return NovelListTile(
            item: novel,
            rank: rank,
            // enrichedData: ... ライブラリ状態が必要ならここで取得
          );
        },
      ),
    );
  }
}
