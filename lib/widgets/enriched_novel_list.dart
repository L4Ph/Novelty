import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/providers/enriched_novel_provider.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// 豊富な情報（ライブラリ状態を含む）を持つ小説リストを表示するウィジェット。
class EnrichedNovelList extends ConsumerWidget {
  /// コンストラクタ。
  const EnrichedNovelList({
    required this.enrichedNovels,
    super.key,
    this.isRanking = true,
  });

  /// 豊富な情報を持つ小説のリスト。
  final List<EnrichedNovelData> enrichedNovels;

  /// ランキングリストかどうか。
  final bool isRanking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ApiService();
    final db = ref.watch(appDatabaseProvider);

    return ListView.builder(
      itemCount: enrichedNovels.length,
      itemBuilder: (context, index) {
        final enrichedItem = enrichedNovels[index];
        final item = enrichedItem.novel;
        
        return NovelListTile(
          item: item,
          enrichedData: enrichedItem,
          isRanking: isRanking,
          onLongPress: () async {
            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            try {
              // Check if already in library
              if (enrichedItem.isInLibrary) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('すでにライブラリに登録されています')),
                  );
                }
                return;
              }

              // Add to library
              final novelInfo = await apiService.fetchNovelInfo(
                item.ncode,
              );
              await db.insertNovel(novelInfo.toDbCompanion().copyWith(
                fav: const Value(1), // Mark as favorite
              ));
              ref.invalidate(libraryNovelsProvider);
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