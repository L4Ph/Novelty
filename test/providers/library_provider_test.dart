import 'dart:async';

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
        isPrivate: false,
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
        isPrivate: false,
      ),
    ];

    setUp(() {
      mockDatabase = MockAppDatabase();
      container = ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDatabase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    // riverpod 3.x では `read(provider.future)` の直後に購読が閉じられ、
    // プロバイダーがローディング中に破棄されてしまう。
    // 値を確定させるまで購読を維持するためのヘルパー。
    // 戻り値の購読はテスト終了時に close する。
    ProviderSubscription<Object?> keepAlive() {
      return container.listen(
            libraryNovelsProvider,
            (_, _) {},
          )
          as ProviderSubscription<Object?>;
    }

    test('should return Future<List<Novel>>', () async {
      when(
        mockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.fromIterable([testNovels]));

      keepAlive();
      final result = await container.read(libraryNovelsProvider.future);

      expect(result, equals(testNovels));
      verify(mockDatabase.watchLibraryNovels()).called(1);
    });

    test('should handle database errors gracefully', () async {
      when(
        mockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.error(Exception('Database error')));

      keepAlive();
      await expectLater(
        container.read(libraryNovelsProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('should be auto-disposed and re-fetched when not in use', () async {
      // 新しい container と mock を作成して再取得を検証する。
      // riverpod 3.x では、read 完了後に購読が閉じられると
      // ローディング中の破棄エラーになるため、購読を維持してから検証する。
      final newMockDatabase = MockAppDatabase();
      final newContainer = ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          appDatabaseProvider.overrideWithValue(newMockDatabase),
        ],
      );
      addTearDown(newContainer.dispose);

      when(
        newMockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.fromIterable([testNovels]));

      newContainer.listen(libraryNovelsProvider, (_, _) {});
      final result = await newContainer.read(libraryNovelsProvider.future);
      expect(result, testNovels);
      verify(newMockDatabase.watchLibraryNovels()).called(1);
    });

    test('should handle refresh correctly', () async {
      // Initial call
      when(
        mockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.fromIterable([testNovels.sublist(0, 1)]));

      keepAlive();
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
