import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/main.dart';
import 'package:novelty/services/drift_database_service.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  late DriftDatabaseService _databaseService;
  late Future<List<Map<String, dynamic>>> _history;

  @override
  void initState() {
    super.initState();
    _databaseService = ref.read(driftDatabaseServiceProvider);
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _history = _databaseService.getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _history,
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
              final ncode = item['ncode'] as String;
              final title = item['title'] as String? ?? 'No Title';
              final writer = item['writer'] as String? ?? 'No Writer';
              final lastEpisode = item['last_episode'] as int?;
              
              return ListTile(
                title: Text(title),
                subtitle: Row(
                  children: [
                    Expanded(child: Text(writer)),
                    if (lastEpisode != null)
                      Text('最終: $lastEpisode話', 
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
