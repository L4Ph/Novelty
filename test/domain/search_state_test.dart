import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/domain/search_state.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';

void main() {
  group('SearchState', () {
    test('デフォルト値が正しく設定される', () {
      const state = SearchState();

      expect(state.query, equals(const NovelSearchQuery()));
      expect(state.results, isEmpty);
      expect(state.allCount, equals(0));
      expect(state.isLoading, isFalse);
      expect(state.isSearching, isFalse);
    });

    test('コンストラクタでフィールドを設定できる', () {
      final state = SearchState(
        query: const NovelSearchQuery(word: 'test'),
        results: [
          NovelInfo(title: 'Test', ncode: 'n1234'),
        ],
        allCount: 100,
        isLoading: true,
        isSearching: true,
      );

      expect(state.query.word, equals('test'));
      expect(state.results.length, equals(1));
      expect(state.allCount, equals(100));
      expect(state.isLoading, isTrue);
      expect(state.isSearching, isTrue);
    });

    test('copyWithでフィールドを変更できる', () {
      const state = SearchState();

      final updated = state.copyWith(
        allCount: 50,
        isLoading: true,
      );

      expect(updated.allCount, equals(50));
      expect(updated.isLoading, isTrue);
      expect(updated.isSearching, isFalse); // 変更されていない
    });

    test('copyWithでresultsを変更できる', () {
      const state = SearchState();

      final newResults = [
        NovelInfo(title: 'Test', ncode: 'n1234'),
      ];
      final updated = state.copyWith(results: newResults);

      expect(updated.results, equals(newResults));
    });

    test('同じ値を持つインスタンスは等価', () {
      final state1 = SearchState(
        query: const NovelSearchQuery(word: 'test'),
        allCount: 100,
        isLoading: true,
      );
      final state2 = SearchState(
        query: const NovelSearchQuery(word: 'test'),
        allCount: 100,
        isLoading: true,
      );

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      const state1 = SearchState(allCount: 100);
      const state2 = SearchState(allCount: 200);

      expect(state1, isNot(equals(state2)));
    });

    test('hasMoreが正しく計算される', () {
      // results.length < allCount の場合
      final state1 = SearchState(
        results: [NovelInfo(title: 'Test', ncode: 'n1')],
        allCount: 10,
      );
      expect(state1.hasMore, isTrue);

      // results.length >= allCount の場合
      final state2 = SearchState(
        results: [NovelInfo(title: 'Test', ncode: 'n1')],
        allCount: 1,
      );
      expect(state2.hasMore, isFalse);
    });

    test('toStringが正しい形式を返す', () {
      const state = SearchState(
        allCount: 100,
        isLoading: true,
      );

      expect(
        state.toString(),
        contains('SearchState'),
      );
    });
  });
}
