// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RankingResponse _$RankingResponseFromJson(Map<String, dynamic> json) =>
    _RankingResponse(
      rank: (json['rank'] as num?)?.toInt(),
      pt: (json['pt'] as num?)?.toInt(),
      allPoint: (json['allPoint'] as num?)?.toInt(),
      ncode: json['ncode'] as String,
      title: json['title'] as String?,
      novelType: (json['novelType'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
      genre: (json['genre'] as num?)?.toInt(),
      writer: json['writer'] as String?,
      story: json['story'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      generalAllNo: (json['generalAllNo'] as num?)?.toInt(),
      keyword: json['keyword'] as String?,
    );

Map<String, dynamic> _$RankingResponseToJson(_RankingResponse instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'pt': instance.pt,
      'allPoint': instance.allPoint,
      'ncode': instance.ncode,
      'title': instance.title,
      'novelType': instance.novelType,
      'end': instance.end,
      'genre': instance.genre,
      'writer': instance.writer,
      'story': instance.story,
      'userId': instance.userId,
      'generalAllNo': instance.generalAllNo,
      'keyword': instance.keyword,
    };
