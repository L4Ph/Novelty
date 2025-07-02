import 'package:flutter/material.dart';
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
    try {
      final novelInfo = await _apiService.fetchNovelInfo(widget.ncode);
      if (!mounted) return;
      setState(() {
        _totalEpisodes = novelInfo.generalAllNo;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _fetchEpisodeData(int episode) async {
    try {
      final episodeData = await _apiService.fetchEpisode(widget.ncode, episode);
      if (!mounted) return;
      setState(() {
        _episodeTitle = episodeData.title;
        _currentEpisode = episode;
      });
    } catch (e) {
      // Handle error
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
                _fetchEpisodeData(index + 1);
              },
              itemBuilder: (context, index) {
                return NovelContent(
                  ncode: widget.ncode,
                  episode: index + 1,
                );
              },
            ),
    );
  }
}


