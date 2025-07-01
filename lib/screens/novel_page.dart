import 'package:flutter/material.dart';
import 'package:novelty/widgets/novel_content.dart';

class NovelPage extends StatelessWidget {
  final String ncode;
  final String title;
  final int? episode;
  final String? body;

  const NovelPage({
    super.key,
    required this.ncode,
    required this.title,
    this.episode,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body != null
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                body!.replaceAll(RegExp(r'<br>'), '\n'),
                style: const TextStyle(fontSize: 16.0),
              ),
            )
          : NovelContent(ncode: ncode, episode: episode ?? 1),
    );
  }
}
