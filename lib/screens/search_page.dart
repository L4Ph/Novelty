import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// 小説検索画面
class SearchPage extends HookConsumerWidget {
  /// コンストラクタ
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final query = useState('');
    final db = ref.watch(appDatabaseProvider);

    // 検索実行
    final searchFuture = useMemoized(() async {
      if (query.value.trim().isEmpty) {
        return null;
      }
      return Future.wait([
        db.searchNovels(query.value),
        db.searchEpisodes(query.value),
      ]);
    }, [query.value]);

    final snapshot = useFuture(searchFuture);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'ライブラリを検索...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            query.value = value;
          },
        ),
        actions: [
          if (query.value.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                query.value = '';
              },
            ),
        ],
      ),
      body: query.value.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'タイトル、作者、あらすじ、\nエピソード本文から検索できます',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : _buildResults(context, snapshot),
    );
  }

  Widget _buildResults(
    BuildContext context,
    AsyncSnapshot<List<Object>?> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    final results = snapshot.data;
    if (results == null) {
      return const SizedBox.shrink();
    }

    final novels = results[0] as List<Novel>;
    final episodes = results[1] as List<EpisodeSearchResult>;

    if (novels.isEmpty && episodes.isEmpty) {
      return const Center(child: Text('見つかりませんでした'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 小説の検索結果
        if (novels.isNotEmpty) ...[
          Text(
            '小説 (${novels.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...novels.map((novel) {
            final novelData = RankingResponse(
              ncode: novel.ncode,
              title: novel.title,
              writer: novel.writer,
              genre: novel.genre,
              novelType: novel.novelType,
              end: novel.end,
              allPoint: novel.allPoint,
            );
            return NovelListTile(item: novelData);
          }),
          const Divider(height: 32),
        ],

        // エピソードの検索結果
        if (episodes.isNotEmpty) ...[
          Text(
            'エピソード (${episodes.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...episodes.map((episode) {
            return ListTile(
              title: Text(
                episode.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                episode.novelTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                // エピソードビューアーへ遷移
                unawaited(
                  context.push(
                    '/novel/${episode.ncode}/${episode.episodeId}',
                  ),
                );
              },
            );
          }),
        ],
      ],
    );
  }
}
