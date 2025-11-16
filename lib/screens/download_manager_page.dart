import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/ranking_response.dart';
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

    return StreamBuilder<List<TypedResult>>(
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
            final row = downloads[index];
            final downloadInfo = row.readTable(db.downloadedNovels);
            final novelInfo = row.readTableOrNull(db.novels);

            return _DownloadListItem(
              downloadInfo: downloadInfo,
              novelInfo: novelInfo,
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

    return StreamBuilder<List<TypedResult>>(
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
            final row = downloads[index];
            final downloadInfo = row.readTable(db.downloadedNovels);
            final novelInfo = row.readTableOrNull(db.novels);

            return _CompletedListItem(
              downloadInfo: downloadInfo,
              novelInfo: novelInfo,
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
    required this.downloadInfo,
    this.novelInfo,
  });

  /// ダウンロード情報
  final DownloadedNovel downloadInfo;

  /// 小説情報
  final Novel? novelInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // NovelListTileを使用するため、RankingResponseに変換
    final novelData = RankingResponse(
      ncode: downloadInfo.ncode,
      title: novelInfo?.title ?? downloadInfo.ncode,
      writer: novelInfo?.writer,
      genre: novelInfo?.genre,
      novelType: novelInfo?.novelType,
      end: novelInfo?.end,
      allPoint: novelInfo?.allPoint,
    );

    final progressAsync = ref.watch(
      downloadProgressProvider(downloadInfo.ncode),
    );

    return Column(
      children: [
        NovelListTile(item: novelData),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: progressAsync.when(
            data: (progress) {
              final current =
                  progress?.currentEpisode ?? downloadInfo.downloadedEpisodes;
              final total =
                  progress?.totalEpisodes ?? downloadInfo.totalEpisodes;
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
              final current = downloadInfo.downloadedEpisodes;
              final total = downloadInfo.totalEpisodes;
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
              final current = downloadInfo.downloadedEpisodes;
              final total = downloadInfo.totalEpisodes;
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
  }
}

/// 完了リストアイテム
class _CompletedListItem extends StatelessWidget {
  /// コンストラクタ
  const _CompletedListItem({
    required this.downloadInfo,
    this.novelInfo,
  });

  /// ダウンロード情報
  final DownloadedNovel downloadInfo;

  /// 小説情報
  final Novel? novelInfo;

  @override
  Widget build(BuildContext context) {
    // NovelListTileを使用するため、RankingResponseに変換
    final novelData = RankingResponse(
      ncode: downloadInfo.ncode,
      title: novelInfo?.title ?? downloadInfo.ncode,
      writer: novelInfo?.writer,
      genre: novelInfo?.genre,
      novelType: novelInfo?.novelType,
      end: novelInfo?.end,
      allPoint: novelInfo?.allPoint,
    );

    return NovelListTile(item: novelData);
  }
}
