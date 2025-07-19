import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/screens/library_page.dart';

@GenerateMocks([AppDatabase, SimpleSelectStatement, $NovelsTable])
import 'library_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('libraryNovelsProvider', () {
    late MockAppDatabase mockDatabase;
    late Mock$NovelsTable mockNovelsTable;
    late ProviderContainer container;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockNovelsTable = Mock$NovelsTable();
      when(mockDatabase.novels).thenReturn(mockNovelsTable);
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDatabase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should be auto-disposed when not in use', () {
      final testLibraryNovels = [
        LibraryNovel(
          ncode: 'n1234ab',
          addedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];
      
      final testNovels = [
        Novel(
          ncode: 'n1234ab',
          title: 'テスト小説',
          writer: 'テスト作者',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      when(mockDatabase.getLibraryNovels()).thenAnswer((_) async => testLibraryNovels);
      when(mockDatabase.getNovel('n1234ab')).thenAnswer((_) async => testNovels[0]);

      container
        ..read(libraryNovelsProvider)
        ..dispose();

      final newMockDatabase = MockAppDatabase();
      final newContainer = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(newMockDatabase),
        ],
      );
      expect(
        () => newContainer.read(libraryNovelsProvider),
        returnsNormally,
      );
      newContainer.dispose();
    });

    test('should handle database errors gracefully', () async {
      // Mock getLibraryNovels to throw an exception
      when(mockDatabase.getLibraryNovels()).thenThrow(Exception('Database error'));

      expect(
        () => container.read(libraryNovelsProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('should return Future<List<Novel>>', () async {
      final testLibraryNovels = [
        LibraryNovel(
          ncode: 'n1234ab',
          addedAt: DateTime.now().millisecondsSinceEpoch,
        ),
        LibraryNovel(
          ncode: 'n5678cd',
          addedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];
      
      final testNovels = [
        Novel(
          ncode: 'n1234ab',
          title: 'テスト小説1',
          writer: 'テスト作者1',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
        Novel(
          ncode: 'n5678cd',
          title: 'テスト小説2',
          writer: 'テスト作者2',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      // Mock the new library query methods
      when(mockDatabase.getLibraryNovels()).thenAnswer((_) async => testLibraryNovels);
      when(mockDatabase.getNovel('n1234ab')).thenAnswer((_) async => testNovels[0]);
      when(mockDatabase.getNovel('n5678cd')).thenAnswer((_) async => testNovels[1]);

      final result = await container.read(libraryNovelsProvider.future);

      expect(result, equals(testNovels));
    });

    test('should handle refresh correctly', () async {
      final testLibraryNovels = [
        LibraryNovel(
          ncode: 'n1234ab',
          addedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];
      
      final testNovels = [
        Novel(
          ncode: 'n1234ab',
          title: 'テスト小説',
          writer: 'テスト作者',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      when(mockDatabase.getLibraryNovels()).thenAnswer((_) async => testLibraryNovels);
      when(mockDatabase.getNovel('n1234ab')).thenAnswer((_) async => testNovels[0]);

      await container.read(libraryNovelsProvider.future);

      expect(
        () => container.refresh(libraryNovelsProvider),
        returnsNormally,
      );
    });

    test('should maintain state across multiple reads', () async {
      final testLibraryNovels = [
        LibraryNovel(
          ncode: 'n1234ab',
          addedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];
      
      final testNovels = [
        Novel(
          ncode: 'n1234ab',
          title: 'テスト小説',
          writer: 'テスト作者',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      when(mockDatabase.getLibraryNovels()).thenAnswer((_) async => testLibraryNovels);
      when(mockDatabase.getNovel('n1234ab')).thenAnswer((_) async => testNovels[0]);

      final asyncValue1 = container.read(libraryNovelsProvider);
      final asyncValue2 = container.read(libraryNovelsProvider);

      expect(asyncValue1, equals(asyncValue2));
    });

    test('should create new state after refresh', () async {
      final testLibraryNovels = [
        LibraryNovel(
          ncode: 'n1234ab',
          addedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];
      
      final testNovels = [
        Novel(
          ncode: 'n1234ab',
          title: 'テスト小説',
          writer: 'テスト作者',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      when(mockDatabase.getLibraryNovels()).thenAnswer((_) async => testLibraryNovels);
      when(mockDatabase.getNovel('n1234ab')).thenAnswer((_) async => testNovels[0]);

      // Wait for initial state to load
      await container.read(libraryNovelsProvider.future);
      final asyncValue1 = container.read(libraryNovelsProvider);

      container.refresh(libraryNovelsProvider);
      final asyncValue2 = container.read(libraryNovelsProvider);

      // After refresh, the new state should be different (likely AsyncLoading)
      expect(asyncValue1, isNot(equals(asyncValue2)));
    });
  });
}
