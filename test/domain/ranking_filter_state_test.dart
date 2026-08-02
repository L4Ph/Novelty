import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/value_wrapper.dart';

void main() {
  group('RankingFilterState', () {
    test('デフォルト値が正しく設定される', () {
      const state = RankingFilterState();

      expect(state.source, NovelSource.narou);
      expect(state.showOnlyOngoing, isFalse);
      expect(state.selectedGenreId, isNull);
    });

    test('コンストラクタでフィールドを設定できる', () {
      const state = RankingFilterState(
        source: NovelSource.kakuyomu,
        showOnlyOngoing: true,
        selectedGenreId: 'FANTASY',
      );

      expect(state.source, NovelSource.kakuyomu);
      expect(state.showOnlyOngoing, isTrue);
      expect(state.selectedGenreId, equals('FANTASY'));
    });

    test('copyWithでフィールドを変更できる', () {
      const state = RankingFilterState();

      final updated1 = state.copyWith(showOnlyOngoing: true);
      expect(updated1.showOnlyOngoing, isTrue);
      expect(updated1.selectedGenreId, isNull);

      final updated2 = updated1.copyWith(
        selectedGenreId: const Value('FANTASY'),
      );
      expect(updated2.showOnlyOngoing, isTrue);
      expect(updated2.selectedGenreId, equals('FANTASY'));
    });

    test('copyWithでnullを明示的に設定できる', () {
      const state = RankingFilterState(selectedGenreId: 'FANTASY');

      final updated = state.copyWith(
        selectedGenreId: const Value<String?>(null),
      );

      expect(updated.selectedGenreId, isNull);
      expect(updated.showOnlyOngoing, equals(state.showOnlyOngoing));
    });

    test('copyWithでパラメータを省略すると元の値が保持される', () {
      const state = RankingFilterState(selectedGenreId: 'FANTASY');

      final updated = state.copyWith(showOnlyOngoing: true);

      expect(updated.showOnlyOngoing, isTrue);
      expect(updated.selectedGenreId, equals('FANTASY')); // 変更されていない
    });

    test('同じ値を持つインスタンスは等価', () {
      const state1 = RankingFilterState(
        source: NovelSource.kakuyomu,
        showOnlyOngoing: true,
        selectedGenreId: 'FANTASY',
      );
      const state2 = RankingFilterState(
        source: NovelSource.kakuyomu,
        showOnlyOngoing: true,
        selectedGenreId: 'FANTASY',
      );

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      const state1 = RankingFilterState();
      const state2 = RankingFilterState(showOnlyOngoing: true);

      expect(state1, isNot(equals(state2)));
    });

    test('toStringが正しい形式を返す', () {
      const state = RankingFilterState(
        source: NovelSource.kakuyomu,
        showOnlyOngoing: true,
        selectedGenreId: 'FANTASY',
      );

      expect(
        state.toString(),
        'RankingFilterState(source: NovelSource.kakuyomu, '
        'showOnlyOngoing: true, selectedGenreId: FANTASY)',
      );
    });
  });

  group('RankingFilterStateNotifier', () {
    test('familyキー(source, rankingType)ごとに初期状態を保持する', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final narouState = container.read(
        rankingFilterStateProvider(NovelSource.narou, 'd'),
      );
      final kakuyomuState = container.read(
        rankingFilterStateProvider(NovelSource.kakuyomu, 'daily'),
      );

      expect(narouState.source, NovelSource.narou);
      expect(kakuyomuState.source, NovelSource.kakuyomu);
    });

    test('setSelectedGenreId / setShowOnlyOngoing が状態を更新する', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(
            rankingFilterStateProvider(NovelSource.kakuyomu, 'daily').notifier,
          )
        ..setSelectedGenreId('FANTASY')
        ..setShowOnlyOngoing(value: true);

      final state = container.read(
        rankingFilterStateProvider(NovelSource.kakuyomu, 'daily'),
      );
      expect(state.selectedGenreId, 'FANTASY');
      expect(state.showOnlyOngoing, isTrue);
    });

    test('resetがsourceを保持したままフィルタをクリアする', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(
            rankingFilterStateProvider(NovelSource.kakuyomu, 'daily').notifier,
          )
        ..setSelectedGenreId('FANTASY')
        ..setShowOnlyOngoing(value: true)
        ..reset();

      final state = container.read(
        rankingFilterStateProvider(NovelSource.kakuyomu, 'daily'),
      );
      expect(state.source, NovelSource.kakuyomu);
      expect(state.selectedGenreId, isNull);
      expect(state.showOnlyOngoing, isFalse);
    });
  });
}
