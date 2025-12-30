import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/utils/app_constants.dart';

/// 小説リストのタイルを表示するウィジェット。
class NovelListTile extends HookWidget {
  /// コンストラクタ。
  const NovelListTile({
    required this.item,
    super.key,
    this.rank,
    this.onTap,
    this.onLongPress,
    this.enrichedData,
  });

  /// 小説の情報。
  final NovelInfo item;

  /// 豊富な小説情報（ライブラリ状態を含む）。
  final EnrichedNovelData? enrichedData;

  /// 順位（ランキング表示用）。
  final int? rank;

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
    // 0: 完結, 1: 連載中, 2: 短編
    final statusType = useMemoized(
      () {
        if (item.novelType == 2) return 2; // 短編
        if (item.end == 1) return 1; // 連載中
        return 0; // 完結
      },
      [item.novelType, item.end],
    );

    // デフォルトのonTapハンドラーをメモ化
    final defaultOnTap = useCallback(
      () {
        if (item.ncode != null) {
          unawaited(context.push('/novel/${item.ncode}'));
        }
      },
      [item.ncode],
    );

    // ステータスに応じた色とラベル定義
    // 短編: Tertiary (アクセント) - Filled
    // 連載: Secondary (アクティブ) - Filled
    // 完結: Outline (境界線のみ) - Outlined
    // 文字色は統一して視認性を確保 (onSurfaceVariant)
    final (statusLabel, statusStyle, statusDecoration) = switch (statusType) {
      2 => (
        // 短編
        '短編',
        TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      1 => (
        // 連載
        '連載',
        TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      _ => (
        // 完結
        '完結',
        TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    };

    return InkWell(
      onTap: onTap ?? defaultOnTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (rank != null) ...[
              Text(
                '$rank',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: statusDecoration,
                        child: Text(
                          statusLabel,
                          style: statusStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item.writer} • $genreName${item.allPoint != null ? ' • ${(item.allPoint! / 1000).toStringAsFixed(1)}k pt' : ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
