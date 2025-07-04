import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/services/database_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _databaseService = DatabaseService();
  final _apiService = ApiService();
  late Future<List<NovelInfo>> _history;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _history = _fetchHistory();
    });
  }

  Future<List<NovelInfo>> _fetchHistory() async {
    final historyData = await _databaseService.getHistory();
    final ncodes = historyData.map((e) => e['ncode'] as String).toList();

    final novels = <NovelInfo>[];
    for (final ncode in ncodes) {
      try {
        final novelInfo = await _apiService.fetchNovelInfoByNcode(ncode);
        novels.add(novelInfo);
      } on Exception catch (_) {
        // Handle error if a novel can't be fetched
      }
    }
    return novels;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NovelInfo>>(
      future: _history,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No history found.'));
        } else {
          final novels = snapshot.data!;
          return ListView.builder(
            itemCount: novels.length,
            itemBuilder: (context, index) {
              final novel = novels[index];
              return ListTile(
                title: Text(novel.title ?? 'No Title'),
                subtitle: Text(novel.writer ?? 'No Writer'),
                onTap: () => context.push('/novel/${novel.ncode}'),
              );
            },
          );
        }
      },
    );
  }
}
