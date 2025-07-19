import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/providers/history_provider.dart';

/// "履歴"ページのウィジェット。
class HistoryPage extends ConsumerWidget {
  /// コンストラクタ。
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return historyAsync.when(
      data: (historyItems) {
        if (historyItems.isEmpty) {
          return const Center(child: Text('No history found.'));
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(historyProvider.future),
          child: ListView.builder(
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final item = historyItems[index];
              final ncode = item.ncode;
              final title = item.title ?? 'No Title';
              final writer = item.writer ?? 'No Writer';
              final lastEpisode = item.lastEpisode;

              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 4,
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
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
