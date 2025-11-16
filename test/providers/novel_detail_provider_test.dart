import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart' hide Episode;
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/services/api_service.dart';

@GenerateMocks([AppDatabase, ApiService, NovelRepository])
import 'novel_detail_provider_test.mocks.dart';

void main() {
  group('novelInfoProvider', () {
    late MockAppDatabase mockDatabase;
    late MockApiService mockApiService;
    late ProviderContainer container;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockApiService = MockApiService();
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDatabase),
          apiServiceProvider.overrideWithValue(mockApiService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should fetch novel info from API when not cached', () async {
      const testNcode = 'N1234AB';
      const testNovelInfo = NovelInfo(
        ncode: testNcode,
        title: 'テスト小説',
        writer: 'テスト作者',
        story: 'テストストーリー',
        novelType: 1,
        episodes: [],
      );

      when(mockDatabase.getNovel(testNcode)).thenAnswer((_) async => null);
      when(mockDatabase.insertNovel(any)).thenAnswer((_) async => 1);
      when(mockDatabase.addToHistory(any)).thenAnswer((_) async => 1);
      when(
        mockApiService.fetchNovelInfo(testNcode),
      ).thenAnswer((_) async => testNovelInfo);

      final result = await container.read(novelInfoProvider(testNcode).future);

      expect(result, equals(testNovelInfo));
      verify(mockDatabase.getNovel(testNcode)).called(1);
      verify(mockApiService.fetchNovelInfo(testNcode)).called(1);
      verify(mockDatabase.insertNovel(any)).called(1);
      verify(mockDatabase.addToHistory(any)).called(1);
    });

    test('should add novel to history when fetched', () async {
      const testNcode = 'N1234AB';
      const testNovelInfo = NovelInfo(
        ncode: testNcode,
        title: 'テスト小説',
        writer: 'テスト作者',
        story: 'テストストーリー',
        novelType: 1,
        episodes: [],
      );

      when(mockDatabase.getNovel(testNcode)).thenAnswer((_) async => null);
      when(mockDatabase.insertNovel(any)).thenAnswer((_) async => 1);
      when(mockDatabase.addToHistory(any)).thenAnswer((_) async => 1);
      when(
        mockApiService.fetchNovelInfo(testNcode),
      ).thenAnswer((_) async => testNovelInfo);

      await container.read(novelInfoProvider(testNcode).future);

      verify(mockDatabase.addToHistory(any)).called(1);
    });

    test('should handle database errors gracefully', () async {
      const testNcode = 'N1234AB';

      when(
        mockDatabase.getNovel(testNcode),
      ).thenThrow(Exception('Database error'));
      when(
        mockApiService.fetchNovelInfo(any),
      ).thenAnswer((_) async => const NovelInfo(ncode: testNcode));
      when(
        mockDatabase.addToHistory(any),
      ).thenAnswer((_) async => 1); // Add stub for addToHistory

      await expectLater(
        container.read(novelInfoProvider(testNcode).future),
        throwsA(isA<Exception>()),
      );
    });

    test('should be auto-disposed when not in use', () {
      const testNcode = 'N1234AB';

      container
        ..read(novelInfoProvider(testNcode))
        ..dispose();

      final newContainer = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDatabase),
        ],
      );
      expect(
        () => newContainer.read(novelInfoProvider(testNcode)),
        returnsNormally,
      );
      newContainer.dispose();
    });
  });
}
