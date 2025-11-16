import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/providers/library_provider.dart';

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
            onRefresh: () async => ref.invalidate(libraryNovelsProvider),
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
