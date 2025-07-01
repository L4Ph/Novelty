import 'package:flutter/material.dart';
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
  PageController? _pageController;
  late int _currentEpisode;

  @override
  void initState() {
    super.initState();
    _currentEpisode = widget.episode ?? 1;
    if (widget.novelType != 2) {
      _pageController = PageController(initialPage: _currentEpisode - 1);
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.novelType == 2 ? widget.title : '${widget.title} - $_currentEpisode話'),
      ),
      body: widget.novelType == 2
          ? NovelContent(ncode: widget.ncode, episode: 1)
          : PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentEpisode = index + 1;
                });
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
