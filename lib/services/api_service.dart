import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/ranking_response.dart';

class ApiService {
  final Dio _dio = Dio();
  final CacheManager _cacheManager = DefaultCacheManager();
  final String _noveltyApiUrl = dotenv.env['NOVELTY_API_URL'] ?? '';

  Future<dynamic> _fetchJsonData(String url) async {
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load data from $url');
    }
  }

  Future<NovelInfo> fetchNovelInfo(String ncode) async {
    if (_noveltyApiUrl.isEmpty) {
      throw Exception('NOVELTY_API_URL is not set');
    }
    final url = '$_noveltyApiUrl/$ncode';
    final data = await _fetchJsonData(url);
    return NovelInfo.fromJson(data);
  }

  Future<Episode> fetchEpisode(String ncode, int episode) async {
    if (_noveltyApiUrl.isEmpty) {
      throw Exception('NOVELTY_API_URL is not set');
    }
    final url = '$_noveltyApiUrl/$ncode/$episode';
    final data = await _fetchJsonData(url);
    return Episode.fromJson(data);
  }

  static List<dynamic> _parseJson(List<int> bytes) {
    final decoded = utf8.decode(GZipDecoder().decodeBytes(bytes));
    return json.decode(decoded);
  }

  Future<List<dynamic>> _fetchData(String url) async {
    final file = await _cacheManager.getSingleFile(url);
    final bytes = await file.readAsBytes();
    return compute(_parseJson, bytes);
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
    if (n >= 10) return '$n';
    return '0$n';
  }

  Future<List<RankingResponse>> fetchRankingAndDetails(
      String rankingType) async {
    final date = _getFormattedDate(rankingType);
    final rankingUrl =
        'https://api.syosetu.com/rank/rankget/?rtype=$date-$rankingType&out=json&gzip=5';

    List<dynamic> rankingData;
    try {
      rankingData = await _fetchData(rankingUrl);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch ranking data: $e');
      }
      return [];
    }

    final ncodes =
        rankingData.map((item) => item['ncode'] as String).toList();
    if (ncodes.isEmpty) {
      return [];
    }

    final Map<String, dynamic> novelDetails = {};
    const chunkSize = 20;

    for (var i = 0; i < ncodes.length; i += chunkSize) {
      final chunk = ncodes.sublist(
          i, i + chunkSize > ncodes.length ? ncodes.length : i + chunkSize);
      final ncodesParam = chunk.join('-');
      final detailsUrl =
          'https://api.syosetu.com/novelapi/api?out=json&of=t-n-u-w-s-bg-g-k-gf-gl-nt-e-ga-l-ti-i-ir-ibl-igl-izk-its-iti-gp-dp-wp-mp-qp-yp-f-imp-r-a-ah-sa-ka-nu-ua&ncode=$ncodesParam&gzip=5';

      try {
        final detailsData = await _fetchData(detailsUrl);
        if (detailsData.isNotEmpty && detailsData[0]['allcount'] != null) {
          for (var item in detailsData.sublist(1)) {
            novelDetails[item['ncode']] = item;
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(
            'An error occurred while fetching novel details for ncodes: $ncodesParam. Error: $e');
        }
      }
    }

    final List<RankingResponse> allData = [];
    for (var rankItem in rankingData) {
      final ncode = rankItem['ncode'];
      if (novelDetails.containsKey(ncode)) {
        final details = novelDetails[ncode];
        details['rank'] = rankItem['rank'];
        details['pt'] = rankItem['pt'];
        allData.add(RankingResponse.fromJson(details));
      } else {
        allData.add(RankingResponse.fromJson({
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
        }));
      }
    }
    return allData;
  }
}
