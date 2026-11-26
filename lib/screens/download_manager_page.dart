import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/models/novel_download_summary.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// ダウンロード管理画面
class DownloadManagerPage extends StatelessWidget {
  /// コンストラクタ
  const DownloadManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: appRouter.pop),
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
class _DownloadingTab extends StatelessWidget {
  /// コンストラクタ
  const _DownloadingTab();

  @override
  Widget build(BuildContext context) {
    final db = context.services.db;

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
class _CompletedTab extends StatelessWidget {
  /// コンストラクタ
  const _CompletedTab();

  @override
  Widget build(BuildContext context) {
    final db = context.services.db;

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
class _DownloadListItem extends StatelessWidget {
  /// コンストラクタ
  const _DownloadListItem({
    required this.summary,
  });

  /// ダウンロード状態の集計情報
  final NovelDownloadSummary summary;

  @override
  Widget build(BuildContext context) {
    final db = context.services.db;

    return FutureBuilder<Novel?>(
      future: db.getNovel(NovelSource.narou, summary.ncode),
      builder: (context, snapshot) {
        final novelInfo = snapshot.data;

        // NovelListTileを使用するため、NovelInfoに変換
        final novelData =
            novelInfo?.toModel() ??
            NovelInfo(
              workId: summary.ncode,
              ncode: summary.ncode,
              title: summary.ncode,
            );

        return Column(
          children: [
            NovelListTile(item: novelData),
            StreamBuilder<DownloadProgress?>(
              stream: context.services.repository.watchDownloadProgress(
                NovelSource.narou,
                summary.ncode,
              ),
              builder: (context, progressSnapshot) {
                final progress = progressSnapshot.data;
                // Until a progress event arrives, show the DB totals.
                final current =
                    progress?.currentEpisode ?? summary.successCount;
                final total = progress?.totalEpisodes ?? summary.totalEpisodes;
                final progressValue = total > 0 ? current / total : 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
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
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

/// 完了リストアイテム
class _CompletedListItem extends StatelessWidget {
  /// コンストラクタ
  const _CompletedListItem({
    required this.summary,
  });

  /// ダウンロード状態の集計情報
  final NovelDownloadSummary summary;

  @override
  Widget build(BuildContext context) {
    final db = context.services.db;

    return FutureBuilder<Novel?>(
      future: db.getNovel(NovelSource.narou, summary.ncode),
      builder: (context, snapshot) {
        final novelInfo = snapshot.data;

        // NovelListTileを使用するため、NovelInfoに変換
        final novelData =
            novelInfo?.toModel() ??
            NovelInfo(
              workId: summary.ncode,
              ncode: summary.ncode,
              title: summary.ncode,
            );

        return NovelListTile(item: novelData);
      },
    );
  }
}
