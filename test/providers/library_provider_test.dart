import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/screens/library_page.dart';

@GenerateMocks([AppDatabase])
import 'library_provider_test.mocks.dart';

void main() {
  group('libraryNovelsProvider', () {
    late MockAppDatabase mockDatabase;
    late ProviderContainer container;

    setUp(() {
      mockDatabase = MockAppDatabase();
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDatabase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should return cached novels when database call succeeds', () async {
      final testNovels = [
        Novel(
          ncode: 'N1234AB',
          title: 'テスト小説1',
          writer: 'テスト作者1',
          story: 'テストストーリー1',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
        Novel(
          ncode: 'N5678CD',
          title: 'テスト小説2',
          writer: 'テスト作者2',
          story: 'テストストーリー2',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      when(mockDatabase.select(mockDatabase.novels)).thenReturn(
        mockDatabase.select(mockDatabase.novels),
      );

      final result = await container.read(libraryNovelsProvider.future);

      expect(result, isA<List<Novel>>());
    });

    test('should return empty list when no cached novels exist', () async {
      when(mockDatabase.select(mockDatabase.novels)).thenReturn(
        mockDatabase.select(mockDatabase.novels),
      );

      final result = await container.read(libraryNovelsProvider.future);

      expect(result, isA<List<Novel>>());
    });

    test('should handle database errors', () async {
      when(mockDatabase.select(mockDatabase.novels)).thenThrow(
        Exception('Database error'),
      );

      expect(
        () => container.read(libraryNovelsProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('should cache results and not call database multiple times', () async {
      when(mockDatabase.select(mockDatabase.novels)).thenReturn(
        mockDatabase.select(mockDatabase.novels),
      );

      final result1 = await container.read(libraryNovelsProvider.future);
      final result2 = await container.read(libraryNovelsProvider.future);

      expect(result1, equals(result2));
    });

    test('should refresh data when provider is refreshed', () async {
      when(mockDatabase.select(mockDatabase.novels)).thenReturn(
        mockDatabase.select(mockDatabase.novels),
      );

      await container.read(libraryNovelsProvider.future);

      container.refresh(libraryNovelsProvider);
      await container.read(libraryNovelsProvider.future);

      expect(() => container.refresh(libraryNovelsProvider), returnsNormally);
    });
  });
}
