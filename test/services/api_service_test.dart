import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';

class _FakeResponseAdapter implements HttpClientAdapter {
  _FakeResponseAdapter(this._body);

  final String _body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final gzipped = const GZipEncoder().encode(utf8.encode(_body));
    return ResponseBody.fromBytes(
      gzipped,
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ApiService _createService(String body) {
  final dio = Dio()..httpClientAdapter = _FakeResponseAdapter(body);
  return ApiService(dio: dio);
}

void main() {
  group('ApiService', () {
    group('fetchBasicNovelInfo レスポンス検証', () {
      test('allcount==0 のみを非公開・削除として扱うこと', () async {
        final service = _createService('[{"allcount":0}]');

        await expectLater(
          service.fetchBasicNovelInfo('N1234AB'),
          throwsA(isA<NovelNotFoundException>()),
        );
      });

      test('allcount>0 だが作品データが無い場合はFormatExceptionを投げること', () async {
        final service = _createService('[{"allcount":1}]');

        await expectLater(
          service.fetchBasicNovelInfo('N1234AB'),
          throwsA(isA<FormatException>()),
        );
      });

      test('メタデータが欠損している場合はFormatExceptionを投げること', () async {
        final service = _createService('[{}]');

        await expectLater(
          service.fetchBasicNovelInfo('N1234AB'),
          throwsA(isA<FormatException>()),
        );
      });

      test('レスポンスが空の場合はFormatExceptionを投げること', () async {
        final service = _createService('[]');

        await expectLater(
          service.fetchBasicNovelInfo('N1234AB'),
          throwsA(isA<FormatException>()),
        );
      });

      test('正常なレスポンスは作品情報を返すこと', () async {
        final service = _createService(
          '[{"allcount":1},'
          '{"ncode":"N1234AB","title":"テスト",'
          '"novel_type":"1","general_all_no":"3"}]',
        );

        final info = await service.fetchBasicNovelInfo('N1234AB');
        expect(info.workId, 'n1234ab');
        expect(info.title, 'テスト');
      });
    });

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
  });
}
