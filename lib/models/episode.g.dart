// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Episode _$EpisodeFromJson(Map<String, dynamic> json) => _Episode(
  subtitle: json['subtitle'] as String?,
  url: json['url'] as String?,
  update: json['update'] as String?,
  revised: json['revised'] as String?,
  ncode: json['ncode'] as String?,
  index: (json['index'] as num?)?.toInt(),
  body: json['body'] as String?,
  novelUpdatedAt: json['novelUpdatedAt'] as String?,
  isDownloaded: json['isDownloaded'] as bool? ?? false,
);

Map<String, dynamic> _$EpisodeToJson(_Episode instance) => <String, dynamic>{
  'subtitle': instance.subtitle,
  'url': instance.url,
  'update': instance.update,
  'revised': instance.revised,
  'ncode': instance.ncode,
  'index': instance.index,
  'body': instance.body,
  'novelUpdatedAt': instance.novelUpdatedAt,
  'isDownloaded': instance.isDownloaded,
};
