import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/repositories/novel_repository.dart';
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

  /// ウィジェットを構築します。
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final novelRepository = ref.watch(novelRepositoryProvider);

    // ローカル状態の管理
    final isProcessingMap = useState<Map<String, bool>>({});
    final errorMessage = useState<String?>(null);

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

          final success = await novelRepository.addNovelToLibrary(ncode);

          if (!context.mounted) return;
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ライブラリに追加しました')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('すでにライブラリに登録されています')),
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
      [novelRepository],
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
          onLongPress: () => addToLibraryCallback(item),
        );
      },
    );
  }
}
