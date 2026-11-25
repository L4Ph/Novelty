import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/database/database_providers.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/utils/history_grouping.dart';
import 'package:novelty/utils/time_format.dart';
import 'package:tiny_state/tiny_state.dart';

/// "履歴"ページのウィジェット。
class HistoryPage extends StatefulWidget {
  /// コンストラクタ。
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Stream<List<HistoryGroup>>? _groups;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Built once: the mapped stream is a new object on every call, and
    // StreamBuilder would re-subscribe on each rebuild if it were rebuilt.
    _groups ??= () {
      final services = Scope.of(context).get<AppServices>();
      return watchGroupedHistory(services.db, services.now());
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴'),
      ),
      body: StreamLoader<List<HistoryGroup>>(
        stream: _groups!,
        builder: (context, state) => state.when(
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
                              Scope.of(
                                context,
                              ).get<AppServices>().db.deleteHistory(
                                item.source,
                                workId,
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          if (lastEpisode != null && lastEpisode > 0) {
                            // 本文を開く際は目次(小説詳細)も積むことで、
                            // 戻るボタンで本文から目次へ遷移できるようにする
                            appRouter
                              ..pushOverlay(
                                NovelDetailDest(
                                  source: item.source,
                                  workId: workId,
                                ),
                              )
                              ..pushOverlay(
                                NovelEpisodeDest(
                                  source: item.source,
                                  workId: workId,
                                  episode: lastEpisode,
                                ),
                              );
                          } else {
                            appRouter.pushOverlay(
                              NovelDetailDest(
                                source: item.source,
                                workId: workId,
                              ),
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
      ),
    );
  }
}
