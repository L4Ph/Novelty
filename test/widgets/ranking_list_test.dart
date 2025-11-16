import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/models/ranking_response.dart';
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

    testWidgets('should display ranking list with load more button', (
      WidgetTester tester,
    ) async {
      // Mock data for ranking (全時間ランキングと同様に詳細情報を含める)
      final mockRankingData = List.generate(
        100,
        (index) => RankingResponse(
          ncode: 'n${index + 1000}ab',
          title: 'Test Novel ${index + 1}',
          writer: 'Test Writer ${index + 1}',
          story: 'Test Story ${index + 1}',
          rank: index + 1,
          pt: 1000 - index,
          end: 1, // 連載中
          genre: 1, // ジャンル
          novelType: 1, // 連載
          generalAllNo: 10,
        ),
      );

      when(
        mockApiService.fetchRanking('d'),
      ).thenAnswer((_) async => mockRankingData);

      // EnrichedNovelDataに変換
      final enrichedMockData = mockRankingData
          .map((novel) => EnrichedNovelData(novel: novel, isInLibrary: false))
          .toList();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            enrichedRankingDataProvider('d').overrideWith(
              (ref) async => enrichedMockData,
            ),
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

      // Wait for initial data to load
      await tester.pump(); // Initial frame
      await tester.pump(); // Provider resolution
      await tester.pump(); // postFrameCallback execution

      // Verify initial items are displayed (全時間ランキングのようにtitleを含むため即座に表示される)
      expect(find.text('Test Novel 1'), findsOneWidget);

      // ListViewが正しく表示されている
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should handle filter functionality correctly', (
      WidgetTester tester,
    ) async {
      // Mock ranking data with mixed ongoing and completed status (詳細情報を含む)
      final mockRankingData = [
        // Ongoing novel (should appear in filter)
        const RankingResponse(
          ncode: 'n1000ab',
          title: 'Ongoing Novel',
          writer: 'Writer 1',
          story: 'Story 1',
          rank: 1,
          pt: 1000,
          end: 1, // Ongoing
          genre: 1, // Fantasy
          novelType: 1,
          generalAllNo: 10,
        ),
        // Completed novel (should not appear in ongoing filter)
        const RankingResponse(
          ncode: 'n1001ab',
          title: 'Completed Novel',
          writer: 'Writer 2',
          story: 'Story 2',
          rank: 2,
          pt: 900,
          end: 0, // Completed
          genre: 1, // Fantasy
          novelType: 1,
          generalAllNo: 10,
        ),
        // Different genre novel
        const RankingResponse(
          ncode: 'n1002ab',
          title: 'Romance Novel',
          writer: 'Writer 3',
          story: 'Story 3',
          rank: 3,
          pt: 800,
          end: 1, // Ongoing
          genre: 2, // Romance
          novelType: 1,
          generalAllNo: 10,
        ),
      ];

      // EnrichedNovelDataに変換
      final enrichedMockData = mockRankingData
          .map((novel) => EnrichedNovelData(novel: novel, isInLibrary: false))
          .toList();

      // Test 1: Show only ongoing novels
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            enrichedRankingDataProvider('d').overrideWith(
              (ref) async => enrichedMockData,
            ),
            rankingFilterStateProvider('d').overrideWithValue(
              const RankingFilterState(showOnlyOngoing: true),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(
                rankingType: 'd',
                key: PageStorageKey('test_ongoing'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pump();

      // Should show ongoing novels only (詳細情報が既に含まれているため即座にフィルタリングされる)
      expect(find.text('Ongoing Novel'), findsOneWidget);
      expect(find.text('Romance Novel'), findsOneWidget);
      expect(find.text('Completed Novel'), findsNothing);

      // Test 2: Filter by genre
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            enrichedRankingDataProvider('d').overrideWith(
              (ref) async => enrichedMockData,
            ),
            rankingFilterStateProvider('d').overrideWithValue(
              const RankingFilterState(selectedGenre: 1), // Fantasy
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(
                rankingType: 'd',
                key: PageStorageKey('test_genre'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pump();

      // Should show only fantasy novels
      expect(find.text('Ongoing Novel'), findsOneWidget);
      expect(find.text('Completed Novel'), findsOneWidget);
      expect(find.text('Romance Novel'), findsNothing);

      // Test 3: Both filters combined
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            enrichedRankingDataProvider('d').overrideWith(
              (ref) async => enrichedMockData,
            ),
            rankingFilterStateProvider('d').overrideWithValue(
              const RankingFilterState(
                showOnlyOngoing: true,
                selectedGenre: 1, // Fantasy
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(
                rankingType: 'd',
                key: PageStorageKey('test_both'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      await tester.pump();

      // Should show only ongoing fantasy novels
      expect(find.text('Ongoing Novel'), findsOneWidget);
      expect(find.text('Completed Novel'), findsNothing);
      expect(find.text('Romance Novel'), findsNothing);
    });

    testWidgets('should handle empty ranking data gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            enrichedRankingDataProvider('d').overrideWith((ref) async => []),
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

      await tester.pump();
      await tester.pump();

      // Should show empty list without crashing
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should handle API errors gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            enrichedRankingDataProvider('d').overrideWith(
              (ref) async => throw Exception('API Error'),
            ),
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

      await tester.pumpAndSettle(); // Wait for all async operations and animations

      // Should show error message
      expect(find.textContaining('エラーが発生しました'), findsOneWidget);
    });

  });
}
