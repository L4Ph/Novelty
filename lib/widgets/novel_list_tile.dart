import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/utils/app_constants.dart';

/// 小説リストのタイルを表示するウィジェット。
class NovelListTile extends StatelessWidget {
  /// コンストラクタ。
  const NovelListTile({
    required this.item,
    super.key,
    this.isRanking = false,
    this.onTap,
    this.onLongPress,
  });

  /// 小説の情報。
  final RankingResponse item;

  /// ランキングリストかどうか。
  final bool isRanking;

  /// タップ時のコールバック。
  final VoidCallback? onTap;

  /// 長押し時のコールバック。
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
    final status = item.end == null || item.end == -1 || item.novelType == null
        ? '情報取得失敗'
        : (item.novelType == 2 ? '短編' : (item.end == 0 ? '完結済' : '連載中'));

    return ListTile(
      leading: isRanking ? Text('${item.rank ?? ''}') : null,
      title: Text(title),
      subtitle: Text(
        'Nコード: ${item.ncode} - ${item.allPoint ?? item.pt ?? 0}pt\nジャンル: $genreName - $status',
      ),
      onTap:
          onTap ??
          () {
            final ncode = item.ncode.toLowerCase();
            context.push('/novel/$ncode');
          },
      onLongPress: onLongPress,
    );
  }
}
