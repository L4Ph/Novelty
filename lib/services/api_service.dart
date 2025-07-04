import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/ranking_response.dart';

class ApiService {
  final _dio = Dio();
  final CacheManager _cacheManager = DefaultCacheManager();
  final String _noveltyApiUrl = dotenv.env['NOVELTY_API_URL'] ?? '';

  Future<dynamic> _fetchJsonData(String url) async {
    final response = await _dio.get<dynamic>(url);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load data from $url');
    }
  }

  Future<NovelInfo> fetchNovelInfoByNcode(String ncode) async {
    final uri = Uri.https('api.syosetu.com', '/novelapi/api', {
      'ncode': ncode,
      'out': 'json',
      'gzip': '5',
      'of':
          't-n-u-w-s-bg-g-k-gf-gl-nt-e-ga-l-ti-i-ir-ibl-igl-izk-its-iti-gp-dp-wp-mp-qp-yp-f-imp-r-a-ah-sa-ka-nu-ua-ga-k',
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
    final decoded = utf8.decode(const GZipDecoder().decodeBytes(bytes));
    final decodedJson = json.decode(decoded);
    if (decodedJson is List) {
      return decodedJson;
    } else {
      return [decodedJson];
    }
  }

  Future<List<dynamic>> _fetchData(String url) async {
    final file = await _cacheManager.getSingleFile(url);
    final bytes = await file.readAsBytes();
    return compute(_parseJson, bytes);
  }

  Future<List<RankingResponse>> searchNovels(NovelSearchQuery query) async {
    final queryParameters = query.toMap();
    final filteredQueryParameters = queryParameters..removeWhere((key, value) => value == null);

    final uri = Uri.https('api.syosetu.com', '/novelapi/api', {
      ...filteredQueryParameters.map((key, value) => MapEntry(key, value.toString())),
      'out': 'json',
      'gzip': '5',
      'of':
          't-n-u-w-s-bg-g-k-gf-gl-nt-e-ga-l-ti-i-ir-ibl-igl-izk-its-iti-gp-dp-wp-mp-qp-yp-f-imp-r-a-ah-sa-ka-nu-ua-ga-k',
    });

    try {
      final data = await _fetchData(uri.toString());
      if (data.isNotEmpty && (data[0] as Map<String, dynamic>?)?['allcount'] != null) {
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
        return '${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}';
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
    final date = _getFormattedDate(rankingType);
    final rankingUrl =
        'https://api.syosetu.com/rank/rankget/?rtype=$date-$rankingType&out=json&gzip=5';

    List<dynamic> rankingData;
    try {
      rankingData = await _fetchData(rankingUrl);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Failed to fetch ranking data: $e');
      }
      return [];
    }

    final ncodes = rankingData
        .map((item) => (item as Map<String, dynamic>)['ncode'] as String?)
        .where((ncode) => ncode != null)
        .cast<String>()
        .toList();
    if (ncodes.isEmpty) {
      return [];
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
        if (detailsData.isNotEmpty && (detailsData[0] as Map<String, dynamic>?)?['allcount'] != null) {
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
      final ncode = (rankItem as Map<String, dynamic>)['ncode'] as String?;
      if (ncode != null && novelDetails.containsKey(ncode)) {
        final details = novelDetails[ncode] as Map<String, dynamic>;
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
    }
    return allData;
  }
}
