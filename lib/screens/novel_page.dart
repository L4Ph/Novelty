import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_content.dart';

class NovelPage extends StatefulWidget {
  final String ncode;
  final String title;
  final int? episode;
  final int novelType;

  const NovelPage({
    super.key,
    required this.ncode,
    required this.title,
    this.episode,
    required this.novelType,
  });

  @override
  State<NovelPage> createState() => _NovelPageState();
}

class _NovelPageState extends State<NovelPage> {
  final ApiService _apiService = ApiService();
  PageController? _pageController;
  late int _currentEpisode;
  String _episodeTitle = '';
  int? _totalEpisodes;

  final LruMap<int, Future<Episode>> _episodeCache = LruMap(maximumSize: 5);

  @override
  void initState() {
    super.initState();
    _currentEpisode = widget.episode ?? 1;
    _pageController = PageController(initialPage: _currentEpisode - 1);
    _fetchNovelInfo();
    _fetchEpisodeData(_currentEpisode);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Future<void> _fetchNovelInfo() async {
    if (widget.novelType == 2) {
      if (!mounted) return;
      setState(() {
        _totalEpisodes = 1;
      });
      return;
    }
    try {
      final novelInfo = await _apiService.fetchNovelInfo(widget.ncode);
      if (!mounted) return;
      setState(() {
        _totalEpisodes = novelInfo.generalAllNo ?? 1;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<Episode> _fetchEpisodeData(int episode) {
    if (_episodeCache.containsKey(episode)) {
      return _episodeCache[episode]!;
    }
    final future = _apiService.fetchEpisode(widget.ncode, episode);
    _episodeCache[episode] = future;
    future.then((data) {
      if (!mounted) return;
      if (_currentEpisode == episode) {
        setState(() {
          _episodeTitle = data.title ?? '';
        });
      }
    }).catchError((e) {
      if (mounted) {
        _episodeCache.remove(episode);
      }
      throw e;
    });

    // Prefetch next and previous episodes
    _prefetchEpisode(episode + 1);
    _prefetchEpisode(episode - 1);

    return future;
  }

  void _prefetchEpisode(int episode) {
    if (episode > 0 &&
        (_totalEpisodes == null || episode <= _totalEpisodes!)) {
      if (!_episodeCache.containsKey(episode)) {
        _apiService.fetchEpisode(widget.ncode, episode).then((ep) {
          _episodeCache[episode] = Future.value(ep);
        }).catchError((_) {
          // Prefetch failed, ignore.
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarTitle = _episodeTitle.isEmpty
        ? widget.title
        : (widget.novelType == 2
            ? _episodeTitle
            : '${widget.title} - $_episodeTitle');

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: _totalEpisodes == null
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              controller: _pageController,
              itemCount: _totalEpisodes,
              onPageChanged: (index) {
                setState(() {
                  _currentEpisode = index + 1;
                });
                _fetchEpisodeData(_currentEpisode);
              },
              itemBuilder: (context, index) {
                return FutureBuilder<Episode>(
                  future: _fetchEpisodeData(index + 1),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No content available.'));
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
  final int _maximumSize;
  final LinkedHashMap<K, V> _map = LinkedHashMap<K, V>();

  LruMap({required int maximumSize}) : _maximumSize = maximumSize;

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


