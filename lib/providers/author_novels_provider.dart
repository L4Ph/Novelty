import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'author_novels_provider.g.dart';

@riverpod
/// 指定したuserIdの作者の小説一覧を取得するFutureProvider
Future<List<NovelInfo>> authorNovels(Ref ref, int userId) async {
  final apiService = ref.read(apiServiceProvider);
  final query = NovelSearchQuery(userid: [userId]);
  final result = await apiService.searchNovels(query);
  return result.novels;
}
