import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';
import 'package:tiny_http/tiny_http.dart';

/// Serves a recorded novelapi response body.
///
/// The body is stored decompressed so that a re-capture shows up as a readable
/// diff; gzip is applied here because ApiService expects the `gzip=5` shape.
class _FixtureTransport implements HttpTransport {
  _FixtureTransport(this.body);

  final String body;

  @override
  Future<RawHttpResponse> send(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async => RawHttpResponse(
    statusCode: 200,
    headers: const <String, List<String>>{
      'content-type': <String>['application/json'],
    },
    bytes: gzip.encode(utf8.encode(body)),
  );

  @override
  void close() {}
}

/// Recorded from https://api.syosetu.com/novelapi/api with the same `of`
/// parameter the app sends. These pin the wire contract: when the API renames
/// or retypes a field, the assertions below fail instead of the field silently
/// turning null in production.
String _fixture(String name) =>
    File('test/fixtures/narou/$name.json').readAsStringSync();

ApiService _service(String fixture) => ApiService(
  http: TinyHttp(
    transport: _FixtureTransport(_fixture(fixture)),
    minInterval: Duration.zero,
  ),
);

void main() {
  group('novelapi contract', () {
    test('a single work keeps every field the app relies on', () async {
      final info = await _service('novel').fetchNovelInfo('n9669bn');

      // readValue normalises ncode to lower case, and derives workId from it.
      expect(info.ncode, equals('n9669bn'));
      expect(info.workId, equals('n9669bn'));
      expect(info.title, equals('桜一分咲き'));
      expect(info.writer, isNotEmpty);
      expect(info.story, isNotEmpty);
      expect(info.userId, equals(73722));
      // Short story: noveltype=2 in the payload.
      expect(info.novelType, equals(2));
      expect(info.generalAllNo, equals(1));
      // genre arrives as a number and must normalise to a string.
      expect(info.genreId, equals('102'));
      // Sanity check that the numeric converters ran at all.
      expect(info.globalPoint, isNotNull);
      expect(info.allPoint, isNotNull);
      expect(info.keyword, isNotNull);
    });

    test(
      'a short story is recognised without inferring from the count',
      () async {
        final service = _service('short');

        final result = await service.searchNovels(
          const NovelSearchQuery(word: 'x', lim: 1),
        );

        final info = result.novels.single;
        expect(info.novelType, equals(2));
        expect(info.generalAllNo, equals(1));
      },
    );

    test('a search response reports allcount and the first work', () async {
      final service = _service('search');

      final result = await service.searchNovels(
        const NovelSearchQuery(word: '魔王', lim: 1),
      );

      expect(result.allCount, equals(56455));
      expect(result.novels, hasLength(1));
      expect(result.novels.single.ncode, equals('n5680mx'));
      expect(result.novels.single.novelType, equals(1));
    });

    test('a ranking response reports allcount and the first work', () async {
      final service = _service('ranking');

      final result = await service.searchNovels(
        const NovelSearchQuery(order: 'hyoka', lim: 1),
      );

      expect(result.allCount, equals(1273206));
      expect(result.novels.single.ncode, equals('n2710db'));
      expect(result.novels.single.generalAllNo, equals(662));
    });

    test('an unknown ncode is reported as not found', () async {
      final service = _service('not_found');

      await expectLater(
        service.fetchNovelInfo('n0000xx'),
        throwsA(isA<NovelNotFoundException>()),
      );
    });
  });
}
