import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/settings_provider.dart';

class NovelContent extends ConsumerStatefulWidget {
  const NovelContent({
    super.key,
    required this.ncode,
    required this.episode,
    this.initialData,
  });
  final String ncode;
  final int episode;
  final Episode? initialData;

  @override
  ConsumerState<NovelContent> createState() => _NovelContentState();
}

class _NovelContentState extends ConsumerState<NovelContent> {
  final _apiService = ApiService();
  late Future<Episode> _episodeData;

  @override
  void initState() {
    super.initState();
    _loadEpisode();
  }

  @override
  void didUpdateWidget(NovelContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ncode != oldWidget.ncode ||
        widget.episode != oldWidget.episode) {
      _loadEpisode();
    }
  }

  void _loadEpisode() {
    if (widget.initialData != null) {
      _episodeData = Future.value(widget.initialData);
    } else {
      _episodeData = _apiService.fetchEpisode(widget.ncode, widget.episode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return settings.when(
      data: (settings) => FutureBuilder<Episode>(
        future: _episodeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              widget.initialData == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No content available.'));
          } else {
            final content = snapshot.data!.body;
            return ColoredBox(
              color: settings.colorScheme.surface,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(
                  content?.replaceAll(RegExp(r'<br>'), '\n') ?? '',
                  style: TextStyle(
                    fontSize: settings.fontSize,
                    color: settings.colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
