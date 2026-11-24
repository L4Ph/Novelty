// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NovelInfo _$NovelInfoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_NovelInfo',
  json,
  ($checkedConvert) {
    final val = _NovelInfo(
      source: $checkedConvert(
        'source',
        (v) =>
            $enumDecodeNullable(_$NovelSourceEnumMap, v) ?? NovelSource.narou,
      ),
      workId: $checkedConvert('workId', (v) => v as String?),
      title: $checkedConvert(
        'title',
        (v) => const HtmlEscapeConverter().fromJson(v as String?),
      ),
      ncode: $checkedConvert('ncode', (v) => v as String?),
      writer: $checkedConvert(
        'writer',
        (v) => const HtmlEscapeConverter().fromJson(v as String?),
      ),
      userId: $checkedConvert(
        'userid',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      story: $checkedConvert(
        'story',
        (v) => const HtmlEscapeConverter().fromJson(v as String?),
      ),
      novelType: $checkedConvert(
        'novel_type',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      end: $checkedConvert(
        'end',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      generalAllNo: $checkedConvert(
        'general_all_no',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      genreId: $checkedConvert(
        'genre',
        (v) => const IntOrStringConverter().fromJson(v),
      ),
      keyword: $checkedConvert(
        'keyword',
        (v) => const HtmlEscapeConverter().fromJson(v as String?),
      ),
      generalFirstup: $checkedConvert('general_firstup', (v) => v as String?),
      generalLastup: $checkedConvert('general_lastup', (v) => v as String?),
      globalPoint: $checkedConvert(
        'global_point',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      dailyPoint: $checkedConvert(
        'daily_point',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      weeklyPoint: $checkedConvert(
        'weekly_point',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      monthlyPoint: $checkedConvert(
        'monthly_point',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      quarterPoint: $checkedConvert(
        'quarter_point',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      yearlyPoint: $checkedConvert(
        'yearly_point',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      favNovelCnt: $checkedConvert(
        'fav_novel_cnt',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      impressionCnt: $checkedConvert(
        'impression_cnt',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      reviewCnt: $checkedConvert(
        'review_cnt',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      allPoint: $checkedConvert(
        'all_point',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      allHyokaCnt: $checkedConvert(
        'all_hyoka_cnt',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      sasieCnt: $checkedConvert(
        'sasie_cnt',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      kaiwaritu: $checkedConvert(
        'kaiwaritu',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      novelupdatedAt: $checkedConvert(
        'novelupdated_at',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      episodes: $checkedConvert(
        'episodes',
        (v) => (v as List<dynamic>?)
            ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      isr15: $checkedConvert(
        'isr15',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      isbl: $checkedConvert(
        'isbl',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      isgl: $checkedConvert(
        'isgl',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      iszankoku: $checkedConvert(
        'iszankoku',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      istensei: $checkedConvert(
        'istensei',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      istenni: $checkedConvert(
        'istenni',
        (v) => const StringToIntConverter().fromJson(v),
      ),
      isPrivate: $checkedConvert('isPrivate', (v) => v as bool? ?? false),
    );
    return val;
  },
  fieldKeyMap: const {
    'userId': 'userid',
    'novelType': 'novel_type',
    'generalAllNo': 'general_all_no',
    'genreId': 'genre',
    'generalFirstup': 'general_firstup',
    'generalLastup': 'general_lastup',
    'globalPoint': 'global_point',
    'dailyPoint': 'daily_point',
    'weeklyPoint': 'weekly_point',
    'monthlyPoint': 'monthly_point',
    'quarterPoint': 'quarter_point',
    'yearlyPoint': 'yearly_point',
    'favNovelCnt': 'fav_novel_cnt',
    'impressionCnt': 'impression_cnt',
    'reviewCnt': 'review_cnt',
    'allPoint': 'all_point',
    'allHyokaCnt': 'all_hyoka_cnt',
    'sasieCnt': 'sasie_cnt',
    'novelupdatedAt': 'novelupdated_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$NovelInfoToJson(
  _NovelInfo instance,
) => <String, dynamic>{
  'source': _$NovelSourceEnumMap[instance.source]!,
  'workId': instance.workId,
  'title': const HtmlEscapeConverter().toJson(instance.title),
  'ncode': instance.ncode,
  'writer': const HtmlEscapeConverter().toJson(instance.writer),
  'userid': const StringToIntConverter().toJson(instance.userId),
  'story': const HtmlEscapeConverter().toJson(instance.story),
  'novel_type': const StringToIntConverter().toJson(instance.novelType),
  'end': const StringToIntConverter().toJson(instance.end),
  'general_all_no': const StringToIntConverter().toJson(instance.generalAllNo),
  'genre': const IntOrStringConverter().toJson(instance.genreId),
  'keyword': const HtmlEscapeConverter().toJson(instance.keyword),
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
  'isPrivate': instance.isPrivate,
};

const _$NovelSourceEnumMap = {
  NovelSource.narou: 'narou',
  NovelSource.kakuyomu: 'kakuyomu',
};
