import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/services/database_service.dart';
import 'package:novelty/utils/app_constants.dart';

class NovelList extends StatefulWidget {
  const NovelList({super.key, required this.novels, this.isRanking = true});
  final List<RankingResponse> novels;
  final bool isRanking;

  @override
  State<NovelList> createState() => _NovelListState();
}

class _NovelListState extends State<NovelList> {
  final _apiService = ApiService();
  final _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.novels.length,
      itemBuilder: (context, index) {
        final item = widget.novels[index];
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
          leading: widget.isRanking ? Text('${item.rank ?? ''}') : null,
          title: Text(title),
          subtitle: Text(
            'Nコード: ${item.ncode} - ${item.allPoint ?? 0}pt\nジャンル: $genreName - $status',
          ),
          onTap: () {
            final ncode = item.ncode.toLowerCase();
            if (item.novelType == 2) {
              context.push('/novel/$ncode');
            } else {
              context.push('/toc/$ncode');
            }
          },
          onLongPress: () async {
            if (!mounted) return;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            try {
              final isInLibrary = await _databaseService.isNovelInLibrary(
                item.ncode,
              );
              if (isInLibrary) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('すでにライブラリに登録されています')),
                  );
                }
                return;
              }

              final novelInfo = await _apiService.fetchNovelInfoByNcode(
                item.ncode,
              );
              await _databaseService.addNovelToLibrary(novelInfo);
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('ライブラリに追加しました')));
              }
            } on Exception catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('エラー: $e')));
              }
            }
          },
        );
      },
    );
  }
}
