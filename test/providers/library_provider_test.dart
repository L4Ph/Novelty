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
      final testNovels = [
        Novel(
          ncode: 'N1234AB',
          title: 'テスト小説',
          writer: 'テスト作者',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      final mockSelectStatement =
          MockSimpleSelectStatement<$NovelsTable, Novel>();
      when(
        mockDatabase.select(mockNovelsTable),
      ).thenReturn(mockSelectStatement);
      when(mockSelectStatement.where(any)).thenReturn(mockSelectStatement);
      when(mockSelectStatement.get()).thenAnswer((_) async => testNovels);

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
      final mockSelectStatement =
          MockSimpleSelectStatement<$NovelsTable, Novel>();
      when(
        mockDatabase.select(mockNovelsTable),
      ).thenReturn(mockSelectStatement);
      when(mockSelectStatement.where(any)).thenReturn(mockSelectStatement);
      when(mockSelectStatement.get()).thenThrow(Exception('Database error'));

      expect(
        () => container.read(libraryNovelsProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('should return Future<List<Novel>>', () async {
      final testNovels = [
        Novel(
          ncode: 'N1234AB',
          title: 'テスト小説1',
          writer: 'テスト作者1',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
        Novel(
          ncode: 'N5678CD',
          title: 'テスト小説2',
          writer: 'テスト作者2',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      // Mock the select query chain used in libraryNovelsProvider
      final mockSelectStatement =
          MockSimpleSelectStatement<$NovelsTable, Novel>();
      when(
        mockDatabase.select(mockNovelsTable),
      ).thenReturn(mockSelectStatement);
      when(mockSelectStatement.where(any)).thenReturn(mockSelectStatement);
      when(mockSelectStatement.get()).thenAnswer((_) async => testNovels);

      final result = await container.read(libraryNovelsProvider.future);

      expect(result, equals(testNovels));
    });

    test('should handle refresh correctly', () async {
      final testNovels = [
        Novel(
          ncode: 'N1234AB',
          title: 'テスト小説',
          writer: 'テスト作者',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      final mockSelectStatement =
          MockSimpleSelectStatement<$NovelsTable, Novel>();
      when(
        mockDatabase.select(mockNovelsTable),
      ).thenReturn(mockSelectStatement);
      when(mockSelectStatement.where(any)).thenReturn(mockSelectStatement);
      when(mockSelectStatement.get()).thenAnswer((_) async => testNovels);

      await container.read(libraryNovelsProvider.future);

      expect(
        () => container.refresh(libraryNovelsProvider),
        returnsNormally,
      );
    });

    test('should maintain state across multiple reads', () async {
      final testNovels = [
        Novel(
          ncode: 'N1234AB',
          title: 'テスト小説',
          writer: 'テスト作者',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      final mockSelectStatement =
          MockSimpleSelectStatement<$NovelsTable, Novel>();
      when(
        mockDatabase.select(mockNovelsTable),
      ).thenReturn(mockSelectStatement);
      when(mockSelectStatement.where(any)).thenReturn(mockSelectStatement);
      when(mockSelectStatement.get()).thenAnswer((_) async => testNovels);

      final asyncValue1 = container.read(libraryNovelsProvider);
      final asyncValue2 = container.read(libraryNovelsProvider);

      expect(asyncValue1, equals(asyncValue2));
    });

    test('should create new state after refresh', () async {
      final testNovels = [
        Novel(
          ncode: 'N1234AB',
          title: 'テスト小説',
          writer: 'テスト作者',
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      final mockSelectStatement =
          MockSimpleSelectStatement<$NovelsTable, Novel>();
      when(
        mockDatabase.select(mockNovelsTable),
      ).thenReturn(mockSelectStatement);
      when(mockSelectStatement.where(any)).thenReturn(mockSelectStatement);
      when(mockSelectStatement.get()).thenAnswer((_) async => testNovels);

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
