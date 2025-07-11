import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/novel_parser.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/novel_content_view.dart';
import 'package:novelty/widgets/tategaki.dart';
import 'package:riverpod/src/providers/future_provider.dart';

final FutureProviderFamily<Episode, ({int episode, String ncode})>
episodeProvider = FutureProvider.autoDispose
    .family<Episode, ({String ncode, int episode})>((ref, params) async {
      final apiService = ref.read(apiServiceProvider);
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
          return _buildContent(context, settings, initialData!);
        }

        final episodeAsync = ref.watch(
          episodeProvider((ncode: ncode, episode: episode)),
        );
        return episodeAsync.when(
          data: (episode) => _buildContent(context, settings, episode),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppSettings settings,
    Episode episode,
  ) {
    final html = episode.body ?? '';
    final textStyle = settings.selectedFontTheme.copyWith(
      fontSize: settings.fontSize,
    );

    if (settings.isVertical) {
      // TODO: TategakiをNovelContentElementに対応させる
      final content = html.replaceAll(RegExp(r'<br>'), '\n');
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return RepaintBoundary(
                child: Tategaki(
                  content,
                  style: textStyle,
                  maxHeight: constraints.maxHeight,
                ),
              );
            },
          ),
        ),
      );
    }

    final elements = parseNovel(html);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: RepaintBoundary(
        child: DefaultTextStyle(
          style: textStyle,
          child: NovelContentView(elements: elements),
        ),
      ),
    );
  }
}
