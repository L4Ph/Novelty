import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart' as db;
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/providers/connectivity_provider.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/ncode_utils.dart';
import 'package:novelty/utils/settings_provider.dart';

import '../providers/novel_info_offline_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NovelRepository fetchEpisodeList', () {
    late MockAppDatabase mockDatabase;
    late MockApiService mockApiService;
    late ProviderContainer container;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockApiService = MockApiService();
    });

    ProviderContainer createContainer({bool isOffline = false}) {
      return ProviderContainer(
        overrides: [
          db.appDatabaseProvider.overrideWithValue(mockDatabase),
          apiServiceProvider.overrideWithValue(mockApiService),
          settingsProvider.overrideWith(FakeSettings.new),
          isOfflineProvider.overrideWithValue(isOffline),
        ],
      );
    }

    tearDown(() {
      container.dispose();
    });

    const testNcode = 'N1234AB';
    final normalizedNcode = testNcode.toNormalizedNcode();
    const page = 1;

    test('should return cached episodes when offline', () async {
      container = createContainer(isOffline: true); // Offline

      when(mockDatabase.getEpisodesRange(normalizedNcode, 1, 100)).thenAnswer(
        (_) async => [
          const Episode(
            ncode: 'n1234ab',
            index: 1,
            subtitle: 'Ep 1',
            url: 'http://example.com/1/',
          ),
        ],
      );

      final repository = container.read(novelRepositoryProvider);
      final result = await repository.fetchEpisodeList(testNcode, page);

      expect(result.length, 1);
      expect(result.first.subtitle, 'Ep 1');
      verify(mockDatabase.getEpisodesRange(normalizedNcode, 1, 100)).called(1);
      verifyNever(mockApiService.fetchEpisodeList(any, any));
    });

    test('should fetch from API and save to DB when online', () async {
      container = createContainer(); // Online

      final episodes = [
        const Episode(
          ncode: 'n1234ab',
          index: 1,
          subtitle: 'Ep 1',
          url: 'http://example.com/1/',
        ),
      ];

      when(
        mockApiService.fetchEpisodeList(normalizedNcode, page),
      ).thenAnswer((_) async => episodes);

      when(mockDatabase.upsertEpisodes(any)).thenAnswer((_) async => {});

      final repository = container.read(novelRepositoryProvider);
      final result = await repository.fetchEpisodeList(testNcode, page);

      expect(result.length, 1);
      expect(result.first.subtitle, 'Ep 1');
      verify(mockApiService.fetchEpisodeList(normalizedNcode, page)).called(1);
      verify(mockDatabase.upsertEpisodes(any)).called(1);
    });

    test('should fallback to cache when online fetch fails', () async {
      container = createContainer(); // Online

      when(
        mockApiService.fetchEpisodeList(normalizedNcode, page),
      ).thenThrow(Exception('Network Error'));

      when(mockDatabase.getEpisodesRange(normalizedNcode, 1, 100)).thenAnswer(
        (_) async => [
          const Episode(
            ncode: 'n1234ab',
            index: 1,
            subtitle: 'Ep 1',
            url: 'http://example.com/1/',
          ),
        ],
      );

      final repository = container.read(novelRepositoryProvider);
      final result = await repository.fetchEpisodeList(testNcode, page);

      expect(result.length, 1);
      expect(result.first.subtitle, 'Ep 1');
      verify(mockApiService.fetchEpisodeList(normalizedNcode, page)).called(1);
      verify(mockDatabase.getEpisodesRange(normalizedNcode, 1, 100)).called(1);
    });
  });

  group('NovelRepository watchNovelInfo TTL', () {
    const testNcode = 'N1234AB';
    final normalizedNcode = testNcode.toNormalizedNcode();

    late db.AppDatabase database;
    late MockApiService mockApiService;
    late ProviderContainer container;

    setUp(() {
      database = db.AppDatabase.memory();
      mockApiService = MockApiService();
      container = ProviderContainer(
        overrides: [
          db.appDatabaseProvider.overrideWithValue(database),
          apiServiceProvider.overrideWithValue(mockApiService),
          settingsProvider.overrideWith(FakeSettings.new),
          isOfflineProvider.overrideWithValue(false),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await database.close();
    });

    Future<void> insertCachedNovel({
      required int cachedAt,
      bool isPrivate = false,
    }) async {
      await database.insertNovel(
        NovelInfo(
          ncode: normalizedNcode,
          title: 'cached title',
        ).toDbCompanion().copyWith(
          cachedAt: drift.Value(cachedAt),
          isPrivate: drift.Value(isPrivate),
        ),
      );
    }

    test('TTL以内ならAPIを呼ばずにキャッシュを返す', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertCachedNovel(
        cachedAt: now - const Duration(minutes: 30).inMilliseconds,
      );

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchNovelInfo(testNcode);

      await expectLater(
        stream,
        emits(
          predicate<NovelInfo>((info) => info.title == 'cached title'),
        ),
      );
      verifyNever(mockApiService.fetchNovelInfo(any));
    });

    test('TTL切れならAPIを取得して新しいデータを返す', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertCachedNovel(
        cachedAt: now - const Duration(hours: 2).inMilliseconds,
      );

      when(mockApiService.fetchNovelInfo(normalizedNcode)).thenAnswer(
        (_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return NovelInfo(
            ncode: normalizedNcode,
            title: 'fresh title',
          );
        },
      );

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchNovelInfo(testNcode);

      await expectLater(
        stream,
        emitsInOrder([
          predicate<NovelInfo>((info) => info.title == 'cached title'),
          predicate<NovelInfo>((info) => info.title == 'fresh title'),
        ]),
      );
      verify(mockApiService.fetchNovelInfo(normalizedNcode)).called(1);
    });

    test('API失敗時もキャッシュを維持して返す', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertCachedNovel(
        cachedAt: now - const Duration(hours: 2).inMilliseconds,
      );

      when(
        mockApiService.fetchNovelInfo(normalizedNcode),
      ).thenThrow(Exception('network error'));

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchNovelInfo(testNcode);

      await expectLater(
        stream,
        emits(
          predicate<NovelInfo>((info) => info.title == 'cached title'),
        ),
      );
      verify(mockApiService.fetchNovelInfo(normalizedNcode)).called(1);
    });

    test('非公開作品と判定されたらisPrivateフラグを立ててキャッシュを維持', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertCachedNovel(
        cachedAt: now - const Duration(hours: 2).inMilliseconds,
      );

      when(
        mockApiService.fetchNovelInfo(normalizedNcode),
      ).thenThrow(const NovelNotFoundException());

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchNovelInfo(testNcode);

      await expectLater(
        stream,
        emits(
          predicate<NovelInfo>((info) => info.title == 'cached title'),
        ),
      );

      final novel = await database.getNovel(normalizedNcode);
      expect(novel?.isPrivate, isTrue);
    });

    test('非公開フラグが立っていても復活時に解除される', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertCachedNovel(
        cachedAt: now - const Duration(hours: 2).inMilliseconds,
        isPrivate: true,
      );

      when(mockApiService.fetchNovelInfo(normalizedNcode)).thenAnswer(
        (_) async => NovelInfo(
          ncode: normalizedNcode,
          title: 'revived title',
        ),
      );

      final repository = container.read(novelRepositoryProvider);
      await repository.watchNovelInfo(testNcode).first;
      await Future<void>.delayed(Duration.zero);

      final novel = await database.getNovel(normalizedNcode);
      expect(novel?.isPrivate, isFalse);
      expect(novel?.title, 'revived title');
    });

    test('同じ小説のwatchを同時に呼んでもAPIは1回だけ', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertCachedNovel(
        cachedAt: now - const Duration(hours: 2).inMilliseconds,
      );

      when(mockApiService.fetchNovelInfo(normalizedNcode)).thenAnswer(
        (_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return NovelInfo(
            ncode: normalizedNcode,
            title: 'dedup title',
          );
        },
      );

      final repository = container.read(novelRepositoryProvider);
      final events1 = <NovelInfo>[];
      final events2 = <NovelInfo>[];
      final subscription1 = repository
          .watchNovelInfo(testNcode)
          .listen(events1.add);
      final subscription2 = repository
          .watchNovelInfo(testNcode)
          .listen(events2.add);

      await Future<void>.delayed(const Duration(milliseconds: 150));

      await subscription1.cancel();
      await subscription2.cancel();

      expect(events1, isNotEmpty);
      expect(events2, isNotEmpty);
      expect(events1.last.title, 'dedup title');
      expect(events2.last.title, 'dedup title');
      verify(mockApiService.fetchNovelInfo(normalizedNcode)).called(1);
    });
  });

  group('NovelRepository watchEpisodeList TTL', () {
    const testNcode = 'N1234AB';
    final normalizedNcode = testNcode.toNormalizedNcode();
    const page = 1;

    late db.AppDatabase database;
    late MockApiService mockApiService;
    late ProviderContainer container;

    setUp(() {
      database = db.AppDatabase.memory();
      mockApiService = MockApiService();
      container = ProviderContainer(
        overrides: [
          db.appDatabaseProvider.overrideWithValue(database),
          apiServiceProvider.overrideWithValue(mockApiService),
          settingsProvider.overrideWith(FakeSettings.new),
          isOfflineProvider.overrideWithValue(false),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await database.close();
    });

    Future<void> insertNovelAndEpisodes({
      required int fetchedAt,
    }) async {
      await database.insertNovel(
        NovelInfo(ncode: normalizedNcode, title: 'test').toDbCompanion(),
      );
      await database
          .into(database.episodeListEntries)
          .insert(
            db.EpisodeListEntriesCompanion(
              ncode: drift.Value(normalizedNcode),
              episodeId: const drift.Value(1),
              subtitle: const drift.Value('cached ep'),
              url: const drift.Value('http://example.com/1/'),
              fetchedAt: drift.Value(fetchedAt),
            ),
          );
    }

    test('TTL以内ならAPIを呼ばずにキャッシュ目次を返す', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertNovelAndEpisodes(
        fetchedAt: now - const Duration(minutes: 30).inMilliseconds,
      );

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchEpisodeList(testNcode, page);

      await expectLater(
        stream,
        emits(
          predicate<List<Episode>>(
            (list) => list.single.subtitle == 'cached ep',
          ),
        ),
      );
      verifyNever(mockApiService.fetchEpisodeList(any, any));
    });

    test('TTL切れならAPIを取得して新しい目次を返す', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertNovelAndEpisodes(
        fetchedAt: now - const Duration(hours: 2).inMilliseconds,
      );

      when(
        mockApiService.fetchEpisodeList(normalizedNcode, page),
      ).thenAnswer(
        (_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return [
            const Episode(
              ncode: 'n1234ab',
              index: 1,
              subtitle: 'fresh ep',
              url: 'http://example.com/1/',
            ),
          ];
        },
      );

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchEpisodeList(testNcode, page);

      await expectLater(
        stream,
        emitsInOrder([
          predicate<List<Episode>>(
            (list) => list.single.subtitle == 'cached ep',
          ),
          predicate<List<Episode>>(
            (list) => list.single.subtitle == 'fresh ep',
          ),
        ]),
      );
      verify(mockApiService.fetchEpisodeList(normalizedNcode, page)).called(1);
    });

    test('API失敗時もキャッシュ目次を維持して返す', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertNovelAndEpisodes(
        fetchedAt: now - const Duration(hours: 2).inMilliseconds,
      );

      when(
        mockApiService.fetchEpisodeList(normalizedNcode, page),
      ).thenThrow(Exception('network error'));

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchEpisodeList(testNcode, page);

      await expectLater(
        stream,
        emits(
          predicate<List<Episode>>(
            (list) => list.single.subtitle == 'cached ep',
          ),
        ),
      );
      verify(mockApiService.fetchEpisodeList(normalizedNcode, page)).called(1);
    });
  });
}

class FakeSettings extends Settings {
  @override
  Future<AppSettings> build() async {
    return const AppSettings(
      fontSize: 16,
      isVertical: false,
      themeMode: ThemeMode.system,
      lineHeight: 1.5,
      fontFamily: 'NotoSansJP',
      isIncognito: false,
      isPageFlip: false,
      isRubyEnabled: true,
    );
  }
}
