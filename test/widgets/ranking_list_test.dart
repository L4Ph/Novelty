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
        mockApiService.fetchRankingAndDetails('d'),
      ).thenAnswer((_) async => mockRankingData);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
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

      // Wait for initial data to load
      await tester.pumpAndSettle();

      // Verify initial items are displayed
      expect(find.text('Test Novel 1'), findsOneWidget);
      // Drag the list to scroll down
      await tester.drag(find.byType(ListView), const Offset(0.0, -3000.0));
      await tester.pumpAndSettle();
      // The 50th item should be visible now
      expect(find.text('Test Novel 50'), findsOneWidget);
      expect(find.text('Test Novel 51'), findsNothing);

      // Drag the list to the bottom to trigger infinite scroll
      await tester.drag(find.byType(ListView), const Offset(0.0, -5000.0));
      await tester.pumpAndSettle();

      // Verify more items are loaded
      expect(find.text('Test Novel 51'), findsOneWidget);
    });

    testWidgets('should handle empty ranking data gracefully', (
      WidgetTester tester,
    ) async {
      when(
        mockApiService.fetchRankingAndDetails('d'),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
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

      // Should show empty list without crashing
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should handle API errors gracefully', (
      WidgetTester tester,
    ) async {
      when(
        mockApiService.fetchRankingAndDetails('d'),
      ).thenThrow(Exception('API Error'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
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

      // Should show error message
      expect(find.textContaining('エラーが発生しました'), findsOneWidget);
    });
  });
}