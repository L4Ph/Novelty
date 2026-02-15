import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/episode.dart';

void main() {
  group('Episode', () {
    test('コンストラクタでフィールドが正しく初期化される', () {
      const episode = Episode(
        subtitle: 'Test Episode',
        url: 'https://example.com/n1234/1',
        update: '2024/01/15 10:00',
        revised: '2024/01/16 12:00',
        ncode: 'n1234',
        index: 1,
        body: '<p>本文</p>',
        novelUpdatedAt: '2024-01-16 12:00:00',
        isDownloaded: true,
      );

      expect(episode.subtitle, equals('Test Episode'));
      expect(episode.url, equals('https://example.com/n1234/1'));
      expect(episode.update, equals('2024/01/15 10:00'));
      expect(episode.revised, equals('2024/01/16 12:00'));
      expect(episode.ncode, equals('n1234'));
      expect(episode.index, equals(1));
      expect(episode.body, equals('<p>本文</p>'));
      expect(episode.novelUpdatedAt, equals('2024-01-16 12:00:00'));
      expect(episode.isDownloaded, isTrue);
    });

    test('デフォルト値が正しく設定される', () {
      const episode = Episode();

      expect(episode.subtitle, isNull);
      expect(episode.url, isNull);
      expect(episode.isDownloaded, isFalse);
    });

    test('copyWithでフィールドを変更できる', () {
      const episode = Episode(subtitle: 'Original');

      final updated = episode.copyWith(subtitle: 'Updated', index: 2);

      expect(updated.subtitle, equals('Updated'));
      expect(updated.index, equals(2));
      expect(updated.isDownloaded, isFalse); // 変更されていない
    });

    test('fromJsonでJSONからインスタンスを生成できる', () {
      final json = {
        'subtitle': 'Test Episode',
        'url': 'https://example.com/n1234/1',
        'update': '2024/01/15 10:00',
        'ncode': 'N1234AB', // 大文字で渡す
        'index': 1,
        'isDownloaded': true,
      };

      final episode = Episode.fromJson(json);

      expect(episode.subtitle, equals('Test Episode'));
      expect(episode.ncode, equals('n1234ab')); // 小文字に正規化される
      expect(episode.index, equals(1));
    });

    test('toJsonでJSONに変換できる', () {
      const episode = Episode(
        subtitle: 'Test Episode',
        url: 'https://example.com/n1234/1',
        ncode: 'n1234',
        index: 1,
      );

      final json = episode.toJson();

      expect(json['subtitle'], equals('Test Episode'));
      expect(json['ncode'], equals('n1234'));
      expect(json['index'], equals(1));
    });

    test('同じ値を持つインスタンスは等価', () {
      const episode1 = Episode(
        subtitle: 'Test',
        ncode: 'n1234',
        index: 1,
      );
      const episode2 = Episode(
        subtitle: 'Test',
        ncode: 'n1234',
        index: 1,
      );

      expect(episode1, equals(episode2));
      expect(episode1.hashCode, equals(episode2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      const episode1 = Episode(subtitle: 'Test1');
      const episode2 = Episode(subtitle: 'Test2');

      expect(episode1, isNot(equals(episode2)));
    });

    test('toStringが正しい形式を返す', () {
      const episode = Episode(subtitle: 'Test', index: 1);

      expect(episode.toString(), contains('Episode'));
      expect(episode.toString(), contains('Test'));
    });
  });
}
