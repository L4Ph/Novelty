import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_search_query.dart';

void main() {
  group('NovelSearchQuery', () {
    test('デフォルト値が正しく設定される', () {
      const query = NovelSearchQuery();

      expect(query.word, isNull);
      expect(query.title, isFalse);
      expect(query.ex, isFalse);
      expect(query.isr15, isFalse);
      expect(query.order, equals('new'));
      expect(query.lim, equals(20));
      expect(query.st, equals(1));
    });

    test('コンストラクタでフィールドを設定できる', () {
      const query = NovelSearchQuery(
        word: 'fantasy',
        title: true,
        ex: true,
        genre: [1, 2],
        isr15: true,
        order: 'popular',
        lim: 50,
        st: 10,
      );

      expect(query.word, equals('fantasy'));
      expect(query.title, isTrue);
      expect(query.ex, isTrue);
      expect(query.genre, equals([1, 2]));
      expect(query.isr15, isTrue);
      expect(query.order, equals('popular'));
      expect(query.lim, equals(50));
      expect(query.st, equals(10));
    });

    test('copyWithでフィールドを変更できる', () {
      const query = NovelSearchQuery(word: 'original');

      final updated = query.copyWith(word: 'updated', lim: 100);

      expect(updated.word, equals('updated'));
      expect(updated.lim, equals(100));
      expect(updated.order, equals('new')); // 変更されていない
    });

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

    test('同じ値を持つインスタンスは等価', () {
      const query1 = NovelSearchQuery(word: 'test', lim: 50);
      const query2 = NovelSearchQuery(word: 'test', lim: 50);

      expect(query1, equals(query2));
      expect(query1.hashCode, equals(query2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      const query1 = NovelSearchQuery(word: 'test1');
      const query2 = NovelSearchQuery(word: 'test2');

      expect(query1, isNot(equals(query2)));
    });
  });
}
