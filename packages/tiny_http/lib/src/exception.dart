/// Exceptions thrown by the HTTP client.
///
/// `sealed` so callers get exhaustive `switch` checking.
sealed class TinyHttpException implements Exception {
  /// Creates the exception.
  const TinyHttpException({required this.uri});

  /// The requested URI.
  final Uri uri;
}

/// A response with a non-2xx status.
class TinyHttpStatusException extends TinyHttpException {
  /// Creates the exception.
  const TinyHttpStatusException({
    required super.uri,
    required this.statusCode,
    this.body = '',
  });

  /// The HTTP status code.
  final int statusCode;

  /// The response body, truncated to [maxExceptionBodyLength].
  final String body;

  /// Maximum number of body characters kept on the exception.
  static const int maxExceptionBodyLength = 4096;

  /// Deliberately excludes the body.
  ///
  /// The body is often a full HTML error page and some call sites render
  /// `toString()` directly, so keeping it out prevents flooding the UI.
  @override
  String toString() => 'TinyHttpStatusException($statusCode): $uri';
}

/// The request timed out.
class TinyHttpTimeoutException extends TinyHttpException {
  /// Creates the exception.
  const TinyHttpTimeoutException({required super.uri});

  @override
  String toString() => 'TinyHttpTimeoutException: $uri';
}

/// A failure that produced no response, such as a socket error.
class TinyHttpNetworkException extends TinyHttpException {
  /// Creates the exception.
  const TinyHttpNetworkException({required super.uri, this.cause});

  /// The underlying error.
  final Object? cause;

  @override
  String toString() => 'TinyHttpNetworkException: $uri';
}

/// The retry budget is exhausted.
class TinyHttpRetryException extends TinyHttpException {
  /// Creates the exception.
  const TinyHttpRetryException({
    required super.uri,
    required this.attempts,
    required this.cause,
  });

  /// Number of attempts made.
  final int attempts;

  /// The failure of the final attempt.
  final TinyHttpException cause;

  @override
  String toString() =>
      'TinyHttpRetryException($attempts attempts): $uri ($cause)';
}
