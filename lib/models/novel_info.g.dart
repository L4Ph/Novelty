// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NovelInfo _$NovelInfoFromJson(Map<String, dynamic> json) => _NovelInfo(
  title: json['title'] as String?,
  ncode: json['ncode'] as String?,
  writer: json['writer'] as String?,
  story: json['story'] as String?,
  novelType: _toInt(json['novelType']),
  end: _toInt(json['end']),
  generalAllNo: _toInt(json['generalAllNo']),
  genre: _toInt(json['genre']),
  keyword: json['keyword'] as String?,
  generalFirstup: json['generalFirstup'] as String?,
  generalLastup: json['generalLastup'] as String?,
  globalPoint: _toInt(json['globalPoint']),
  dailyPoint: _toInt(json['dailyPoint']),
  weeklyPoint: _toInt(json['weeklyPoint']),
  monthlyPoint: _toInt(json['monthlyPoint']),
  quarterPoint: _toInt(json['quarterPoint']),
  yearlyPoint: _toInt(json['yearlyPoint']),
  favNovelCnt: _toInt(json['favNovelCnt']),
  impressionCnt: _toInt(json['impressionCnt']),
  reviewCnt: _toInt(json['reviewCnt']),
  allPoint: _toInt(json['allPoint']),
  allHyokaCnt: _toInt(json['allHyokaCnt']),
  sasieCnt: _toInt(json['sasieCnt']),
  kaiwaritu: _toInt(json['kaiwaritu']),
  novelupdatedAt: _toInt(json['novelupdated_at']),
  updatedAt: _toInt(json['updatedAt']),
  episodes: (json['episodes'] as List<dynamic>?)
      ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
      .toList(),
  isr15: _toInt(json['isr15']),
  isbl: _toInt(json['isbl']),
  isgl: _toInt(json['isgl']),
  iszankoku: _toInt(json['iszankoku']),
  istensei: _toInt(json['istensei']),
  istenni: _toInt(json['istenni']),
);

Map<String, dynamic> _$NovelInfoToJson(_NovelInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'ncode': instance.ncode,
      'writer': instance.writer,
      'story': instance.story,
      'novelType': instance.novelType,
      'end': instance.end,
      'generalAllNo': instance.generalAllNo,
      'genre': instance.genre,
      'keyword': instance.keyword,
      'generalFirstup': instance.generalFirstup,
      'generalLastup': instance.generalLastup,
      'globalPoint': instance.globalPoint,
      'dailyPoint': instance.dailyPoint,
      'weeklyPoint': instance.weeklyPoint,
      'monthlyPoint': instance.monthlyPoint,
      'quarterPoint': instance.quarterPoint,
      'yearlyPoint': instance.yearlyPoint,
      'favNovelCnt': instance.favNovelCnt,
      'impressionCnt': instance.impressionCnt,
      'reviewCnt': instance.reviewCnt,
      'allPoint': instance.allPoint,
      'allHyokaCnt': instance.allHyokaCnt,
      'sasieCnt': instance.sasieCnt,
      'kaiwaritu': instance.kaiwaritu,
      'novelupdated_at': instance.novelupdatedAt,
      'updatedAt': instance.updatedAt,
      'episodes': instance.episodes,
      'isr15': instance.isr15,
      'isbl': instance.isbl,
      'isgl': instance.isgl,
      'iszankoku': instance.iszankoku,
      'istensei': instance.istensei,
      'istenni': instance.istenni,
    };
