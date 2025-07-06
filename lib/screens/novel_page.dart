import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/services/database_service.dart';
import 'package:novelty/widgets/novel_content.dart';

class NovelPage extends ConsumerStatefulWidget {
  const NovelPage({super.key, required this.ncode, this.episode});
  final String ncode;
  final int? episode;

  @override
  ConsumerState<NovelPage> createState() => _NovelPageState();
}

class _NovelPageState extends ConsumerState<NovelPage> {
  final _apiService = ApiService();
  late DatabaseService _databaseService;
  PageController? _pageController;
  late int _currentEpisode;
  var _episodeSubtitle = '';
  var _novelTitle = '';
  var _errorMessage = '';
  int? _totalEpisodes;
  int? _novelType;

  final LruMap<int, Future<Episode>> _episodeCache = LruMap(maximumSize: 5);

  @override
  void initState() {
    super.initState();
    _databaseService = ref.read(databaseServiceProvider);
    _currentEpisode = widget.episode ?? 1;
    _pageController = PageController(initialPage: _currentEpisode - 1);
    _fetchNovelInfo();
    // 初期状態では基本情報とエピソード番号を履歴に追加
    _databaseService.addNovelToHistory(
      widget.ncode,
      lastEpisode: _currentEpisode,
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  // 履歴追加メソッドは不要になったため削除

  Future<void> _fetchNovelInfo() async {
    try {
      final novelInfo = await _apiService.fetchNovelInfo(widget.ncode);
      if (!mounted) {
        return;
      }

      // 短編小説の場合は、エピソード番号を1として扱う
      if (novelInfo.novelType == 2) {
        setState(() {
          _currentEpisode = 1;
          _novelTitle = novelInfo.title ?? '';
          _totalEpisodes = 1;
          _novelType = novelInfo.novelType;
        });

        // 小説情報が取得できたら、タイトル、作者名、エピソード番号を含めて履歴を更新
        await _databaseService.addNovelToHistory(
          widget.ncode,
          title: novelInfo.title,
          writer: novelInfo.writer,
          lastEpisode: _currentEpisode,
        );

        await _fetchEpisodeData(1);
        return;
      }

      setState(() {
        _novelTitle = novelInfo.title ?? '';
        _totalEpisodes = novelInfo.generalAllNo ?? 1;
        _novelType = novelInfo.novelType;
      });

      // 小説情報が取得できたら、タイトル、作者名、エピソード番号を含めて履歴を更新
      await _databaseService.addNovelToHistory(
        widget.ncode,
        title: novelInfo.title,
        writer: novelInfo.writer,
        lastEpisode: _currentEpisode,
      );
      await _fetchEpisodeData(_currentEpisode);
    } on Exception catch (e) {
      setState(() {
        _errorMessage = 'エラーが発生しました: $e';
      });
    }
  }

  Future<Episode> _fetchEpisodeData(int episode) {
    if (_episodeCache.containsKey(episode)) {
      return _episodeCache[episode]!;
    }
    final future = _apiService.fetchEpisode(widget.ncode, episode);
    _episodeCache[episode] = future;
    future
        .then((data) {
          if (!mounted) {
            return;
          }
          if (_currentEpisode == episode) {
            setState(() {
              _episodeSubtitle = data.subtitle ?? '';
            });
          }
        })
        .catchError((Object e) {
          if (mounted) {
            _episodeCache.remove(episode);
          }
          throw Exception(e);
        });

    // Prefetch next and previous episodes
    _prefetchEpisode(episode + 1);
    _prefetchEpisode(episode - 1);

    return future;
  }

  void _prefetchEpisode(int episode) {
    if (episode > 0 && (_totalEpisodes == null || episode <= _totalEpisodes!)) {
      if (!_episodeCache.containsKey(episode)) {
        _apiService
            .fetchEpisode(widget.ncode, episode)
            .then((ep) {
              _episodeCache[episode] = Future.value(ep);
            })
            .catchError((_) {
              // Prefetch failed, ignore.
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarTitle = _episodeSubtitle.isEmpty
        ? _novelTitle
        : (_novelType == 2
              ? _episodeSubtitle
              : '$_novelTitle - $_episodeSubtitle');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(appBarTitle),
      ),
      body: _errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('戻る'),
                  ),
                ],
              ),
            )
          : _totalEpisodes == null
              ? const Center(child: CircularProgressIndicator())
              : PageView.builder(
                  controller: _pageController,
                  itemCount: _totalEpisodes,
                  onPageChanged: (index) {
                    final newEpisode = index + 1;
                    setState(() {
                      _currentEpisode = newEpisode;
                    });
                    _fetchEpisodeData(_currentEpisode);

                    // エピソードが変わったら履歴を更新
                    _databaseService.addNovelToHistory(
                      widget.ncode,
                      title: _novelTitle,
                      lastEpisode: newEpisode,
                    );
                  },
                  itemBuilder: (context, index) {
                    return FutureBuilder<Episode>(
                      future: _fetchEpisodeData(index + 1),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return const Center(
                              child: Text('No content available.'));
                        } else {
                          return NovelContent(
                            ncode: widget.ncode,
                            episode: index + 1,
                            initialData: snapshot.data,
                          );
                        }
                      },
                    );
                  },
                ),
    );
  }
}

class LruMap<K, V> {
  LruMap({required int maximumSize}) : _maximumSize = maximumSize;
  final int _maximumSize;
  final _map = <K, V>{};

  V? operator [](K key) {
    final value = _map.remove(key);
    if (value != null) {
      _map[key] = value;
    }
    return value;
  }

  void operator []=(K key, V value) {
    _map.remove(key);
    _map[key] = value;
    if (_map.length > _maximumSize) {
      _map.remove(_map.keys.first);
    }
  }

  bool containsKey(K key) => _map.containsKey(key);

  V? remove(K key) => _map.remove(key);

  void clear() => _map.clear();
}

