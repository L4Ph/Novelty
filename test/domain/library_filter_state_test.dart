import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/domain/library_filter_state.dart';

void main() {
  group('LibraryFilterState', () {
    test('デフォルト値が正しく設定される', () {
      const state = LibraryFilterState();

      expect(state.showOnlyOngoing, isFalse);
      expect(state.selectedGenre, isNull);
    });

    test('コンストラクタでフィールドを設定できる', () {
      const state = LibraryFilterState(
        showOnlyOngoing: true,
        selectedGenre: 1,
      );

      expect(state.showOnlyOngoing, isTrue);
      expect(state.selectedGenre, equals(1));
    });

    test('copyWithでフィールドを変更できる', () {
      const state = LibraryFilterState();

      final updated1 = state.copyWith(showOnlyOngoing: true);
      expect(updated1.showOnlyOngoing, isTrue);
      expect(updated1.selectedGenre, isNull);

      final updated2 = updated1.copyWith(selectedGenre: 2);
      expect(updated2.showOnlyOngoing, isTrue);
      expect(updated2.selectedGenre, equals(2));
    });

    test('同じ値を持つインスタンスは等価', () {
      const state1 = LibraryFilterState(
        showOnlyOngoing: true,
        selectedGenre: 1,
      );
      const state2 = LibraryFilterState(
        showOnlyOngoing: true,
        selectedGenre: 1,
      );

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      const state1 = LibraryFilterState(showOnlyOngoing: false);
      const state2 = LibraryFilterState(showOnlyOngoing: true);

      expect(state1, isNot(equals(state2)));
    });

    test('toStringが正しい形式を返す', () {
      const state = LibraryFilterState(
        showOnlyOngoing: true,
        selectedGenre: 1,
      );

      expect(
        state.toString(),
        'LibraryFilterState(showOnlyOngoing: true, selectedGenre: 1)',
      );
    });
  });
}
