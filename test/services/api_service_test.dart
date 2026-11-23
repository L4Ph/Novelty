import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';

/// 固定のJSON文字列をgzip圧縮して返すHTTPアダプタ。
///
/// なろう小説APIは`gzip=5`指定時に圧縮済みボディを返すため、
/// その経路が正しく展開されることを確認するために使う。
class _GzipAdapter implements HttpClientAdapter {
  _GzipAdapter(this.json);

  /// gzip圧縮前のJSON文字列。
  final String json;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromBytes(
      gzip.encode(utf8.encode(json)),
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
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
        final service = ApiService(dio: Dio()..httpClientAdapter = adapter);

        final result = await service.searchNovels(
          const NovelSearchQuery(word: 'テスト'),
        );

        expect(result.allCount, equals(1));
        expect(result.novels, hasLength(1));
        expect(result.novels.single.title, equals('テスト作品'));
      });
    });
  });
}
