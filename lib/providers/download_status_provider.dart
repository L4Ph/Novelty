import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/models/download_result.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/providers/download_provider.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_status_provider.g.dart';

@riverpod
/// 小説のダウンロード状態を管理するプロバイダー。
///
/// 小説のダウンロード状態を監視し、ダウンロードの開始や削除を行うためのプロバイダー。
class DownloadStatus extends _$DownloadStatus {
  @override
  Stream<bool> build(NovelInfo novelInfo) {
    final repo = ref.watch(novelRepositoryProvider);

    // downloadProgressProviderを監視
    ref.listen<AsyncValue<DownloadProgress?>>(
      downloadProgressProvider(novelInfo.ncode!),
      (previous, next) {
        final progress = next.value;
        if (progress != null && !progress.isDownloading) {
          // ダウンロードが完了または失敗したら、自身の状態を再評価
          ref.invalidateSelf();
        }
      },
    );

    return repo.isNovelDownloaded(novelInfo.ncode!);
  }

  /// 小説のダウンロードを実行するメソッド。
  ///
  /// Permission処理を含み、結果を[DownloadResult]で返す。
  /// UIでの処理（Dialog、SnackBar表示等）は呼び出し側で行う。
  Future<DownloadResult> executeDownload(NovelInfo novelInfo) async {
    final repo = ref.read(novelRepositoryProvider);
    final previousState = state;
    state = const AsyncValue.loading();

    try {
      final result = await repo.downloadNovelWithPermission(
        novelInfo.ncode!,
        novelInfo.generalAllNo!,
      );

      return result;
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
      await Future<void>.delayed(const Duration(seconds: 2));
      state = previousState;
      return DownloadResult.error(e.toString());
    }
  }

  /// 小説の削除を実行するメソッド。
  ///
  /// 削除確認はUIレイヤーで行うため、このメソッドは削除のみを実行する。
  Future<DownloadResult> executeDelete(NovelInfo novelInfo) async {
    final repo = ref.read(novelRepositoryProvider);
    state = const AsyncValue.loading();

    try {
      await repo.deleteDownloadedNovel(novelInfo.ncode!);
      ref.invalidateSelf();
      return const DownloadResult.success();
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
      return DownloadResult.error(e.toString());
    }
  }
}
