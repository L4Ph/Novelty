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
            // ignore: scoped_providers_should_specify_dependencies
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
            // ignore: scoped_providers_should_specify_dependencies
            apiServiceProvider.overrideWithValue(mockApiService),
            // ignore: scoped_providers_should_specify_dependencies
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
  });
}
