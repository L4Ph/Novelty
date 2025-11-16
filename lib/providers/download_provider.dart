import 'package:novelty/models/download_progress.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_provider.g.dart';

@riverpod
/// 小説のダウンロード進捗を監視するプロバイダー。
Stream<DownloadProgress?> downloadProgress(Ref ref, String ncode) {
  final repo = ref.watch(novelRepositoryProvider);
  return repo.watchDownloadProgress(ncode);
}
