import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/router/router.dart';
import 'package:novelty/utils/time_format.dart';

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
                    final workId = item.workId;
                    final title = item.title ?? 'タイトルなし';
                    final lastEpisode = item.lastEpisode;
                    final updatedAt = item.updatedAt != 0
                        ? DateTime.fromMillisecondsSinceEpoch(item.updatedAt)
                        : null;

                    return ListTile(
                      title: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        '第$lastEpisode章 - '
                        '${updatedAt != null ? formatTimeHm(updatedAt) : ''}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          unawaited(
                            ref
                                .read(novelRepositoryProvider)
                                .deleteHistory(item.source, workId),
                          );
                        },
                      ),
                      onTap: () {
                        if (lastEpisode != null && lastEpisode > 0) {
                          // 本文を開く際は目次(小説詳細)も積むことで、
                          // 戻るボタンで本文から目次へ遷移できるようにする
                          unawaited(
                            NovelDetailRoute(
                              source: item.source.name,
                              workId: workId,
                            ).push(context),
                          );
                          unawaited(
                            NovelEpisodeRoute(
                              source: item.source.name,
                              workId: workId,
                              episode: lastEpisode,
                            ).push(context),
                          );
                        } else {
                          unawaited(
                            NovelDetailRoute(
                              source: item.source.name,
                              workId: workId,
                            ).push(context),
                          );
                        }
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
