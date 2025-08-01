import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/repositories/novel_repository.dart';

/// 小説のライブラリを表示するためのプロバイダー。
final libraryNovelsProvider = FutureProvider<List<Novel>>((ref) async {
  final db = ref.watch(appDatabaseProvider);

  // LibraryNovelsテーブルとNovelsテーブルをJOINして詳細情報を取得
  final libraryNovels = await db.getLibraryNovels();
  final novels = <Novel>[];

  for (final libNovel in libraryNovels) {
    final novel = await db.getNovel(libNovel.ncode);
    if (novel != null) {
      novels.add(novel);
    }
  }

  return novels;
});

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
          const IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
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
          return RefreshIndicator(
            onRefresh: () async {
              // ライブラリ小説更新を実行
              final repository = ref.read(novelRepositoryProvider);
              final updatedNcodes = await repository.updateLibraryNovels();
              
              // 更新があった場合の通知
              if (updatedNcodes.isNotEmpty && context.mounted) {
                final message = updatedNcodes.length == 1
                    ? '1つの小説が更新されました'
                    : '${updatedNcodes.length}つの小説が更新されました';
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
              
              // ライブラリ情報を再取得
              ref.invalidate(libraryNovelsProvider);
            },
            child: ListView.builder(
              itemCount: novels.length,
              itemBuilder: (context, index) {
                final novel = novels[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: ListTile(
                    title: Text(novel.title ?? ''),
                    subtitle: Text(novel.writer ?? ''),
                    onTap: () {
                      context.push('/novel/${novel.ncode}');
                    },
                    onLongPress: () {
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
                                    .read(appDatabaseProvider)
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
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
