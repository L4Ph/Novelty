import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/providers/library_search_provider.dart';

class NovelSearchDelegate extends SearchDelegate<Novel?> {
  final WidgetRef ref;

  NovelSearchDelegate(this.ref);

  @override
  String get searchFieldLabel => 'ライブラリを検索';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    ref.read(librarySearchQueryProvider.notifier).update(query);
    final searchResults = ref.watch(librarySearchResultsProvider);

    return searchResults.when(
      data: (novels) {
        if (query.isNotEmpty && novels.isEmpty) {
          return const Center(
            child: Text('小説が見つかりません'),
          );
        }
        return ListView.builder(
          itemCount: novels.length,
          itemBuilder: (context, index) {
            final novel = novels[index];
            return ListTile(
              title: Text(novel.title ?? ''),
              subtitle: Text(novel.writer ?? ''),
              onTap: () {
                close(context, novel);
                context.push('/novel/${novel.ncode}');
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('エラー: $err')),
    );
  }
}
