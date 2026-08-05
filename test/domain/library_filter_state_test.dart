import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/domain/library_filter_state.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/value_wrapper.dart';

void main() {
  group('LibraryFilterState', () {
    test('デフォルト値が正しく設定される', () {
      const state = LibraryFilterState();

      expect(state.source, isNull);
      expect(state.showOnlyOngoing, isFalse);
      expect(state.selectedGenreId, isNull);
    });

    test('コンストラクタでフィールドを設定できる', () {
      const state = LibraryFilterState(
        source: NovelSource.kakuyomu,
        showOnlyOngoing: true,
        selectedGenreId: 'FANTASY',
      );

      expect(state.source, NovelSource.kakuyomu);
      expect(state.showOnlyOngoing, isTrue);
      expect(state.selectedGenreId, equals('FANTASY'));
    });

    test('copyWithでフィールドを変更できる', () {
      const state = LibraryFilterState();

      final updated1 = state.copyWith(showOnlyOngoing: true);
      expect(updated1.showOnlyOngoing, isTrue);
      expect(updated1.selectedGenreId, isNull);

      final updated2 = updated1.copyWith(
        selectedGenreId: const Value('FANTASY'),
        source: const Value(NovelSource.kakuyomu),
      );
      expect(updated2.showOnlyOngoing, isTrue);
      expect(updated2.selectedGenreId, equals('FANTASY'));
      expect(updated2.source, NovelSource.kakuyomu);
    });

    test('copyWithでnullを明示的に設定できる', () {
      const state = LibraryFilterState(selectedGenreId: 'FANTASY');

      final updated = state.copyWith(
        selectedGenreId: const Value<String?>(null),
      );

      expect(updated.selectedGenreId, isNull);
      expect(updated.showOnlyOngoing, equals(state.showOnlyOngoing));
    });

    test('同じ値を持つインスタンスは等価', () {
      const state1 = LibraryFilterState(
        source: NovelSource.kakuyomu,
        showOnlyOngoing: true,
        selectedGenreId: 'FANTASY',
      );
      const state2 = LibraryFilterState(
        source: NovelSource.kakuyomu,
        showOnlyOngoing: true,
        selectedGenreId: 'FANTASY',
      );

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      const state1 = LibraryFilterState();
      const state2 = LibraryFilterState(showOnlyOngoing: true);

      expect(state1, isNot(equals(state2)));
    });

    test('toStringが正しい形式を返す', () {
      const state = LibraryFilterState(
        source: NovelSource.kakuyomu,
        showOnlyOngoing: true,
        selectedGenreId: 'FANTASY',
      );

      expect(
        state.toString(),
        'LibraryFilterState(source: NovelSource.kakuyomu, '
        'showOnlyOngoing: true, selectedGenreId: FANTASY)',
      );
    });
  });

  group('LibraryFilterStateNotifier', () {
    test('setSourceがジャンルフィルタをリセットして状態を更新する', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(libraryFilterStateProvider.notifier)
        ..setSelectedGenreId('FANTASY')
        ..setShowOnlyOngoing(value: true)
        ..setSource(NovelSource.kakuyomu);

      final state = container.read(libraryFilterStateProvider);
      expect(state.source, NovelSource.kakuyomu);
      // サイト切替時はジャンルフィルタがリセットされる
      expect(state.selectedGenreId, isNull);
      expect(state.showOnlyOngoing, isTrue);
    });

    test('setSelectedGenreId / setShowOnlyOngoing が状態を更新する', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(libraryFilterStateProvider.notifier)
        ..setSource(NovelSource.narou)
        ..setSelectedGenreId('201')
        ..setShowOnlyOngoing(value: true);

      final state = container.read(libraryFilterStateProvider);
      expect(state.source, NovelSource.narou);
      expect(state.selectedGenreId, '201');
      expect(state.showOnlyOngoing, isTrue);
    });

    test('resetが初期状態に戻す', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(libraryFilterStateProvider.notifier)
        ..setSource(NovelSource.kakuyomu)
        ..setSelectedGenreId('FANTASY')
        ..reset();

      expect(
        container.read(libraryFilterStateProvider),
        const LibraryFilterState(),
      );
    });
  });
}
