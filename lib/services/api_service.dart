import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:riverpod/src/providers/future_provider.dart';

final Provider<ApiService> apiServiceProvider = Provider((ref) => ApiService());

final FutureProviderFamily<List<RankingResponse>, String> rankingDataProvider =
    FutureProvider.autoDispose.family<List<RankingResponse>, String>(
  (ref, rankingType) {
    final apiService = ref.watch(apiServiceProvider);
    return apiService.fetchRanking(rankingType);
  },
);

class ApiService {
  Future<http.Response> _fetchWithCache(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
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
        update: update?.text.trim().replaceAll(RegExp(r'（.+）'), '').trim(),
        revised: revisedAttr?.replaceAll(' 改稿', '').trim(),
        index: index,
      );
    }).toList();
  }

  Future<NovelInfo> _fetchNovelInfoFromNarou(String ncode) async {
    final uri = Uri.https('api.syosetu.com', '/novelapi/api', {
      'ncode': ncode,
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
      if (kDebugMode) {
        print('Novel data from API: $novelData');
        print('Novel type: ${novelData['novel_type']}');
        print('General all no: ${novelData['general_all_no']}');
      }

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

      final ncodesParam = chunk.join('-');
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
                      url: 'https://ncode.syosetu.com/${ncode.toLowerCase()}/',
                      ncode: ncode,
                      index: 1,
                    ),
                  ],
                );
              }

              result[ncode] = novelInfo;
            }
          }
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          print('Error fetching multiple novels: $e');
        }
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

    if (kDebugMode) {
      print('Novel type after processing: ${info.novelType}');
      print('General all no: ${info.generalAllNo}');
    }

    // For short stories, add a single episode with basic info
    if (info.novelType == 2) {
      info = info.copyWith(
        episodes: [
          Episode(
            subtitle: info.title,
            url: 'https://ncode.syosetu.com/${ncode.toLowerCase()}/',
            ncode: ncode,
            index: 1,
          ),
        ],
      );
    }

    return info;
  }

  Future<List<Episode>> fetchEpisodeList(String ncode, int page) async {
    final pageUrl = page == 1
        ? 'https://ncode.syosetu.com/${ncode.toLowerCase()}/'
        : 'https://ncode.syosetu.com/${ncode.toLowerCase()}/?p=$page';

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

    if (kDebugMode) {
      print('Novel type after processing: ${info.novelType}');
      print('General all no: ${info.generalAllNo}');
    }

    // 短編小説の場合は、単一のエピソードとして扱う
    if (info.novelType == 2) {
      // 短編小説の場合は、単一のエピソードとして扱う
      info = info.copyWith(
        episodes: [
          Episode(
            subtitle: info.title,
            url: 'https://ncode.syosetu.com/${ncode.toLowerCase()}/',
            ncode: ncode,
            index: 1,
          ),
        ],
      );
      return info;
    }

    final firstPageUrl = 'https://ncode.syosetu.com/${ncode.toLowerCase()}/';
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
          'https://ncode.syosetu.com/${ncode.toLowerCase()}/?p=$currentPage';
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
    info = info.copyWith(episodes: allEpisodes);
    return info;
  }

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

    if (kDebugMode) {
      print('fetchEpisode - Novel type: ${info.novelType}');
      print('fetchEpisode - General all no: ${info.generalAllNo}');
    }

    // 短編小説の場合のみ特別処理
    final isShortStory = info.novelType == 2;

    // 短編小説の場合、episode が 1 以外は無効
    if (isShortStory && episode != 1) {
      throw Exception('短編小説にはエピソード番号 $episode は存在しません');
    }

    // 短編小説の場合は、エピソード番号を含まないURLを使用する
    final url = isShortStory
        ? 'https://ncode.syosetu.com/${ncode.toLowerCase()}/'
        : 'https://ncode.syosetu.com/${ncode.toLowerCase()}/$episode/';

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

    final body = document
        .querySelectorAll(
          '.p-novel__text:not(.p-novel__text--preface):not(.p-novel__text--afterword)',
        )
        .map((el) => el.innerHtml)
        // ignore: avoid_redundant_argument_values
        .join('');

    return Episode(
      ncode: ncode,
      index: currentEpisode,
      subtitle: episodeTitle,
      body: body,
    );
  }

  static List<dynamic> _parseJson(List<int> bytes) {
    try {
      if (kDebugMode) {
        print('Attempting to decode ${bytes.length} bytes');
      }
      final decoded = utf8.decode(const GZipDecoder().decodeBytes(bytes));
      if (kDebugMode) {
        print('Successfully decoded gzip, string length: ${decoded.length}');
        print(
          'First 200 chars: ${decoded.length > 200 ? decoded.substring(0, 200) : decoded}',
        );
      }
      final decodedJson = json.decode(decoded);
      if (kDebugMode) {
        print('Successfully parsed JSON');
      }
      if (decodedJson is List) {
        return decodedJson;
      } else {
        return [decodedJson];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in _parseJson: $e');
      }
      rethrow;
    }
  }

  Future<List<dynamic>> _fetchData(String url) async {
    if (kDebugMode) {
      print('Fetching data from URL: $url');
    }
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    if (kDebugMode) {
      print('Downloaded ${bytes.length} bytes from cache/network');
    }
    return compute(_parseJson, bytes.toList());
  }

  Future<List<RankingResponse>> searchNovels(NovelSearchQuery query) async {
    final queryParameters = query.toMap();
    final filteredQueryParameters = queryParameters
      ..removeWhere((key, value) => value == null);

    final uri = Uri.https('api.syosetu.com', '/novelapi/api', {
      ...filteredQueryParameters.map(
        (key, value) => MapEntry(key, value.toString()),
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
        return data
            .sublist(1)
            .map(
              (item) => RankingResponse.fromJson(
                _processNovelType(item as Map<String, dynamic>),
              ),
            )
            .toList();
      }
      return [];
    } on Exception catch (e) {
      if (kDebugMode) {
        print('An error occurred while searching for novels. Error: $e');
      }
      return [];
    }
  }

  String _getFormattedDate(String rtype) {
    final now = DateTime.now();
    switch (rtype) {
      case 'd':
        final yesterday = now.subtract(const Duration(days: 1));
        return '${yesterday.year}${_twoDigits(yesterday.month)}${_twoDigits(yesterday.day)}';
      case 'w':
        var date = now;
        while (date.weekday != DateTime.tuesday) {
          date = date.subtract(const Duration(days: 1));
        }
        return '${date.year}${_twoDigits(date.month)}${_twoDigits(date.day)}';
      case 'm':
        return '${now.year}${_twoDigits(now.month)}01';
      case 'q':
        final month = now.month;
        int quarterStartMonth;
        if (month >= 1 && month <= 3) {
          quarterStartMonth = 1;
        } else if (month >= 4 && month <= 6) {
          quarterStartMonth = 4;
        } else if (month >= 7 && month <= 9) {
          quarterStartMonth = 7;
        } else {
          quarterStartMonth = 10;
        }
        return '${now.year}${_twoDigits(quarterStartMonth)}01';
      case 'all':
        // 累計ランキングの場合は空文字を返す（特別な処理が必要）
        return '';
      default:
        return '';
    }
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  Future<List<RankingResponse>> fetchRanking(
    String rankingType,
  ) async {
    // 累計ランキングの場合は小説APIの検索機能を使用
    if (rankingType == 'all') {
      return _fetchAllTimeRanking();
    }

    final date = _getFormattedDate(rankingType);
    if (date.isEmpty) {
      if (kDebugMode) {
        print('Invalid ranking type: $rankingType');
      }
      return [];
    }

    final rankingUrl =
        'https://api.syosetu.com/rank/rankget/?rtype=$date-$rankingType&out=json&gzip=5';

    if (kDebugMode) {
      print('Fetching ranking data from: $rankingUrl');
      print('Ranking type: $rankingType, Date: $date');
    }

    List<dynamic> rankingData;
    try {
      rankingData = await _fetchData(rankingUrl);
      if (kDebugMode) {
        print(
          'Successfully fetched ranking data, count: ${rankingData.length}',
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Failed to fetch ranking data: $e');
        print('URL was: $rankingUrl');
      }
      return [];
    }

    // ランキングデータの検証
    if (rankingData.isEmpty) {
      if (kDebugMode) {
        print('Ranking data is empty');
      }
      return [];
    }

    final allData = <RankingResponse>[];
    for (final rankItem in rankingData) {
      if (rankItem is! Map<String, dynamic>) {
        continue;
      }

      final ncode = rankItem['ncode'] as String?;
      if (ncode == null || ncode.isEmpty) {
        continue;
      }

      try {
        allData.add(
          RankingResponse.fromJson(
            rankItem,
          ),
        );
      } on Exception catch (e) {
        if (kDebugMode) {
          print('Error processing ranking item for ncode $ncode: $e');
        }
        continue;
      }
    }
    return allData;
  }

  Future<List<RankingResponse>> _fetchAllTimeRanking() async {
    if (kDebugMode) {
      print('Fetching all-time ranking using novel search API');
    }

    const query = NovelSearchQuery(order: 'hyoka', lim: 300);

    try {
      var results = await searchNovels(query);
      if (kDebugMode) {
        print(
          'Successfully fetched all-time ranking, count: ${results.length}',
        );
      }

      // ランキング順位を追加
      results = [
        for (var i = 0; i < results.length; i++)
          results[i].copyWith(rank: i + 1, pt: results[i].allPoint),
      ];

      return results;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Failed to fetch all-time ranking: $e');
      }
      return [];
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
