import 'package:flutter/material.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/services/database_service.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

class NovelList extends StatelessWidget {
  const NovelList({super.key, required this.novels, this.isRanking = true});
  final List<RankingResponse> novels;
  final bool isRanking;

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final databaseService = DatabaseService();

    return ListView.builder(
      itemCount: novels.length,
      itemBuilder: (context, index) {
        final item = novels[index];
        return NovelListTile(
          item: item,
          isRanking: isRanking,
          onLongPress: () async {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            try {
              final isInLibrary = await databaseService.isNovelInLibrary(
                item.ncode,
              );
              if (isInLibrary) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('すでにライブラリに登録されています')),
                  );
                }
                return;
              }

              final novelInfo = await apiService.fetchNovelInfoByNcode(
                item.ncode,
              );
              await databaseService.addNovelToLibrary(novelInfo);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('ライブラリに追加しました')));
              }
            } on Exception catch (e) {
              if (context.mounted) {
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

