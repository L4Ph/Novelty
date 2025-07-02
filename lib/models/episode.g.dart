// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
      title: json['title'] as String,
      ncode: json['ncode'] as String,
      index: (json['index'] as num).toInt(),
      body: json['body'] as String,
      novelUpdatedAt: json['novelUpdatedAt'] as String,
    );

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
      'title': instance.title,
      'ncode': instance.ncode,
      'index': instance.index,
      'body': instance.body,
      'novelUpdatedAt': instance.novelUpdatedAt,
    };
