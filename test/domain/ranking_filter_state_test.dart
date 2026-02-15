import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/utils/value_wrapper.dart';

void main() {
  group('RankingFilterState', () {
    test('デフォルト値が正しく設定される', () {
      const state = RankingFilterState();

      expect(state.showOnlyOngoing, isFalse);
      expect(state.selectedGenre, isNull);
    });

    test('コンストラクタでフィールドを設定できる', () {
      const state = RankingFilterState(
        showOnlyOngoing: true,
        selectedGenre: 1,
      );

      expect(state.showOnlyOngoing, isTrue);
      expect(state.selectedGenre, equals(1));
    });

    test('copyWithでフィールドを変更できる', () {
      const state = RankingFilterState();

      final updated1 = state.copyWith(showOnlyOngoing: true);
      expect(updated1.showOnlyOngoing, isTrue);
      expect(updated1.selectedGenre, isNull);

      final updated2 = updated1.copyWith(selectedGenre: const Value(2));
      expect(updated2.showOnlyOngoing, isTrue);
      expect(updated2.selectedGenre, equals(2));
    });

    test('copyWithでnullを明示的に設定できる', () {
      const state = RankingFilterState(selectedGenre: 1);

      final updated = state.copyWith(selectedGenre: const Value<int?>(null));

      expect(updated.selectedGenre, isNull);
      expect(updated.showOnlyOngoing, equals(state.showOnlyOngoing));
    });

    test('copyWithでパラメータを省略すると元の値が保持される', () {
      const state = RankingFilterState(selectedGenre: 1);

      final updated = state.copyWith(showOnlyOngoing: true);

      expect(updated.showOnlyOngoing, isTrue);
      expect(updated.selectedGenre, equals(1)); // 変更されていない
    });

    test('同じ値を持つインスタンスは等価', () {
      const state1 = RankingFilterState(
        showOnlyOngoing: true,
        selectedGenre: 1,
      );
      const state2 = RankingFilterState(
        showOnlyOngoing: true,
        selectedGenre: 1,
      );

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      const state1 = RankingFilterState(showOnlyOngoing: false);
      const state2 = RankingFilterState(showOnlyOngoing: true);

      expect(state1, isNot(equals(state2)));
    });

    test('toStringが正しい形式を返す', () {
      const state = RankingFilterState(
        showOnlyOngoing: true,
        selectedGenre: 1,
      );

      expect(
        state.toString(),
        'RankingFilterState(showOnlyOngoing: true, selectedGenre: 1)',
      );
    });
  });
}
