import 'package:flutter/foundation.dart';

/// 小説のダウンロード状態の集計情報を表すクラス。
@immutable
class NovelDownloadSummary {
  /// ファクトリーコンストラクタ
  const NovelDownloadSummary({
    required this.ncode,
    required this.successCount,
    required this.failureCount,
    required this.totalEpisodes,
  });

  /// 小説のncode
  final String ncode;

  /// ダウンロード成功したエピソード数
  final int successCount;

  /// ダウンロード失敗したエピソード数
  final int failureCount;

  /// ダウンロード対象の総エピソード数
  final int totalEpisodes;

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

  /// フィールドを変更した新しいインスタンスを作成する
  NovelDownloadSummary copyWith({
    String? ncode,
    int? successCount,
    int? failureCount,
    int? totalEpisodes,
  }) {
    return NovelDownloadSummary(
      ncode: ncode ?? this.ncode,
      successCount: successCount ?? this.successCount,
      failureCount: failureCount ?? this.failureCount,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NovelDownloadSummary &&
          runtimeType == other.runtimeType &&
          ncode == other.ncode &&
          successCount == other.successCount &&
          failureCount == other.failureCount &&
          totalEpisodes == other.totalEpisodes;

  @override
  int get hashCode =>
      Object.hash(ncode, successCount, failureCount, totalEpisodes);

  @override
  String toString() {
    return 'NovelDownloadSummary(ncode: $ncode, successCount: $successCount, '
        'failureCount: $failureCount, totalEpisodes: $totalEpisodes)';
  }
}
