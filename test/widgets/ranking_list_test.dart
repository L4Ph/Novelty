import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/models/novel_info.dart';
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

    testWidgets('should display infinite scroll ranking list', (
      WidgetTester tester,
    ) async {
      // Mock data for ranking
      final mockRankingData = List.generate(
        100,
        (index) => RankingResponse(
          ncode: 'N${index + 1000}AB',
          title: 'Test Novel ${index + 1}',
          rank: index + 1,
          pt: 1000 - index,
        ),
      );

      when(
        mockApiService.fetchRanking('d'),
      ).thenAnswer((_) async => mockRankingData);

      when(
        mockApiService.fetchMultipleNovelsInfo(any),
      ).thenAnswer((_) async => {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            rankingDataProvider('d').overrideWith((ref) async => mockRankingData),
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
      await tester.pump(const Duration(milliseconds: 100)); // Post frame callbacks

      // Verify initial items are displayed
      expect(find.text('Test Novel 1'), findsOneWidget);
    });

    testWidgets('should handle filter functionality correctly', (
      WidgetTester tester,
    ) async {
      // Mock ranking data with mixed ongoing and completed status
      final mockRankingData = [
        // Ongoing novel (should appear in filter)
        const RankingResponse(
          ncode: 'N1000AB',
          rank: 1,
          pt: 1000,
        ),
        // Completed novel (should not appear in ongoing filter)
        const RankingResponse(
          ncode: 'N1001AB',
          rank: 2,
          pt: 900,
        ),
        // Different genre novel
        const RankingResponse(
          ncode: 'N1002AB',
          rank: 3,
          pt: 800,
        ),
      ];

      // Mock novel details that will be fetched
      final mockNovelDetails = {
        'N1000AB': const NovelInfo(
          ncode: 'N1000AB',
          title: 'Ongoing Novel',
          writer: 'Writer 1',
          story: 'Story 1',
          end: 1, // Ongoing
          genre: 1, // Fantasy
        ),
        'N1001AB': const NovelInfo(
          ncode: 'N1001AB',
          title: 'Completed Novel',
          writer: 'Writer 2',
          story: 'Story 2',
          end: 0, // Completed
          genre: 1, // Fantasy
        ),
        'N1002AB': const NovelInfo(
          ncode: 'N1002AB',
          title: 'Romance Novel',
          writer: 'Writer 3',
          story: 'Story 3',
          end: 1, // Ongoing
          genre: 2, // Romance
        ),
      };

      when(
        mockApiService.fetchRanking('d'),
      ).thenAnswer((_) async => mockRankingData);

      when(
        mockApiService.fetchMultipleNovelsInfo(any),
      ).thenAnswer((invocation) async {
        final ncodes = invocation.positionalArguments[0] as List<String>;
        final result = <String, NovelInfo>{};
        for (final ncode in ncodes) {
          if (mockNovelDetails.containsKey(ncode)) {
            result[ncode] = mockNovelDetails[ncode]!;
          }
        }
        return result;
      });

      // Test 1: Show only ongoing novels
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            rankingDataProvider('d').overrideWith((ref) async => mockRankingData),
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
      await tester.pump(const Duration(milliseconds: 100));

      // Should show ongoing novels only after details are loaded
      expect(find.text('Ongoing Novel'), findsOneWidget);
      expect(find.text('Romance Novel'), findsOneWidget);
      expect(find.text('Completed Novel'), findsNothing);

      // Test 2: Filter by genre
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            rankingDataProvider('d').overrideWith((ref) async => mockRankingData),
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
      await tester.pump(const Duration(milliseconds: 100));

      // Should show only fantasy novels after details are loaded
      expect(find.text('Ongoing Novel'), findsOneWidget);
      expect(find.text('Completed Novel'), findsOneWidget);
      expect(find.text('Romance Novel'), findsNothing);

      // Test 3: Both filters combined
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            rankingDataProvider('d').overrideWith((ref) async => mockRankingData),
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
      await tester.pump(const Duration(milliseconds: 100));

      // Should show only ongoing fantasy novels
      expect(find.text('Ongoing Novel'), findsOneWidget);
      expect(find.text('Completed Novel'), findsNothing);
      expect(find.text('Romance Novel'), findsNothing);
    });

    testWidgets('should handle empty ranking data gracefully', (
      WidgetTester tester,
    ) async {
      when(
        mockApiService.fetchRanking('d'),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            rankingDataProvider('d').overrideWith((ref) async => []),
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
      when(
        mockApiService.fetchRanking('d'),
      ).thenThrow(Exception('API Error'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiServiceProvider.overrideWithValue(mockApiService),
            rankingDataProvider('d').overrideWith((ref) async => throw Exception('API Error')),
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

      // Should show error message
      expect(find.textContaining('エラーが発生しました'), findsOneWidget);
    });

  });
}
