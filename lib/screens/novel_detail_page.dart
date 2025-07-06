import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/services/database_service.dart';
import 'package:novelty/widgets/novel_content.dart';

class NovelDetailPage extends ConsumerStatefulWidget {
  const NovelDetailPage({super.key, required this.ncode});
  final String ncode;

  @override
  ConsumerState<NovelDetailPage> createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends ConsumerState<NovelDetailPage> {
  final _apiService = ApiService();
  late DatabaseService _databaseService;
  NovelInfo? _novelInfo;
  Episode? _shortStoryEpisode;
  var _isLoading = true;
  var _isInLibrary = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // ref.readはinitState内で安全に使用できます
    _databaseService = ref.read(databaseServiceProvider);
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
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load novel info: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
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

    // 短編小説 (novelType == 2) またはエピソードリストが空の場合の処理を統合
    final isShortStory =
        novelInfo.novelType == 2 || (novelInfo.episodes?.isEmpty ?? true);

    if (isShortStory) {
      // 本文がまだ取得できていない場合
      if (_shortStoryEpisode == null && _errorMessage.isEmpty) {
        // ビルド中に非同期処理を呼び出すのは良くないため、
        // _fetchNovelInfo 内で処理するように変更済み
        // ここではローディング表示に留める
        return Scaffold(
          appBar: AppBar(title: Text(novelInfo.title ?? '')),
          body: const Center(child: CircularProgressIndicator()),
        );
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
        body: _shortStoryEpisode == null
            ? Center(child: Text(_errorMessage))
            : NovelContent(
                ncode: widget.ncode,
                episode: 1,
                initialData: _shortStoryEpisode,
              ),
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
                  title: Text(
                    '作品情報',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  childrenPadding: const EdgeInsets.all(16),
                  children: [
                    if (novelInfo.writer != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '作者: ${novelInfo.writer}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
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
                    final episodeUrl = episode.url;
                    if (episodeUrl != null) {
                      // URLからエピソード番号を正規表現で抽出
                      final match = RegExp(r'/(\d+)/$').firstMatch(episodeUrl);
                      if (match != null) {
                        final episodeNumber = match.group(1);
                        if (episodeNumber != null) {
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
