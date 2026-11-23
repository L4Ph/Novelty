import 'dart:convert';

import 'package:tiny_http/src/transport.dart';

/// A successful (2xx) response.
class TinyHttpResponse {
  /// Creates a response.
  TinyHttpResponse({
    required this.statusCode,
    required this.headers,
    required this.bytes,
  });

  /// Creates a response from [RawHttpResponse].
  factory TinyHttpResponse.fromRaw(RawHttpResponse raw) => TinyHttpResponse(
    statusCode: raw.statusCode,
    headers: raw.headers,
    bytes: raw.bytes,
  );

  /// The HTTP status code.
  final int statusCode;

  /// The headers. Keys are lower-cased.
  final Map<String, List<String>> headers;

  /// The raw body bytes.
  final List<int> bytes;

  /// The body decoded as UTF-8.
  ///
  /// Malformed bytes are replaced rather than thrown: scraped markup is
  /// not always valid, and showing garbled text beats crashing.
  String get text => utf8.decode(bytes, allowMalformed: true);
}
