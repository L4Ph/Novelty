// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RankingResponse _$RankingResponseFromJson(Map<String, dynamic> json) =>
    _RankingResponse(
      rank: const StringToIntConverter().fromJson(json['rank']),
      pt: const StringToIntConverter().fromJson(json['pt']),
      allPoint: const StringToIntConverter().fromJson(json['all_point']),
      ncode: json['ncode'] as String,
      title: json['title'] as String?,
      novelType: const StringToIntConverter().fromJson(json['novel_type']),
      end: const StringToIntConverter().fromJson(json['end']),
      genre: const StringToIntConverter().fromJson(json['genre']),
      writer: json['writer'] as String?,
      story: json['story'] as String?,
      userId: const StringToIntConverter().fromJson(json['userid']),
      generalAllNo: const StringToIntConverter().fromJson(
        json['general_all_no'],
      ),
      keyword: json['keyword'] as String?,
    );

Map<String, dynamic> _$RankingResponseToJson(
  _RankingResponse instance,
) => <String, dynamic>{
  'rank': const StringToIntConverter().toJson(instance.rank),
  'pt': const StringToIntConverter().toJson(instance.pt),
  'all_point': const StringToIntConverter().toJson(instance.allPoint),
  'ncode': instance.ncode,
  'title': instance.title,
  'novel_type': const StringToIntConverter().toJson(instance.novelType),
  'end': const StringToIntConverter().toJson(instance.end),
  'genre': const StringToIntConverter().toJson(instance.genre),
  'writer': instance.writer,
  'story': instance.story,
  'userid': const StringToIntConverter().toJson(instance.userId),
  'general_all_no': const StringToIntConverter().toJson(instance.generalAllNo),
  'keyword': instance.keyword,
};
