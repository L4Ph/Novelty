import 'package:flutter/material.dart';
import 'package:novelty/screens/novel_page.dart';

class TocPage extends StatelessWidget {
  final String ncode;
  final String title;
  final List<Map<String, dynamic>> episodes;
  final int novelType;

  const TocPage({
    super.key,
    required this.ncode,
    required this.title,
    required this.episodes,
    required this.novelType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: episodes.length,
        itemBuilder: (context, index) {
          final episode = episodes[index];
          final episodeTitle = episode['title'] as String? ?? 'No Title';
          return ListTile(
            title: Text(episodeTitle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovelPage(
                    ncode: ncode,
                    episode: index + 1,
                    title: title, // Pass the novel title
                    novelType: 1, // Always a series from TocPage
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
