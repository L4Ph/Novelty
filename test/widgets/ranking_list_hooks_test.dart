import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_result.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/widgets/ranking_list.dart';

import '../support/test_services.dart';
import 'ranking_list_test.mocks.dart';

void main() {
  group('RankingList HookConsumerWidget Tests', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    testWidgets('should be a HookConsumerWidget and render successfully', (
      tester,
    ) async {
      // ダミーデータの準備
      const testNovel = NovelInfo(
        ncode: 'n1111a',
        title: 'Test Novel 1',
        writer: 'Test Writer 1',
        genreId: '1',
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
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await tester.pumpWidget(
        withServices(
          buildTestServices(db: db, api: mockApiService),
          MaterialApp(
            home: Scaffold(
              body: RankingList(
                source: NovelSource.narou,
                rankingType: 'test',
                filter: RankingFilterController(source: NovelSource.narou),
              ),
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
      tester,
    ) async {
      const searchResult = NovelSearchResult(
        novels: [],
        allCount: 0,
      );

      when(
        mockApiService.searchNovels(any),
      ).thenAnswer((_) async => searchResult);

      final db = AppDatabase.memory();
      addTearDown(db.close);
      await tester.pumpWidget(
        withServices(
          buildTestServices(db: db, api: mockApiService),
          MaterialApp(
            home: Scaffold(
              body: RankingList(
                source: NovelSource.narou,
                rankingType: 'test',
                filter: RankingFilterController(source: NovelSource.narou),
              ),
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
