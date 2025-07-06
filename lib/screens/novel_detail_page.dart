import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/main.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/services/drift_database_service.dart';
import 'package:novelty/widgets/novel_content.dart';

class NovelDetailPage extends ConsumerStatefulWidget {
  const NovelDetailPage({super.key, required this.ncode});
  final String ncode;

  @override
  ConsumerState<NovelDetailPage> createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends ConsumerState<NovelDetailPage> {
  final _apiService = ApiService();
  late DriftDatabaseService _databaseService;
  NovelInfo? _novelInfo;
  Episode? _shortStoryEpisode;
  var _isLoading = true;
  var _isInLibrary = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _databaseService = ref.read(driftDatabaseServiceProvider);
    _fetchNovelInfo();
    _checkIfInLibrary();
    // 初期状態では基本情報だけで履歴に追加
    // 詳細ページでは特定のエピソードを表示していないのでlastEpisodeは指定しない
    _databaseService.addNovelToHistory(widget.ncode);
  }

  

  Future<void> _fetchNovelInfo() async {
    try {
      final novelInfo = await _apiService.fetchNovelInfo(widget.ncode);
      if (!mounted) return;

      setState(() {
        _novelInfo = novelInfo;
      });
      
      // 小説情報が取得できたら、タイトルと作者名を含めて履歴を更新
      await _databaseService.addNovelToHistory(
        widget.ncode,
        title: novelInfo.title,
        writer: novelInfo.writer,
      );

      // 短編小説の場合は本文も取得
      if (novelInfo.novelType == 2) {
        final episode = await _apiService.fetchEpisode(widget.ncode, 1);
        if (!mounted) return;
        setState(() {
          _shortStoryEpisode = episode;
        });
      }

      setState(() {
        _isLoading = false;
      });
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load novel info: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkIfInLibrary() async {
    final isInLibrary = await _databaseService.isNovelInLibrary(widget.ncode);
    if (mounted) {
      setState(() {
        _isInLibrary = isInLibrary;
      });
    }
  }

  Future<void> _toggleLibraryStatus() async {
    if (_novelInfo == null) return;
    if (!mounted) return;

    if (_isInLibrary) {
      await _databaseService.removeNovelFromLibrary(widget.ncode);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ライブラリから削除しました')),
        );
      }
    } else {
      _novelInfo!.ncode = widget.ncode;
      await _databaseService.addNovelToLibrary(_novelInfo!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ライブラリに追加しました')),
        );
      }
    }
    await _checkIfInLibrary();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_errorMessage)),
      );
    }

    final novelInfo = _novelInfo!;

    // 短編小説の場合は本文を表示
    if (novelInfo.novelType == 2) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(novelInfo.title ?? ''),
          actions: [
            IconButton(
              icon: Icon(_isInLibrary ? Icons.favorite : Icons.favorite_border),
              onPressed: _toggleLibraryStatus,
            ),
          ],
        ),
        body: _shortStoryEpisode == null
            ? const Center(child: CircularProgressIndicator())
            : NovelContent(
                ncode: widget.ncode,
                episode: 1,
                initialData: _shortStoryEpisode,
              ),
      );
    }
    
    // エピソードリストが空の場合は、短編小説として扱う
    if (novelInfo.episodes == null || novelInfo.episodes!.isEmpty) {
      // 短編小説の場合は本文を取得して表示
      if (_shortStoryEpisode == null) {
        // まだ本文を取得していない場合は取得を開始
        _apiService.fetchEpisode(widget.ncode, 1).then((episode) {
          if (mounted) {
            setState(() {
              _shortStoryEpisode = episode;
            });
          }
        }).catchError((Object error) {
          if (mounted) {
            setState(() {
              _errorMessage = 'エラーが発生しました: $error';
            });
          }
        });
      }
      
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(novelInfo.title ?? ''),
          actions: [
            IconButton(
              icon: Icon(_isInLibrary ? Icons.favorite : Icons.favorite_border),
              onPressed: _toggleLibraryStatus,
            ),
          ],
        ),
        body: _errorMessage.isNotEmpty
            ? Center(child: Text(_errorMessage))
            : (_shortStoryEpisode == null
                ? const Center(child: CircularProgressIndicator())
                : NovelContent(
                    ncode: widget.ncode,
                    episode: 1,
                    initialData: _shortStoryEpisode,
                  )),
      );
    }

    // 連載小説の場合は目次を表示
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(novelInfo.title ?? '目次'),
        actions: [
          IconButton(
            icon: Icon(_isInLibrary ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleLibraryStatus,
          ),
        ],
      ),
      body: Column(
        children: [
          // 小説情報表示
          if (novelInfo.story != null && novelInfo.story!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Card(
                child: ExpansionTile(
                  // Replaced Padding with ExpansionTile
                  title: Text(
                    '作品情報', // You can set a title for the collapsible section
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  childrenPadding: const EdgeInsets.all(
                    16,
                  ), // Padding for the content inside the expanded tile
                  children: [
                    if (novelInfo.writer != null)
                      Text(
                        '作者: ${novelInfo.writer}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      novelInfo.story!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          // エピソードリスト
          Expanded(
            child: ListView.builder(
              itemCount: novelInfo.episodes?.length ?? 0,
              itemBuilder: (context, index) {
                final episode = novelInfo.episodes![index];
                final episodeTitle = episode.subtitle ?? 'No Title';
                return ListTile(
                  title: Text(episodeTitle),
                  subtitle: episode.update != null
                      ? Text('更新: ${episode.update}')
                      : null,
                  onTap: () {
                    // エピソードのURLから番号を抽出
                    final episodeUrl = episode.url;
                    if (episodeUrl != null) {
                      // 短編小説の場合は特別な処理
                      if (novelInfo.novelType == 2) {
                        context.push('/novel/${widget.ncode}');
                      } else {
                        final match = RegExp(r'/(\d+)/$').firstMatch(episodeUrl);
                        if (match != null) {
                          final episodeNumber = match.group(1);
                          context.push('/novel/${widget.ncode}/$episodeNumber');
                        }
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
