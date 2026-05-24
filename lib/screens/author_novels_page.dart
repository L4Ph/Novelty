import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/providers/author_novels_provider.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// 作者の小説一覧ページ
class AuthorNovelsPage extends ConsumerWidget {
  /// コンストラクタ
  const AuthorNovelsPage({required this.userId, super.key});

  /// 作者のユーザID
  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final novelsAsync = ref.watch(authorNovelsProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title:
            novelsAsync.whenOrNull(
              data: (novels) => novels.isNotEmpty
                  ? Text(novels.first.writer ?? '作者の作品')
                  : null,
            ) ??
            const Text('作者の作品'),
      ),
      body: novelsAsync.when(
        data: (novels) {
          if (novels.isEmpty) {
            return const Center(
              child: Text('作品が見つかりませんでした'),
            );
          }

          return ListView.builder(
            itemCount: novels.length,
            itemBuilder: (context, index) {
              final novel = novels[index];
              return NovelListTile(
                item: novel,
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) {
          debugPrint('作者の作品一覧取得エラー: $error\n$stackTrace');
          return const Center(
            child: Text('データの読み込み中に問題が発生しました'),
          );
        },
      ),
    );
  }
}
