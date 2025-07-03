import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';

class TocPage extends StatefulWidget {
  final String ncode;

  const TocPage({
    super.key,
    required this.ncode,
  });

  @override
  State<TocPage> createState() => _TocPageState();
}

class _TocPageState extends State<TocPage> {
  final ApiService _apiService = ApiService();
  NovelInfo? _novelInfo;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNovelInfo();
  }

  Future<void> _fetchNovelInfo() async {
    try {
      final novelInfo = await _apiService.fetchNovelInfo(widget.ncode);
      if (mounted) {
        setState(() {
          _novelInfo = novelInfo;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load novel info: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_novelInfo?.title ?? '目次'),
      ),
      body: ListView.builder(
        itemCount: _novelInfo?.episodes?.length ?? 0,
        itemBuilder: (context, index) {
          final episode = _novelInfo!.episodes![index];
          final episodeTitle = episode['title'] as String? ?? 'No Title';
          return ListTile(
            title: Text(episodeTitle),
            onTap: () {
              context.go('/novel/${widget.ncode}?episode=${index + 1}');
            },
          );
        },
      ),
    );
  }
}
