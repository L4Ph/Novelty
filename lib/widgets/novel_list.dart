import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/providers/enriched_novel_provider.dart';
import 'package:novelty/providers/library_provider.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// 小説リストを表示するウィジェット。
class NovelList extends HookConsumerWidget {
  /// コンストラクタ。
  const NovelList({required this.novels, super.key, this.isRanking = true});

  /// 小説のリスト。
  final List<RankingResponse> novels;

  /// ランキングリストかどうか。
  final bool isRanking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    
    // ローカル状態管理
    final isProcessingMap = useState<Map<String, bool>>({});
    final errorMessage = useState<String?>(null);

    // ApiServiceインスタンスをメモ化
    final apiService = useMemoized(ApiService.new, []);

    // ライブラリ追加処理のコールバック
    final addToLibraryCallback = useCallback(
      (RankingResponse item) async {
        final ncode = item.ncode;
        if (isProcessingMap.value[ncode] ?? false) {
          return; // 処理中の場合は何もしない
        }

        // エラーメッセージをクリア
        errorMessage.value = null;
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        try {
          // 処理開始をマーク
          isProcessingMap.value = {...isProcessingMap.value, ncode: true};

          final novel = await db.getNovel(item.ncode);
          if (novel != null) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('すでにライブラリに登録されています')),
              );
            }
            return;
          }

          final apiService = ApiService();
          final novelInfo = await apiService.fetchNovelInfo(item.ncode);
          await db.insertNovel(novelInfo.toDbCompanion());
          
          // Invalidate providers to refresh UI
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
          isProcessingMap.value = {...isProcessingMap.value, ncode: false};
        }
      },
      [db, ref, apiService],
    );

    return ListView.builder(
      itemCount: novels.length,
      itemBuilder: (context, index) {
        final item = novels[index];
        return NovelListTile(
          item: item,
          isRanking: isRanking,
          onLongPress: () => addToLibraryCallback(item),
        );
      },
    );
  }
}
