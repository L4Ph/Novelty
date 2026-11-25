import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/providers/ranking_provider.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// ランキングリストを表示するウィジェット。
class RankingList extends StatefulWidget {
  /// コンストラクタ。
  const RankingList({
    required this.source,
    required this.rankingType,
    required this.filter,
    super.key,
  });

  /// 提供サイト（プロバイダ）。
  final NovelSource source;

  /// ランキングの種類。
  final String rankingType;

  /// このタブのフィルタ。親が所有し、タブ切り替えを跨いで保持される。
  final RankingFilterController filter;

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  final _scrollController = ScrollController();
  RankingController? _ranking;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // didChangeDependencies fires again on theme/MediaQuery changes; binding
    // twice would double the scroll listener and the initial fetch.
    if (_ranking != null) return;
    final ranking = _ranking = RankingController(
      source: widget.source,
      rankingType: widget.rankingType,
      filter: widget.filter,
      api: context.services.api,
      settings: context.services.settings,
      sites: context.services.sites,
    );
    _scrollController.addListener(_onScroll);
    ranking.start();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _ranking?.dispose();
    super.dispose();
  }

  // 下端に近づいたら次のページを読み込む
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (_scrollController.offset >= maxScroll * 0.8) {
      unawaited(_ranking!.fetchNextPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _ranking!,
      builder: (context, _) => _buildBody(_ranking!.state),
    );
  }

  Widget _buildBody(RankingState rankingState) {
    // 初回ロード失敗時のリトライボタン
    if (rankingState.error != null && rankingState.novels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('読み込みに失敗しました'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => unawaited(_ranking!.refresh()),
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
      onRefresh: _ranking!.refresh,
      child: ListView.builder(
        controller: _scrollController,
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

          return NovelListTile(
            item: rankingState.novels[index],
            // 順位は現在のリストのインデックス + 1
            rank: index + 1,
          );
        },
      ),
    );
  }
}
