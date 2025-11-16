import 'package:novelty/models/episode.dart';
import 'package:novelty/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episode_provider.g.dart';

@riverpod
/// 小説のエピソードを取得するプロバイダー。
Future<Episode> episode(
  Ref ref, {
  required String ncode,
  required int episode,
}) {
  final apiService = ApiService();
  return apiService.fetchEpisode(ncode, episode);
}

@riverpod
/// 小説のエピソードリストを取得するプロバイダー。
Future<List<Episode>> episodeList(Ref ref, String key) async {
  final parts = key.split('_');
  if (parts.length != 2) {
    throw ArgumentError('Invalid episode list key format: $key');
  }

  final ncode = parts[0];
  final page = int.parse(parts[1]);

  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchEpisodeList(ncode, page);
}
