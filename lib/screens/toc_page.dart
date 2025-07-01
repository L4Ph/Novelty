import 'package:flutter/material.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/screens/novel_page.dart';

class TocPage extends StatefulWidget {
  final String ncode;
  final String title;

  const TocPage({super.key, required this.ncode, required this.title});

  @override
  State<TocPage> createState() => _TocPageState();
}

class _TocPageState extends State<TocPage> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _novelInfo;

  @override
  void initState() {
    super.initState();
    _novelInfo = _apiService.fetchNovelInfo(widget.ncode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _novelInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          final novelInfo = snapshot.data!;
          final episodes = novelInfo['episodes'] as List;

          return ListView.builder(
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
                        ncode: widget.ncode,
                        episode: index + 1,
                        title: episode['title'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
