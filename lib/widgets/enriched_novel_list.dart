import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/utils/library_callbacks.dart';
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
    // ローカル状態の管理
    final isProcessingMap = useState<Map<String, bool>>({});
    final errorMessage = useState<String?>(null);

    // ライブラリ追加処理のコールバック
    final addToLibraryCallback = useCallback(
      (EnrichedNovelData enrichedData) => handleAddToLibrary(
        item: enrichedData.novel,
        context: context,
        ref: ref,
        isProcessingMap: isProcessingMap,
        errorMessage: errorMessage,
      ),
      [ref],
    );

    return ListView.builder(
      itemCount: enrichedNovels.length,
      itemBuilder: (context, index) {
        final enrichedItem = enrichedNovels[index];
        final item = enrichedItem.novel;

        return NovelListTile(
          item: item,
          enrichedData: enrichedItem,
          rank: isRanking ? index + 1 : null,
          onLongPress: () => addToLibraryCallback(enrichedItem),
        );
      },
    );
  }
}
