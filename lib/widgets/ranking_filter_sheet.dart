import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:novelty/sites/novel_site.dart';

/// ランキングフィルタ（ジャンル・連載状況）を選択するボトムシート
///
/// ジャンル一覧はサイト実装のマスタデータ（[NovelSite.genres]）から受け取る。
class RankingFilterSheet extends HookWidget {
  /// コンストラクタ
  const RankingFilterSheet({
    required this.genres,
    required this.initialShowOnlyOngoing,
    required this.initialSelectedGenreId,
    required this.onApply,
    super.key,
  });

  /// ジャンルのマスタデータ一覧（サイト実装が提供）。
  final List<GenreMaster> genres;

  /// 前回の「連載中のみ」設定
  final bool initialShowOnlyOngoing;

  /// 前回の「選択ジャンルID」設定（nullはすべて）
  final String? initialSelectedGenreId;

  /// 適用ボタン押下時のコールバック
  final void Function({
    required bool showOnlyOngoing,
    required String? selectedGenreId,
  })
  onApply;

  @override
  Widget build(BuildContext context) {
    // 状態管理
    final showOnlyOngoing = useState(initialShowOnlyOngoing);
    final selectedGenreId = useState(initialSelectedGenreId);

    // ジャンルデータの加工（カテゴリごとにグループ化）
    // useMemoizedで再計算を防ぐ
    final groupedGenres = useMemoized(() {
      final groups = <String, List<GenreMaster>>{};

      for (final genre in genres) {
        // "名称〔カテゴリ〕" の形式をパース（なろう形式）
        // カテゴリが無いジャンル（カクヨム等）はそのままの名前でグループ化
        final match = RegExp('(.+)〔(.+)〕').firstMatch(genre.name);
        final category = match?.group(2) ?? genre.name;
        groups.putIfAbsent(category, () => []).add(genre);
      }
      return groups;
    }, [genres]);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // ハンドル
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ヘッダー
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // リセット
                      showOnlyOngoing.value = false;
                      selectedGenreId.value = null;
                    },
                    child: const Text('リセット'),
                  ),
                  Text(
                    '絞り込み',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      onApply(
                        showOnlyOngoing: showOnlyOngoing.value,
                        selectedGenreId: selectedGenreId.value,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('適用'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // コンテンツ
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // ステータスセクション
                  Text(
                    '連載状況',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('連載中作品のみ表示'),
                    value: showOnlyOngoing.value,
                    onChanged: (value) => showOnlyOngoing.value = value,
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 24),

                  // ジャンルセクション
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ジャンル',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // "指定なし"を選択するためのチップ等
                      if (selectedGenreId.value != null)
                        TextButton.icon(
                          onPressed: () => selectedGenreId.value = null,
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('ジャンル解除'),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // グループ化されたジャンル
                  ...groupedGenres.entries.map((entry) {
                    final category = entry.key;
                    final items = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            category,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: items.map((genre) {
                            final isSelected =
                                selectedGenreId.value == genre.id;

                            return FilterChip(
                              label: Text(genre.name),
                              selected: isSelected,
                              onSelected: (selected) {
                                selectedGenreId.value = selected
                                    ? genre.id
                                    : null;
                              },
                              showCheckmark:
                                  false, // シンプルにするためチェックマークなし（色変化のみ）も選択肢
                              // checkmarkColor:
                              // Theme.of(context).colorScheme.onPrimary,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),
                  const SizedBox(height: 48), // 下部パディング
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
