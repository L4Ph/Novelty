import 'package:flutter/foundation.dart';
import 'package:novelty/utils/value_wrapper.dart';

/// ダウンロード進捗の状態を表すクラス。
@immutable
class DownloadProgress {
  /// ダウンロード進捗の状態を作成する。
  const DownloadProgress({
    required this.currentEpisode,
    required this.totalEpisodes,
    required this.isDownloading,
    this.errorMessage,
  });

  /// 現在ダウンロード中のエピソード数
  final int currentEpisode;

  /// 全エピソード数
  final int totalEpisodes;

  /// ダウンロード中かどうか
  final bool isDownloading;

  /// エラーメッセージ（ある場合）
  final String? errorMessage;

  /// 進捗の割合を取得する (0.0 - 1.0)
  double get progress {
    if (totalEpisodes == 0) return 0;
    return currentEpisode / totalEpisodes;
  }

  /// ダウンロードが完了しているかどうか
  bool get isCompleted => currentEpisode >= totalEpisodes && !isDownloading;

  /// ダウンロードでエラーが発生しているかどうか
  bool get hasError => errorMessage != null;

  /// フィールドを変更した新しいインスタンスを作成する
  DownloadProgress copyWith({
    int? currentEpisode,
    int? totalEpisodes,
    bool? isDownloading,
    Value<String?>? errorMessage,
  }) {
    return DownloadProgress(
      currentEpisode: currentEpisode ?? this.currentEpisode,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      isDownloading: isDownloading ?? this.isDownloading,
      errorMessage: errorMessage != null
          ? errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadProgress &&
          runtimeType == other.runtimeType &&
          currentEpisode == other.currentEpisode &&
          totalEpisodes == other.totalEpisodes &&
          isDownloading == other.isDownloading &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
    currentEpisode,
    totalEpisodes,
    isDownloading,
    errorMessage,
  );

  @override
  String toString() {
    return 'DownloadProgress(currentEpisode: $currentEpisode, '
        'totalEpisodes: $totalEpisodes, isDownloading: $isDownloading, '
        'errorMessage: $errorMessage)';
  }
}
