import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/utils/value_wrapper.dart';

void main() {
  group('RankingResponse', () {
    test('コンストラクタでフィールドが正しく初期化される', () {
      const response = RankingResponse(
        ncode: 'n1234',
        rank: 1,
        pt: 1000,
        allPoint: 5000,
        title: 'Test Novel',
        novelType: 1,
        end: 0,
        genre: 1,
        writer: 'Author',
        story: 'Story summary',
        userId: 12345,
        generalAllNo: 100,
        keyword: 'fantasy',
      );

      expect(response.ncode, equals('n1234'));
      expect(response.rank, equals(1));
      expect(response.pt, equals(1000));
      expect(response.allPoint, equals(5000));
      expect(response.title, equals('Test Novel'));
      expect(response.novelType, equals(1));
      expect(response.end, equals(0));
      expect(response.genre, equals(1));
      expect(response.writer, equals('Author'));
      expect(response.story, equals('Story summary'));
      expect(response.userId, equals(12345));
      expect(response.generalAllNo, equals(100));
      expect(response.keyword, equals('fantasy'));
    });

    test('copyWithでフィールドを変更できる', () {
      const response = RankingResponse(ncode: 'n1234', rank: 1);

      final updated = response.copyWith(
        rank: const Value(2),
        pt: const Value(2000),
      );

      expect(updated.ncode, equals('n1234'));
      expect(updated.rank, equals(2));
      expect(updated.pt, equals(2000));
    });

    test('copyWithでnullを明示的に設定できる', () {
      const response = RankingResponse(
        ncode: 'n1234',
        rank: 1,
        title: 'Original',
        genre: 1,
      );

      final updated = response.copyWith(
        rank: const Value<int?>(null),
        title: const Value<String?>(null),
      );

      expect(updated.ncode, equals('n1234'));
      expect(updated.rank, isNull);
      expect(updated.title, isNull);
      expect(updated.genre, equals(1)); // 変更されていない
    });

    test('copyWithでパラメータを省略すると元の値が保持される', () {
      const response = RankingResponse(
        ncode: 'n1234',
        rank: 1,
        title: 'Original',
      );

      final updated = response.copyWith(pt: const Value(100));

      expect(updated.ncode, equals('n1234'));
      expect(updated.rank, equals(1));
      expect(updated.title, equals('Original'));
      expect(updated.pt, equals(100));
    });

    test('fromJsonでJSONからインスタンスを生成できる', () {
      final json = {
        'ncode': 'N1234AB', // 大文字で渡す
        'rank': '1', // StringToIntConverterで変換される
        'pt': '1000',
        'all_point': '5000',
        'title': 'Test Novel',
        'novel_type': '1',
        'end': '0',
        'genre': '1',
      };

      final response = RankingResponse.fromJson(json);

      expect(response.ncode, equals('n1234ab')); // 小文字に正規化される
      expect(response.rank, equals(1)); // intに変換される
      expect(response.pt, equals(1000));
      expect(response.allPoint, equals(5000));
      expect(response.title, equals('Test Novel'));
    });

    test('toJsonでJSONに変換できる', () {
      const response = RankingResponse(
        ncode: 'n1234',
        rank: 1,
        title: 'Test Novel',
      );

      final json = response.toJson();

      expect(json['ncode'], equals('n1234'));
      expect(json['rank'], equals(1)); // StringToIntConverterではintのまま
      expect(json['title'], equals('Test Novel'));
    });

    test('同じ値を持つインスタンスは等価', () {
      const response1 = RankingResponse(
        ncode: 'n1234',
        rank: 1,
        title: 'Test',
      );
      const response2 = RankingResponse(
        ncode: 'n1234',
        rank: 1,
        title: 'Test',
      );

      expect(response1, equals(response2));
      expect(response1.hashCode, equals(response2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      const response1 = RankingResponse(ncode: 'n1234', rank: 1);
      const response2 = RankingResponse(ncode: 'n1234', rank: 2);

      expect(response1, isNot(equals(response2)));
    });

    test('toStringが正しい形式を返す', () {
      const response = RankingResponse(ncode: 'n1234', title: 'Test');

      expect(response.toString(), contains('RankingResponse'));
      expect(response.toString(), contains('n1234'));
    });
  });
}
