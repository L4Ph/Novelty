import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/screens/search_page.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// "ライブラリ"ページのウィジェット。
class LibraryPage extends ConsumerWidget {
  /// コンストラクタ。
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryNovels = ref.watch(libraryNovelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ライブラリ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              unawaited(
                showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  builder: (BuildContext context) {
                    return const DefaultTabController(
                      length: 2,
                      child: SizedBox(
                        height: 300,
                        child: Column(
                          children: <Widget>[
                            TabBar(
                              tabs: <Widget>[
                                Tab(text: '絞り込み'),
                                Tab(text: '並び替え'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: <Widget>[
                                  Center(child: Text('絞り込みオプション')),
                                  Center(child: Text('並び替えオプション')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: libraryNovels.when(
        data: (novels) {
          if (novels.isEmpty) {
            return const Center(child: Text('ライブラリに小説がありません'));
          }
          return ListView.builder(
            itemCount: novels.length,
            itemBuilder: (context, index) {
              final novel = novels[index];

              // NovelListTileを使用するため、RankingResponseに変換
              final novelData = RankingResponse(
                ncode: novel.ncode,
                title: novel.title,
                writer: novel.writer,
                genre: novel.genre,
                novelType: novel.novelType,
                end: novel.end,
                allPoint: novel.allPoint,
              );

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
