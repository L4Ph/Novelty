import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/novel_search_result.dart';
import 'package:novelty/utils/ncode_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

/// 累計ランキングの表示上限数
/// なろう小説APIの制限値（最大500件）を最大限活用
const int allTimeRankingLimit = 500;

/// User-Agent 基本的には最新になるようにする
const String userAgent =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36';

@Riverpod(keepAlive: true, dependencies: [])
/// APIサービスのプロバイダー
ApiService apiService(ApiServiceRef ref) => ApiService();

/// APIサービスクラス。
class ApiService {
  Future<http.Response> _fetchWithCache(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent': userAgent,
      },
    );
    return response;
  }

  List<Episode> _parseEpisodes(dom.Document document) {
    final elements = document.querySelectorAll('.p-eplist__sublist');
    return elements.map((el) {
      final subtitle = el.querySelector('.p-eplist__subtitle');
      final update = el.querySelector('.p-eplist__update');
      final revisedAttr = update?.querySelector('span')?.attributes['title'];
      final url = subtitle?.attributes['href'];
      int? index;
      if (url != null) {
        final match = RegExp(r'/(\d+)/').firstMatch(url);
        if (match != null) {
          index = int.tryParse(match.group(1)!);
        }
      }
      return Episode(
        subtitle: subtitle?.text.trim(),
        url: url,
        // ignore: unnecessary_raw_strings 明示的に入れる
        update: update?.text.trim().replaceAll(RegExp(r'（.+）'), '').trim(),
        revised: revisedAttr?.replaceAll(' 改稿', '').trim(),
        index: index,
      );
    }).toList();
  }

  Future<NovelInfo> _fetchNovelInfoFromNarou(String ncode) async {
    final uri = Uri.https('api.syosetu.com', '/novelapi/api', {
      'ncode': ncode.toNormalizedNcode(),
      'out': 'json',
      'gzip': '5',
      'of':
          't-n-u-w-s-bg-g-k-gf-gl-nt-e-ga-l-ti-i-ir-ibl-igl-izk-its-iti-gp-dp-wp-mp-qp-yp-f-imp-r-a-ah-sa-ka-nu-ua',
    });

    final data = await _fetchData(uri.toString());
    if (data.isNotEmpty &&
        (data[0] as Map<String, dynamic>?)?['allcount'] != null &&
        ((data[0] as Map<String, dynamic>?)?['allcount'] as int? ?? 0) > 0 &&
        data.length > 1) {
      final novelData = data[1] as Map<String, dynamic>;

      // デバッグ: APIレスポンスを確認

      final processedData = _processNovelType(novelData);
      return NovelInfo.fromJson(processedData);
    } else {
      throw Exception('Novel not found');
    }
  }

  /// Fetches multiple novels' basic information in a single API request
  /// This is more efficient than making individual requests for each novel
  Future<Map<String, NovelInfo>> fetchMultipleNovelsInfo(
    List<String> ncodes,
  ) async {
    if (ncodes.isEmpty) {
      return {};
    }

    // API allows fetching up to 20 novels at once, so we'll chunk the requests
    const chunkSize = 20;
    final result = <String, NovelInfo>{};

    for (var i = 0; i < ncodes.length; i += chunkSize) {
      final chunk = ncodes.sublist(
        i,
        i + chunkSize > ncodes.length ? ncodes.length : i + chunkSize,
      );

      final ncodesParam = chunk
          .map((ncode) => ncode.toNormalizedNcode())
          .join('-');
      final uri = Uri.https('api.syosetu.com', '/novelapi/api', {
        'ncode': ncodesParam,
        'out': 'json',
        'gzip': '5',
        'of':
            't-n-u-w-s-bg-g-k-gf-gl-nt-e-ga-l-ti-i-ir-ibl-igl-izk-its-iti-gp-dp-wp-mp-qp-yp-f-imp-r-a-ah-sa-ka-nu-ua',
      });

      try {
        final data = await _fetchData(uri.toString());
        if (data.isNotEmpty &&
            (data[0] as Map<String, dynamic>?)?['allcount'] != null &&
            ((data[0] as Map<String, dynamic>?)?['allcount'] as int? ?? 0) >
                0) {
          // Skip the first item which contains metadata
          for (final item in data.sublist(1)) {
            final novelData = item as Map<String, dynamic>;
            final ncode = novelData['ncode'] as String?;

            if (ncode != null) {
              final processedData = _processNovelType(novelData);
              var novelInfo = NovelInfo.fromJson(processedData);

              // For short stories, add a single episode with basic info
              if (novelInfo.novelType == 2) {
                novelInfo = novelInfo.copyWith(
                  episodes: [
                    Episode(
                      subtitle: novelInfo.title,
                      url:
                          'https://ncode.syosetu.com/${ncode.toNormalizedNcode()}/',
                      ncode: ncode.toNormalizedNcode(),
                      index: 1,
                    ),
                  ],
                );
              }

              result[ncode.toNormalizedNcode()] = novelInfo;
            }
          }
        }
      } on Exception {
        // Continue with the next chunk even if this one fails
      }
    }

    return result;
  }

  /// Fetches basic novel information without episodes
  /// This is a lightweight version of fetchNovelInfo that doesn't fetch episodes
  /// Suitable for list views like history where full episode data isn't needed
  Future<NovelInfo> fetchBasicNovelInfo(String ncode) async {
    var info = await _fetchNovelInfoFromNarou(ncode);

    // novelTypeがnullの場合、general_all_noを使って判断
    if (info.novelType == null) {
      if (info.generalAllNo != null && info.generalAllNo! <= 1) {
        info = info.copyWith(novelType: 2); // 短編小説
      } else {
        info = info.copyWith(novelType: 1); // 連載小説
      }
    }

    // For short stories, add a single episode with basic info
    if (info.novelType == 2) {
      info = info.copyWith(
        episodes: [
          Episode(
            subtitle: info.title,
            url: 'https://ncode.syosetu.com/${ncode.toNormalizedNcode()}/',
            ncode: ncode.toNormalizedNcode(),
            index: 1,
          ),
        ],
      );
    }

    return info;
  }

  /// 小説のエピソードを取得するメソッド。
  Future<List<Episode>> fetchEpisodeList(String ncode, int page) async {
    final pageUrl = page == 1
        ? 'https://ncode.syosetu.com/${ncode.toNormalizedNcode()}/'
        : 'https://ncode.syosetu.com/${ncode.toNormalizedNcode()}/?p=$page';

    final response = await _fetchWithCache(pageUrl);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch episodes page $page: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    final html = response.body;
    final document = parser.parse(html);
    return _parseEpisodes(document);
  }

  /// 小説のランキングを取得するメソッド。
  Future<NovelInfo> fetchNovelInfo(String ncode) async {
    var info = await _fetchNovelInfoFromNarou(ncode);

    // novelTypeがnullの場合、general_all_noを使って判断
    if (info.novelType == null) {
      if (info.generalAllNo != null && info.generalAllNo! <= 1) {
        info = info.copyWith(novelType: 2); // 短編小説
      } else {
        info = info.copyWith(novelType: 1); // 連載小説
      }
    }

    // 短編小説の場合は、単一のエピソードとして扱う
    if (info.novelType == 2) {
      // 短編小説の場合は、単一のエピソードとして扱う
      return info.copyWith(
        episodes: [
          Episode(
            subtitle: info.title,
            url: 'https://ncode.syosetu.com/${ncode.toNormalizedNcode()}/',
            ncode: ncode.toNormalizedNcode(),
            index: 1,
          ),
        ],
      );
    }

    final firstPageUrl =
        'https://ncode.syosetu.com/${ncode.toNormalizedNcode()}/';
    final firstPageResponse = await _fetchWithCache(firstPageUrl);

    if (firstPageResponse.statusCode != 200) {
      throw Exception(
        'Failed to fetch URL: ${firstPageResponse.statusCode} ${firstPageResponse.reasonPhrase}',
      );
    }

    final firstPageHtml = firstPageResponse.body;
    var document = parser.parse(firstPageHtml);

    final allEpisodes = _parseEpisodes(document);
    final episodeUrls = allEpisodes.map((e) => e.url).toSet();

    var currentPage = 2;
    while (true) {
      final pageUrl =
          'https://ncode.syosetu.com/${ncode.toNormalizedNcode()}/?p=$currentPage';
      final response = await _fetchWithCache(pageUrl);

      if (response.statusCode != 200) {
        break;
      }

      final html = response.body;
      document = parser.parse(html);
      final episodesOnPage = _parseEpisodes(document);

      if (episodesOnPage.isEmpty) {
        break;
      }

      final newEpisodes = episodesOnPage
          .where((e) => !episodeUrls.contains(e.url))
          .toList();
      if (newEpisodes.isEmpty) {
        break;
      }

      for (final e in newEpisodes) {
        allEpisodes.add(e);
        episodeUrls.add(e.url);
      }

      currentPage++;
    }
    return info.copyWith(episodes: allEpisodes);
  }

  /// 小説のエピソードを取得するメソッド。
  Future<Episode> fetchEpisode(String ncode, int episode) async {
    var info = await _fetchNovelInfoFromNarou(ncode);

    // novelTypeがnullの場合、general_all_noを使って判断
    if (info.novelType == null) {
      if (info.generalAllNo != null && info.generalAllNo! <= 1) {
        info = info.copyWith(novelType: 2); // 短編小説
      } else {
        info = info.copyWith(novelType: 1); // 連載小説
      }
    }

    // 短編小説の場合のみ特別処理
    final isShortStory = info.novelType == 2;

    // 短編小説の場合、episode が 1 以外は無効
    if (isShortStory && episode != 1) {
      throw Exception('短編小説にはエピソード番号 $episode は存在しません');
    }

    // 短編小説の場合は、エピソード番号を含まないURLを使用する
    final url = isShortStory
        ? 'https://ncode.syosetu.com/${ncode.toNormalizedNcode()}/'
        : 'https://ncode.syosetu.com/${ncode.toNormalizedNcode()}/$episode/';

    final response = await _fetchWithCache(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch URL: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    final html = response.body;
    final document = parser.parse(html);

    final episodeTitle = isShortStory
        ? document.querySelector('h1.p-novel__title')?.text
        : document.querySelector('h1.p-novel__title--rensai')?.text;
    final episodeNumberRaw = isShortStory
        ? '1/1'
        : document.querySelector('.p-novel__number')?.text;
    final episodeNumberParts = episodeNumberRaw
        ?.split('/')
        .map((s) => int.tryParse(s.trim()));
    final currentEpisode = episodeNumberParts?.elementAt(0);

    return Episode(
      ncode: ncode.toNormalizedNcode(),
      index: currentEpisode,
      subtitle: episodeTitle,
      body: document
          .querySelectorAll(
            '.p-novel__text:not(.p-novel__text--preface):not(.p-novel__text--afterword)',
          )
          .map((el) => el.innerHtml)
          // ignore: avoid_redundant_argument_values　明示的に空文字をjoin
          .join(),
    );
  }

  static List<dynamic> _parseJson(List<int> bytes) {
    try {
      final decoded = utf8.decode(const GZipDecoder().decodeBytes(bytes));
      final decodedJson = json.decode(decoded);
      if (decodedJson is List) {
        return decodedJson;
      } else {
        return [decodedJson];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> _fetchData(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent': userAgent,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch data: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    final bytes = response.bodyBytes;
    return compute(_parseJson, bytes.toList());
  }

  /// 小説を検索するメソッド。
  ///
  /// 検索結果と全件数を含む[NovelSearchResult]を返す。
  Future<NovelSearchResult> searchNovels(NovelSearchQuery query) async {
    final queryParameters = query.toMap();
    final filteredQueryParameters = queryParameters
      ..removeWhere((key, value) => value == null);

    final uri = Uri.https('api.syosetu.com', '/novelapi/api', {
      ...filteredQueryParameters.map(
        (key, value) {
          if (value is List) {
            return MapEntry(key, value.join('-'));
          }
          return MapEntry(key, value.toString());
        },
      ),
      'out': 'json',
      'gzip': '5',
      'of':
          't-n-u-w-s-bg-g-k-gf-gl-nt-e-ga-l-ti-i-ir-ibl-igl-izk-its-iti-gp-dp-wp-mp-qp-yp-f-imp-r-a-ah-sa-ka-nu-ua',
    });

    try {
      final data = await _fetchData(uri.toString());
      if (data.isNotEmpty &&
          (data[0] as Map<String, dynamic>?)?['allcount'] != null) {
        final allCount =
            (data[0] as Map<String, dynamic>)['allcount'] as int? ?? 0;
        final novels = data
            .sublist(1)
            .map(
              (item) => NovelInfo.fromJson(
                _processNovelType(item as Map<String, dynamic>),
              ),
            )
            .toList();
        return NovelSearchResult(novels: novels, allCount: allCount);
      }
      return const NovelSearchResult(novels: [], allCount: 0);
    } on Object {
      // 全てのエラーをキャッチして空の結果として返す
      // これにより、UI側で無限ロードやクラッシュが発生するのを防ぐ
      return const NovelSearchResult(novels: [], allCount: 0);
    }
  }

  Map<String, dynamic> _processNovelType(Map<String, dynamic> novelData) {
    // novelTypeが文字列の場合、整数に変換
    if (novelData['novel_type'] is String) {
      final novelTypeStr = novelData['novel_type'] as String;
      novelData['novel_type'] = int.tryParse(novelTypeStr) ?? 1; // デフォルトは連載(1)
    } else if (novelData['novel_type'] == null) {
      // novelTypeがnullの場合、general_all_noを使って判断
      // general_all_noが1または0の場合は短編小説、それ以外は連載小説
      final generalAllNo = novelData['general_all_no'];
      var allNo = 0;

      if (generalAllNo is String) {
        allNo = int.tryParse(generalAllNo) ?? 0;
      } else if (generalAllNo is int) {
        allNo = generalAllNo;
      }

      if (allNo <= 1) {
        novelData['novel_type'] = 2; // 短編小説
      } else {
        novelData['novel_type'] = 1; // 連載小説
      }
    }

    return novelData;
  }
}

// ==================== Providers ====================

// ==================== Providers ====================

/// 小説の情報を取得するプロバイダー（シンプル版）。
@Riverpod(dependencies: [apiService, appDatabase])
Future<NovelInfo> novelInfo(NovelInfoRef ref, String ncode) async {
  final normalizedNcode = ncode.toNormalizedNcode();
  final apiService = ref.read(apiServiceProvider);

  try {
    return await apiService.fetchNovelInfo(normalizedNcode);
  } catch (e) {
    // API取得失敗時はDBから取得を試みる
    final db = ref.read(appDatabaseProvider);
    final cachedNovel = await db.getNovel(normalizedNcode);
    if (cachedNovel != null) {
      // Episodesテーブルからも目次を取得
      final episodes = await db.getEpisodes(normalizedNcode);
      return cachedNovel.toModel(episodes: episodes);
    }
    rethrow;
  }
}

/// 小説の情報を取得し、DBにキャッシュするプロバイダー。
///
/// APIから小説情報を取得し、DBに保存する。
@Riverpod(dependencies: [apiService, appDatabase])
Future<NovelInfo> novelInfoWithCache(
  NovelInfoWithCacheRef ref,
  String ncode,
) async {
  final normalizedNcode = ncode.toNormalizedNcode();
  final apiService = ref.read(apiServiceProvider);
  final db = ref.watch(appDatabaseProvider);

  try {
    final novelInfo = await apiService.fetchNovelInfo(normalizedNcode);

    // Save Novel data
    await db.insertNovel(novelInfo.toDbCompanion());

    // Save Episodes metadata (TOC)
    if (novelInfo.episodes != null) {
      final episodesCompanions = novelInfo.episodes!.map((e) {
        return EpisodeEntitiesCompanion(
          ncode: drift.Value(normalizedNcode),
          episodeId: drift.Value(e.index ?? 0),
          subtitle: drift.Value(e.subtitle),
          url: drift.Value(e.url),
          publishedAt: drift.Value(e.update),
          revisedAt: drift.Value(e.revised),
          // content is not updated here
        );
      }).toList();
      await db.upsertEpisodes(episodesCompanions);
    }

    return novelInfo;
  } catch (e) {
    // API取得失敗時はDBから取得を試みる
    final cachedNovel = await db.getNovel(normalizedNcode);
    if (cachedNovel != null) {
      // Episodesテーブルからも目次を取得
      final episodes = await db.getEpisodes(normalizedNcode);
      return cachedNovel.toModel(episodes: episodes);
    }
    rethrow;
  }
}

/// 小説のエピソードを取得するプロバイダー。
@Riverpod(dependencies: [apiService, appDatabase])
Future<Episode> episode(EpisodeRef ref, EpisodeParam param) async {
  final normalizedNcode = param.ncode.toNormalizedNcode();
  final apiService = ref.read(apiServiceProvider);
  final db = ref.read(appDatabaseProvider);

  try {
    // 1. Try fetching from API
    final ep = await apiService.fetchEpisode(
      normalizedNcode,
      param.episode,
    );

    // 2. Save content to DB
    if (ep.body != null) {
      await db.updateEpisodeContent(
        EpisodeEntitiesCompanion(
          ncode: drift.Value(normalizedNcode),
          episodeId: drift.Value(param.episode),
          content: drift.Value(
            parseNovelContent(ep.body!),
          ),
          fetchedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
          subtitle: drift.Value(ep.subtitle),
          url: drift.Value(ep.url),
        ),
      );
    }

    return ep;
  } catch (e) {
    // 3. Fallback to DB
    final cachedEp = await db.getEpisodeData(
      normalizedNcode,
      param.episode,
    );
    if (cachedEp != null && cachedEp.content != null) {
      // Reconstruct HTML from content elements
      final elements = cachedEp.content;
      final htmlBuffer = StringBuffer();

      for (final element in elements) {
        element.when(
          plainText: (text) => htmlBuffer.write('<p>$text</p>'),
          rubyText: (base, ruby) =>
              htmlBuffer.write('<p><ruby>$base<rt>$ruby</rt></ruby></p>'),
          newLine: () => htmlBuffer.write('<br>'),
        );
      }

      return Episode(
        ncode: cachedEp.ncode,
        index: cachedEp.episodeId,
        subtitle: cachedEp.subtitle,
        url: cachedEp.url,
        update: cachedEp.publishedAt,
        revised: cachedEp.revisedAt,
        body: htmlBuffer.toString(),
      );
    }
    rethrow;
  }
}

@immutable
/// エピソード取得のためのパラメータ
class EpisodeParam {
  /// コンストラクタ
  const EpisodeParam({required this.ncode, required this.episode});

  /// 小説のNコード
  final String ncode;

  /// エピソード番号
  final int episode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EpisodeParam &&
        other.ncode == ncode &&
        other.episode == episode;
  }

  @override
  int get hashCode => ncode.hashCode ^ episode.hashCode;
}
