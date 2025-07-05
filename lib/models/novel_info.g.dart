// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelInfo _$NovelInfoFromJson(Map<String, dynamic> json) => NovelInfo(
  title: json['title'] as String?,
  ncode: json['ncode'] as String?,
  writer: json['writer'] as String?,
  story: json['story'] as String?,
  novelType: _toInt(json['novel_type']),
  end: _toInt(json['end']),
  generalAllNo: _toInt(json['general_all_no']),
  genre: _toInt(json['genre']),
  keyword: json['keyword'] as String?,
  generalFirstup: json['general_firstup'] as String?,
  generalLastup: json['general_lastup'] as String?,
  globalPoint: _toInt(json['global_point']),
  dailyPoint: _toInt(json['daily_point']),
  weeklyPoint: _toInt(json['weekly_point']),
  monthlyPoint: _toInt(json['monthly_point']),
  quarterPoint: _toInt(json['quarter_point']),
  yearlyPoint: _toInt(json['yearly_point']),
  favNovelCnt: _toInt(json['fav_novel_cnt']),
  impressionCnt: _toInt(json['impression_cnt']),
  reviewCnt: _toInt(json['review_cnt']),
  allPoint: _toInt(json['all_point']),
  allHyokaCnt: _toInt(json['all_hyoka_cnt']),
  sasieCnt: _toInt(json['sasie_cnt']),
  kaiwaritu: _toInt(json['kaiwaritu']),
  novelupdatedAt: _toInt(json['novelupdated_at']),
  updatedAt: _toInt(json['updated_at']),
  episodes: (json['episodes'] as List<dynamic>?)
      ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NovelInfoToJson(NovelInfo instance) => <String, dynamic>{
  'title': instance.title,
  'ncode': instance.ncode,
  'writer': instance.writer,
  'story': instance.story,
  'novel_type': instance.novelType,
  'end': instance.end,
  'general_all_no': instance.generalAllNo,
  'genre': instance.genre,
  'keyword': instance.keyword,
  'general_firstup': instance.generalFirstup,
  'general_lastup': instance.generalLastup,
  'global_point': instance.globalPoint,
  'daily_point': instance.dailyPoint,
  'weekly_point': instance.weeklyPoint,
  'monthly_point': instance.monthlyPoint,
  'quarter_point': instance.quarterPoint,
  'yearly_point': instance.yearlyPoint,
  'fav_novel_cnt': instance.favNovelCnt,
  'impression_cnt': instance.impressionCnt,
  'review_cnt': instance.reviewCnt,
  'all_point': instance.allPoint,
  'all_hyoka_cnt': instance.allHyokaCnt,
  'sasie_cnt': instance.sasieCnt,
  'kaiwaritu': instance.kaiwaritu,
  'novelupdated_at': instance.novelupdatedAt,
  'updated_at': instance.updatedAt,
  'episodes': instance.episodes,
};
