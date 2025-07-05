// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
  subtitle: json['subtitle'] as String?,
  url: json['url'] as String?,
  update: json['update'] as String?,
  revised: json['revised'] as String?,
  ncode: json['ncode'] as String?,
  index: (json['index'] as num?)?.toInt(),
  body: json['body'] as String?,
  novelUpdatedAt: json['novel_updated_at'] as String?,
);

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
  'subtitle': instance.subtitle,
  'url': instance.url,
  'update': instance.update,
  'revised': instance.revised,
  'ncode': instance.ncode,
  'index': instance.index,
  'body': instance.body,
  'novel_updated_at': instance.novelUpdatedAt,
};
