import 'package:freezed_annotation/freezed_annotation.dart';

part 'novel_download_summary.freezed.dart';

/// 小説のダウンロード状態の集計情報を表すクラス。
@freezed
abstract class NovelDownloadSummary with _$NovelDownloadSummary {
  const factory NovelDownloadSummary({
    /// 小説のncode
    required String ncode,
    /// ダウンロード成功したエピソード数
    required int successCount,
    /// ダウンロード失敗したエピソード数
    required int failureCount,
    /// ダウンロード対象の総エピソード数
    required int totalEpisodes,
  }) = _NovelDownloadSummary;

  const NovelDownloadSummary._();

  /// すべてのエピソードがダウンロード完了しているか
  bool get isComplete => successCount == totalEpisodes && totalEpisodes > 0;

  /// ダウンロード中かどうか（一部成功または失敗しているが未完了）
  bool get isDownloading =>
      (successCount > 0 || failureCount > 0) && !isComplete;

  /// ダウンロード状態を返す
  /// 0: 未ダウンロード, 1: ダウンロード中, 2: 完了, 3: 失敗
  int get downloadStatus {
    if (successCount == totalEpisodes && totalEpisodes > 0) {
      return 2; // 完了
    } else if (successCount + failureCount == totalEpisodes &&
        failureCount > 0) {
      return 3; // 一部失敗
    } else if (successCount > 0 || failureCount > 0) {
      return 1; // ダウンロード中
    } else {
      return 0; // 未ダウンロード
    }
  }

  /// ダウンロード済みエピソード数（成功したもののみ）
  int get downloadedEpisodes => successCount;
}
