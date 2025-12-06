import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/utils/app_constants.dart';

/// 小説リストのタイルを表示するウィジェット。
class NovelListTile extends HookWidget {
  /// コンストラクタ。
  const NovelListTile({
    required this.item,
    super.key,
    this.isRanking = false,
    this.onTap,
    this.onLongPress,
    this.enrichedData,
  });

  /// 小説の情報。
  final RankingResponse item;

  /// 豊富な小説情報（ライブラリ状態を含む）。
  final EnrichedNovelData? enrichedData;

  /// ランキングリストかどうか。
  final bool isRanking;

  /// タップ時のコールバック。
  final VoidCallback? onTap;

  /// 長押し時のコールバック。
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    // タイトルの計算をメモ化してパフォーマンスを最適化
    final title = useMemoized(
      () => item.title ?? 'タイトルなし',
      [item.title],
    );

    // ジャンル名の計算をメモ化
    final genreName = useMemoized(
      () => item.genre != null && item.genre != -1
          ? genreList.firstWhere(
                  (g) => g['id'] == item.genre,
                  orElse: () => {'name': '不明'},
                )['name']
                as String
          : '不明',
      [item.genre],
    );

    // ステータスの計算をメモ化
    final status = useMemoized(
      () => item.end == null || item.end == -1 || item.novelType == null
          ? '情報取得失敗'
          : (item.novelType == 2 ? '短編' : (item.end == 0 ? '完結済' : '連載中')),
      [item.end, item.novelType],
    );

    // デフォルトのonTapハンドラーをメモ化
    final defaultOnTap = useCallback(
      () {
        unawaited(context.push('/novel/${item.ncode}'));
      },
      [item.ncode],
    );

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: ListTile(
        leading: isRanking ? Text('${item.rank ?? ''}') : null,
        title: Row(
          children: [
            Expanded(child: Text(title)),
          ],
        ),
        subtitle: Text(
          'Nコード: ${item.ncode} - ${item.allPoint ?? item.pt ?? 0}pt\nジャンル: $genreName - $status',
        ),
        onTap: onTap ?? defaultOnTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
