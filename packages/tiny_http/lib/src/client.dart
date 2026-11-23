import 'dart:async';
import 'dart:io' show SocketException;
import 'dart:math';

import 'package:tiny_http/src/exception.dart';
import 'package:tiny_http/src/io_transport.dart';
import 'package:tiny_http/src/response.dart';
import 'package:tiny_http/src/transport.dart';

/// HTTP status codes that are worth retrying.
const Set<int> retryStatusCodes = <int>{408, 413, 429, 500, 502, 503, 504};

/// Status codes whose `Retry-After` header is authoritative.
const Set<int> afterStatusCodes = <int>{413, 429, 503};

/// A small GET-only HTTP client.
///
/// Provides exponential backoff with full jitter, per-attempt timeouts,
/// request spacing and typed exceptions. It deliberately holds no cache:
/// the app caches at the database layer instead.
class TinyHttp {
  /// Creates a client.
  ///
  /// [transport], [sleep] and [random] are injectable for tests.
  TinyHttp({
    HttpTransport? transport,
    this.minInterval = const Duration(milliseconds: 300),
    this.timeout = const Duration(seconds: 10),
    this.retryLimit = 2,
    this.baseDelay = const Duration(milliseconds: 300),
    Future<void> Function(Duration)? sleep,
    Random? random,
  }) : _transport = transport ?? IoHttpTransport(),
       _sleep = sleep ?? _defaultSleep,
       _random = random ?? Random() {
    _stopwatch.start();
  }

  /// Minimum spacing between requests, applied before every attempt,
  /// retries included.
  final Duration minInterval;

  /// Timeout for a single attempt.
  final Duration timeout;

  /// Maximum number of retries. `0` disables retrying.
  final int retryLimit;

  /// Base value for the exponential backoff.
  final Duration baseDelay;

  final HttpTransport _transport;
  final Future<void> Function(Duration) _sleep;
  final Random _random;
  final Stopwatch _stopwatch = Stopwatch();
  Duration _lastAttemptAt = Duration.zero;
  bool _hasAttempted = false;

  /// Sends a GET request.
  ///
  /// A non-2xx status that is not retryable is thrown as-is in a
  /// [TinyHttpStatusException]. When a retryable failure exhausts the
  /// budget, the final cause is wrapped in [TinyHttpRetryException].
  Future<TinyHttpResponse> get(Uri uri, {Map<String, String>? headers}) async {
    for (var attempt = 1; ; attempt++) {
      await _throttle();
      try {
        return await _attempt(uri, headers);
      } on _RetryableFailure catch (failure) {
        if (attempt > retryLimit) {
          throw retryLimit == 0
              ? failure.error
              : TinyHttpRetryException(
                  uri: uri,
                  attempts: attempt,
                  cause: failure.error,
                );
        }
        await _sleep(_retryDelay(attempt, failure.retryAfter));
      }
    }
  }

  /// Closes any kept-alive connections.
  void close() => _transport.close();

  Future<TinyHttpResponse> _attempt(
    Uri uri,
    Map<String, String>? headers,
  ) async {
    try {
      final raw = await _transport
          .send(uri, headers: headers ?? const <String, String>{})
          .timeout(timeout);

      if (raw.statusCode >= 200 && raw.statusCode < 300) {
        return TinyHttpResponse.fromRaw(raw);
      }

      final error = TinyHttpStatusException(
        uri: uri,
        statusCode: raw.statusCode,
        body: _truncate(raw.bodyText),
      );
      if (!retryStatusCodes.contains(raw.statusCode)) {
        throw error;
      }
      throw _RetryableFailure(
        error,
        afterStatusCodes.contains(raw.statusCode)
            ? _parseRetryAfter(raw.headers)
            : null,
      );
    } on TimeoutException {
      throw _RetryableFailure(TinyHttpTimeoutException(uri: uri), null);
    } on SocketException catch (e) {
      throw _RetryableFailure(
        TinyHttpNetworkException(uri: uri, cause: e),
        null,
      );
    } on HttpTransportException catch (e) {
      throw _RetryableFailure(
        TinyHttpNetworkException(uri: uri, cause: e.cause),
        null,
      );
    }
  }

  Future<void> _throttle() async {
    if (_hasAttempted) {
      final sinceLast = _stopwatch.elapsed - _lastAttemptAt;
      if (sinceLast < minInterval) {
        await _sleep(minInterval - sinceLast);
      }
    }
    _hasAttempted = true;
    _lastAttemptAt = _stopwatch.elapsed;
  }

  /// Delay before the next attempt.
  ///
  /// `Retry-After` (seconds) wins verbatim for [afterStatusCodes];
  /// otherwise the exponential backoff is multiplied by a full-jitter
  /// random factor.
  Duration _retryDelay(int attempt, Duration? retryAfter) {
    if (retryAfter != null) {
      return retryAfter;
    }
    final backoff = baseDelay.inMilliseconds * pow(2, attempt - 1);
    return Duration(milliseconds: (_random.nextDouble() * backoff).round());
  }

  /// Parses `Retry-After` as a number of seconds.
  ///
  /// shortcut: the HTTP-date form is ignored and falls back to the
  /// exponential backoff; the sites we scrape only send seconds.
  Duration? _parseRetryAfter(Map<String, List<String>> headers) {
    final raw = headers['retry-after'];
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final seconds = int.tryParse(raw.first.trim());
    if (seconds == null || seconds < 0) {
      return null;
    }
    return Duration(seconds: seconds);
  }

  static String _truncate(String body) =>
      body.length <= TinyHttpStatusException.maxExceptionBodyLength
      ? body
      : '${body.substring(0, TinyHttpStatusException.maxExceptionBodyLength)}…';

  static Future<void> _defaultSleep(Duration duration) =>
      Future<void>.delayed(duration);
}

/// Carries a retryable failure along with its retry hint.
class _RetryableFailure implements Exception {
  const _RetryableFailure(this.error, this.retryAfter);

  final TinyHttpException error;
  final Duration? retryAfter;
}
