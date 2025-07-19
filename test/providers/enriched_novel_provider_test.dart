import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/providers/enriched_novel_provider.dart';

import '../mocks.dart';

void main() {
  group('EnrichedNovelProvider Tests', () {
    late ProviderContainer container;
    late MockAppDatabase mockDb;
    late MockNovelDao mockNovelDao;

    setUp(() {
      mockDb = MockAppDatabase();
      mockNovelDao = MockNovelDao();
      when(mockDb.novelDao).thenReturn(mockNovelDao);

      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDb),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('EnrichedNovelData should contain novel and library status', () {
      // Arrange
      const testNovel = RankingResponse(
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

    test('getNovelLibraryStatus should return correct status', () async {
      // Arrange
      final mockNovel = MockNovel();
      when(mockNovelDao.getNovel('n1234test')).thenAnswer((_) async => mockNovel);

      // Act
      final isInLibrary = await getNovelLibraryStatus(
        container as WidgetRef,
        'n1234test',
      );

      // Assert
      expect(isInLibrary, isTrue);
    });

    test(
        'getNovelLibraryStatus should return false for non-existent novel',
        () async {
      // Arrange
      when(mockNovelDao.getNovel('nonexistent')).thenAnswer((_) async => null);

      // Act
      final isInLibrary = await getNovelLibraryStatus(
        container as WidgetRef,
        'nonexistent',
      );

      // Assert
      expect(isInLibrary, isFalse);
    });
  });
}
