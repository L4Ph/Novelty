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
  novelType: (json['novel_type'] as num?)?.toInt(),
  end: (json['end'] as num?)?.toInt(),
  generalAllNo: (json['general_all_no'] as num?)?.toInt(),
  genre: (json['genre'] as num?)?.toInt(),
  keyword: json['keyword'] as String?,
  generalFirstup: json['general_firstup'] as String?,
  generalLastup: json['general_lastup'] as String?,
  globalPoint: (json['global_point'] as num?)?.toInt(),
  dailyPoint: (json['daily_point'] as num?)?.toInt(),
  weeklyPoint: (json['weekly_point'] as num?)?.toInt(),
  monthlyPoint: (json['monthly_point'] as num?)?.toInt(),
  quarterPoint: (json['quarter_point'] as num?)?.toInt(),
  yearlyPoint: (json['yearly_point'] as num?)?.toInt(),
  favNovelCnt: (json['fav_novel_cnt'] as num?)?.toInt(),
  impressionCnt: (json['impression_cnt'] as num?)?.toInt(),
  reviewCnt: (json['review_cnt'] as num?)?.toInt(),
  allPoint: (json['all_point'] as num?)?.toInt(),
  allHyokaCnt: (json['all_hyoka_cnt'] as num?)?.toInt(),
  sasieCnt: (json['sasie_cnt'] as num?)?.toInt(),
  kaiwaritu: (json['kaiwaritu'] as num?)?.toInt(),
  novelupdatedAt: (json['novelupdated_at'] as num?)?.toInt(),
  updatedAt: (json['updated_at'] as num?)?.toInt(),
  episodes: (json['episodes'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
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
