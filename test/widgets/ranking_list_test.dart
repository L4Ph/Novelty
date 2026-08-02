import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/novel_search_result.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/ranking_list.dart';

import 'ranking_list_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('RankingList Widget Tests', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    testWidgets('should display ranking list items', (
      tester,
    ) async {
      final mockNovels = List.generate(
        5,
        (index) => NovelInfo(
          ncode: 'n$index',
          title: 'Novel $index',
          writer: 'Writer $index',
          story: 'Story $index',
          genre: 101,
          novelType: 1,
          end: 1,
          allPoint: 1000 - index,
        ),
      );

      final searchResult = NovelSearchResult(
        novels: mockNovels,
        allCount: 5,
      );

      // デフォルトクエリ一致
      when(
        mockApiService.searchNovels(any),
      ).thenAnswer((_) async => searchResult);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies overrides_are_scoped_to_test
            apiServiceProvider.overrideWithValue(mockApiService),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(
                rankingType: 'd',
                key: PageStorageKey('test'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Novel 0'), findsOneWidget);
      expect(find.text('Novel 4'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should update query when filter changes', (
      tester,
    ) async {
      final mockNovels = [
        const NovelInfo(
          ncode: 'n1',
          title: 'Filtered Novel',
          writer: 'Writer',
          genre: 201, // ファンタジー
        ),
      ];

      final searchResult = NovelSearchResult(
        novels: mockNovels,
        allCount: 1,
      );

      when(
        mockApiService.searchNovels(any),
      ).thenAnswer((_) async => searchResult);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies overrides_are_scoped_to_test
            apiServiceProvider.overrideWithValue(mockApiService),
            // ignore: scoped_providers_should_specify_dependencies overrides_are_scoped_to_test
            rankingFilterStateProvider('d').overrideWithValue(
              const RankingFilterState(selectedGenre: 201),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(
                rankingType: 'd',
                key: PageStorageKey('test_filter'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // searchNovels がジャンルを含むクエリで呼ばれたことを確認
      final captured = verify(mockApiService.searchNovels(captureAny)).captured;
      final query = captured.last as NovelSearchQuery;
      expect(query.genre, equals([201]));

      expect(find.text('Filtered Novel'), findsOneWidget);
    });
    testWidgets('should filter ongoing novels locally', (
      tester,
    ) async {
      final mockNovels = [
        const NovelInfo(
          ncode: 'n1',
          title: 'Ongoing Novel',
          writer: 'Writer',
          novelType: 1, // 連載中
          end: 1, // 連載中
        ),
        const NovelInfo(
          ncode: 'n2',
          title: 'Short Story',
          writer: 'Writer',
          novelType: 2, // 短編
          end: 0, // 短編または完結
        ),
      ];

      final searchResult = NovelSearchResult(
        novels: mockNovels,
        allCount: 2,
      );

      when(
        mockApiService.searchNovels(any),
      ).thenAnswer((_) async => searchResult);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies overrides_are_scoped_to_test
            apiServiceProvider.overrideWithValue(mockApiService),
            // ignore: scoped_providers_should_specify_dependencies overrides_are_scoped_to_test
            rankingFilterStateProvider('d').overrideWithValue(
              const RankingFilterState(showOnlyOngoing: true),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(
                rankingType: 'd',
                key: PageStorageKey('test_ongoing_local'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // クエリに type='r' が含まれないことを確認（削除したため）
      final captured = verify(mockApiService.searchNovels(captureAny)).captured;
      final query = captured.last as NovelSearchQuery;
      expect(query.type, isNull);

      // フィルタリング検証: 連載中の小説のみ表示されること
      expect(find.text('Ongoing Novel'), findsOneWidget);
      expect(find.text('Short Story'), findsNothing);
    });
    testWidgets('should refresh list when filter changes dynamically', (
      tester,
    ) async {
      final mockNovels = [
        const NovelInfo(
          ncode: 'n1',
          title: 'Initial Novel',
          writer: 'Writer',
          novelType: 1,
          end: 1,
        ),
      ];
      final filteredNovels = [
        const NovelInfo(
          ncode: 'n2',
          title: 'Filtered Novel',
          writer: 'Writer',
          novelType: 1,
          end: 1,
        ),
      ];

      when(mockApiService.searchNovels(any)).thenAnswer(
        (_) async => NovelSearchResult(novels: mockNovels, allCount: 1),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies overrides_are_scoped_to_test
            apiServiceProvider.overrideWithValue(mockApiService),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(
                rankingType: 'd',
                key: PageStorageKey('test_dynamic'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Initial Novel'), findsOneWidget);

      // フィルタを変更
      final element = tester.element(find.byType(RankingList));
      final container = ProviderScope.containerOf(element);
      container
          .read(rankingFilterStateProvider('d').notifier)
          .setShowOnlyOngoing(value: true);

      // 新しいクエリ用にモックの応答を更新
      when(mockApiService.searchNovels(any)).thenAnswer(
        (_) async => NovelSearchResult(novels: filteredNovels, allCount: 1),
      );

      await tester.pumpAndSettle();

      // 絞り込み後の小説が表示されるはず
      // リアクティブ性が無い場合、'Initial Novel' が表示されたままになり失敗する
      if (find.text('Filtered Novel').evaluate().isEmpty) {}
      expect(find.text('Filtered Novel'), findsOneWidget);
    });
  });
}
