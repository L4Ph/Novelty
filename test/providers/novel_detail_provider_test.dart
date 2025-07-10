import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart' hide Episode;
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/screens/novel_detail_page.dart';
import 'package:novelty/services/api_service.dart';


@GenerateMocks([AppDatabase, ApiService])
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
      final testNovelInfo = NovelInfo(
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
      final testNovelInfo = NovelInfo(
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

      expect(
        () => container.read(novelInfoProvider(testNcode).future),
        throwsA(isA<Exception>()),
      );
    });

    test('should be auto-disposed when not in use', () {
      const testNcode = 'N1234AB';

      container.read(novelInfoProvider(testNcode));

      container.dispose();

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

  group('shortStoryEpisodeProvider', () {
    late MockApiService mockApiService;
    late ProviderContainer container;

    setUp(() {
      mockApiService = MockApiService();
      container = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should be auto-disposed when not in use', () {
      const testNcode = 'N1234AB';

      final testEpisode = Episode(
        ncode: testNcode,
        index: 1,
        subtitle: 'テストエピソード',
        body: 'テスト本文',
      );

      when(
        mockApiService.fetchEpisode(testNcode, 1),
      ).thenAnswer((_) async => testEpisode);

      container
        ..read(shortStoryEpisodeProvider(testNcode))
        ..dispose();

      final newMockApiService = MockApiService();
      final newContainer = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(newMockApiService),
        ],
      );
      expect(
        () => newContainer.read(shortStoryEpisodeProvider(testNcode)),
        returnsNormally,
      );
      newContainer.dispose();
    });

    test('should handle API errors gracefully', () async {
      const testNcode = 'INVALID_NCODE';

      when(
        mockApiService.fetchEpisode(testNcode, 1),
      ).thenThrow(Exception('API error'));

      expect(
        () => container.read(shortStoryEpisodeProvider(testNcode).future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('isFavoriteProvider', () {
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

    test('should return true when novel is favorite', () async {
      const testNcode = 'N1234AB';
      when(mockDatabase.watchIsFavorite(testNcode))
          .thenAnswer((_) => Stream.value(true));

      final result = await container.read(isFavoriteProvider(testNcode).future);

      expect(result, isTrue);
      verify(mockDatabase.watchIsFavorite(testNcode)).called(1);
    });

    test('should return false when novel is not favorite', () async {
      const testNcode = 'N1234AB';

      when(mockDatabase.watchIsFavorite(testNcode))
          .thenAnswer((_) => Stream.value(false));

      final result = await container.read(isFavoriteProvider(testNcode).future);

      expect(result, isFalse);
      verify(mockDatabase.watchIsFavorite(testNcode)).called(1);
    });

    test('should handle database errors', () async {
      const testNcode = 'N1234AB';

      when(mockDatabase.watchIsFavorite(testNcode))
          .thenAnswer((_) => Stream.error(Exception('Database error')));

      expect(
        () => container.read(isFavoriteProvider(testNcode).future),
        throwsA(isA<Exception>()),
      );
    });

    test('should be auto-disposed when not in use', () {
      const testNcode = 'N1234AB';

      when(mockDatabase.watchIsFavorite(testNcode))
          .thenAnswer((_) => Stream.value(false));

      container.read(isFavoriteProvider(testNcode));

      container.dispose();

      final newContainer = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDatabase),
        ],
      );
      expect(
        () => newContainer.read(isFavoriteProvider(testNcode)),
        returnsNormally,
      );
      newContainer.dispose();
    });
  });
}
