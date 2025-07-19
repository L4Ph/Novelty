import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/providers/enriched_novel_provider.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// 小説リストを表示するウィジェット。
class NovelList extends ConsumerWidget {
  /// コンストラクタ。
  const NovelList({required this.novels, super.key, this.isRanking = true});

  /// 小説のリスト。
  final List<RankingResponse> novels;

  /// ランキングリストかどうか。
  final bool isRanking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ApiService();
    final db = ref.watch(appDatabaseProvider);

    return ListView.builder(
      itemCount: novels.length,
      itemBuilder: (context, index) {
        final item = novels[index];
        return NovelListTile(
          item: item,
          isRanking: isRanking,
          onLongPress: () async {
            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            try {
              final novel = await db.novelDao.getNovel(item.ncode);
              if (novel != null) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('すでにライブラリに登録されています')),
                  );
                }
                return;
              }

              final novelInfo = await apiService.fetchNovelInfo(
                item.ncode,
              );
              await db.novelDao.insertNovel(novelInfo.toDbCompanion());
              // Invalidate providers to refresh UI
              ref
                ..invalidate(libraryNovelsProvider)
                ..invalidate(enrichedRankingDataProvider('d'))
                ..invalidate(enrichedRankingDataProvider('w'))
                ..invalidate(enrichedRankingDataProvider('m'))
                ..invalidate(enrichedRankingDataProvider('q'))
                ..invalidate(enrichedRankingDataProvider('all'));
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('ライブラリに追加しました')));
              }
            } on Exception catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('エラー: $e')));
              }
            }
          },
        );
      },
    );
  }
}
