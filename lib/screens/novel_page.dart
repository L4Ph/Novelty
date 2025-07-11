import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart' hide Episode;
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/novel_content.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'novel_page.g.dart';


@riverpod
Future<NovelInfo> novelInfo(Ref ref, String ncode) {
  return ApiService().fetchNovelInfo(ncode);
}

@riverpod
Future<Episode> episode(
  Ref ref, {
  required String ncode,
  required int episode,
}) {
  final apiService = ApiService();
  return apiService.fetchEpisode(ncode, episode);
}

@riverpod
class CurrentEpisode extends _$CurrentEpisode {
  @override
  int build() => 1;

  void set(int value) => state = value;
}

class NovelPage extends ConsumerWidget {
  const NovelPage({super.key, required this.ncode, this.episode});
  final String ncode;
  final int? episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final novelInfoAsync = ref.watch(novelInfoProvider(ncode));
    final initialEpisode = episode ?? 1;

    // initialEpisodeをproviderに設定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentEpisodeProvider.notifier).set(initialEpisode);
    });

    return novelInfoAsync.when(
      data: (novelInfo) {
        final totalEpisodes = novelInfo.generalAllNo ?? 1;
        final settings = ref.watch(settingsProvider);

        return settings.when(
          data: (settings) {
            final pageController =
                PageController(initialPage: initialEpisode - 1);

            // 最初の履歴追加
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateHistory(ref, novelInfo, initialEpisode);
            });

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Consumer(
                  builder: (context, ref, child) {
                    final currentEpisode = ref.watch(currentEpisodeProvider);
                    final episodeAsync = ref.watch(
                      episodeProvider(ncode: ncode, episode: currentEpisode),
                    );
                    return episodeAsync.when(
                      data: (ep) {
                        final subtitle = ep.subtitle ?? '';
                        return Text(
                          novelInfo.novelType == 2
                              ? (subtitle.isNotEmpty
                                  ? subtitle
                                  : novelInfo.title ?? '')
                              : '${novelInfo.title} - $subtitle',
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                      loading: () => Text(novelInfo.title ?? ''),
                      error: (e, s) => Text(novelInfo.title ?? ''),
                    );
                  },
                ),
              ),
              body: PageView.builder(
                scrollDirection:
                    settings.isVertical ? Axis.vertical : Axis.horizontal,
                controller: pageController,
                itemCount: totalEpisodes,
                onPageChanged: (index) {
                  final newEpisode = index + 1;
                  ref.read(currentEpisodeProvider.notifier).set(newEpisode);
                  _updateHistory(ref, novelInfo, newEpisode);
                },
                itemBuilder: (context, index) {
                  final episodeNum = index + 1;
                  return RepaintBoundary(
                    child: NovelContent(
                      ncode: ncode,
                      episode: episodeNum,
                    ),
                  );
                },
              ),
            );
          },
          loading: () => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (e, s) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: $e')),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('エラーが発生しました: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('戻る'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateHistory(WidgetRef ref, NovelInfo novelInfo, int episode) {
    ref.read(appDatabaseProvider).addToHistory(
          HistoryCompanion(
            ncode: drift.Value(ncode),
            title: drift.Value(novelInfo.title),
            writer: drift.Value(novelInfo.writer),
            lastEpisode: drift.Value(episode),
            viewedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
  }
}
