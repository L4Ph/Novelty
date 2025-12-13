import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/models/novel_info.dart';

void main() {
  group('EnrichedNovelProvider Tests', () {
    test('EnrichedNovelData should contain novel and library status', () {
      // Arrange
      const testNovel = NovelInfo(
        ncode: 'n1234test',
        title: 'Test Novel',
        writer: 'Test Author',
      );

      // Act
      const enrichedData = EnrichedNovelData(
        novel: testNovel,
        isInLibrary: true,
      );

      // Assert
      expect(enrichedData.novel.ncode, equals('n1234test'));
      expect(enrichedData.novel.title, equals('Test Novel'));
      expect(enrichedData.isInLibrary, isTrue);
    });
  });
}
