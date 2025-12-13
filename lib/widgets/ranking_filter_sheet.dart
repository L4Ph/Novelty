import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:novelty/utils/app_constants.dart';

/// ランキングフィルタ（ジャンル・連載状況）を選択するボトムシート
class RankingFilterSheet extends HookWidget {
  /// コンストラクタ
  const RankingFilterSheet({
    required this.initialShowOnlyOngoing,
    required this.initialSelectedGenre,
    required this.onApply,
    super.key,
  });

  /// 前回の「連載中のみ」設定
  final bool initialShowOnlyOngoing;

  /// 前回の「選択ジャンル」設定（nullはすべて）
  final int? initialSelectedGenre;

  /// 適用ボタン押下時のコールバック
  final void Function({
    required bool showOnlyOngoing,
    required int? selectedGenre,
  })
  onApply;

  @override
  Widget build(BuildContext context) {
    // 状態管理
    final showOnlyOngoing = useState(initialShowOnlyOngoing);
    final selectedGenre = useState(initialSelectedGenre);

    // ジャンルデータの加工（カテゴリごとにグループ化）
    // useMemoizedで再計算を防ぐ
    final groupedGenres = useMemoized(() {
      final groups = <String, List<Map<String, dynamic>>>{};

      for (final genre in genreList) {
        final name = genre['name'] as String;
        final id = genre['id'] as int;

        // "名称〔カテゴリ〕" の形式をパース
        final match = RegExp('(.+)〔(.+)〕').firstMatch(name);
        var category = 'その他';
        var label = name;

        if (match != null) {
          label = match.group(1)!;
          category = match.group(2)!;
        }

        groups.putIfAbsent(category, () => []).add({
          'id': id,
          'name': label, // UI表示用には短い名称を使用
          'fullName': name,
        });
      }
      return groups;
    }, []);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle
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

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // リセット
                      showOnlyOngoing.value = false;
                      selectedGenre.value = null;
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
                        selectedGenre: selectedGenre.value,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('適用'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Status Section
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

                  // Genre Section
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
                      if (selectedGenre.value != null)
                        TextButton.icon(
                          onPressed: () => selectedGenre.value = null,
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('ジャンル解除'),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Grouped Genres
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
                          children: items.map((item) {
                            final id = item['id'] as int;
                            final name = item['name'] as String;
                            final isSelected = selectedGenre.value == id;

                            return FilterChip(
                              label: Text(name),
                              selected: isSelected,
                              onSelected: (selected) {
                                selectedGenre.value = selected ? id : null;
                              },
                              showCheckmark:
                                  false, // シンプルにするためチェックマークなし（色変化のみ）も選択肢
                              // checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),
                  const SizedBox(height: 48), // Bottom padding
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
