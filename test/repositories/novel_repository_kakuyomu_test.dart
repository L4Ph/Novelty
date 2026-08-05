import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakuyomu_parser/kakuyomu_parser.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart' as db;
import 'package:novelty/models/episode.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/kakuyomu/kakuyomu_site.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';

import '../providers/novel_info_offline_test.mocks.dart';

/// パスごとにフィクスチャを返すHTTPアダプタ。
class _FixtureAdapter implements HttpClientAdapter {
  _FixtureAdapter(this._fixtures);

  final Map<String, String> _fixtures;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = Uri.parse(options.path).path;
    final html = _fixtures[path];
    if (html == null) {
      return ResponseBody.fromString('not found', 404);
    }
    return ResponseBody.fromString(
      html,
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>['text/html; charset=utf-8'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const String _workId = '16818023211929539879';
const String _firstEpisodeId = '16818023211929635009';
const String _episodeUrl =
    'https://kakuyomu.jp/works/$_workId/episodes/$_firstEpisodeId';

String _fixture(String name) =>
    File('test/fixtures/kakuyomu/$name').readAsStringSync();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NovelRepository（カクヨム）', () {
    late MockAppDatabase mockDatabase;
    late MockApiService mockApiService;
    late ProviderContainer container;
    late KakuyomuSite kakuyomuSite;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockApiService = MockApiService();
      final adapter = _FixtureAdapter(<String, String>{
        '/works/$_workId': _fixture('work_page.html'),
        '/works/$_workId/episodes/$_firstEpisodeId/episode_sidebar':
            _fixture('toc.html'),
        '/works/$_workId/episodes/$_firstEpisodeId':
            _fixture('episode_page.html'),
      });
      kakuyomuSite = KakuyomuSite(
        dio: Dio()..httpClientAdapter = adapter,
        rateLimiter: KakuyomuRateLimiter(interval: Duration.zero),
      );
      container = ProviderContainer(
        overrides: [
          db.appDatabaseProvider.overrideWithValue(mockDatabase),
          apiServiceProvider.overrideWithValue(mockApiService),
          settingsProvider.overrideWith(FakeSettings.new),
          isOfflineModeProvider.overrideWithValue(false),
          novelRepositoryProvider.overrideWith(
            (ref) => NovelRepository(
              ref: ref,
              apiService: mockApiService,
              settings: ref.watch(settingsProvider),
              db: mockDatabase,
              sites: <NovelSource, NovelSite>{
                NovelSource.kakuyomu: kakuyomuSite,
              },
            ),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('カクヨム作品をライブラリに追加できる', () async {
      when(
        mockDatabase.isInLibrary(NovelSource.kakuyomu, _workId),
      ).thenAnswer((_) async => false);
      when(mockDatabase.insertNovel(any)).thenAnswer((_) async => 1);
      when(
        mockDatabase.addToLibrary(NovelSource.kakuyomu, _workId),
      ).thenAnswer((_) async => 1);

      final repository = container.read(novelRepositoryProvider);
      final added = await repository.addNovelToLibrary(
        NovelSource.kakuyomu,
        _workId,
      );

      expect(added, true);
      verify(mockDatabase.insertNovel(any)).called(1);
      verify(
        mockDatabase.addToLibrary(NovelSource.kakuyomu, _workId),
      ).called(1);
      // なろうAPI（ApiService）は呼ばれないこと
      verifyNever(mockApiService.fetchNovelInfo(any));
    });

    test('目次を取得してページ単位で返す（100件スライス）', () async {
      when(
        mockDatabase.getEpisodesRange(NovelSource.kakuyomu, _workId, 1, 100),
      ).thenAnswer((_) async => <Episode>[]);

      final repository = container.read(novelRepositoryProvider);
      final episodes = await repository.fetchEpisodeList(
        NovelSource.kakuyomu,
        _workId,
        1,
      );

      expect(episodes, hasLength(100));
      expect(episodes.first.index, 1);
      expect(episodes.first.subtitle, '破滅と回帰');
      expect(episodes.first.url, _episodeUrl);
      verify(mockDatabase.upsertEpisodes(any)).called(1);
    });

    test('エピソード本文をカクヨムパーサーでパースして返す', () async {
      when(
        mockDatabase.getEpisodeData(NovelSource.kakuyomu, _workId, 1),
      ).thenAnswer((_) async => null);
      when(
        mockDatabase.getEpisodeUrl(NovelSource.kakuyomu, _workId, 1),
      ).thenAnswer((_) async => _episodeUrl);

      final repository = container.read(novelRepositoryProvider);
      final content = await repository.getEpisode(
        NovelSource.kakuyomu,
        _workId,
        1,
      );

      expect(content, isNotEmpty);
      expect(content.first, isA<PlainText>());
      expect(
        (content.first as PlainText).text,
        '炎の海と土の津波が眼前を覆っていた。',
      );
      verify(
        mockDatabase.updateEpisodeContent(
          source: anyNamed('source'),
          workId: anyNamed('workId'),
          episodeId: anyNamed('episodeId'),
          content: anyNamed('content'),
          fetchedAt: anyNamed('fetchedAt'),
          subtitle: anyNamed('subtitle'),
          url: anyNamed('url'),
          publishedAt: anyNamed('publishedAt'),
        ),
      ).called(1);
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
      isIncognito: false,
      isPageFlip: false,
      isRubyEnabled: true,
    );
  }
}
