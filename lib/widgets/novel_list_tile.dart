import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/utils/app_constants.dart';

class NovelListTile extends StatelessWidget {
  const NovelListTile({
    super.key,
    required this.item,
    this.isRanking = false,
    this.onTap,
    this.onLongPress,
  });

  final RankingResponse item;
  final bool isRanking;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final title = item.title ?? 'タイトルなし';
    final genreName = item.genre != null && item.genre != -1
        ? genreList.firstWhere(
                (g) => g['id'] == item.genre,
                orElse: () => {'name': '不明'},
              )['name']
              as String
        : '不明';
    final status = item.end == null || item.end == -1
        ? '情報取得失敗'
        : (item.end == 0 ? '連載中' : '完結済');

    return ListTile(
      leading: isRanking ? Text('${item.rank ?? ''}') : null,
      title: Text(title),
      subtitle: Text(
        'Nコード: ${item.ncode} - ${item.allPoint ?? item.pt ?? 0}pt\nジャンル: $genreName - $status',
      ),
      onTap: onTap ??
          () async {
            final ncode = item.ncode.toLowerCase();
            // Show loading indicator
            final navigator = Navigator.of(context);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
            
            try {
              // Fetch novel info to determine navigation path
              final apiService = ApiService();
              final novelInfo = await apiService.fetchNovelInfo(ncode);
              
              // Dismiss loading dialog
              navigator.pop();
              
              if (!context.mounted) return;
              
              // Determine navigation path based on novel info
              if (novelInfo.novelType == 2 || novelInfo.episodes == null || novelInfo.episodes!.isEmpty) {
                // Short story or no episodes, go directly to the novel page
                context.push('/novel/$ncode/1');
              } else {
                // Has multiple episodes, go to TOC page
                context.push('/toc/$ncode');
              }
            } catch (e) {
              // Dismiss loading dialog
              navigator.pop();
              if (!context.mounted) return;
              
              // Show error and default to TOC page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('情報の取得に失敗しました: $e')),
              );
              context.push('/toc/$ncode');
            }
          },
      onLongPress: onLongPress,
    );
  }
}
