// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelInfo _$NovelInfoFromJson(Map<String, dynamic> json) => NovelInfo(
      title: json['title'] as String,
      ncode: json['ncode'] as String,
      writer: json['writer'] as String,
      story: json['story'] as String,
      novelType: (json['novelType'] as num).toInt(),
      end: (json['end'] as num).toInt(),
      generalAllNo: (json['generalAllNo'] as num).toInt(),
      genre: (json['genre'] as num).toInt(),
      keyword: json['keyword'] as String,
      generalFirstup: json['generalFirstup'] as String,
      generalLastup: json['generalLastup'] as String,
      globalPoint: (json['globalPoint'] as num).toInt(),
      dailyPoint: (json['dailyPoint'] as num).toInt(),
      weeklyPoint: (json['weeklyPoint'] as num).toInt(),
      monthlyPoint: (json['monthlyPoint'] as num).toInt(),
      quarterPoint: (json['quarterPoint'] as num).toInt(),
      yearlyPoint: (json['yearlyPoint'] as num).toInt(),
      favNovelCnt: (json['favNovelCnt'] as num).toInt(),
      impressionCnt: (json['impressionCnt'] as num).toInt(),
      reviewCnt: (json['reviewCnt'] as num).toInt(),
      allPoint: (json['allPoint'] as num).toInt(),
      allHyokaCnt: (json['allHyokaCnt'] as num).toInt(),
      sasieCnt: (json['sasieCnt'] as num).toInt(),
      kaiwaritu: (json['kaiwaritu'] as num).toInt(),
      novelupdatedAt: (json['novelupdatedAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      episodes: json['episodes'] as List<dynamic>?,
    );

Map<String, dynamic> _$NovelInfoToJson(NovelInfo instance) => <String, dynamic>{
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
      'novelupdatedAt': instance.novelupdatedAt,
      'updatedAt': instance.updatedAt,
      'episodes': instance.episodes,
    };
