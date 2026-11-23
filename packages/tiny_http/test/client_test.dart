import 'dart:async';
import 'dart:convert';
import 'dart:io'
    show HandshakeException, HttpClient, HttpClientRequest, SocketException;
import 'dart:math';

import 'package:test/test.dart';
import 'package:tiny_http/tiny_http.dart';

/// A fake [HttpTransport] that replays a scripted sequence.
class _FakeTransport implements HttpTransport {
  _FakeTransport(this._script);

  /// Consumed from the front on every call.
  final List<Object> _script;

  /// URIs that were requested.
  final List<Uri> requestedUris = <Uri>[];

  /// Whether [close] was called.
  bool closed = false;

  @override
  Future<RawHttpResponse> send(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async {
    requestedUris.add(uri);
    return switch (_script.removeAt(0)) {
      final RawHttpResponse response => response,
      final Future<RawHttpResponse> response => await response,
      final Exception error => throw error,
      _ => throw StateError(
        'script must contain a response, future or exception',
      ),
    };
  }

  @override
  void close() => closed = true;
}

RawHttpResponse _ok(String body, {int statusCode = 200}) => RawHttpResponse(
  statusCode: statusCode,
  headers: const <String, List<String>>{},
  bytes: utf8.encode(body),
);

RawHttpResponse _ng(
  int statusCode, {
  String body = '',
  Map<String, List<String>> headers = const <String, List<String>>{},
}) => RawHttpResponse(
  statusCode: statusCode,
  headers: headers,
  bytes: utf8.encode(body),
);

TinyHttp _client(
  List<Object> script, {
  int retryLimit = 2,
  Duration minInterval = Duration.zero,
  Duration baseDelay = const Duration(milliseconds: 300),
  List<Duration>? delays,
  int seed = 1,
}) => TinyHttp(
  transport: _FakeTransport(script),
  retryLimit: retryLimit,
  minInterval: minInterval,
  baseDelay: baseDelay,
  random: Random(seed),
  sleep: (duration) async => delays?.add(duration),
);

void main() {
  final uri = Uri.parse('https://example.test/works/1');

  group('IoHttpTransport', () {
    test('wraps a TLS handshake failure and preserves its cause', () async {
      const failure = HandshakeException('TLS handshake failed');
      final transport = IoHttpTransport(
        client: _FailingHttpClient(() => throw failure),
      );

      await expectLater(
        transport.send(uri),
        throwsA(
          isA<HttpTransportException>().having(
            (error) => error.cause,
            'cause',
            same(failure),
          ),
        ),
      );
    });

    test('does not wrap programming errors', () async {
      final failure = StateError('invalid client state');
      final transport = IoHttpTransport(
        client: _FailingHttpClient(() => throw failure),
      );

      await expectLater(transport.send(uri), throwsA(same(failure)));
    });
  });

  group('TinyHttp', () {
    test('returns the status and body for a 2xx response', () async {
      final client = _client(<Object>[_ok('hello')]);

      final response = await client.get(uri);

      expect(response.statusCode, equals(200));
      expect(response.text, equals('hello'));
      expect(response.bytes, equals(utf8.encode('hello')));
    });

    test(
      'throws a status exception that keeps the body for a non-retryable status',
      () async {
        final client = _client(<Object>[_ng(404, body: 'not found')]);

        await expectLater(
          client.get(uri),
          throwsA(
            isA<TinyHttpStatusException>()
                .having((e) => e.statusCode, 'statusCode', 404)
                .having((e) => e.body, 'body', 'not found')
                .having((e) => e.uri, 'uri', uri),
          ),
        );
      },
    );

    test('does not expose the body in toString', () async {
      final client = _client(<Object>[
        _ng(404, body: '<html>huge body</html>'),
      ]);

      await expectLater(
        client.get(uri),
        throwsA(
          isA<TinyHttpStatusException>().having(
            (e) => e.toString(),
            'toString',
            isNot(contains('huge body')),
          ),
        ),
      );
    });

    test('does not retry a non-retryable status', () async {
      final transport = _FakeTransport(<Object>[_ng(404)]);
      final client = TinyHttp(
        transport: transport,
        minInterval: Duration.zero,
        sleep: (_) async {},
      );

      await expectLater(
        client.get(uri),
        throwsA(isA<TinyHttpStatusException>()),
      );
      expect(transport.requestedUris, hasLength(1));
    });

    test(
      'retries a retryable status up to the limit and wraps the cause',
      () async {
        final transport = _FakeTransport(<Object>[
          _ng(500),
          _ng(502),
          _ng(503),
        ]);
        final client = TinyHttp(
          transport: transport,
          minInterval: Duration.zero,
          sleep: (_) async {},
        );

        await expectLater(
          client.get(uri),
          throwsA(
            isA<TinyHttpRetryException>()
                .having((e) => e.attempts, 'attempts', 3)
                .having(
                  (e) => e.cause,
                  'cause',
                  isA<TinyHttpStatusException>().having(
                    (e) => e.statusCode,
                    'statusCode',
                    503,
                  ),
                ),
          ),
        );
        expect(transport.requestedUris, hasLength(3));
      },
    );

    test('stops retrying once a request succeeds', () async {
      final transport = _FakeTransport(<Object>[_ng(500), _ok('ok')]);
      final client = TinyHttp(
        transport: transport,
        minInterval: Duration.zero,
        sleep: (_) async {},
      );

      final response = await client.get(uri);

      expect(response.text, equals('ok'));
      expect(transport.requestedUris, hasLength(2));
    });

    test('throws the plain exception when retryLimit is 0', () async {
      final transport = _FakeTransport(<Object>[_ng(500)]);
      final client = TinyHttp(
        transport: transport,
        retryLimit: 0,
        minInterval: Duration.zero,
        sleep: (_) async {},
      );

      await expectLater(
        client.get(uri),
        throwsA(isA<TinyHttpStatusException>()),
      );
      expect(transport.requestedUris, hasLength(1));
    });

    test('retries a socket error as a network failure', () async {
      final transport = _FakeTransport(<Object>[
        const SocketException('connection refused'),
        _ok('ok'),
      ]);
      final client = TinyHttp(
        transport: transport,
        minInterval: Duration.zero,
        sleep: (_) async {},
      );

      final response = await client.get(uri);

      expect(response.text, equals('ok'));
      expect(transport.requestedUris, hasLength(2));
    });

    test('surfaces an exhausted socket error as a network exception', () async {
      final transport = _FakeTransport(<Object>[
        const SocketException('connection refused'),
      ]);
      final client = TinyHttp(
        transport: transport,
        retryLimit: 0,
        minInterval: Duration.zero,
        sleep: (_) async {},
      );

      await expectLater(
        client.get(uri),
        throwsA(
          isA<TinyHttpNetworkException>().having(
            (e) => e.cause,
            'cause',
            isA<SocketException>(),
          ),
        ),
      );
    });

    test('wraps a transport failure as a network exception', () async {
      final transport = _FakeTransport(<Object>[
        const HttpTransportException(SocketException('tls handshake failed')),
      ]);
      final client = TinyHttp(
        transport: transport,
        retryLimit: 0,
        minInterval: Duration.zero,
        sleep: (_) async {},
      );

      await expectLater(
        client.get(uri),
        throwsA(
          isA<TinyHttpNetworkException>().having(
            (e) => e.cause,
            'cause',
            isA<SocketException>(),
          ),
        ),
      );
    });

    test('retries a timeout', () async {
      final transport = _FakeTransport(<Object>[
        TimeoutException('slow'),
        _ok('ok'),
      ]);
      final client = TinyHttp(
        transport: transport,
        minInterval: Duration.zero,
        sleep: (_) async {},
      );

      final response = await client.get(uri);

      expect(response.text, equals('ok'));
      expect(transport.requestedUris, hasLength(2));
    });

    test('throws a timeout exception when no response arrives', () async {
      final client = TinyHttp(
        transport: _NeverRespondingTransport(),
        retryLimit: 0,
        minInterval: Duration.zero,
        timeout: const Duration(milliseconds: 20),
        sleep: (_) async {},
      );

      await expectLater(
        client.get(uri),
        throwsA(isA<TinyHttpTimeoutException>()),
      );
    });

    test('uses the Retry-After seconds verbatim', () async {
      final delays = <Duration>[];
      final transport = _FakeTransport(<Object>[
        _ng(
          429,
          headers: const <String, List<String>>{
            'retry-after': <String>['2'],
          },
        ),
        _ok('ok'),
      ]);
      final client = TinyHttp(
        transport: transport,
        minInterval: Duration.zero,
        sleep: (duration) async => delays.add(duration),
      );

      await client.get(uri);

      expect(delays, equals(<Duration>[const Duration(seconds: 2)]));
    });

    test('ignores Retry-After for statuses outside afterStatusCodes', () async {
      final delays = <Duration>[];
      final transport = _FakeTransport(<Object>[
        _ng(
          500,
          headers: const <String, List<String>>{
            'retry-after': <String>['30'],
          },
        ),
        _ok('ok'),
      ]);
      final client = TinyHttp(
        transport: transport,
        minInterval: Duration.zero,
        random: Random(1),
        sleep: (duration) async => delays.add(duration),
      );

      await client.get(uri);

      expect(delays, hasLength(1));
      expect(delays.single, lessThan(const Duration(seconds: 30)));
    });

    test(
      'backs off within the base delay when Retry-After is absent',
      () async {
        final delays = <Duration>[];
        final transport = _FakeTransport(<Object>[_ng(500), _ok('ok')]);
        final client = TinyHttp(
          transport: transport,
          minInterval: Duration.zero,
          random: Random(1),
          sleep: (duration) async => delays.add(duration),
        );

        await client.get(uri);

        expect(delays, hasLength(1));
        expect(delays.single, greaterThanOrEqualTo(Duration.zero));
        expect(
          delays.single,
          lessThanOrEqualTo(const Duration(milliseconds: 300)),
        );
      },
    );

    test('waits between requests that are closer than minInterval', () async {
      const interval = Duration(milliseconds: 100);
      var elapsed = Duration.zero;
      final transport = _FakeTransport(<Object>[_ok('1'), _ok('2'), _ok('3')]);
      final client = TinyHttp(
        transport: transport,
        minInterval: interval,
        elapsed: () => elapsed,
        sleep: (duration) async {
          elapsed += duration;
        },
      );

      await client.get(uri);
      expect(elapsed, Duration.zero);
      elapsed += const Duration(milliseconds: 40);
      await client.get(uri);
      expect(elapsed, interval);

      elapsed += interval;
      await client.get(uri);
      expect(elapsed, interval * 2);
    });

    test(
      'spaces concurrent sends while the first response is pending',
      () async {
        const interval = Duration(milliseconds: 100);
        var elapsed = Duration.zero;
        final waits = <(Duration, Completer<void>)>[];
        final firstResponse = Completer<RawHttpResponse>();
        final transport = _FakeTransport(<Object>[
          firstResponse.future,
          _ok('2'),
          _ok('3'),
        ]);
        final client = TinyHttp(
          transport: transport,
          minInterval: interval,
          elapsed: () => elapsed,
          sleep: (duration) {
            final wake = Completer<void>();
            waits.add((elapsed + duration, wake));
            return wake.future;
          },
        );

        Future<void> advanceTo(Duration time) async {
          elapsed = time;
          for (final (deadline, wake) in waits) {
            if (deadline <= elapsed && !wake.isCompleted) wake.complete();
          }
          await Future<void>.delayed(Duration.zero);
        }

        final secondUri = uri.resolve('2');
        final thirdUri = uri.resolve('3');
        final first = client.get(uri);
        final second = client.get(secondUri);
        final third = client.get(thirdUri);

        try {
          await advanceTo(const Duration(milliseconds: 99));
          expect(transport.requestedUris, [uri]);
          await advanceTo(interval);
          expect(transport.requestedUris, [uri, secondUri]);
          await advanceTo(interval * 2);
          expect(transport.requestedUris, [uri, secondUri, thirdUri]);
        } finally {
          firstResponse.complete(_ok('1'));
        }
        await Future.wait([first, second, third]);
      },
    );

    test('enforces minInterval with real waiting', () async {
      // Allow for timer resolution: assert 250ms out of a 300ms interval.
      final transport = _FakeTransport(<Object>[_ok('1'), _ok('2')]);
      // 300ms is the default minInterval.
      final client = TinyHttp(transport: transport);
      final stopwatch = Stopwatch()..start();

      await client.get(uri);
      await client.get(uri);

      stopwatch.stop();
      expect(
        stopwatch.elapsed,
        greaterThanOrEqualTo(const Duration(milliseconds: 250)),
      );
    });

    test('propagates close to the transport', () {
      final transport = _FakeTransport(<Object>[]);

      TinyHttp(transport: transport).close();

      expect(transport.closed, isTrue);
    });
  });
}

class _FailingHttpClient implements HttpClient {
  _FailingHttpClient(this.fail);

  final Never Function() fail;

  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => fail();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A fake [HttpTransport] that never responds.
class _NeverRespondingTransport implements HttpTransport {
  @override
  Future<RawHttpResponse> send(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) => Completer<RawHttpResponse>().future;

  @override
  void close() {}
}
