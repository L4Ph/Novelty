import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

void main() {
  group('NovelListTile Tests', () {
    testWidgets('should show heart icon when novel is in library', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testNovel = RankingResponse(
        ncode: 'n1234test',
        title: 'Test Novel',
        writer: 'Test Author',
      );

      const enrichedData = EnrichedNovelData(
        novel: testNovel,
        isInLibrary: true,
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NovelListTile(
              item: testNovel,
              enrichedData: enrichedData,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Novel'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('should not show heart icon when novel is not in library', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testNovel = RankingResponse(
        ncode: 'n1234test',
        title: 'Test Novel',
        writer: 'Test Author',
      );

      const enrichedData = EnrichedNovelData(
        novel: testNovel,
        isInLibrary: false,
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NovelListTile(
              item: testNovel,
              enrichedData: enrichedData,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Novel'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('should not show heart icon when enriched data is null', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testNovel = RankingResponse(
        ncode: 'n1234test',
        title: 'Test Novel',
        writer: 'Test Author',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NovelListTile(
              item: testNovel,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Novel'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });
  });
}
