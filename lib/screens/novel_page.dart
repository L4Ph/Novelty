import 'package:flutter/material.dart';
import 'package:novelty/services/api_service.dart';

class NovelPage extends StatefulWidget {
  final String ncode;
  final int episode;
  final String title;

  const NovelPage(
      {super.key,
      required this.ncode,
      required this.episode,
      required this.title});

  @override
  State<NovelPage> createState() => _NovelPageState();
}

class _NovelPageState extends State<NovelPage> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _episodeData;

  @override
  void initState() {
    super.initState();
    _episodeData = _apiService.fetchEpisode(widget.ncode, widget.episode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _episodeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          final episodeData = snapshot.data!;
          final body = episodeData['body'] as String;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(body),
          );
        },
      ),
    );
  }
}
