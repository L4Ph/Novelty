import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/services/database_service.dart';
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
          () {
            final ncode = item.ncode.toLowerCase();
            if (item.novelType == 2) {
              context.push('/novel/$ncode');
            } else {
              context.push('/toc/$ncode');
            }
          },
      onLongPress: onLongPress,
    );
  }
}
