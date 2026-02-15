import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_search_result.dart';
import 'package:novelty/models/novel_info.dart';

void main() {
  group('NovelSearchResult', () {
    test('コンストラクタでフィールドが正しく初期化される', () {
      const novelInfos = <NovelInfo>[];
      const result = NovelSearchResult(
        novels: novelInfos,
        allCount: 100,
      );

      expect(result.novels, equals(novelInfos));
      expect(result.allCount, equals(100));
    });

    test('copyWithでフィールドを変更できる', () {
      const novelInfos = <NovelInfo>[];
      const result = NovelSearchResult(
        novels: novelInfos,
        allCount: 100,
      );

      final newNovels = [
        NovelInfo(
          title: 'Test Novel',
          ncode: 'n1234',
        ),
      ];
      final updated = result.copyWith(
        novels: newNovels,
        allCount: 50,
      );

      expect(updated.novels, equals(newNovels));
      expect(updated.allCount, equals(50));
    });

    test('copyWithで一部のフィールドのみ変更できる', () {
      const novelInfos = <NovelInfo>[];
      const result = NovelSearchResult(
        novels: novelInfos,
        allCount: 100,
      );

      final updated = result.copyWith(allCount: 200);

      expect(updated.novels, equals(novelInfos));
      expect(updated.allCount, equals(200));
    });

    test('同じ値を持つインスタンスは等価', () {
      const result1 = NovelSearchResult(
        novels: <NovelInfo>[],
        allCount: 100,
      );
      const result2 = NovelSearchResult(
        novels: <NovelInfo>[],
        allCount: 100,
      );

      expect(result1, equals(result2));
      expect(result1.hashCode, equals(result2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      const result1 = NovelSearchResult(
        novels: <NovelInfo>[],
        allCount: 100,
      );
      const result2 = NovelSearchResult(
        novels: <NovelInfo>[],
        allCount: 200,
      );

      expect(result1, isNot(equals(result2)));
    });

    test('toStringが正しい形式を返す', () {
      const result = NovelSearchResult(
        novels: <NovelInfo>[],
        allCount: 100,
      );

      expect(
        result.toString(),
        'NovelSearchResult(novels: [], allCount: 100)',
      );
    });
  });
}
