import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/settings_provider.dart';

final episodeProvider = FutureProvider.autoDispose.family<Episode, ({String ncode, int episode})>((ref, params) async {
  final apiService = ApiService();
  return apiService.fetchEpisode(params.ncode, params.episode);
});

class NovelContent extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    
    return settings.when(
      data: (settings) {
        if (initialData != null) {
          return _buildContent(settings, initialData!);
        }
        
        final episodeAsync = ref.watch(episodeProvider((ncode: ncode, episode: episode)));
        return episodeAsync.when(
          data: (episode) => _buildContent(settings, episode),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildContent(AppSettings settings, Episode episode) {
    final content = episode.body;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        content?.replaceAll(RegExp(r'<br>'), '\n') ?? '',
        style: settings.selectedFontTheme.copyWith(
          fontSize: settings.fontSize,
        ),
      ),
    );
  }
}
