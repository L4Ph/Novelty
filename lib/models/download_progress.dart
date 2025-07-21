import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_progress.freezed.dart';

/// ダウンロード進捗の状態を表すクラス。
@freezed
abstract class DownloadProgress with _$DownloadProgress {
  /// ダウンロード進捗の状態を作成する。
  const factory DownloadProgress({
    /// 現在ダウンロード中のエピソード数
    required int currentEpisode,
    /// 全エピソード数
    required int totalEpisodes,
    /// ダウンロード中かどうか
    required bool isDownloading,
    /// エラーメッセージ（ある場合）
    String? errorMessage,
  }) = _DownloadProgress;

  const DownloadProgress._();

  /// 進捗の割合を取得する (0.0 - 1.0)
  double get progress {
    if (totalEpisodes == 0) return 0;
    return currentEpisode / totalEpisodes;
  }

  /// ダウンロードが完了しているかどうか
  bool get isCompleted => currentEpisode >= totalEpisodes && !isDownloading;

  /// ダウンロードでエラーが発生しているかどうか
  bool get hasError => errorMessage != null;
}
