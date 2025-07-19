import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/providers/grouped_history_provider.dart';

/// "履歴"ページのウィジェット。
class HistoryPage extends ConsumerWidget {
  /// コンストラクタ。
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedHistoryAsync = ref.watch(groupedHistoryProvider);

    return groupedHistoryAsync.when(
      data: (historyGroups) {
        if (historyGroups.isEmpty) {
          return const Center(child: Text('No history found.'));
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(groupedHistoryProvider.future),
          child: ListView.builder(
            itemCount: historyGroups.length,
            itemBuilder: (context, groupIndex) {
              final group = historyGroups[groupIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 日付ラベル
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: Text(
                      group.dateLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // グループ内のアイテム
                  ...group.items.map((item) {
                    final ncode = item.ncode;
                    final title = item.title ?? 'No Title';
                    final writer = item.writer ?? 'No Writer';
                    final lastEpisode = item.lastEpisode;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 8,
                      ),
                      child: ListTile(
                        title: Text(title),
                        subtitle: Row(
                          children: [
                            Expanded(child: Text(writer)),
                            if (lastEpisode != null)
                              Text(
                                '最終: $lastEpisode話',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          if (lastEpisode != null && lastEpisode > 0) {
                            context.push('/novel/$ncode/$lastEpisode');
                          } else {
                            context.push('/novel/$ncode');
                          }
                        },
                      ),
                    );
                  }),
                  // グループ間の余白
                  if (groupIndex < historyGroups.length - 1)
                    const SizedBox(height: 8),
                ],
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
