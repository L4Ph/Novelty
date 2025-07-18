import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_search_query.dart';

void main() {
  group('ncodeを小文字で扱うテスト', () {
    test('NovelInfo.fromJsonでncodeが小文字化される', () {
      final json = {
        'title': 'テスト小説',
        'ncode': 'N1234AB',
        'writer': 'テスト作者',
      };

      final novelInfo = NovelInfo.fromJson(json);
      expect(novelInfo.ncode, equals('n1234ab'));
    });

    test('RankingResponse.fromJsonでncodeが小文字化される', () {
      final json = {
        'ncode': 'N5678CD',
        'title': 'ランキング小説',
        'rank': '1',
      };

      final rankingResponse = RankingResponse.fromJson(json);
      expect(rankingResponse.ncode, equals('n5678cd'));
    });

    test('Episode.fromJsonでncodeが小文字化される', () {
      final json = {
        'ncode': 'N9876EF',
        'subtitle': 'エピソード1',
        'index': 1,
      };

      final episode = Episode.fromJson(json);
      expect(episode.ncode, equals('n9876ef'));
    });

    test('NovelSearchQueryでncodeが小文字化される', () {
      const query = NovelSearchQuery(
        ncode: ['N1111AA', 'N2222BB'],
      );

      final map = query.toMap();
      expect(map['ncode'], equals('n1111aa-n2222bb'));
    });

    test('ncodeがnullの場合は例外が発生しない', () {
      final json = {
        'title': 'テスト小説',
        'ncode': null,
        'writer': 'テスト作者',
      };

      expect(() => NovelInfo.fromJson(json), returnsNormally);
    });

    test('ncodeが文字列でない場合は変更されない', () {
      final json = {
        'title': 'テスト小説',
        'ncode': 12345,
        'writer': 'テスト作者',
      };

      final novelInfo = NovelInfo.fromJson(json);
      expect(novelInfo.ncode, equals(12345));
    });
  });
}