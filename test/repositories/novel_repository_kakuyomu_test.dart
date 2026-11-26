import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakuyomu_parser/kakuyomu_parser.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/repositories/preferences_repository.dart';
import 'package:novelty/sites/kakuyomu/kakuyomu_site.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:tiny_http/tiny_http.dart';
import 'package:tiny_state/tiny_state.dart';

import '../providers/novel_info_offline_test.mocks.dart';
import '../support/test_services.dart';

/// パスごとにフィクスチャを返す偽の transport。
class _FixtureAdapter implements HttpTransport {
  _FixtureAdapter(this._fixtures);

  final Map<String, String> _fixtures;

  @override
  Future<RawHttpResponse> send(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async {
    final html = _fixtures[uri.path];
    if (html == null) {
      return RawHttpResponse(
        statusCode: 404,
        headers: const <String, List<String>>{},
        bytes: utf8.encode('not found'),
      );
    }
    return RawHttpResponse(
      statusCode: 200,
      headers: const <String, List<String>>{
        'content-type': <String>['text/html; charset=utf-8'],
      },
      bytes: utf8.encode(html),
    );
  }

  @override
  void close() {}
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
    late NovelRepository repository;
    late KakuyomuSite kakuyomuSite;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockApiService = MockApiService();
      final adapter = _FixtureAdapter(<String, String>{
        '/works/$_workId': _fixture('work_page.html'),
        '/works/$_workId/episodes/$_firstEpisodeId/episode_sidebar': _fixture(
          'toc.html',
        ),
        '/works/$_workId/episodes/$_firstEpisodeId': _fixture(
          'episode_page.html',
        ),
      });
      kakuyomuSite = KakuyomuSite(
        http: TinyHttp(transport: adapter, minInterval: Duration.zero),
      );
      repository = NovelRepository(
        apiService: mockApiService,
        settings: SettingsController(
          PreferencesRepository(),
          initialState: const AsyncData(testSettings),
        ),
        db: mockDatabase,
        sites: <NovelSource, NovelSite>{NovelSource.kakuyomu: kakuyomuSite},
      );
    });

    tearDown(() {
      repository.dispose();
    });

    test('カクヨム作品をライブラリに追加できる', () async {
      when(
        mockDatabase.isInLibrary(NovelSource.kakuyomu, _workId),
      ).thenAnswer((_) async => false);
      when(mockDatabase.insertNovel(any)).thenAnswer((_) async => 1);
      when(
        mockDatabase.addToLibrary(NovelSource.kakuyomu, _workId),
      ).thenAnswer((_) async => 1);
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
