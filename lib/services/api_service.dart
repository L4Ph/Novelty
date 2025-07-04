import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/ranking_response.dart';

class ApiService {
  final _dio = Dio();
  final CacheManager _cacheManager = DefaultCacheManager();
  final _noveltyApiUrl = const String.fromEnvironment('NOVELTY_API_URL');

  Future<dynamic> _fetchJsonData(String url) async {
    final response = await _dio.get<dynamic>(url);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load data from $url');
    }
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
      return NovelInfo.fromJson(novelData);
    } else {
      throw Exception('Novel not found');
    }
  }

  Future<NovelInfo> fetchNovelInfo(String ncode) async {
    final info = await _fetchNovelInfoFromNarou(ncode);

    if (info.novelType == 2) {
      info.episodes = [];
      return info;
    }

    final episodes = await fetchEpisodes(ncode);
    info.episodes = episodes;
    return info;
  }

  Future<Episode> fetchEpisode(String ncode, int episode) async {
    if (_noveltyApiUrl.isEmpty) {
      throw Exception('NOVELTY_API_URL is not set');
    }
    final url = '$_noveltyApiUrl/${ncode.toLowerCase()}/$episode';
    final data = await _fetchJsonData(url) as Map<String, dynamic>;
    return Episode.fromJson(data);
  }

  Future<List<Map<String, dynamic>>> fetchEpisodes(String ncode) async {
    if (_noveltyApiUrl.isEmpty) {
      throw Exception('NOVELTY_API_URL is not set');
    }
    final url = '$_noveltyApiUrl/${ncode.toLowerCase()}';
    if (kDebugMode) {
      print(url);
    }
    final data = await _fetchJsonData(url);
    if (data is List) {
      return List<Map<String, dynamic>>.from(
        data.map((e) => e as Map<String, dynamic>),
      );
    } else if (data is Map && data.containsKey('episodes')) {
      return List<Map<String, dynamic>>.from(
        (data['episodes'] as List).map((e) => e as Map<String, dynamic>),
      );
    } else {
      throw Exception('Unexpected response format for episodes');
    }
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
    final file = await _cacheManager.getSingleFile(url);
    final bytes = await file.readAsBytes();
    if (kDebugMode) {
      print('Downloaded ${bytes.length} bytes from cache/network');
    }
    return compute(_parseJson, bytes);
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
              (item) => RankingResponse.fromJson(item as Map<String, dynamic>),
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

  Future<List<RankingResponse>> fetchRankingAndDetails(
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

    final ncodes = <String>[];
    for (final item in rankingData) {
      if (item is Map<String, dynamic>) {
        final ncode = item['ncode'] as String?;
        if (ncode != null && ncode.isNotEmpty) {
          ncodes.add(ncode);
        }
      }
    }

    if (ncodes.isEmpty) {
      if (kDebugMode) {
        print('No valid ncodes found in ranking data');
      }
      return [];
    }

    if (kDebugMode) {
      print('Found ${ncodes.length} valid ncodes');
    }

    final novelDetails = <String, dynamic>{};
    const chunkSize = 20;

    for (var i = 0; i < ncodes.length; i += chunkSize) {
      final chunk = ncodes.sublist(
        i,
        i + chunkSize > ncodes.length ? ncodes.length : i + chunkSize,
      );
      final ncodesParam = chunk.join('-');
      final detailsUrl =
          'https://api.syosetu.com/novelapi/api?out=json&of=t-n-u-w-s-bg-g-k-gf-gl-nt-e-ga-l-ti-i-ir-ibl-igl-izk-its-iti-gp-dp-wp-mp-qp-yp-f-imp-r-a-ah-sa-ka-nu-ua&ncode=$ncodesParam&gzip=5';

      try {
        final detailsData = await _fetchData(detailsUrl);
        if (detailsData.isNotEmpty &&
            (detailsData[0] as Map<String, dynamic>?)?['allcount'] != null) {
          for (final item in detailsData.sublist(1)) {
            final ncode = (item as Map<String, dynamic>)['ncode'] as String?;
            if (ncode != null) {
              novelDetails[ncode] = item;
            }
          }
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          print(
            'An error occurred while fetching novel details for ncodes: $ncodesParam. Error: $e',
          );
        }
      }
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
        if (novelDetails.containsKey(ncode)) {
          final details = Map<String, dynamic>.from(
            novelDetails[ncode] as Map<String, dynamic>,
          );
          details['rank'] = rankItem['rank'];
          details['pt'] = rankItem['pt'];
          allData.add(RankingResponse.fromJson(details));
        } else {
          allData.add(
            RankingResponse.fromJson({
              'ncode': ncode,
              'title': 'タイトル取得失敗',
              'rank': rankItem['rank'],
              'pt': rankItem['pt'],
              'novel_type': null,
              'end': null,
              'genre': null,
              'writer': null,
              'story': null,
              'userid': null,
            }),
          );
        }
      } catch (e) {
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

    final query = NovelSearchQuery()
      ..order = 'hyoka'
      ..lim = 300;

    try {
      final results = await searchNovels(query);
      if (kDebugMode) {
        print(
          'Successfully fetched all-time ranking, count: ${results.length}',
        );
      }

      // ランキング順位を追加
      for (var i = 0; i < results.length; i++) {
        // RankingResponseは不変オブジェクトなので、新しいインスタンスを作成
        final item = results[i];
        final newItem = RankingResponse(
          rank: i + 1,
          pt: item.allPoint,
          allPoint: item.allPoint,
          ncode: item.ncode,
          title: item.title,
          novelType: item.novelType,
          end: item.end,
          genre: item.genre,
          writer: item.writer,
          story: item.story,
          userId: item.userId,
          generalAllNo: item.generalAllNo,
          keyword: item.keyword,
        );
        results[i] = newItem;
      }

      return results;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Failed to fetch all-time ranking: $e');
      }
      return [];
    }
  }
}
