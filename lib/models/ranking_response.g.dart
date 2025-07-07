// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RankingResponse _$RankingResponseFromJson(Map<String, dynamic> json) =>
    RankingResponse(
      rank: (json['rank'] as num?)?.toInt(),
      pt: (json['pt'] as num?)?.toInt(),
      allPoint: (json['all_point'] as num?)?.toInt(),
      ncode: json['ncode'] as String,
      title: json['title'] as String?,
      novelType: (json['noveltype'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
      genre: (json['genre'] as num?)?.toInt(),
      writer: json['writer'] as String?,
      story: json['story'] as String?,
      userId: (json['userid'] as num?)?.toInt(),
      generalAllNo: (json['general_all_no'] as num?)?.toInt(),
      keyword: json['keyword'] as String?,
    );

Map<String, dynamic> _$RankingResponseToJson(RankingResponse instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'pt': instance.pt,
      'all_point': instance.allPoint,
      'ncode': instance.ncode,
      'title': instance.title,
      'noveltype': instance.novelType,
      'end': instance.end,
      'genre': instance.genre,
      'writer': instance.writer,
      'story': instance.story,
      'userid': instance.userId,
      'general_all_no': instance.generalAllNo,
      'keyword': instance.keyword,
    };
