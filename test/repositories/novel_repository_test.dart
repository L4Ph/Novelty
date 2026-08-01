import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/database/database.dart' as db;
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/providers/network_fallback_event_provider.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/font_family.dart';
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
          isOfflineModeProvider.overrideWithValue(isOffline),
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

  group('NovelRepository watchNovelInfo', () {
    const testNcode = 'N1234AB';
    final normalizedNcode = testNcode.toNormalizedNcode();

    late db.AppDatabase database;
    late MockApiService mockApiService;
    late ProviderContainer container;
    NetworkFallbackEventData? fallbackEvent;

    setUp(() {
      database = db.AppDatabase.memory();
      mockApiService = MockApiService();
      container =
          ProviderContainer(
            overrides: [
              db.appDatabaseProvider.overrideWithValue(database),
              apiServiceProvider.overrideWithValue(mockApiService),
              settingsProvider.overrideWith(FakeSettings.new),
              isOfflineModeProvider.overrideWithValue(false),
            ],
          )..listen(
            networkFallbackEventProvider,
            (_, next) => fallbackEvent = next,
            fireImmediately: true,
          );
      fallbackEvent = null;
    });

    tearDown(() async {
      container.dispose();
      await database.close();
    });

    Future<void> insertCachedNovel({
      required String title,
      bool isPrivate = false,
    }) async {
      await database.insertNovel(
        NovelInfo(
          ncode: normalizedNcode,
          title: title,
        ).toDbCompanion().copyWith(
          cachedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
          isPrivate: drift.Value(isPrivate),
        ),
      );
    }

    test('キャッシュがあれば即座に発行し、裏で最新を取得して更新する', () async {
      await insertCachedNovel(title: 'cached title');

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

    test('API失敗時はキャッシュを維持し、フォールバックイベントを発行する', () async {
      await insertCachedNovel(title: 'cached title');

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
      expect(
        fallbackEvent?.message,
        '最新の作品情報を取得できませんでした。キャッシュを表示しています。',
      );
    });

    test('非公開作品と判定されたらisPrivateフラグを立ててキャッシュを維持', () async {
      await insertCachedNovel(title: 'cached title');

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

    test('キャッシュが無い状態で取得成功ならデータを返す', () async {
      when(mockApiService.fetchNovelInfo(normalizedNcode)).thenAnswer(
        (_) async => NovelInfo(
          ncode: normalizedNcode,
          title: 'fresh title',
        ),
      );

      final repository = container.read(novelRepositoryProvider);
      final stream = repository.watchNovelInfo(testNcode);

      await expectLater(
        stream,
        emits(
          predicate<NovelInfo>((info) => info.title == 'fresh title'),
        ),
      );
      verify(mockApiService.fetchNovelInfo(normalizedNcode)).called(1);
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

    test('オフラインかつキャッシュが無い場合はOfflineExceptionを投げる', () async {
      container.dispose();
      container =
          ProviderContainer(
            overrides: [
              db.appDatabaseProvider.overrideWithValue(database),
              apiServiceProvider.overrideWithValue(mockApiService),
              settingsProvider.overrideWith(FakeSettings.new),
              isOfflineModeProvider.overrideWithValue(true),
            ],
          )..listen(
            networkFallbackEventProvider,
            (_, _) {},
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
          isOfflineModeProvider.overrideWithValue(false),
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

  group('NovelRepository watchEpisodeList', () {
    const testNcode = 'N1234AB';
    final normalizedNcode = testNcode.toNormalizedNcode();
    const page = 1;

    late db.AppDatabase database;
    late MockApiService mockApiService;
    late ProviderContainer container;
    NetworkFallbackEventData? fallbackEvent;

    setUp(() {
      database = db.AppDatabase.memory();
      mockApiService = MockApiService();
      container =
          ProviderContainer(
            overrides: [
              db.appDatabaseProvider.overrideWithValue(database),
              apiServiceProvider.overrideWithValue(mockApiService),
              settingsProvider.overrideWith(FakeSettings.new),
              isOfflineModeProvider.overrideWithValue(false),
            ],
          )..listen(
            networkFallbackEventProvider,
            (_, next) => fallbackEvent = next,
            fireImmediately: true,
          );
      fallbackEvent = null;
    });

    tearDown(() async {
      container.dispose();
      await database.close();
    });

    Future<void> insertNovelAndEpisodes() async {
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
              fetchedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
            ),
          );
    }

    test('キャッシュがあれば即座に発行し、裏で最新を取得して更新する', () async {
      await insertNovelAndEpisodes();

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

    test('API失敗時はキャッシュ目次を維持し、フォールバックイベントを発行する', () async {
      await insertNovelAndEpisodes();

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
      expect(
        fallbackEvent?.message,
        '最新の目次を取得できませんでした。キャッシュを表示しています。',
      );
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

    test('オフラインかつキャッシュが無い場合はOfflineExceptionを投げる', () async {
      container.dispose();
      container =
          ProviderContainer(
            overrides: [
              db.appDatabaseProvider.overrideWithValue(database),
              apiServiceProvider.overrideWithValue(mockApiService),
              settingsProvider.overrideWith(FakeSettings.new),
              isOfflineModeProvider.overrideWithValue(true),
            ],
          )..listen(
            networkFallbackEventProvider,
            (_, _) {},
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

  group('NovelRepository getEpisode', () {
    const testNcode = 'N1234AB';
    final normalizedNcode = testNcode.toNormalizedNcode();
    const episodeId = 1;

    late db.AppDatabase database;
    late MockApiService mockApiService;
    late ProviderContainer container;
    NetworkFallbackEventData? fallbackEvent;

    setUp(() {
      database = db.AppDatabase.memory();
      mockApiService = MockApiService();
      container =
          ProviderContainer(
            overrides: [
              db.appDatabaseProvider.overrideWithValue(database),
              apiServiceProvider.overrideWithValue(mockApiService),
              settingsProvider.overrideWith(FakeSettings.new),
              isOfflineModeProvider.overrideWithValue(false),
            ],
          )..listen(
            networkFallbackEventProvider,
            (_, next) => fallbackEvent = next,
            fireImmediately: true,
          );
      fallbackEvent = null;
    });

    tearDown(() async {
      container.dispose();
      await database.close();
    });

    Future<void> insertEpisodeContent() async {
      await database.insertNovel(
        NovelInfo(ncode: normalizedNcode, title: 'test').toDbCompanion(),
      );
      await database.updateEpisodeContent(
        ncode: normalizedNcode,
        episodeId: episodeId,
        content: [NovelContentElement.plainText('cached body')],
        fetchedAt: DateTime.now().millisecondsSinceEpoch,
        revisedAt: '2024-01-01',
      );
    }

    test('改稿がなければキャッシュを返し通信しない', () async {
      await insertEpisodeContent();

      final repository = container.read(novelRepositoryProvider);
      final content = await repository.getEpisode(
        normalizedNcode,
        episodeId,
        revised: '2024-01-01',
      );

      expect(content.first, isA<PlainText>());
      expect((content.first as PlainText).text, 'cached body');
      verifyNever(mockApiService.fetchEpisode(any, any));
    });

    test('改稿ありで取得失敗時はキャッシュを返しフォールバックイベントを発行する', () async {
      await insertEpisodeContent();

      when(
        mockApiService.fetchEpisode(normalizedNcode, episodeId),
      ).thenThrow(Exception('network error'));

      final repository = container.read(novelRepositoryProvider);
      final content = await repository.getEpisode(
        normalizedNcode,
        episodeId,
        revised: '2024-02-01',
      );

      expect(content.first, isA<PlainText>());
      expect((content.first as PlainText).text, 'cached body');
      verify(mockApiService.fetchEpisode(normalizedNcode, episodeId)).called(1);
      expect(
        fallbackEvent?.message,
        '最新のエピソードを取得できませんでした。キャッシュを表示しています。',
      );
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
      fontFamily: FontFamilySetting.sans,
      isIncognito: false,
      isPageFlip: false,
      isRubyEnabled: true,
    );
  }
}
