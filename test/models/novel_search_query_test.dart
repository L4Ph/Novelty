import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_search_query.dart';

void main() {
  group('NovelSearchQuery', () {
    test('fromJsonでJSONからインスタンスを生成できる', () {
      final json = {
        'word': 'fantasy',
        'title': true,
        'genre': [1, 2],
        'order': 'popular',
        'lim': 50,
      };

      final query = NovelSearchQuery.fromJson(json);

      expect(query.word, equals('fantasy'));
      expect(query.title, isTrue);
      expect(query.genre, equals([1, 2]));
      expect(query.lim, equals(50));
    });

    test('toJsonでJSONに変換できる', () {
      const query = NovelSearchQuery(
        word: 'fantasy',
        title: true,
        lim: 50,
      );

      final json = query.toJson();

      expect(json['word'], equals('fantasy'));
      expect(json['title'], isTrue);
      expect(json['lim'], equals(50));
    });

    test('toMapが正しく動作する', () {
      const query = NovelSearchQuery(
        word: 'fantasy',
        title: true,
        genre: [1, 2],
        isr15: true,
        order: 'popular',
        lim: 50,
        st: 10,
      );

      final map = query.toMap();

      expect(map['word'], equals('fantasy'));
      expect(map['title'], equals(1));
      expect(map['genre'], equals('1-2'));
      expect(map['isr15'], equals(1));
      expect(map['order'], equals('popular'));
      expect(map['lim'], equals(50));
      expect(map['st'], equals(10));
    });

    test('toMapでnull値は除外される', () {
      const query = NovelSearchQuery(word: 'fantasy');

      final map = query.toMap();

      expect(map.containsKey('title'), isFalse);
      expect(map.containsKey('genre'), isFalse);
    });

    test('toMapでncodeは正規化される', () {
      const query = NovelSearchQuery(ncode: ['N1234AB', 'N5678CD']);

      final map = query.toMap();

      expect(map['ncode'], equals('n1234ab-n5678cd'));
    });
  });
}
