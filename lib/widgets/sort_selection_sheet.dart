import 'package:flutter/material.dart';
import 'package:novelty/utils/app_constants.dart';

/// ソート順を選択するボトムシート
class SortSelectionSheet extends StatelessWidget {
  /// コンストラクタ
  const SortSelectionSheet({
    required this.currentOrder,
    required this.onOrderSelected,
    super.key,
  });

  /// 現在選択されているソート順
  final String currentOrder;

  /// ソート順が選択された時のコールバック
  final ValueChanged<String> onOrderSelected;

  @override
  Widget build(BuildContext context) {
    // グループ定義
    final groups = [
      const _SortGroup(
        title: 'ポイント・人気',
        keys: [
          'hyoka', // 総合ポイントの高い順
          'dailypoint', // 日間ポイントの高い順
          'weeklypoint', // 週間ポイントの高い順
          'monthlypoint', // 月間ポイントの高い順
          'quarterpoint', // 四半期ポイントの高い順
          'yearlypoint', // 年間ポイントの高い順
          'favnovelcnt', // ブックマーク数の多い順
        ],
      ),
      const _SortGroup(
        title: '更新・投稿',
        keys: [
          'new', // 新着更新順
          'old', // 更新が古い順
          'generalfirstup', // 初回掲載順
        ],
      ),
      const _SortGroup(
        title: '評価・反応',
        keys: [
          'reviewcnt', // レビュー数の多い順
          'impressioncnt', // 感想の多い順
          'hyokacnt', // 評価者数の多い順
          'hyokacntasc', // 評価者数の少ない順
          'weekly', // 週間ユニークユーザの多い順
        ],
      ),
      const _SortGroup(
        title: '作品情報',
        keys: [
          'lengthdesc', // 作品本文の文字数が多い順
          'lengthasc', // 作品本文の文字数が少ない順
          'ncodeasc', // Nコード昇順
          'ncodedesc', // Nコード降順
        ],
      ),
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return RadioGroup<String>(
          groupValue: currentOrder,
          onChanged: (value) {
            if (value != null) {
              onOrderSelected(value);
            }
          },
          child: Column(
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
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '並び替え',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              // Content
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            group.title,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ...group.keys.map((key) {
                          final label = novelOrders[key] ?? key;
                          // final isSelected = currentOrder == key; // Unused
                          return RadioListTile<String>(
                            title: Text(label),
                            value: key,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            dense: true,
                          );
                        }),
                        if (index < groups.length - 1) const Divider(height: 1),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SortGroup {
  const _SortGroup({required this.title, required this.keys});
  final String title;
  final List<String> keys;
}
