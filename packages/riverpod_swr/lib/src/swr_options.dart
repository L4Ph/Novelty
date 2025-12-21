/// SWR (Stale-While-Revalidate) リクエストの設定オプション。
class SwrOptions {
  /// [SwrOptions] 設定を新しく作成します。
  const SwrOptions({
    this.staleDuration = Duration.zero,
    this.dedupInterval = const Duration(seconds: 2),
    this.retryCount = 3,
    this.awaitForInitialData = true,
  });

  /// データを古い（stale）とみなすまでの期間。
  /// この期間内にフェッチされたデータがある場合、新しいフェッチをトリガーせずに
  /// 即座にそのデータが返されます。
  /// デフォルト: `Duration.zero`（常に古いとみなす）。
  final Duration staleDuration;

  /// 同一のリクエストを無視する期間。
  /// 前回の「同一」リクエストからこの間隔内にリクエストが行われた場合、
  /// そのリクエストは無視（重複排除）されます。
  /// デフォルト: `Duration(seconds: 2)`。
  final Duration dedupInterval;

  /// フェッチに失敗した際の再試行回数。
  /// デフォルト: 3回。
  final int retryCount;

  /// ローカルデータが空またはnullの場合にフェッチの完了を待機するかどうか。
  /// trueの場合、初期フェッチが完了するまでストリームはデータを発行しません。
  /// デフォルト: true。
  final bool awaitForInitialData;
}
