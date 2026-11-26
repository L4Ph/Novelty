import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/providers/author_novels_provider.dart';
import 'package:novelty/widgets/novel_list_tile.dart';
import 'package:tiny_state/tiny_state.dart';

/// 作者の小説一覧ページ
class AuthorNovelsPage extends StatefulWidget {
  /// コンストラクタ
  const AuthorNovelsPage({required this.userId, super.key});

  /// 作者のユーザID
  final int userId;

  @override
  State<AuthorNovelsPage> createState() => _AuthorNovelsPageState();
}

class _AuthorNovelsPageState extends State<AuthorNovelsPage> {
  Async<List<NovelInfo>> _novels = const AsyncLoading();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_novels is! AsyncLoading<List<NovelInfo>>) return;
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final novels = await fetchAuthorNovels(
        context.services.api,
        context.services.settings,
        widget.userId,
      );
      if (!mounted) return;
      setState(() => _novels = AsyncData(novels));
    } on Object catch (error, stackTrace) {
      debugPrint('作者の作品一覧取得エラー: $error\n$stackTrace');
      if (!mounted) return;
      setState(() => _novels = AsyncError(error, stackTrace));
    }
  }

  @override
  Widget build(BuildContext context) {
    final novelsAsync = _novels;

    return Scaffold(
      appBar: AppBar(
        title: switch (novelsAsync) {
          AsyncData(:final value) when value.isNotEmpty => Text(
            value.first.writer ?? '作者の作品',
          ),
          _ => const Text('作者の作品'),
        },
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
        error: (error, stackTrace) => const Center(
          child: Text('データの読み込み中に問題が発生しました'),
        ),
      ),
    );
  }
}
