import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/providers/database_providers.dart';

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
        mockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.fromIterable([testNovels]));

      final result = await container.read(libraryNovelsProvider.future);

      expect(result, equals(testNovels));
      verify(mockDatabase.watchLibraryNovels()).called(1);
    });

    test('should handle database errors gracefully', () async {
      when(
        mockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.error(Exception('Database error')));

      await expectLater(
        container.read(libraryNovelsProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('should be auto-disposed and re-fetched when not in use', () async {
      when(
        mockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.fromIterable([testNovels]));

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
        newMockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.fromIterable([testNovels]));

      final result = await newContainer.read(libraryNovelsProvider.future);
      expect(result, testNovels);
      verify(newMockDatabase.watchLibraryNovels()).called(1);

      newContainer.dispose();
    });

    test('should handle refresh correctly', () async {
      // Initial call
      when(
        mockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.fromIterable([testNovels.sublist(0, 1)]));

      final firstResult = await container.read(libraryNovelsProvider.future);
      expect(firstResult, equals(testNovels.sublist(0, 1)));

      // Invalidate the provider to force re-read
      container.invalidate(libraryNovelsProvider);

      // Update mock to return new data for the NEXT call
      when(
        mockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.fromIterable([testNovels]));

      final secondResult = await container.read(libraryNovelsProvider.future);
      expect(secondResult, equals(testNovels));

      // Verify called twice
      verify(mockDatabase.watchLibraryNovels()).called(2);
    });
  });
}
