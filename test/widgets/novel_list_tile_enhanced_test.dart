import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

void main() {
  group('NovelListTile Tests', () {
    testWidgets('ライブラリ登録済みの小説にはハートアイコンが表示される', (tester) async {
      // Arrange
      const testNovel = NovelInfo(
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

    testWidgets('ライブラリ未登録の小説にはハートアイコンが表示されない', (tester) async {
      // Arrange
      const testNovel = NovelInfo(
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

    testWidgets('enriched data が null の場合はハートアイコンが表示されない', (tester) async {
      // Arrange
      const testNovel = NovelInfo(
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
