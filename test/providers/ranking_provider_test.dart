import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_result.dart';
import 'package:novelty/providers/ranking_provider.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/utils/value_wrapper.dart';

import 'novel_info_offline_test.mocks.dart';

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
        novels: const [NovelInfo(title: 'Test', ncode: 'n1234')],
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
        const NovelInfo(title: 'Test', ncode: 'n1234'),
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
      const state1 = RankingState();
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

  group('RankingNotifier（破棄時の安全性）', () {
    test('プロバイダ破棄後にfetchNextPageが完了しても例外を投げない', () async {
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

      // ランキングの購読を開始（fetchNextPageが走る）
      final subscription = container.listen(
        rankingProvider(NovelSource.narou, 'm'),
        (_, _) {},
      );
      // fetchNextPage がAPI await中になるまで進める
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      // タブ切替等でプロバイダが破棄される
      subscription.close();
      container.dispose();

      // APIレスポンスが遅れて返る（破棄後の完了）
      completer.complete(
        const NovelSearchResult(novels: [], allCount: 0),
      );
      await Future<void>.delayed(Duration.zero);

      // 例外が投げられていなければ成功（破棄後のstate更新でエラーにならない）
      verify(mockApiService.searchNovels(any)).called(1);
    });


  });
}
