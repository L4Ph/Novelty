import 'package:flutter/material.dart';
import 'package:novelty/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:novelty/utils/settings_provider.dart';

class NovelContent extends StatefulWidget {
  final String ncode;
  final int episode;

  const NovelContent({super.key, required this.ncode, required this.episode});

  @override
  State<NovelContent> createState() => _NovelContentState();
}

class _NovelContentState extends State<NovelContent> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _episodeData;

  @override
  void initState() {
    super.initState();
    _episodeData = _apiService.fetchEpisode(widget.ncode, widget.episode);
  }

  @override
  void didUpdateWidget(NovelContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ncode != oldWidget.ncode || widget.episode != oldWidget.episode) {
      setState(() {
        _episodeData = _apiService.fetchEpisode(widget.ncode, widget.episode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return FutureBuilder<Map<String, dynamic>>(
      future: _episodeData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No content available.'));
        }
        else {
          final content = snapshot.data!['body'] as String? ?? '本文がありません。';
          return Container(
            color: settings.colorScheme.surface,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Text(
                content.replaceAll(RegExp(r'<br>'), '\n'),
                style: TextStyle(
                  fontSize: settings.fontSize,
                  color: settings.colorScheme.onSurface,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
