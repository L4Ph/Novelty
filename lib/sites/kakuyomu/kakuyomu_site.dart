import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_source.dart';

/// カクヨムへのリクエスト間隔を制御するレートリミッター。
///
/// サーバー負荷軽減のため、連続リクエスト間に最低限の間隔を設ける。
/// 壁時計（DateTime）ではなくモノトニッククロック（Stopwatch）を
/// 使用することで、システム時刻の変更の影響を受けない。
class KakuyomuRateLimiter {
  /// コンストラクタ。
  KakuyomuRateLimiter({
    this.interval = const Duration(seconds: 1),
  });

  /// リクエスト間隔。
  final Duration interval;

  final Stopwatch _stopwatch = Stopwatch();

  /// 直前のリクエストから [interval] 以上経過するまで待機する。
  Future<void> wait() async {
    if (_stopwatch.isRunning) {
      final elapsed = _stopwatch.elapsed;
      if (elapsed < interval) {
        await Future<void>.delayed(interval - elapsed);
      }
      _stopwatch
        ..reset()
        ..start();
    } else {
      _stopwatch.start();
    }
  }
}

/// カクヨムからのHTTP取得に失敗した場合の例外。
class KakuyomuHttpException implements Exception {
  /// コンストラクタ。
  const KakuyomuHttpException(this.statusCode, this.url);

  /// HTTPステータスコード。
  final int statusCode;

  /// リクエストURL。
  final String url;

  @override
  String toString() => 'KakuyomuHttpException($statusCode): $url';
}

/// カクヨムのサイト定義。
///
/// 公式APIが存在しないため、公開HTMLの取得・解析のみで
/// 作品情報・目次・本文を提供する。
///
/// アクセス方針:
/// - robots.txt で取得禁止のパス（`/read` ページ等）は取得しない
/// - レートリミッターによりリクエスト間隔を制御する
/// - 本文キャッシュはレポジトリ層（DB）でキャッシュファースト運用する
class KakuyomuSite implements NovelSite {
  /// コンストラクタ。
  ///
  /// [dio] と [rateLimiter] はテスト時に注入できる。
  KakuyomuSite({Dio? dio, KakuyomuRateLimiter? rateLimiter})
    : _dio = dio ?? Dio(),
      _rateLimiter = rateLimiter ?? KakuyomuRateLimiter();

  final Dio _dio;
  final KakuyomuRateLimiter _rateLimiter;

  /// カクヨムのUser-Agent。
  static const String _userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36';

  /// robots.txt（2026-08-02 確認）に基づく取得禁止パスのパターン。
  static final List<RegExp> _disallowedPathPatterns = <RegExp>[
    RegExp('^/shared_drafts/'),
    RegExp(r'^/works/[^/]+/episodes/[^/]+/read$'),
    RegExp('^/login'),
    RegExp('^/auth/login'),
    RegExp('^/violation_report'),
    RegExp('^/site_feedback'),
  ];

  @override
  NovelSource get source => NovelSource.kakuyomu;

  /// カクヨムのジャンルマスタ。
  ///
  /// ジャンルIDは作品ページの `Work.genre` に含まれるキー
  /// （`LOVE_STORY` / `FANTASY` 等）と一致させる。
  @override
  List<GenreMaster> get genres => const <GenreMaster>[
    GenreMaster(id: 'LOVE_STORY', name: '恋愛'),
    GenreMaster(id: 'ROMANCE', name: 'ラブコメ'),
    GenreMaster(id: 'FANTASY', name: 'ファンタジー'),
    GenreMaster(id: 'ACTION', name: 'アクション'),
    GenreMaster(id: 'SF', name: 'SF'),
    GenreMaster(id: 'HISTORY', name: '歴史'),
    GenreMaster(id: 'MYSTERY', name: 'ミステリー'),
    GenreMaster(id: 'HORROR', name: 'ホラー'),
    GenreMaster(id: 'DRAMA', name: 'ドラマ'),
    GenreMaster(id: 'OTHER', name: 'その他'),
  ];

  /// カクヨムのランキング種別マスタ。
  ///
  /// 期間パスは `/rankings/all/<period>` に対応する。
  @override
  List<RankingTypeMaster> get rankingTypes => const <RankingTypeMaster>[
    RankingTypeMaster(id: 'daily', label: '日間', urlPath: 'daily'),
    RankingTypeMaster(id: 'weekly', label: '週間', urlPath: 'weekly'),
    RankingTypeMaster(id: 'monthly', label: '月間', urlPath: 'monthly'),
    RankingTypeMaster(id: 'yearly', label: '年間', urlPath: 'yearly'),
    RankingTypeMaster(id: 'entire', label: '累計', urlPath: 'entire'),
  ];

  /// 作品情報を取得する。
  ///
  /// 作品ページ（Next.js）の `__NEXT_DATA__` JSONからパースする。
  @override
  Future<NovelInfo> fetchNovelInfo(String workId) async {
    final html = await _fetch('/works/$workId');
    return _parseNovelInfo(html, workId);
  }

  /// 目次（エピソード一覧）を取得する。
  ///
  /// 作品ページから初回エピソードIDを取得し、
  /// `episode_sidebar`（目次HTML）をパースする。
  /// 返却される [Episode.index] は目次順の連番（1始まり）。
  @override
  Future<List<Episode>> fetchToc(String workId) async {
    final workHtml = await _fetch('/works/$workId');
    final firstEpisodeId = _parseFirstEpisodeId(workHtml, workId);
    final tocHtml = await _fetch(
      '/works/$workId/episodes/$firstEpisodeId/episode_sidebar',
    );
    return _parseToc(tocHtml, workId);
  }

  /// エピソード本文を取得する。
  ///
  /// [index] は目次順の連番。 [url] が省略された場合は
  /// 目次を取得して対応するエピソードURLを解決する。
  @override
  Future<Episode> fetchEpisode(
    String workId,
    int index, {
    String? url,
  }) async {
    final episodeUrl = url ?? await _resolveEpisodeUrl(workId, index);
    final html = await _fetch(episodeUrl);
    return _parseEpisode(html, workId, index, episodeUrl);
  }

  /// 目次の [index] 番目のエピソードURLを解決する。
  Future<String> _resolveEpisodeUrl(String workId, int index) async {
    final episodes = await fetchToc(workId);
    final episode = episodes.where((e) => e.index == index).firstOrNull;
    if (episode?.url == null) {
      throw StateError('エピソード $index が見つかりません: $workId');
    }
    return episode!.url!;
  }

  /// パスがrobots.txtで取得禁止でないことを検証する。
  void _assertAllowed(String path) {
    for (final pattern in _disallowedPathPatterns) {
      if (pattern.hasMatch(path)) {
        throw StateError('robots.txtにより取得が禁止されています: $path');
      }
    }
  }

  /// HTTP GET を実行し、HTML文字列を返す。
  Future<String> _fetch(String pathOrUrl) async {
    final uri = Uri.parse(pathOrUrl);
    // 相対パスはカクヨムのベースURLに解決する
    final url = uri.hasScheme ? pathOrUrl : '${source.baseUrl}$pathOrUrl';
    _assertAllowed(Uri.parse(url).path);

    await _rateLimiter.wait();
    final response = await _dio.get<String>(
      url,
      options: Options(
        headers: <String, String>{'User-Agent': _userAgent},
        responseType: ResponseType.plain,
        followRedirects: true,
      ),
    );
    if (response.statusCode != 200) {
      throw KakuyomuHttpException(response.statusCode ?? -1, url);
    }
    return response.data ?? '';
  }

  /// 作品ページの `__NEXT_DATA__` から [NovelInfo] を組み立てる。
  NovelInfo _parseNovelInfo(String html, String workId) {
    final apollo = _parseApolloState(html);
    final work = apollo['Work:$workId'] as Map<String, dynamic>?;
    if (work == null) {
      throw const FormatException('Work データが見つかりません');
    }

    final authorRef = (work['author'] as Map<String, dynamic>?)?['__ref']
        as String?;
    final author = authorRef == null
        ? null
        : apollo[authorRef] as Map<String, dynamic>?;
    final writerName = author?['activityName'] ?? author?['name'];

    final publicEpisodeCount = work['publicEpisodeCount'] as int?;

    return NovelInfo(
      source: NovelSource.kakuyomu,
      workId: workId,
      title: work['title'] as String?,
      writer: writerName as String?,
      story: work['introduction'] as String?,
      genreId: work['genre'] as String?,
      // なろうのendと同義: 1=連載中, 0=完結
      end: switch (work['serialStatus'] as String?) {
        'RUNNING' => 1,
        'COMPLETED' => 0,
        _ => null,
      },
      // エピソード数1件は短編扱い（なろうのnovelTypeと同義）
      novelType: switch (publicEpisodeCount) {
        null => null,
        1 => 2,
        _ => 1,
      },
      generalAllNo: publicEpisodeCount,
      keyword:
          (work['tagLabels'] as List<dynamic>?)?.cast<String>().join(' '),
      generalFirstup: work['publishedAt'] as String?,
      generalLastup: work['lastEpisodePublishedAt'] as String?,
    );
  }

  /// 作品ページの `__NEXT_DATA__` から初回エピソードIDを取得する。
  String _parseFirstEpisodeId(String html, String workId) {
    final apollo = _parseApolloState(html);
    final work = apollo['Work:$workId'] as Map<String, dynamic>?;
    final firstEpisode =
        work?['firstPublicEpisodeUnion'] as Map<String, dynamic>?;
    final ref = firstEpisode?['__ref'] as String?;
    if (ref == null || !ref.startsWith('Episode:')) {
      throw const FormatException('初回エピソードが見つかりません');
    }
    return ref.split(':').last;
  }

  /// `__NEXT_DATA__` スクリプトから Apollo ステートを取得する。
  Map<String, dynamic> _parseApolloState(String html) {
    final document = html_parser.parse(html);
    final script = document.querySelector('script#__NEXT_DATA__');
    if (script == null) {
      throw const FormatException('__NEXT_DATA__ が見つかりません');
    }
    final data = json.decode(script.text) as Map<String, dynamic>;
    final pageProps =
        (data['props'] as Map<String, dynamic>?)?['pageProps']
            as Map<String, dynamic>?;
    final apollo =
        pageProps?['__APOLLO_STATE__'] as Map<String, dynamic>?;
    if (apollo == null) {
      throw const FormatException('__APOLLO_STATE__ が見つかりません');
    }
    return apollo;
  }

  /// 目次HTML（`episode_sidebar`）から [Episode] のリストを組み立てる。
  List<Episode> _parseToc(String html, String workId) {
    final document = html_parser.parse(html);
    final items = document.querySelectorAll('li.widget-toc-episode');
    final episodes = <Episode>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final link = item.querySelector('a.widget-toc-episode-episodeTitle');
      final title = item
          .querySelector('.widget-toc-episode-titleLabel')
          ?.text
          .trim();
      final time = item.querySelector('time.widget-toc-episode-datePublished');
      episodes.add(
        Episode(
          source: NovelSource.kakuyomu,
          // 目次順の連番（アプリ内でのエピソード番号）
          index: i + 1,
          subtitle: title,
          url: _toAbsoluteUrl(link?.attributes['href']),
          update: time?.text.trim(),
        ),
      );
    }
    return episodes;
  }

  /// エピソードページから [Episode] を組み立てる。
  Episode _parseEpisode(
    String html,
    String workId,
    int index,
    String episodeUrl,
  ) {
    final document = html_parser.parse(html);
    final title = document.querySelector('.widget-episodeTitle')?.text.trim();
    final body = document.querySelector('.widget-episodeBody')?.innerHtml;
    return Episode(
      source: NovelSource.kakuyomu,
      index: index,
      subtitle: title,
      body: body,
      url: episodeUrl,
    );
  }

  /// 相対URLを絶対URLに変換する。絶対URLの場合はそのまま返す。
  String? _toAbsoluteUrl(String? href) {
    if (href == null) {
      return null;
    }
    final uri = Uri.parse(href);
    if (uri.hasScheme) {
      return href;
    }
    return '${source.baseUrl}$href';
  }
}
