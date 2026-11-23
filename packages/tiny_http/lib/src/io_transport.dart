import 'dart:io';

import 'package:tiny_http/src/transport.dart';

/// An [HttpTransport] backed by `dart:io`'s [HttpClient].
class IoHttpTransport implements HttpTransport {
  /// Creates a transport.
  IoHttpTransport({HttpClient? client}) : _client = client ?? HttpClient() {
    _client.autoUncompress = true;
  }

  final HttpClient _client;

  @override
  Future<RawHttpResponse> send(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async {
    try {
      final request = await _client.getUrl(uri);
      headers.forEach(request.headers.set);
      final response = await request.close();
      final bytes = <int>[];
      await response.forEach(bytes.addAll);
      final headerMap = <String, List<String>>{};
      response.headers.forEach((name, values) {
        headerMap[name.toLowerCase()] = values;
      });
      return RawHttpResponse(
        statusCode: response.statusCode,
        headers: headerMap,
        bytes: bytes,
      );
    } on SocketException catch (e) {
      throw HttpTransportException(e);
    } on HttpException catch (e) {
      throw HttpTransportException(e);
    }
  }

  @override
  void close() => _client.close(force: true);
}
