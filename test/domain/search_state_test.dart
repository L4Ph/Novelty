import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/domain/search_state.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/novel_search_result.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/settings_provider.dart';

import '../providers/novel_info_offline_test.mocks.dart';

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
      const state = SearchState(
        query: NovelSearchQuery(word: 'test'),
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
        const NovelInfo(title: 'Test', ncode: 'n1234'),
      ];
      final updated = state.copyWith(results: newResults);

      expect(updated.results, equals(newResults));
    });

    test('同じ値を持つインスタンスは等価', () {
      const state1 = SearchState(
        query: NovelSearchQuery(word: 'test'),
        allCount: 100,
        isLoading: true,
      );
      const state2 = SearchState(
        query: NovelSearchQuery(word: 'test'),
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
      const state1 = SearchState(
        results: [NovelInfo(title: 'Test', ncode: 'n1')],
        allCount: 10,
      );
      expect(state1.hasMore, isTrue);

      // results.length >= allCount の場合
      const state2 = SearchState(
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

  group('SearchStateNotifier（破棄時の安全性）', () {
    test('プロバイダ破棄後にsearchが完了しても例外を投げない', () async {
      final mockApiService = MockApiService();
      final completer = Completer<NovelSearchResult>();
      when(
        mockApiService.searchNovels(any),
      ).thenAnswer((_) => completer.future);

      final container = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
          isOfflineModeProvider.overrideWithValue(false),
        ],
      );

      // 購読を保持（プロバイダを生きたままにする）
      final subscription = container.listen(searchStateProvider, (_, _) {});
      final searchFuture = container
          .read(searchStateProvider.notifier)
          .search(const NovelSearchQuery(word: 'test'));
      await Future<void>.delayed(Duration.zero);

      // 画面離脱等でプロバイダが破棄される
      subscription.close();
      container.dispose();

      // 検索が遅れて完了する（破棄後の完了）
      completer.complete(
        const NovelSearchResult(novels: [], allCount: 0),
      );
      await searchFuture;

      // 例外が投げられていなければ成功
      verify(mockApiService.searchNovels(any)).called(1);
    });
  });
}
