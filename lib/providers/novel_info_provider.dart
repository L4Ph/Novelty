import 'package:drift/drift.dart' as drift;
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'novel_info_provider.g.dart';

@riverpod
/// 小説の情報を取得するプロバイダー（シンプル版）。
Future<NovelInfo> novelInfo(Ref ref, String ncode) {
  return ApiService().fetchNovelInfo(ncode);
}

@riverpod
/// 小説の情報を取得し、DBにキャッシュするプロバイダー。
///
/// APIから小説情報を取得し、既存のfavステータスを保持しながらDBに保存する。
Future<NovelInfo> novelInfoWithCache(Ref ref, String ncode) async {
  final apiService = ref.read(apiServiceProvider);
  final db = ref.watch(appDatabaseProvider);

  final novelInfo = await apiService.fetchNovelInfo(ncode);

  // Upsert novel data, preserving fav status
  final existing = await db.getNovel(ncode);
  await db.insertNovel(
    novelInfo.toDbCompanion().copyWith(
      fav: drift.Value(existing?.fav ?? 0),
    ),
  );

  return novelInfo;
}
