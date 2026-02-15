import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/providers/ranking_provider.dart';
import 'package:novelty/utils/value_wrapper.dart';

void main() {
  group('RankingState', () {
    test('デフォルト値が正しく設定される', () {
      const state = RankingState();

      expect(state.novels, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.isLoadingMore, isFalse);
      expect(state.hasMore, isTrue);
      expect(state.page, equals(1));
      expect(state.error, isNull);
    });

    test('コンストラクタでフィールドを設定できる', () {
      final state = RankingState(
        novels: [NovelInfo(title: 'Test', ncode: 'n1234')],
        isLoading: true,
        isLoadingMore: true,
        hasMore: false,
        page: 2,
        error: Exception('error'),
      );

      expect(state.novels.length, equals(1));
      expect(state.isLoading, isTrue);
      expect(state.isLoadingMore, isTrue);
      expect(state.hasMore, isFalse);
      expect(state.page, equals(2));
      expect(state.error, isNotNull);
    });

    test('copyWithでフィールドを変更できる', () {
      const state = RankingState();

      final updated = state.copyWith(
        isLoading: true,
        page: 2,
      );

      expect(updated.isLoading, isTrue);
      expect(updated.page, equals(2));
      expect(updated.novels, isEmpty); // 変更されていない
    });

    test('copyWithでerrorを設定できる', () {
      const state = RankingState();

      final withError = state.copyWith(
        error: Value<Object?>(Exception('error')),
      );
      expect(withError.error, isNotNull);
    });

    test('copyWithでnovelsを変更できる', () {
      const state = RankingState();

      final newNovels = [
        NovelInfo(title: 'Test', ncode: 'n1234'),
      ];
      final updated = state.copyWith(novels: newNovels);

      expect(updated.novels, equals(newNovels));
    });

    test('同じ値を持つインスタンスは等価', () {
      // novelsリストは比較対象外（NovelInfoの等価性がfreezed依存のため）
      const state1 = RankingState(
        isLoading: true,
        page: 2,
      );
      const state2 = RankingState(
        isLoading: true,
        page: 2,
      );

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      const state1 = RankingState(page: 1);
      const state2 = RankingState(page: 2);

      expect(state1, isNot(equals(state2)));
    });

    test('toStringが正しい形式を返す', () {
      const state = RankingState(
        isLoading: true,
        page: 2,
      );

      expect(
        state.toString(),
        contains('RankingState'),
      );
    });
  });
}
