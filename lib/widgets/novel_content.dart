import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/novel_content_view.dart';
import 'package:novelty/widgets/tategaki.dart';

final novelContentProvider = FutureProvider.autoDispose.family<
    List<NovelContentElement>,
    ({String ncode, int episode})>((ref, params) async {
  final repository = ref.read(novelRepositoryProvider);
  return repository.getEpisode(params.ncode, params.episode);
});

class NovelContent extends ConsumerWidget {
  const NovelContent({
    super.key,
    required this.ncode,
    required this.episode,
  });
  final String ncode;
  final int episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final contentAsync = ref.watch(
      novelContentProvider((ncode: ncode, episode: episode)),
    );

    return settings.when(
      data: (settings) {
        return contentAsync.when(
          data: (content) => _buildContent(context, settings, content),
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
    List<NovelContentElement> content,
  ) {
    final textStyle = settings.selectedFontTheme.copyWith(
      fontSize: settings.fontSize,
    );

    if (settings.isVertical) {
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: RepaintBoundary(
        child: DefaultTextStyle(
          style: textStyle,
          child: NovelContentView(elements: content),
        ),
      ),
    );
  }
}
