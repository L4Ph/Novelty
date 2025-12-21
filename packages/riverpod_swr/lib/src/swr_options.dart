/// Configuration options for SWR (Stale-While-Revalidate) requests.
class SwrOptions {
  /// Creates a new [SwrOptions] configuration.
  const SwrOptions({
    this.staleDuration = Duration.zero,
    this.dedupInterval = const Duration(seconds: 2),
    this.retryCount = 3,
    this.awaitForInitialData = true,
  });

  /// Date/Time after which data is considered stale.
  /// If data is fetched within this duration, it will be returned immediately
  /// without triggering a new fetch.
  /// Default: `Duration.zero` (always stale).
  final Duration staleDuration;

  /// Duration to ignore identical requests.
  /// If a request is made within this interval of a previous IDENTICAL request,
  /// it will be ignored (deduplicated).
  /// Default: `Duration(seconds: 2)`.
  final Duration dedupInterval;

  /// Number of times to retry a failed fetch.
  /// Default: 3.
  final int retryCount;

  /// Whether to wait for the fetch to complete if the local data is empty/null.
  /// If true, the stream will not emit until the initial fetch completes.
  /// Default: true.
  final bool awaitForInitialData;
}
