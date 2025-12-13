import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_result.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/ranking_list.dart';

import 'ranking_list_test.mocks.dart';

void main() {
  group('RankingList HookConsumerWidget Tests', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    testWidgets('should be a HookConsumerWidget and render successfully', (
      WidgetTester tester,
    ) async {
      // ダミーデータの準備
      const testNovel = NovelInfo(
        ncode: 'n1111a',
        title: 'Test Novel 1',
        writer: 'Test Writer 1',
        genre: 1,
        novelType: 1,
        end: 0,
        generalAllNo: 10,
        allPoint: 200,
      );

      const searchResult = NovelSearchResult(
        novels: [testNovel],
        allCount: 1,
      );

      when(
        mockApiService.searchNovels(any),
      ).thenAnswer((_) async => searchResult);

      // ウィジェットをテスト
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(rankingType: 'test'),
            ),
          ),
        ),
      );

      // ローディング状態からデータ読み込み完了まで待機
      await tester.pumpAndSettle();

      // ウィジェットが正常に描画されることを確認
      expect(find.byType(RankingList), findsOneWidget);

      // HookConsumerWidgetとして機能していることを確認
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should handle empty data gracefully', (
      WidgetTester tester,
    ) async {
      const searchResult = NovelSearchResult(
        novels: [],
        allCount: 0,
      );

      when(
        mockApiService.searchNovels(any),
      ).thenAnswer((_) async => searchResult);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(rankingType: 'test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 空のリストでもクラッシュしないことを確認
      expect(find.byType(RankingList), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
