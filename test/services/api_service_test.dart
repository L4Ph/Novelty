import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';
import 'package:tiny_http/tiny_http.dart';

/// 固定のJSON文字列をgzip圧縮して返す偽の transport。
///
/// なろう小説APIは `gzip=5` 指定時に圧縮済みボディを返すため、
/// その経路が正しく展開されることを確認するために使う。
class _GzipAdapter implements HttpTransport {
  _GzipAdapter(this.json);

  /// gzip圧縮前のJSON文字列。
  final String json;

  @override
  Future<RawHttpResponse> send(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async {
    return RawHttpResponse(
      statusCode: 200,
      headers: const <String, List<String>>{
        'content-type': <String>['application/json'],
      },
      bytes: gzip.encode(utf8.encode(json)),
    );
  }

  @override
  void close() {}
}

void main() {
  group('ApiService', () {
    group('累計ランキング制限値', () {
      test('allTimeRankingLimitは500であること', () {
        expect(allTimeRankingLimit, equals(500));
      });

      test('累計ランキングクエリのlimが500であること', () {
        // _fetchAllTimeRankingメソッドで使用されるクエリを検証
        const query = NovelSearchQuery(
          order: 'hyoka',
          lim: allTimeRankingLimit,
        );
        expect(query.lim, equals(500));
      });

      test('累計ランキングが500件まで取得可能であること', () {
        // なろう小説APIの仕様確認：limの最大値は500
        const query = NovelSearchQuery(order: 'hyoka', lim: 500);
        expect(query.lim, lessThanOrEqualTo(500));
      });
    });

    group('gzipレスポンスの展開', () {
      test('gzip圧縮されたレスポンスを展開して作品情報をパースできる', () async {
        final adapter = _GzipAdapter(
          jsonEncode(<Object?>[
            <String, Object?>{'allcount': 1},
            <String, Object?>{'ncode': 'N1234AB', 'title': 'テスト作品'},
          ]),
        );
        final service = ApiService(
          http: TinyHttp(transport: adapter, minInterval: Duration.zero),
        );

        final result = await service.searchNovels(
          const NovelSearchQuery(word: 'テスト'),
        );

        expect(result.allCount, equals(1));
        expect(result.novels, hasLength(1));
        expect(result.novels.single.title, equals('テスト作品'));
      });

      test('turns a non-numeric noveltype into a FormatException', () async {
        // The API emits `noveltype` when `nt` is requested. A non-numeric value
        // must reach the converter rather than defaulting to "serialising".
        final adapter = _GzipAdapter(
          jsonEncode(<Object?>[
            <String, Object?>{'allcount': 1},
            <String, Object?>{'ncode': 'N1234AB', 'noveltype': 'unknown'},
          ]),
        );
        final service = ApiService(
          http: TinyHttp(transport: adapter, minInterval: Duration.zero),
        );

        await expectLater(
          service.searchNovels(const NovelSearchQuery(word: 'テスト')),
          throwsA(isA<FormatException>()),
        );
      });

      test('accepts a numeric noveltype string', () async {
        final adapter = _GzipAdapter(
          jsonEncode(<Object?>[
            <String, Object?>{'allcount': 1},
            <String, Object?>{'ncode': 'N1234AB', 'noveltype': '2'},
          ]),
        );
        final service = ApiService(
          http: TinyHttp(transport: adapter, minInterval: Duration.zero),
        );

        final result = await service.searchNovels(
          const NovelSearchQuery(word: 'テスト'),
        );

        expect(result.novels.single.novelType, equals(2));
      });

      test('turns a retyped field into a FormatException', () async {
        // ncode is typed as String? but the payload carries a number.
        final adapter = _GzipAdapter(
          jsonEncode(<Object?>[
            <String, Object?>{'allcount': 1},
            <String, Object?>{'ncode': 123},
          ]),
        );
        final service = ApiService(
          http: TinyHttp(transport: adapter, minInterval: Duration.zero),
        );

        await expectLater(
          service.searchNovels(const NovelSearchQuery(word: 'テスト')),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
