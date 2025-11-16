import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/utils/library_callbacks.dart';
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
    // ローカル状態管理
    final isProcessingMap = useState<Map<String, bool>>({});
    final errorMessage = useState<String?>(null);

    // ライブラリ追加処理のコールバック
    final addToLibraryCallback = useCallback(
      (RankingResponse item) => handleAddToLibrary(
        item: item,
        context: context,
        ref: ref,
        isProcessingMap: isProcessingMap,
        errorMessage: errorMessage,
      ),
      [ref],
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
