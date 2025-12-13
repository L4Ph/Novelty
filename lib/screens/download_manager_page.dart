import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_download_summary.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// ダウンロード管理画面
class DownloadManagerPage extends ConsumerWidget {
  /// コンストラクタ
  const DownloadManagerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ダウンロード'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ダウンロード中'),
              Tab(text: '完了'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DownloadingTab(),
            _CompletedTab(),
          ],
        ),
      ),
    );
  }
}

/// ダウンロード中タブ
class _DownloadingTab extends ConsumerWidget {
  /// コンストラクタ
  const _DownloadingTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);

    return StreamBuilder<List<NovelDownloadSummary>>(
      stream: db.watchDownloadingNovels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('エラー: ${snapshot.error}'));
        }

        final downloads = snapshot.data ?? [];

        if (downloads.isEmpty) {
          return const Center(
            child: Text('ダウンロード中の小説はありません'),
          );
        }

        return ListView.builder(
          itemCount: downloads.length,
          itemBuilder: (context, index) {
            final summary = downloads[index];

            return _DownloadListItem(
              summary: summary,
            );
          },
        );
      },
    );
  }
}

/// 完了タブ
class _CompletedTab extends ConsumerWidget {
  /// コンストラクタ
  const _CompletedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);

    return StreamBuilder<List<NovelDownloadSummary>>(
      stream: db.watchCompletedDownloads(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('エラー: ${snapshot.error}'));
        }

        final downloads = snapshot.data ?? [];

        if (downloads.isEmpty) {
          return const Center(
            child: Text('完了したダウンロードはありません'),
          );
        }

        return ListView.builder(
          itemCount: downloads.length,
          itemBuilder: (context, index) {
            final summary = downloads[index];

            return _CompletedListItem(
              summary: summary,
            );
          },
        );
      },
    );
  }
}

/// ダウンロード中リストアイテム
class _DownloadListItem extends ConsumerWidget {
  /// コンストラクタ
  const _DownloadListItem({
    required this.summary,
  });

  /// ダウンロード状態の集計情報
  final NovelDownloadSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);

    return FutureBuilder<Novel?>(
      future: db.getNovel(summary.ncode),
      builder: (context, snapshot) {
        final novelInfo = snapshot.data;

        // NovelListTileを使用するため、NovelInfoに変換
        final novelData =
            novelInfo?.toModel() ??
            NovelInfo(ncode: summary.ncode, title: summary.ncode);

        final progressAsync = ref.watch(
          downloadProgressProvider(summary.ncode),
        );

        return Column(
          children: [
            NovelListTile(item: novelData),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: progressAsync.when(
                data: (progress) {
                  final current =
                      progress?.currentEpisode ?? summary.successCount;
                  final total =
                      progress?.totalEpisodes ?? summary.totalEpisodes;
                  final progressValue = total > 0 ? current / total : 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$current / $total 話',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                },
                loading: () {
                  final current = summary.successCount;
                  final total = summary.totalEpisodes;
                  final progressValue = total > 0 ? current / total : 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$current / $total 話',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                },
                error: (e, s) {
                  final current = summary.successCount;
                  final total = summary.totalEpisodes;
                  final progressValue = total > 0 ? current / total : 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$current / $total 話',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 完了リストアイテム
class _CompletedListItem extends ConsumerWidget {
  /// コンストラクタ
  const _CompletedListItem({
    required this.summary,
  });

  /// ダウンロード状態の集計情報
  final NovelDownloadSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);

    return FutureBuilder<Novel?>(
      future: db.getNovel(summary.ncode),
      builder: (context, snapshot) {
        final novelInfo = snapshot.data;

        // NovelListTileを使用するため、NovelInfoに変換
        final novelData =
            novelInfo?.toModel() ??
            NovelInfo(ncode: summary.ncode, title: summary.ncode);

        return NovelListTile(item: novelData);
      },
    );
  }
}
