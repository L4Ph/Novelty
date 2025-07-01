import 'package:flutter/material.dart';
import 'package:Novelty/screens/novel_page.dart';

class TocPage extends StatelessWidget {
  final String ncode;
  final String title;
  final List<dynamic> episodes;
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
          return ListTile(
            title: Text(episode['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovelPage(
                    ncode: ncode,
                    episode: index + 1,
                    title: episode['title'],
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
