import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:novelty/providers/enriched_novel_provider.dart';
import 'package:novelty/providers/grouped_history_provider.dart';
import 'package:novelty/services/database_service.dart';

/// "履歴"ページのウィジェット。
class HistoryPage extends ConsumerWidget {
  /// コンストラクタ。
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedHistoryAsync = ref.watch(groupedHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴'),
      ),
      body: groupedHistoryAsync.when(
        data: (historyGroups) {
          if (historyGroups.isEmpty) {
            return const Center(child: Text('履歴がありません。'));
          }
          return ListView.builder(
            itemCount: historyGroups.length,
            itemBuilder: (context, groupIndex) {
              final group = historyGroups[groupIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 日付ラベル
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
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
                    final title = item.title ?? 'タイトルなし';
                    final lastEpisode = item.lastEpisode;
                    final updatedAt = item.updatedAt != 0
                        ? DateTime.fromMillisecondsSinceEpoch(item.updatedAt)
                        : null;

                    return Consumer(
                      builder: (context, ref, child) {
                        final enrichedNovelAsync = ref.watch(
                          enrichedNovelProvider(ncode),
                        );
                        return enrichedNovelAsync.when(
                          data: (enrichedNovel) {
                            return ListTile(
                              title: Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '第$lastEpisode章 - ${updatedAt != null ? DateFormat('HH:mm').format(updatedAt) : ''}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () async {
                                  await ref
                                      .read(databaseServiceProvider)
                                      .deleteHistory(ncode);
                                  // StreamProviderを使用しているため、手動での更新は不要
                                },
                              ),
                              onTap: () {
                                if (lastEpisode != null && lastEpisode > 0) {
                                  context.push('/novel/$ncode/$lastEpisode');
                                } else {
                                  context.push('/novel/$ncode');
                                }
                              },
                            );
                          },
                          loading: () => const ListTile(
                            leading: SizedBox(
                              width: 48,
                              height: 48,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            title: Text('読み込み中...'),
                          ),
                          error: (err, stack) => ListTile(
                            leading: const SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(Icons.error),
                            ),
                            title: Text('エラー: $err'),
                          ),
                        );
                      },
                    );
                  }),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
