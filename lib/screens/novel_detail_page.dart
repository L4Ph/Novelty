import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'novel_detail_page.g.dart';

@riverpod
Future<NovelInfo> novelInfo(Ref ref, String ncode) async {
  final apiService = ref.read(apiServiceProvider);
  final db = ref.watch(appDatabaseProvider);

  final novelInfo = await apiService.fetchNovelInfo(ncode);

  // Insert into history
  await db.addToHistory(
    HistoryCompanion(
      ncode: drift.Value(ncode),
      title: drift.Value(novelInfo.title),
      writer: drift.Value(novelInfo.writer),
      viewedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
    ),
  );

  // Upsert novel data, preserving fav status
  final existing = await db.getNovel(ncode);
  await db.insertNovel(
    novelInfo.toDbCompanion().copyWith(
      fav: drift.Value(existing?.fav ?? 0),
    ),
  );

  return novelInfo;
}

class NovelDetailPage extends ConsumerWidget {
  const NovelDetailPage({super.key, required this.ncode});
  final String ncode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final novelInfoAsync = ref.watch(novelInfoProvider(ncode));

    return novelInfoAsync.when(
      data: (novelInfo) => _buildContent(context, ref, novelInfo),
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Failed to load novel info: $err')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    NovelInfo novelInfo,
  ) {
    final isShortStory = novelInfo.generalAllNo == 1;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              novelInfo.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, novelInfo),
                  const SizedBox(height: 24),
                  _StorySection(story: novelInfo.story ?? ''),
                  const SizedBox(height: 16),
                  _buildGenreTags(context, novelInfo),
                ],
              ),
            ),
          ),
          if (isShortStory)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.menu_book),
                    label: const Text('この小説を読む'),
                    onPressed: () => context.push('/novel/$ncode/1'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      textStyle: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: _buildEpisodeList(
                context,
                ref,
                novelInfo,
                ncode,
              ),
            ),
        ],
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, NovelInfo novelInfo) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        novelInfo.title ?? 'No Title',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          const Icon(Icons.person_outline, size: 16),
          const SizedBox(width: 4),
          Text(novelInfo.writer ?? 'Unknown'),
          const SizedBox(width: 16),
          const Icon(Icons.star_outline, size: 16),
          const SizedBox(width: 4),
          Text('${novelInfo.allPoint ?? 0} pt'),
        ],
      ),
    ],
  );
}

class _StorySection extends StatefulWidget {
  const _StorySection({required this.story});

  final String story;

  @override
  _StorySectionState createState() => _StorySectionState();
}

class _StorySectionState extends State<_StorySection> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.story.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'あらすじ',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: Text(
            widget.story,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
          ),
          secondChild: Text(
            widget.story,
            style: textTheme.bodyMedium,
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            child: Text(_isExpanded ? '閉じる' : 'もっと読む'),
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
          ),
        ),
      ],
    );
  }
}

Widget _buildGenreTags(BuildContext context, NovelInfo novelInfo) {
  final keywords =
      novelInfo.keyword?.split(' ').where((k) => k.isNotEmpty).toList() ?? [];
  if (keywords.isEmpty) {
    return const SizedBox.shrink();
  }

  return Wrap(
    spacing: 8,
    runSpacing: 4,
    children: keywords.map((keyword) => Chip(label: Text(keyword))).toList(),
  );
}

Widget _buildEpisodeList(
  BuildContext context,
  WidgetRef ref,
  NovelInfo novelInfo,
  String ncode,
) {
  final episodes = novelInfo.episodes ?? [];
  if (episodes.isEmpty) {
    return const SizedBox.shrink();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          '${novelInfo.generalAllNo} 話',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: episodes.length,
        itemBuilder: (context, index) {
          final episode = episodes[index];
          final episodeTitle = episode.subtitle ?? 'No Title';
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(episodeTitle),
            subtitle: episode.update != null
                ? Text('更新日: ${episode.update}')
                : null,
            onTap: () {
              final episodeUrl = episode.url;
              if (episodeUrl != null) {
                final match = RegExp(r'/(\d+)/').firstMatch(episodeUrl);
                if (match != null) {
                  final episodeNumber = match.group(1);
                  if (episodeNumber != null) {
                    context.push('/novel/$ncode/$episodeNumber');
                  }
                }
              }
            },
          );
        },
      ),
    ],
  );
}
