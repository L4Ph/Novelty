import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/database/database.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyFuture = ref.watch(appDatabaseProvider).getHistory();

    return FutureBuilder<List<HistoryData>>(
      future: historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No history found.'));
        } else {
          final historyItems = snapshot.data!;
          return ListView.builder(
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final item = historyItems[index];
              final ncode = item.ncode;
              final title = item.title ?? 'No Title';
              final writer = item.writer ?? 'No Writer';
              final lastEpisode = item.lastEpisode;

              return ListTile(
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
                  // 最後に開いたエピソードがある場合はそのエピソードに移動
                  if (lastEpisode != null && lastEpisode > 0) {
                    context.push('/novel/$ncode/$lastEpisode');
                  } else {
                    context.push('/novel/$ncode');
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
