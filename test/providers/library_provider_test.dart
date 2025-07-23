import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/screens/library_page.dart';

@GenerateMocks([AppDatabase])
import 'library_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('libraryNovelsProvider', () {
    late MockAppDatabase mockDatabase;
    late ProviderContainer container;

    final testLibraryNovels = [
      LibraryNovel(
        ncode: 'n1234ab',
        title: 'テスト小説1',
        writer: 'テスト作者1',
        story: 'あらすじ1',
        novelType: 1,
        end: 0,
        generalAllNo: 10,
        novelUpdatedAt: DateTime.now().toIso8601String(),
        addedAt: DateTime.now().millisecondsSinceEpoch,
      ),
      LibraryNovel(
        ncode: 'n5678cd',
        title: 'テスト小説2',
        writer: 'テスト作者2',
        story: 'あらすじ2',
        novelType: 2,
        end: 1,
        generalAllNo: 1,
        novelUpdatedAt: DateTime.now().toIso8601String(),
        addedAt: DateTime.now().millisecondsSinceEpoch,
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
        mockDatabase.getLibraryNovels(),
      ).thenAnswer((_) async => testLibraryNovels);

      // getNovelのスタブを追加
      when(mockDatabase.getNovel(any)).thenAnswer((invocation) async {
        final ncode = invocation.positionalArguments[0] as String;
        final libraryNovel = testLibraryNovels.firstWhere((novel) => novel.ncode == ncode);
        return Novel(
          ncode: libraryNovel.ncode,
          title: libraryNovel.title,
          writer: libraryNovel.writer,
          story: libraryNovel.story,
          novelType: libraryNovel.novelType,
          end: libraryNovel.end,
          generalAllNo: libraryNovel.generalAllNo,
          generalLastup: libraryNovel.novelUpdatedAt != null
              ? DateTime.parse(libraryNovel.novelUpdatedAt!).millisecondsSinceEpoch
              : null,
        );
      });

      final result = await container.read(libraryNovelsProvider.future);

      expect(result, isA<List<Novel>>());
      expect(result.length, equals(testLibraryNovels.length));
      expect(result.first.ncode, equals(testLibraryNovels.first.ncode));
      verify(mockDatabase.getLibraryNovels()).called(1);
    });

    test('should handle database errors gracefully', () async {
      when(
        mockDatabase.getLibraryNovels(),
      ).thenThrow(Exception('Database error'));

      await expectLater(
        container.read(libraryNovelsProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('should be auto-disposed and re-fetched when not in use', () async {
      when(
        mockDatabase.getLibraryNovels(),
      ).thenAnswer((_) async => testLibraryNovels);

      when(mockDatabase.getNovel(any)).thenAnswer((invocation) async {
        final ncode = invocation.positionalArguments[0] as String;
        final libraryNovel = testLibraryNovels.firstWhere((novel) => novel.ncode == ncode);
        return Novel(
          ncode: libraryNovel.ncode,
          title: libraryNovel.title,
          writer: libraryNovel.writer,
          story: libraryNovel.story,
          novelType: libraryNovel.novelType,
          end: libraryNovel.end,
          generalAllNo: libraryNovel.generalAllNo,
          generalLastup: libraryNovel.novelUpdatedAt != null ? DateTime.parse(libraryNovel.novelUpdatedAt!).millisecondsSinceEpoch : null,
        );
      });

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
        newMockDatabase.getLibraryNovels(),
      ).thenAnswer((_) async => testLibraryNovels);
      
      when(newMockDatabase.getNovel(any)).thenAnswer((invocation) async {
        final ncode = invocation.positionalArguments[0] as String;
        final libraryNovel = testLibraryNovels.firstWhere((novel) => novel.ncode == ncode);
        return Novel(
          ncode: libraryNovel.ncode,
          title: libraryNovel.title,
          writer: libraryNovel.writer,
          story: libraryNovel.story,
          novelType: libraryNovel.novelType,
          end: libraryNovel.end,
          generalAllNo: libraryNovel.generalAllNo,
          generalLastup: libraryNovel.novelUpdatedAt != null ? DateTime.parse(libraryNovel.novelUpdatedAt!).millisecondsSinceEpoch : null,
        );
      });

      final result = await newContainer.read(libraryNovelsProvider.future);
      expect(result, isA<List<Novel>>());
      verify(newMockDatabase.getLibraryNovels()).called(1);

      newContainer.dispose();
    });

    test('should handle refresh correctly', () async {
      when(
        mockDatabase.getLibraryNovels(),
      ).thenAnswer((_) async => testLibraryNovels.sublist(0, 1));

      when(mockDatabase.getNovel(any)).thenAnswer((invocation) async {
        final ncode = invocation.positionalArguments[0] as String;
        final libraryNovel = testLibraryNovels.firstWhere((novel) => novel.ncode == ncode);
        return Novel(
          ncode: libraryNovel.ncode,
          title: libraryNovel.title,
          writer: libraryNovel.writer,
          story: libraryNovel.story,
          novelType: libraryNovel.novelType,
          end: libraryNovel.end,
          generalAllNo: libraryNovel.generalAllNo,
          generalLastup: libraryNovel.novelUpdatedAt != null ? DateTime.parse(libraryNovel.novelUpdatedAt!).millisecondsSinceEpoch : null,
        );
      });

      await container.read(libraryNovelsProvider.future);

      when(
        mockDatabase.getLibraryNovels(),
      ).thenAnswer((_) async => testLibraryNovels);

      final refreshedResult = await container.refresh(
        libraryNovelsProvider.future,
      );

      expect(refreshedResult, isA<List<Novel>>());
      expect(refreshedResult.length, equals(testLibraryNovels.length));
      verify(mockDatabase.getLibraryNovels()).called(2);
    });
  });
}
