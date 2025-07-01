import 'package:flutter/material.dart';
import 'package:novelty/widgets/novel_content.dart';

class NovelEpisodePage extends StatelessWidget {
  final String ncode;
  final int episode;
  final PageController pageController;

  const NovelEpisodePage({
    super.key,
    required this.ncode,
    required this.episode,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return NovelContent(
      ncode: ncode,
      episode: episode,
    );
  }
}
