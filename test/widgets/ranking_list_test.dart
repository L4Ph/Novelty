import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/ranking_list.dart';

import 'ranking_list_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('RankingList Widget Tests', () {
    late MockApiService mockApiService;
    late ProviderContainer container;

    setUp(() {
      mockApiService = MockApiService();
      container = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should display infinite scroll ranking list', (WidgetTester tester) async {
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

      when(mockApiService.fetchRankingAndDetails('d'))
          .thenAnswer((_) async => mockRankingData);

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
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
      await tester.pumpAndSettle();

      // Verify initial items are displayed (first 50)
      expect(find.text('Test Novel 1'), findsOneWidget);
      expect(find.text('Test Novel 50'), findsOneWidget);
      expect(find.text('Test Novel 51'), findsNothing);

      // Verify loading indicator is shown at bottom
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Scroll to bottom to trigger infinite scroll
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();

      // Verify more items are loaded
      expect(find.text('Test Novel 51'), findsOneWidget);
    });

    testWidgets('should handle empty ranking data gracefully', (WidgetTester tester) async {
      when(mockApiService.fetchRankingAndDetails('d'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
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

      // Should show empty list without crashing
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should handle API errors gracefully', (WidgetTester tester) async {
      when(mockApiService.fetchRankingAndDetails('d'))
          .thenThrow(Exception('API Error'));

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
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

      // Should show error message
      expect(find.textContaining('エラーが発生しました'), findsOneWidget);
    });
  });
}