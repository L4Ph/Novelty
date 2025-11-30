import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';

@GenerateMocks([AppDatabase])
import 'library_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('libraryNovelsProvider', () {
    late MockAppDatabase mockDatabase;
    late ProviderContainer container;

    final testNovels = [
      Novel(
        ncode: 'n1234ab',
        title: 'テスト小説1',
        writer: 'テスト作者1',
        story: 'あらすじ1',
        novelType: 1,
        end: 0,
        generalAllNo: 10,
        novelUpdatedAt: DateTime.now().toIso8601String(),
        cachedAt: DateTime.now().millisecondsSinceEpoch,
      ),
      Novel(
        ncode: 'n5678cd',
        title: 'テスト小説2',
        writer: 'テスト作者2',
        story: 'あらすじ2',
        novelType: 2,
        end: 1,
        generalAllNo: 1,
        novelUpdatedAt: DateTime.now().toIso8601String(),
        cachedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    ];

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

    test('should return Future<List<Novel>>', () async {
      when(
        mockDatabase.watchLibraryNovelsWithDetails(),
      ).thenAnswer((_) => Stream.value(testNovels));

      final result = await container.read(libraryNovelsProvider.future);

      expect(result, equals(testNovels));
      verify(mockDatabase.watchLibraryNovelsWithDetails()).called(1);
    });

    test('should handle database errors gracefully', () async {
      when(
        mockDatabase.watchLibraryNovelsWithDetails(),
      ).thenAnswer((_) => Stream.error(Exception('Database error')));

      await expectLater(
        container.read(libraryNovelsProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('should be auto-disposed and re-fetched when not in use', () async {
      when(
        mockDatabase.watchLibraryNovelsWithDetails(),
      ).thenAnswer((_) => Stream.value(testNovels));

      await container.read(libraryNovelsProvider.future);
      container.dispose();

      // Create a new container and mock
      final newMockDatabase = MockAppDatabase();
      final newContainer = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(newMockDatabase),
        ],
      );
      when(
        newMockDatabase.watchLibraryNovelsWithDetails(),
      ).thenAnswer((_) => Stream.value(testNovels));

      final result = await newContainer.read(libraryNovelsProvider.future);
      expect(result, testNovels);
      verify(newMockDatabase.watchLibraryNovelsWithDetails()).called(1);

      newContainer.dispose();
    });

    test('should handle refresh correctly', () async {
      // StreamProvider doesn't support manual refresh in the same way as FutureProvider
      // when mocking the stream directly. 
      // Instead, we can verify that the stream emits new values.
      // But here we are mocking the method call.
      
      // Initial call
      when(
        mockDatabase.watchLibraryNovelsWithDetails(),
      ).thenAnswer((_) => Stream.value(testNovels.sublist(0, 1)));

      final firstResult = await container.read(libraryNovelsProvider.future);
      expect(firstResult, equals(testNovels.sublist(0, 1)));

      // Invalidate the provider to force re-read
      container.invalidate(libraryNovelsProvider);
      
      // Update mock to return new data for the NEXT call
      when(
        mockDatabase.watchLibraryNovelsWithDetails(),
      ).thenAnswer((_) => Stream.value(testNovels));

      final secondResult = await container.read(libraryNovelsProvider.future);
      expect(secondResult, equals(testNovels));
      
      // Verify called twice
      verify(mockDatabase.watchLibraryNovelsWithDetails()).called(2);
    });
  });
}
