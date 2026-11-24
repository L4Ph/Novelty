// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Episode _$EpisodeFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Episode',
  json,
  ($checkedConvert) {
    final val = Episode(
      source: $checkedConvert(
        'source',
        (v) =>
            $enumDecodeNullable(_$NovelSourceEnumMap, v) ?? NovelSource.narou,
      ),
      subtitle: $checkedConvert(
        'subtitle',
        (v) => const HtmlEscapeConverter().fromJson(v as String?),
      ),
      url: $checkedConvert('url', (v) => v as String?),
      update: $checkedConvert('update', (v) => v as String?),
      revised: $checkedConvert('revised', (v) => v as String?),
      ncode: $checkedConvert('ncode', (v) => v as String?),
      index: $checkedConvert('index', (v) => (v as num?)?.toInt()),
      body: $checkedConvert('body', (v) => v as String?),
      novelUpdatedAt: $checkedConvert('novelUpdatedAt', (v) => v as String?),
      isDownloaded: $checkedConvert('isDownloaded', (v) => v as bool? ?? false),
    );
    return val;
  },
);

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
  'source': _$NovelSourceEnumMap[instance.source]!,
  'subtitle': const HtmlEscapeConverter().toJson(instance.subtitle),
  'url': instance.url,
  'update': instance.update,
  'revised': instance.revised,
  'ncode': instance.ncode,
  'index': instance.index,
  'body': instance.body,
  'novelUpdatedAt': instance.novelUpdatedAt,
  'isDownloaded': instance.isDownloaded,
};

const _$NovelSourceEnumMap = {
  NovelSource.narou: 'narou',
  NovelSource.kakuyomu: 'kakuyomu',
};
