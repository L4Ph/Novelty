import 'package:flutter/material.dart';
import 'package:novelty/widgets/novel_content.dart';

class NovelPage extends StatelessWidget {
  final String ncode;
  final String title;
  final int? episode;
  final int novelType;

  const NovelPage(
      {super.key,
      required this.ncode,
      required this.title,
      this.episode,
      required this.novelType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: NovelContent(ncode: ncode, episode: episode ?? 1),
    );
  }
}
