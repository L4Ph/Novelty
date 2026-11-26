import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/settings_provider.dart';

/// Fetches the novels of the author with [userId].
Future<List<NovelInfo>> fetchAuthorNovels(
  ApiService api,
  SettingsController settings,
  int userId,
) async {
  if (settings.isOfflineMode) {
    throw const OfflineException();
  }

  final query = NovelSearchQuery(userid: [userId]);
  final result = await api.searchNovels(query);
  return result.novels;
}
