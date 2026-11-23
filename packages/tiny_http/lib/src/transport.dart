import 'dart:convert';

/// Raw data returned by a transport.
class RawHttpResponse {
  /// Creates a raw response.
  RawHttpResponse({
    required this.statusCode,
    required this.headers,
    required this.bytes,
  });

  /// The HTTP status code.
  final int statusCode;

  /// The headers. Keys are lower-cased.
  final Map<String, List<String>> headers;

  /// The raw body bytes.
  final List<int> bytes;

  /// The body decoded as UTF-8.
  String get bodyText => utf8.decode(bytes, allowMalformed: true);
}

/// The lower layer that actually performs HTTP requests.
///
/// Tests inject a fake implementation of this.
abstract class HttpTransport {
  /// Sends a GET request.
  Future<RawHttpResponse> send(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  });

  /// Closes any kept-alive connections.
  void close();
}

/// A failure that produced no HTTP response, such as a socket error.
class HttpTransportException implements Exception {
  /// Creates the exception.
  const HttpTransportException(this.cause);

  /// The underlying error.
  final Object cause;

  @override
  String toString() => 'HttpTransportException: $cause';
}
