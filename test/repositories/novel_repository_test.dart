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

    test('キャッシュが無い状態で非公開作品と判定された場合、プレースホルダーが挿入される', () async {
      when(
        mockApiService.fetchNovelInfo(normalizedNcode),
      ).thenThrow(const NovelNotFoundException());

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchNovelInfo(testNcode);

      await expectLater(
        stream,
        emits(
          predicate<NovelInfo>(
            (info) =>
                info.ncode == normalizedNcode &&
                info.title == null &&
                info.isPrivate,
          ),
        ),
      );

      final novel = await database.getNovel(normalizedNcode);
      expect(novel, isNotNull);
      expect(novel!.isPrivate, isTrue);
      expect(novel.cachedAt, isNotNull);
    });

    test('キャッシュが無い状態でネットワークエラー時はストリームエラーとして伝播する', () async {
      when(
        mockApiService.fetchNovelInfo(normalizedNcode),
      ).thenThrow(Exception('network error'));

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchNovelInfo(testNcode);

      await expectLater(
        stream,
        emitsError(
          predicate<Exception>((e) => e.toString().contains('network error')),
        ),
      );

      final novel = await database.getNovel(normalizedNcode);
      expect(novel, isNull);
    });

    test('エラー時にcachedAtが更新され、TTL内は再取得しない', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertCachedNovel(
        cachedAt: now - const Duration(hours: 2).inMilliseconds,
      );
      when(
        mockApiService.fetchNovelInfo(normalizedNcode),
      ).thenThrow(Exception('network error'));

      final repository = container.read(novelRepositoryProvider);
      await repository.watchNovelInfo(testNcode).first;

      // キャッシュのcachedAtが更新されていること
      final novelAfterFirst = await database.getNovel(normalizedNcode);
      expect(novelAfterFirst?.cachedAt, isNotNull);
      expect(novelAfterFirst!.cachedAt! >= now - 1000, isTrue);

      // TTL内に再度watchしてもAPIは呼ばれないこと
      clearInteractions(mockApiService);
      await repository.watchNovelInfo(testNcode).first;
      verifyNever(mockApiService.fetchNovelInfo(any));
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

      await expectLater(
        repository.watchNovelInfo(testNcode),
        emitsInOrder([
          predicate<NovelInfo>((info) => info.title == 'cached title'),
          predicate<NovelInfo>((info) => info.title == 'dedup title'),
        ]),
      );

      await subscription1.cancel();
      await subscription2.cancel();

      expect(events1, isNotEmpty);
      expect(events2, isNotEmpty);
      expect(events1.last.title, 'dedup title');
      expect(events2.last.title, 'dedup title');
      verify(mockApiService.fetchNovelInfo(normalizedNcode)).called(1);
    });
    test('force指定でTTL内でもAPIを再取得する', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertCachedNovel(
        cachedAt: now - const Duration(minutes: 30).inMilliseconds,
      );

      when(mockApiService.fetchNovelInfo(normalizedNcode)).thenAnswer(
        (_) async => NovelInfo(
          ncode: normalizedNcode,
          title: 'force refreshed title',
        ),
      );

      final repository = container.read(novelRepositoryProvider);
      await repository.refreshNovelInfo(testNcode);

      verify(mockApiService.fetchNovelInfo(normalizedNcode)).called(1);
      final novel = await database.getNovel(normalizedNcode);
      expect(novel?.title, 'force refreshed title');
    });

    test('オフラインかつキャッシュが無い場合はOfflineExceptionを投げる', () async {
      container.dispose();
      container = ProviderContainer(
        overrides: [
          db.appDatabaseProvider.overrideWithValue(database),
          apiServiceProvider.overrideWithValue(mockApiService),
          settingsProvider.overrideWith(FakeSettings.new),
          isOfflineProvider.overrideWithValue(true),
        ],
      );

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchNovelInfo(testNcode);

      await expectLater(
        stream,
        emitsError(isA<OfflineException>()),
      );
      verifyNever(mockApiService.fetchNovelInfo(any));
    });
  });

  group('NovelRepository downloadSingleEpisode', () {
    const testNcode = 'N1234AB';
    final normalizedNcode = testNcode.toNormalizedNcode();
    const episodeId = 1;

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

    test('フェッチ失敗時に既存の目次サブタイトルが上書きされない', () async {
      await database.insertNovel(
        NovelInfo(ncode: normalizedNcode, title: 'test').toDbCompanion(),
      );
      await database.upsertEpisodes([
        db.EpisodeListEntriesCompanion(
          ncode: drift.Value(normalizedNcode),
          episodeId: const drift.Value(episodeId),
          subtitle: const drift.Value('元のサブタイトル'),
          url: const drift.Value('https://example.com/1/'),
        ),
      ]);

      when(
        mockApiService.fetchEpisode(normalizedNcode, episodeId),
      ).thenThrow(Exception('network error'));

      final repository = container.read(novelRepositoryProvider);
      final result = await repository.downloadSingleEpisode(
        testNcode,
        episodeId,
      );

      expect(result, isFalse);

      final data = await database.getEpisodeData(normalizedNcode, episodeId);
      expect(data?.subtitle, '元のサブタイトル');
      expect(data?.content, isEmpty);
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

    test('キャッシュが無い状態で取得成功なら目次を返す', () async {
      await database.insertNovel(
        NovelInfo(ncode: normalizedNcode, title: 'test').toDbCompanion(),
      );

      when(
        mockApiService.fetchEpisodeList(normalizedNcode, page),
      ).thenAnswer(
        (_) async => [
          const Episode(
            ncode: 'n1234ab',
            index: 1,
            subtitle: 'fresh ep',
            url: 'http://example.com/1/',
          ),
        ],
      );

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchEpisodeList(testNcode, page);

      await expectLater(
        stream,
        emits(
          predicate<List<Episode>>(
            (list) => list.single.subtitle == 'fresh ep',
          ),
        ),
      );
    });

    test('キャッシュが無い状態でAPI失敗時はストリームエラーとして伝播する', () async {
      await database.insertNovel(
        NovelInfo(ncode: normalizedNcode, title: 'test').toDbCompanion(),
      );

      when(
        mockApiService.fetchEpisodeList(normalizedNcode, page),
      ).thenThrow(Exception('network error'));

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchEpisodeList(testNcode, page);

      await expectLater(
        stream,
        emitsError(
          predicate<Exception>((e) => e.toString().contains('network error')),
        ),
      );
    });

    test('force指定でTTL内でもAPIを再取得する', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await insertNovelAndEpisodes(
        fetchedAt: now - const Duration(minutes: 30).inMilliseconds,
      );

      when(
        mockApiService.fetchEpisodeList(normalizedNcode, page),
      ).thenAnswer(
        (_) async => [
          const Episode(
            ncode: 'n1234ab',
            index: 1,
            subtitle: 'force refreshed ep',
            url: 'http://example.com/1/',
          ),
        ],
      );

      final repository = container.read(novelRepositoryProvider);
      await repository.refreshEpisodeList(testNcode, page);

      verify(mockApiService.fetchEpisodeList(normalizedNcode, page)).called(1);
      final list = await database.getEpisodesRange(normalizedNcode, 1, 100);
      expect(list.single.subtitle, 'force refreshed ep');
    });

    test('オフラインかつキャッシュが無い場合はOfflineExceptionを投げる', () async {
      container.dispose();
      container = ProviderContainer(
        overrides: [
          db.appDatabaseProvider.overrideWithValue(database),
          apiServiceProvider.overrideWithValue(mockApiService),
          settingsProvider.overrideWith(FakeSettings.new),
          isOfflineProvider.overrideWithValue(true),
        ],
      );
      await database.insertNovel(
        NovelInfo(ncode: normalizedNcode, title: 'test').toDbCompanion(),
      );

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchEpisodeList(testNcode, page);

      await expectLater(
        stream,
        emitsError(isA<OfflineException>()),
      );
      verifyNever(mockApiService.fetchEpisodeList(any, any));
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
