import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/providers/library_search_provider.dart';

/// ライブラリ検索ダイアログ
class LibrarySearchDialog extends ConsumerStatefulWidget {
  /// コンストラクタ
  const LibrarySearchDialog({super.key});

  @override
  ConsumerState<LibrarySearchDialog> createState() => _LibrarySearchDialogState();
}

class _LibrarySearchDialogState extends ConsumerState<LibrarySearchDialog> {
  late TextEditingController _searchController;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query != _currentQuery) {
      _currentQuery = query;
      ref.read(librarySearchProvider.notifier).searchNovels(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(librarySearchProvider);

    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // 検索バー
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'タイトル、著者、あらすじ、キーワードで検索',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(librarySearchProvider.notifier).clearSearch();
                      _currentQuery = '';
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  // リアルタイム検索を実装
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (value == _searchController.text) {
                      _performSearch();
                    }
                  });
                },
                onSubmitted: (value) => _performSearch(),
              ),
            ),
            // 検索結果
            Expanded(
              child: searchResults.when(
                data: (novels) {
                  if (_currentQuery.isEmpty) {
                    return const Center(
                      child: Text('検索キーワードを入力してください'),
                    );
                  }
                  
                  if (novels.isEmpty) {
                    return const Center(
                      child: Text('検索結果がありません'),
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
                          Navigator.of(context).pop();
                          context.push('/novel/${novel.ncode}');
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text('エラーが発生しました: $error'),
                ),
              ),
            ),
            // 閉じるボタン
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('閉じる'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
