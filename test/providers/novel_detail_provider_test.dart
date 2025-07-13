import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart' hide Episode;
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/screens/novel_detail_page.dart';
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

  group('shortStoryContentProvider', () {
    late MockApiService mockApiService;
    late MockNovelRepository mockNovelRepository;
    late ProviderContainer container;

    setUp(() {
      mockApiService = MockApiService();
      mockNovelRepository = MockNovelRepository();
      container = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
          novelRepositoryProvider.overrideWithValue(mockNovelRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should be auto-disposed when not in use', () {
      const testNcode = 'N1234AB';

      when(
        mockNovelRepository.getEpisode(testNcode, 1),
      ).thenAnswer((_) async => []);

      container
        ..read(shortStoryContentProvider(testNcode))
        ..dispose();

      final newMockNovelRepository = MockNovelRepository();
      final newContainer = ProviderContainer(
        overrides: [
          novelRepositoryProvider.overrideWithValue(newMockNovelRepository),
        ],
      );
      expect(
        () => newContainer.read(shortStoryContentProvider(testNcode)),
        returnsNormally,
      );
      newContainer.dispose();
    });

    test('should handle API errors gracefully', () async {
      const testNcode = 'INVALID_NCODE';

      when(
        mockNovelRepository.getEpisode(testNcode, 1),
      ).thenThrow(Exception('API error'));

      expect(
        () => container.read(shortStoryContentProvider(testNcode).future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('FavoriteStatus', () {
    late MockAppDatabase mockDatabase;
    late ProviderContainer container;
    const ncode = 'N1234AB';
    const novelInfo = NovelInfo(ncode: ncode, title: 'Test Novel');

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

    test('initial state is false when novel does not exist', () async {
      when(mockDatabase.getNovel(ncode)).thenAnswer((_) async => null);
      await expectLater(
        container.read(favoriteStatusProvider(ncode).future),
        completion(isFalse),
      );
    });

    test('initial state is true when novel is favorite', () async {
      when(mockDatabase.getNovel(ncode)).thenAnswer(
        (_) async => const Novel(ncode: ncode, fav: 1),
      );
      await expectLater(
        container.read(favoriteStatusProvider(ncode).future),
        completion(isTrue),
      );
    });

    test('toggle adds to favorites and returns true', () async {
      // Arrange
      when(mockDatabase.getNovel(ncode)).thenAnswer((_) async => null);
      when(mockDatabase.insertNovel(any)).thenAnswer((_) async => 1);
      final notifier = container.read(favoriteStatusProvider(ncode).notifier);

      // Act
      final result = await notifier.toggle(novelInfo);

      // Assert
      expect(result, isTrue);
      final captured = verify(mockDatabase.insertNovel(captureAny)).captured;
      expect(captured.single.fav.value, 1);
      await expectLater(
        container.read(favoriteStatusProvider(ncode).future),
        completion(isTrue),
      );
    });

    test('toggle removes from favorites and returns true', () async {
      // Arrange
      when(
        mockDatabase.getNovel(ncode),
      ).thenAnswer((_) async => const Novel(ncode: ncode, fav: 1));
      when(mockDatabase.insertNovel(any)).thenAnswer((_) async => 1);
      final notifier = container.read(favoriteStatusProvider(ncode).notifier);
      await container.read(
        favoriteStatusProvider(ncode).future,
      ); // Ensure initial state

      // Act
      final result = await notifier.toggle(novelInfo);

      // Assert
      expect(result, isTrue);
      final captured = verify(mockDatabase.insertNovel(captureAny)).captured;
      expect(captured.single.fav.value, 0);
      await expectLater(
        container.read(favoriteStatusProvider(ncode).future),
        completion(isFalse),
      );
    });

    test('toggle returns false and state is error when db fails', () async {
      // Arrange
      final exception = Exception('Database failed');
      when(mockDatabase.getNovel(ncode)).thenAnswer((_) async => null);
      when(mockDatabase.insertNovel(any)).thenThrow(exception);
      final notifier = container.read(favoriteStatusProvider(ncode).notifier);

      final states = <AsyncValue<bool>>[];
      container.listen<AsyncValue<bool>>(
        favoriteStatusProvider(ncode),
        (previous, next) {
          states.add(next);
        },
      );

      // Act
      final result = await notifier.toggle(novelInfo);

      // Assert
      expect(result, isFalse);
      expect(
        states,
        contains(isA<AsyncError<bool>>()),
      );
    });
  });
}
