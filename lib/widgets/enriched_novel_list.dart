import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/providers/enriched_novel_provider.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// 豊富な情報（ライブラリ状態を含む）を持つ小説リストを表示するウィジェット。
class EnrichedNovelList extends HookConsumerWidget {
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
    
    // ローカル状態の管理
    final isProcessingMap = useState<Map<String, bool>>({});
    final errorMessage = useState<String?>(null);

    // ライブラリ追加処理のコールバック
    final addToLibraryCallback = useCallback(
      (EnrichedNovelData enrichedItem) async {
        final ncode = enrichedItem.novel.ncode;
        if (isProcessingMap.value[ncode] ?? false) {
          return; // 処理中の場合は何もしない
        }

        // エラーメッセージをクリア
        errorMessage.value = null;

        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        try {
          // 既にライブラリに存在するかチェック
          if (enrichedItem.isInLibrary) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('すでにライブラリに登録されています')),
              );
            }
            return;
          }

          // 処理開始をマーク
          isProcessingMap.value = {
            ...isProcessingMap.value,
            ncode: true,
          };

          // ライブラリに追加
          final novelInfo = await apiService.fetchNovelInfo(ncode);
          
          // Novelテーブルに保存（favは設定しない）
          await db.insertNovel(novelInfo.toDbCompanion());
          
          // LibraryNovelsテーブルに追加
          await db.addToLibrary(
            LibraryNovelsCompanion(
              ncode: Value(ncode),
              addedAt: Value(DateTime.now().millisecondsSinceEpoch),
            ),
          );

          // Providersを無効化してUIを更新
          ref
            ..invalidate(libraryNovelsProvider)
            ..invalidate(enrichedRankingDataProvider('d'))
            ..invalidate(enrichedRankingDataProvider('w'))
            ..invalidate(enrichedRankingDataProvider('m'))
            ..invalidate(enrichedRankingDataProvider('q'))
            ..invalidate(enrichedRankingDataProvider('all'));

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ライブラリに追加しました')),
            );
          }
        } on Exception catch (e) {
          errorMessage.value = 'エラー: $e';
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('エラー: $e')),
            );
          }
        } finally {
          // 処理完了をマーク
          isProcessingMap.value = {
            ...isProcessingMap.value,
            ncode: false,
          };
        }
      },
      [apiService, db, ref],
    );

    return ListView.builder(
      itemCount: enrichedNovels.length,
      itemBuilder: (context, index) {
        final enrichedItem = enrichedNovels[index];
        final item = enrichedItem.novel;

        return NovelListTile(
          item: item,
          enrichedData: enrichedItem,
          isRanking: isRanking,
          onLongPress: () => addToLibraryCallback(enrichedItem),
        );
      },
    );
  }
}
