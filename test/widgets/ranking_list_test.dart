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
      WidgetTester tester,
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

      // Default query match
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
      WidgetTester tester,
    ) async {
      final mockNovels = [
        const NovelInfo(
          ncode: 'n1',
          title: 'Filtered Novel',
          writer: 'Writer',
          genre: 201, // Fantasy
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

      // Verify that searchNovels was called with a query including the genre
      final captured = verify(mockApiService.searchNovels(captureAny)).captured;
      final query = captured.last as NovelSearchQuery;
      expect(query.genre, equals([201]));

      expect(find.text('Filtered Novel'), findsOneWidget);
    });
    testWidgets('should filter ongoing novels locally', (
      WidgetTester tester,
    ) async {
      final mockNovels = [
        const NovelInfo(
          ncode: 'n1',
          title: 'Ongoing Novel',
          writer: 'Writer',
          novelType: 1, // Ongoing
        ),
        const NovelInfo(
          ncode: 'n2',
          title: 'Short Story',
          writer: 'Writer',
          novelType: 2, // Short
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

      // Verify that query does NOT have type='r' (since we removed it)
      final captured = verify(mockApiService.searchNovels(captureAny)).captured;
      final query = captured.last as NovelSearchQuery;
      expect(query.type, isNull);

      // Verify filtering: Only Ongoing Novel should be visible
      expect(find.text('Ongoing Novel'), findsOneWidget);
      expect(find.text('Short Story'), findsNothing);
    });
    testWidgets('should refresh list when filter changes dynamically', (
      WidgetTester tester,
    ) async {
      final mockNovels = [
        const NovelInfo(
          ncode: 'n1',
          title: 'Initial Novel',
          writer: 'Writer',
          novelType: 1,
        ),
      ];
      final filteredNovels = [
        const NovelInfo(
          ncode: 'n2',
          title: 'Filtered Novel',
          writer: 'Writer',
          novelType: 1,
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

      // Change filter
      final element = tester.element(find.byType(RankingList));
      final container = ProviderScope.containerOf(element);
      container
          .read(rankingFilterStateProvider('d').notifier)
          .setShowOnlyOngoing(value: true);

      // Update mock response for the new query
      when(mockApiService.searchNovels(any)).thenAnswer(
        (_) async => NovelSearchResult(novels: filteredNovels, allCount: 1),
      );

      await tester.pumpAndSettle();

      // Should now show the filtered novel
      // If reactivity is missing, this will fail as it will still show 'Initial Novel'
      if (find.text('Filtered Novel').evaluate().isEmpty) {}
      expect(find.text('Filtered Novel'), findsOneWidget);
    });
  });
}
