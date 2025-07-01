import 'package:flutter/material.dart';
import 'package:novelty/widgets/novel_episode_page.dart';

class NovelPage extends StatefulWidget {
  final String ncode;
  final String title;
  final int? episode;

  const NovelPage({
    super.key,
    required this.ncode,
    required this.title,
    this.episode,
  });

  @override
  State<NovelPage> createState() => _NovelPageState();
}

class _NovelPageState extends State<NovelPage> {
  late PageController _pageController;
  late int _currentEpisode;

  @override
  void initState() {
    super.initState();
    _currentEpisode = widget.episode ?? 1;
    _pageController = PageController(initialPage: _currentEpisode - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} - $_currentEpisode話'),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentEpisode = index + 1;
          });
        },
        itemBuilder: (context, index) {
          return NovelEpisodePage(
            ncode: widget.ncode,
            episode: index + 1,
            pageController: _pageController,
          );
        },
      ),
    );
  }
}
