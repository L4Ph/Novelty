import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/database/database.dart';

final libraryNovelsProvider = FutureProvider<List<Novel>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.novels)..where((tbl) => tbl.cachedAt.isNotNull())).get();
});

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryNovels = ref.watch(libraryNovelsProvider);

    return libraryNovels.when(
      data: (novels) {
        if (novels.isEmpty) {
          return const Center(child: Text('ライブラリに小説がありません'));
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(libraryNovelsProvider.future),
          child: ListView.builder(
            itemCount: novels.length,
            itemBuilder: (context, index) {
              final novel = novels[index];
              return ListTile(
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
                      content: Text('${novel.title}をライブラリから削除しますか？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('キャンセル'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await ref
                                .read(appDatabaseProvider)
                                .deleteNovel(novel.ncode);
                            ref.invalidate(libraryNovelsProvider);
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('ライブラリから削除しました')),
                              );
                            }
                          },
                          child: const Text('削除'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
