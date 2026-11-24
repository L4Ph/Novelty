// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_search_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelSearchQuery _$NovelSearchQueryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NovelSearchQuery', json, ($checkedConvert) {
      final val = NovelSearchQuery(
        source: $checkedConvert(
          'source',
          (v) =>
              $enumDecodeNullable(_$NovelSourceEnumMap, v) ?? NovelSource.narou,
        ),
        word: $checkedConvert('word', (v) => v as String?),
        notword: $checkedConvert('notword', (v) => v as String?),
        title: $checkedConvert('title', (v) => v as bool? ?? false),
        ex: $checkedConvert('ex', (v) => v as bool? ?? false),
        keyword: $checkedConvert('keyword', (v) => v as bool? ?? false),
        wname: $checkedConvert('wname', (v) => v as bool? ?? false),
        biggenre: $checkedConvert(
          'biggenre',
          (v) => (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
        ),
        notbiggenre: $checkedConvert(
          'notbiggenre',
          (v) => (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
        ),
        genreId: $checkedConvert(
          'genre',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        notgenre: $checkedConvert(
          'notgenre',
          (v) => (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
        ),
        userid: $checkedConvert(
          'userid',
          (v) => (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
        ),
        isr15: $checkedConvert('isr15', (v) => v as bool? ?? false),
        isbl: $checkedConvert('isbl', (v) => v as bool? ?? false),
        isgl: $checkedConvert('isgl', (v) => v as bool? ?? false),
        iszankoku: $checkedConvert('iszankoku', (v) => v as bool? ?? false),
        istensei: $checkedConvert('istensei', (v) => v as bool? ?? false),
        istenni: $checkedConvert('istenni', (v) => v as bool? ?? false),
        istt: $checkedConvert('istt', (v) => v as bool? ?? false),
        notr15: $checkedConvert('notr15', (v) => v as bool? ?? false),
        notbl: $checkedConvert('notbl', (v) => v as bool? ?? false),
        notgl: $checkedConvert('notgl', (v) => v as bool? ?? false),
        notzankoku: $checkedConvert('notzankoku', (v) => v as bool? ?? false),
        nottensei: $checkedConvert('nottensei', (v) => v as bool? ?? false),
        nottenni: $checkedConvert('nottenni', (v) => v as bool? ?? false),
        minlen: $checkedConvert('minlen', (v) => (v as num?)?.toInt()),
        maxlen: $checkedConvert('maxlen', (v) => (v as num?)?.toInt()),
        length: $checkedConvert('length', (v) => v as String?),
        kaiwaritu: $checkedConvert('kaiwaritu', (v) => v as String?),
        sasie: $checkedConvert('sasie', (v) => v as String?),
        mintime: $checkedConvert('mintime', (v) => (v as num?)?.toInt()),
        maxtime: $checkedConvert('maxtime', (v) => (v as num?)?.toInt()),
        time: $checkedConvert('time', (v) => v as String?),
        ncode: $checkedConvert(
          'ncode',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        type: $checkedConvert('type', (v) => v as String?),
        serialStatus: $checkedConvert('serialStatus', (v) => v as String?),
        totalCharacterCountRange: $checkedConvert(
          'totalCharacterCountRange',
          (v) => v as String?,
        ),
        buntai: $checkedConvert(
          'buntai',
          (v) => (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
        ),
        stop: $checkedConvert('stop', (v) => (v as num?)?.toInt()),
        lastup: $checkedConvert('lastup', (v) => v as String?),
        lastupdate: $checkedConvert('lastupdate', (v) => v as String?),
        ispickup: $checkedConvert('ispickup', (v) => v as bool? ?? false),
        order: $checkedConvert('order', (v) => v as String? ?? 'new'),
        lim: $checkedConvert('lim', (v) => (v as num?)?.toInt() ?? 20),
        st: $checkedConvert('st', (v) => (v as num?)?.toInt() ?? 1),
      );
      return val;
    }, fieldKeyMap: const {'genreId': 'genre'});

Map<String, dynamic> _$NovelSearchQueryToJson(NovelSearchQuery instance) =>
    <String, dynamic>{
      'source': _$NovelSourceEnumMap[instance.source]!,
      'word': instance.word,
      'notword': instance.notword,
      'title': instance.title,
      'ex': instance.ex,
      'keyword': instance.keyword,
      'wname': instance.wname,
      'biggenre': instance.biggenre,
      'notbiggenre': instance.notbiggenre,
      'genre': instance.genreId,
      'notgenre': instance.notgenre,
      'userid': instance.userid,
      'isr15': instance.isr15,
      'isbl': instance.isbl,
      'isgl': instance.isgl,
      'iszankoku': instance.iszankoku,
      'istensei': instance.istensei,
      'istenni': instance.istenni,
      'istt': instance.istt,
      'notr15': instance.notr15,
      'notbl': instance.notbl,
      'notgl': instance.notgl,
      'notzankoku': instance.notzankoku,
      'nottensei': instance.nottensei,
      'nottenni': instance.nottenni,
      'minlen': instance.minlen,
      'maxlen': instance.maxlen,
      'length': instance.length,
      'kaiwaritu': instance.kaiwaritu,
      'sasie': instance.sasie,
      'mintime': instance.mintime,
      'maxtime': instance.maxtime,
      'time': instance.time,
      'ncode': instance.ncode,
      'type': instance.type,
      'serialStatus': instance.serialStatus,
      'totalCharacterCountRange': instance.totalCharacterCountRange,
      'buntai': instance.buntai,
      'stop': instance.stop,
      'lastup': instance.lastup,
      'lastupdate': instance.lastupdate,
      'ispickup': instance.ispickup,
      'order': instance.order,
      'lim': instance.lim,
      'st': instance.st,
    };

const _$NovelSourceEnumMap = {
  NovelSource.narou: 'narou',
  NovelSource.kakuyomu: 'kakuyomu',
};
