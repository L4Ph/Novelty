import 'package:flutter/material.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_site_registry.dart';

/// 小説リストのタイルを表示するウィジェット。
class NovelListTile extends StatelessWidget {
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
    final title = item.title ?? 'タイトルなし';

    // ジャンル名の計算をメモ化
    // ジャンル一覧はサイト実装のマスタデータ（NovelSite.genres）から取得する
    // （なろう=数値ID / カクヨム=FANTASY 等のID体系が異なるため）
    final genreName = () {
      if (item.genreId == null || item.genreId == '-1') {
        return '不明';
      }
      final genres = defaultNovelSiteRegistry[item.source]!.genres;
      return genres
          .firstWhere(
            (g) => g.id == item.genreId,
            orElse: () => const GenreMaster(id: '', name: '不明'),
          )
          .name;
    }();

    // ステータスの計算をメモ化
    // 0: 完結, 1: 連載中, 2: 短編
    final statusType = () {
      if (item.novelType == 2) return 2; // short story
      if (item.end == 1) return 1; // ongoing
      return 0; // finished
    }();

    // サイト固有情報(pt/★)の計算をメモ化
    // 評価指標はサイトごとに異なるため、サイト実装（NovelSite.metaText）に委譲する
    final pointSuffix = () {
      final text = defaultNovelSiteRegistry[item.source]!.metaText(item);
      return text != null ? ' • $text' : '';
    }();

    void defaultOnTap() {
      final workId = item.workId ?? item.ncode;
      if (workId != null) {
        appRouter.pushOverlay(
          NovelDetailDest(source: item.source, workId: workId),
        );
      }
    }

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
                      // ライブラリ登録状態のハートアイコン
                      if (enrichedData?.isInLibrary ?? false) ...[
                        Icon(
                          Icons.favorite,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                      ],
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
                    '${item.writer} • $genreName$pointSuffix',
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
