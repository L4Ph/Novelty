// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_search_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelSearchQuery _$NovelSearchQueryFromJson(Map<String, dynamic> json) =>
    NovelSearchQuery(
      word: json['word'] as String?,
      notword: json['notword'] as String?,
      title: json['title'] as bool? ?? false,
      ex: json['ex'] as bool? ?? false,
      keyword: json['keyword'] as bool? ?? false,
      wname: json['wname'] as bool? ?? false,
      biggenre: (json['biggenre'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      notbiggenre: (json['notbiggenre'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      genre: (json['genre'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      notgenre: (json['notgenre'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      userid: (json['userid'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      isr15: json['isr15'] as bool? ?? false,
      isbl: json['isbl'] as bool? ?? false,
      isgl: json['isgl'] as bool? ?? false,
      iszankoku: json['iszankoku'] as bool? ?? false,
      istensei: json['istensei'] as bool? ?? false,
      istenni: json['istenni'] as bool? ?? false,
      istt: json['istt'] as bool? ?? false,
      notr15: json['notr15'] as bool? ?? false,
      notbl: json['notbl'] as bool? ?? false,
      notgl: json['notgl'] as bool? ?? false,
      notzankoku: json['notzankoku'] as bool? ?? false,
      nottensei: json['nottensei'] as bool? ?? false,
      nottenni: json['nottenni'] as bool? ?? false,
      minlen: (json['minlen'] as num?)?.toInt(),
      maxlen: (json['maxlen'] as num?)?.toInt(),
      length: json['length'] as String?,
      kaiwaritu: json['kaiwaritu'] as String?,
      sasie: json['sasie'] as String?,
      mintime: (json['mintime'] as num?)?.toInt(),
      maxtime: (json['maxtime'] as num?)?.toInt(),
      time: json['time'] as String?,
      ncode: (json['ncode'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      type: json['type'] as String?,
      buntai: (json['buntai'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      stop: (json['stop'] as num?)?.toInt(),
      lastup: json['lastup'] as String?,
      lastupdate: json['lastupdate'] as String?,
      ispickup: json['ispickup'] as bool? ?? false,
      order: json['order'] as String? ?? 'new',
      lim: (json['lim'] as num?)?.toInt() ?? 20,
      st: (json['st'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$NovelSearchQueryToJson(NovelSearchQuery instance) =>
    <String, dynamic>{
      'word': instance.word,
      'notword': instance.notword,
      'title': instance.title,
      'ex': instance.ex,
      'keyword': instance.keyword,
      'wname': instance.wname,
      'biggenre': instance.biggenre,
      'notbiggenre': instance.notbiggenre,
      'genre': instance.genre,
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
      'buntai': instance.buntai,
      'stop': instance.stop,
      'lastup': instance.lastup,
      'lastupdate': instance.lastupdate,
      'ispickup': instance.ispickup,
      'order': instance.order,
      'lim': instance.lim,
      'st': instance.st,
    };
