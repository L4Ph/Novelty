import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/database_service.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final DatabaseService _databaseService = DatabaseService();
  late Future<List<NovelInfo>> _libraryNovels;
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    _loadLibraryNovels();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    if (_router != router) {
      _router?.routerDelegate.removeListener(_routerListener);
      _router = router;
      _router?.routerDelegate.addListener(_routerListener);
    }
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_routerListener);
    super.dispose();
  }

  void _routerListener() {
    if (mounted && _router?.routerDelegate.currentConfiguration.uri.toString() == '/') {
      _loadLibraryNovels();
    }
  }

  void _loadLibraryNovels() {
    setState(() {
      _libraryNovels = _databaseService.getLibraryNovels();
    });
  }

  void _removeNovelFromLibrary(String ncode) async {
    await _databaseService.removeNovelFromLibrary(ncode);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ライブラリから削除しました')),
    );
    _loadLibraryNovels();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NovelInfo>>(
      future: _libraryNovels,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('ライブラリに小説がありません'));
        }

        final novels = snapshot.data!;
        return ListView.builder(
          itemCount: novels.length,
          itemBuilder: (context, index) {
            final novel = novels[index];
            return ListTile(
              title: Text(novel.title ?? ''),
              subtitle: Text(novel.writer ?? ''),
              onTap: () {
                if (novel.ncode != null) {
                  context.push('/toc/${novel.ncode}');
                }
              },
              onLongPress: () {
                if (novel.ncode != null) {
                  showDialog(
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
                          onPressed: () {
                            if (novel.ncode != null) {
                              _removeNovelFromLibrary(novel.ncode!);
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('削除'),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
