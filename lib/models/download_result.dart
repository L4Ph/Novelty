import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_result.freezed.dart';

/// ダウンロード/削除操作の結果を表すモデル。
@freezed
class DownloadResult with _$DownloadResult {
  /// 成功時の結果を作成する。
  const factory DownloadResult.success({
    /// ライブラリへの追加が必要かどうか
    @Default(false) bool needsLibraryAddition,
  }) = _Success;

  /// ユーザーによる操作のキャンセル時の結果を作成する。
  const factory DownloadResult.cancelled() = _Cancelled;

  /// エラー発生時の結果を作成する。
  const factory DownloadResult.error(
    /// エラーメッセージ
    String message,
  ) = _Error;
}
