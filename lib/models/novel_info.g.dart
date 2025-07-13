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
  novelType: const StringToIntConverter().fromJson(json['novel_type']),
  end: const StringToIntConverter().fromJson(json['end']),
  generalAllNo: const StringToIntConverter().fromJson(json['general_all_no']),
  genre: const StringToIntConverter().fromJson(json['genre']),
  keyword: json['keyword'] as String?,
  generalFirstup: json['general_firstup'] as String?,
  generalLastup: json['general_lastup'] as String?,
  globalPoint: const StringToIntConverter().fromJson(json['global_point']),
  dailyPoint: const StringToIntConverter().fromJson(json['daily_point']),
  weeklyPoint: const StringToIntConverter().fromJson(json['weekly_point']),
  monthlyPoint: const StringToIntConverter().fromJson(json['monthly_point']),
  quarterPoint: const StringToIntConverter().fromJson(json['quarter_point']),
  yearlyPoint: const StringToIntConverter().fromJson(json['yearly_point']),
  favNovelCnt: const StringToIntConverter().fromJson(json['fav_novel_cnt']),
  impressionCnt: const StringToIntConverter().fromJson(json['impression_cnt']),
  reviewCnt: const StringToIntConverter().fromJson(json['review_cnt']),
  allPoint: const StringToIntConverter().fromJson(json['all_point']),
  allHyokaCnt: const StringToIntConverter().fromJson(json['all_hyoka_cnt']),
  sasieCnt: const StringToIntConverter().fromJson(json['sasie_cnt']),
  kaiwaritu: const StringToIntConverter().fromJson(json['kaiwaritu']),
  novelupdatedAt: const StringToIntConverter().fromJson(
    json['novelupdated_at'],
  ),
  updatedAt: const StringToIntConverter().fromJson(json['updated_at']),
  episodes: (json['episodes'] as List<dynamic>?)
      ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
      .toList(),
  isr15: const StringToIntConverter().fromJson(json['isr15']),
  isbl: const StringToIntConverter().fromJson(json['isbl']),
  isgl: const StringToIntConverter().fromJson(json['isgl']),
  iszankoku: const StringToIntConverter().fromJson(json['iszankoku']),
  istensei: const StringToIntConverter().fromJson(json['istensei']),
  istenni: const StringToIntConverter().fromJson(json['istenni']),
);

Map<String, dynamic> _$NovelInfoToJson(
  _NovelInfo instance,
) => <String, dynamic>{
  'title': instance.title,
  'ncode': instance.ncode,
  'writer': instance.writer,
  'story': instance.story,
  'novel_type': const StringToIntConverter().toJson(instance.novelType),
  'end': const StringToIntConverter().toJson(instance.end),
  'general_all_no': const StringToIntConverter().toJson(instance.generalAllNo),
  'genre': const StringToIntConverter().toJson(instance.genre),
  'keyword': instance.keyword,
  'general_firstup': instance.generalFirstup,
  'general_lastup': instance.generalLastup,
  'global_point': const StringToIntConverter().toJson(instance.globalPoint),
  'daily_point': const StringToIntConverter().toJson(instance.dailyPoint),
  'weekly_point': const StringToIntConverter().toJson(instance.weeklyPoint),
  'monthly_point': const StringToIntConverter().toJson(instance.monthlyPoint),
  'quarter_point': const StringToIntConverter().toJson(instance.quarterPoint),
  'yearly_point': const StringToIntConverter().toJson(instance.yearlyPoint),
  'fav_novel_cnt': const StringToIntConverter().toJson(instance.favNovelCnt),
  'impression_cnt': const StringToIntConverter().toJson(instance.impressionCnt),
  'review_cnt': const StringToIntConverter().toJson(instance.reviewCnt),
  'all_point': const StringToIntConverter().toJson(instance.allPoint),
  'all_hyoka_cnt': const StringToIntConverter().toJson(instance.allHyokaCnt),
  'sasie_cnt': const StringToIntConverter().toJson(instance.sasieCnt),
  'kaiwaritu': const StringToIntConverter().toJson(instance.kaiwaritu),
  'novelupdated_at': const StringToIntConverter().toJson(
    instance.novelupdatedAt,
  ),
  'updated_at': const StringToIntConverter().toJson(instance.updatedAt),
  'episodes': instance.episodes,
  'isr15': const StringToIntConverter().toJson(instance.isr15),
  'isbl': const StringToIntConverter().toJson(instance.isbl),
  'isgl': const StringToIntConverter().toJson(instance.isgl),
  'iszankoku': const StringToIntConverter().toJson(instance.iszankoku),
  'istensei': const StringToIntConverter().toJson(instance.istensei),
  'istenni': const StringToIntConverter().toJson(instance.istenni),
};
