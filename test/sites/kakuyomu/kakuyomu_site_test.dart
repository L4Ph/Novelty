import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/sites/kakuyomu/kakuyomu_site.dart';
import 'package:novelty/sites/novel_source.dart';

/// パスごとにフィクスチャを返すHTTPアダプタ。
class _FixtureAdapter implements HttpClientAdapter {
  _FixtureAdapter(this._fixtures);

  /// key: パス（例: `/works/123`）、value: HTML文字列
  final Map<String, String> _fixtures;

  final List<String> requestedPaths = <String>[];

  /// リクエストされた完全なURI（クエリ含む）の一覧。
  final List<String> requestedUris = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final uri = Uri.parse(options.path);
    requestedPaths.add(uri.path);
    requestedUris.add(options.path);
    final html = _fixtures[uri.path];
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

/// 指定URLへの初回アクセスで302を返し、リダイレクト先ではHTMLを返すアダプタ。
class _RedirectAdapter implements HttpClientAdapter {
  _RedirectAdapter({
    required this.redirectFrom,
    required this.redirectTo,
    required this.targetHtml,
  });

  final String redirectFrom;
  final String redirectTo;
  final String targetHtml;

  final List<String> requestedUris = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestedUris.add(options.path);
    if (options.path == redirectFrom) {
      return ResponseBody.fromString(
        '',
        302,
        headers: <String, List<String>>{
          'location': <String>[redirectTo],
        },
      );
    }
    return ResponseBody.fromString(
      targetHtml,
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

String _fixture(String name) =>
    File('test/fixtures/kakuyomu/$name').readAsStringSync();

KakuyomuSite _createSite(_FixtureAdapter adapter) {
  final dio = Dio()..httpClientAdapter = adapter;
  return KakuyomuSite(
    dio: dio,
    rateLimiter: KakuyomuRateLimiter(interval: Duration.zero),
  );
}

void main() {
  group('KakuyomuSite', () {
    group('fetchNovelInfo', () {
      test('作品ページの__NEXT_DATA__から作品情報をパースできる', () async {
        final adapter = _FixtureAdapter(<String, String>{
          '/works/$_workId': _fixture('work_page.html'),
        });
        final site = _createSite(adapter);

        final info = await site.fetchNovelInfo(_workId);

        expect(info.source, NovelSource.kakuyomu);
        expect(info.workId, _workId);
        expect(info.title, '【書籍化】魔術帝の参謀は二度目の破滅を打ち砕く');
        expect(info.writer, 'Sty');
        expect(info.story, startsWith('突出した才を持った六人の帝王'));
        expect(info.genreId, 'FANTASY');
        // RUNNING → 連載中
        expect(info.end, 1);
        // エピソード数123 → 連載扱い
        expect(info.novelType, 1);
        expect(info.generalAllNo, 123);
        expect(info.keyword, contains('剣と魔法'));
        expect(info.generalFirstup, '2024-01-15T12:32:34Z');
        expect(info.generalLastup, '2026-07-13T08:04:50Z');
      });

      test('__NEXT_DATA__が無い場合はFormatExceptionを投げる', () async {
        final adapter = _FixtureAdapter(<String, String>{
          '/works/$_workId': '<html><body>no next data</body></html>',
        });
        final site = _createSite(adapter);

        await expectLater(
          site.fetchNovelInfo(_workId),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('fetchToc', () {
      test('episode_sidebarの目次から全エピソードを目次順連番で返す', () async {
        final adapter = _FixtureAdapter(<String, String>{
          '/works/$_workId': _fixture('work_page.html'),
          '/works/$_workId/episodes/$_firstEpisodeId/episode_sidebar':
              _fixture('toc.html'),
        });
        final site = _createSite(adapter);

        final episodes = await site.fetchToc(_workId);

        expect(episodes, hasLength(123));
        expect(episodes.first.index, 1);
        expect(episodes.last.index, 123);

        final first = episodes.first;
        expect(first.source, NovelSource.kakuyomu);
        expect(first.subtitle, '破滅と回帰');
        expect(
          first.url,
          'https://kakuyomu.jp/works/$_workId/episodes/$_firstEpisodeId',
        );
        expect(first.update, '2024年1月15日');
      });
    });

    group('fetchEpisode', () {
      test('エピソードページから本文とタイトルをパースできる', () async {
        const episodePath =
            '/works/$_workId/episodes/$_firstEpisodeId';
        final adapter = _FixtureAdapter(<String, String>{
          episodePath: _fixture('episode_page.html'),
        });
        final site = _createSite(adapter);

        final episode = await site.fetchEpisode(
          _workId,
          1,
          url: 'https://kakuyomu.jp$episodePath',
        );

        expect(episode.source, NovelSource.kakuyomu);
        expect(episode.index, 1);
        expect(episode.subtitle, '破滅と回帰');
        expect(episode.body, contains('<p id="p1">'));
        // 目次ページへの追加リクエストが発生しないこと
        expect(adapter.requestedPaths, <String>[episodePath]);
      });

      test('url省略時は目次からURLを解決して本文を取得する', () async {
        const episodePath =
            '/works/$_workId/episodes/$_firstEpisodeId';
        final adapter = _FixtureAdapter(<String, String>{
          '/works/$_workId': _fixture('work_page.html'),
          '/works/$_workId/episodes/$_firstEpisodeId/episode_sidebar':
              _fixture('toc.html'),
          episodePath: _fixture('episode_page.html'),
        });
        final site = _createSite(adapter);

        final episode = await site.fetchEpisode(_workId, 1);

        expect(episode.subtitle, '破滅と回帰');
        expect(episode.body, isNotNull);
      });
    });

    group('アクセス方針', () {
      test('robots.txtで禁止された/readページは取得しない', () async {
        final adapter = _FixtureAdapter(<String, String>{});
        final site = _createSite(adapter);

        await expectLater(
          site.fetchEpisode(
            _workId,
            1,
            url: 'https://kakuyomu.jp/works/$_workId/episodes/1/read',
          ),
          throwsStateError,
        );
        // リクエストが一切発行されないこと
        expect(adapter.requestedPaths, isEmpty);
      });

      test('レートリミッターがリクエスト間隔を保証する', () async {
        // タイマー解像度の影響を考慮し、間隔300msに対して250ms以上を検証する
        final limiter = KakuyomuRateLimiter(
          interval: const Duration(milliseconds: 300),
        );
        final stopwatch = Stopwatch()..start();

        await limiter.wait();
        await limiter.wait();

        stopwatch.stop();
        expect(
          stopwatch.elapsed,
          greaterThanOrEqualTo(const Duration(milliseconds: 250)),
        );
      });
    });

    group('searchNovels', () {
      test('検索結果ページのsearchWorksから作品一覧と総件数をパースできる', () async {
        final adapter = _FixtureAdapter(<String, String>{
          '/search': _fixture('search_page.html'),
        });
        final site = _createSite(adapter);

        final result = await site.searchNovels(
          const NovelSearchQuery(word: 'test'),
        );

        expect(result.allCount, 83);
        expect(result.novels, hasLength(5));
        final first = result.novels.first;
        expect(first.source, NovelSource.kakuyomu);
        expect(first.workId, isNotNull);
        expect(first.title, isNotEmpty);
        expect(first.writer, isNotEmpty);
        expect(first.genreId, isNotNull);
      });

      test('ページング（offset）をURLクエリに反映する', () async {
        final adapter = _FixtureAdapter(<String, String>{
          '/search': _fixture('search_page.html'),
        });
        final site = _createSite(adapter);

        // 3ページ目（st=41, limはデフォルト20）
        await site.searchNovels(
          const NovelSearchQuery(word: 'test', st: 41),
        );

        final requested = adapter.requestedPaths.first;
        expect(requested, '/search');
        // offset=40 が付与されている（クエリはpathに含まれないため別途確認）
        expect(
          adapter.requestedUris,
          anyElement(contains('offset=40')),
        );
      });
    });

    group('fetchRanking', () {
      test('302リダイレクトをフォローしてランキングを取得できる', () async {
        final redirectAdapter = _RedirectAdapter(
          redirectFrom: 'https://kakuyomu.jp/rankings/all/daily',
          redirectTo:
              'https://kakuyomu.jp/rankings/all/daily?work_variation=long',
          targetHtml: _fixture('ranking_page.html'),
        );
        final dio = Dio()..httpClientAdapter = redirectAdapter;
        final site = KakuyomuSite(
          dio: dio,
          rateLimiter: KakuyomuRateLimiter(interval: Duration.zero),
        );

        final novels = await site.fetchRanking('daily');

        expect(novels, isNotEmpty);
        // リダイレクト先が1回リクエストされている
        expect(
          redirectAdapter.requestedUris,
          anyElement(contains('work_variation=long')),
        );
      });

      test('ランキングページのHTMLから作品一覧をパースできる', () async {
        final adapter = _FixtureAdapter(<String, String>{
          '/rankings/all/daily': _fixture('ranking_page.html'),
        });
        final site = _createSite(adapter);

        final novels = await site.fetchRanking('daily');

        expect(novels, isNotEmpty);
        expect(novels, hasLength(10));
        final first = novels.first;
        expect(first.source, NovelSource.kakuyomu);
        expect(first.workId, '2912051603474311296');
        expect(first.title, '宮廷魔導師選抜試験を記念受験した田舎者');
        expect(first.writer, '古野ジョン');
        expect(first.genreId, 'FANTASY');
        expect(first.generalAllNo, 23);
        expect(first.end, 1); // 連載中
        // ★12,218 → 12218（レビューポイント）
        expect(first.allPoint, 12218);
      });

      test('ページング（page）をURLクエリに反映する', () async {
        final adapter = _FixtureAdapter(<String, String>{
          '/rankings/all/daily': _fixture('ranking_page.html'),
        });
        final site = _createSite(adapter);

        await site.fetchRanking('daily', page: 2);

        expect(adapter.requestedUris, anyElement(contains('page=2')));
        expect(
          adapter.requestedUris,
          anyElement(contains('work_variation=long')),
        );
      });
    });

    group('マスタデータ', () {
      test('カクヨムのジャンル・ランキング種別を定義している', () {
        final site = _createSite(_FixtureAdapter(<String, String>{}));

        expect(site.genres, hasLength(10));
        expect(site.genres.first.id, 'LOVE_STORY');
        expect(site.genres.first.name, '恋愛');
        expect(site.genres.map((g) => g.id), contains('FANTASY'));

        expect(site.rankingTypes, hasLength(5));
        expect(site.rankingTypes.first.id, 'daily');
        expect(site.rankingTypes.last.id, 'entire');
      });
    });
  });
}
