import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/ncode_utils.dart';

part 'novel_search_query.g.dart';

/// Sentinel for "argument not supplied", so that copyWith can tell
/// "keep the old value" apart from "set this field to null".
const Object _unset = Object();

/// 小説検索クエリを表すクラス。
///
/// なろう小説APIのGETパラメータ（[なろう小説API](https://dev.syosetu.com/man/api/)）を
/// 表現する。カクヨム等の他サイトでは共通項目（[word] / [st] 等）のみが使われる。
@immutable
@JsonSerializable()
class NovelSearchQuery {
  /// Constructor.
  const NovelSearchQuery({
    this.source = NovelSource.narou,
    this.word,
    this.notword,
    this.title = false,
    this.ex = false,
    this.keyword = false,
    this.wname = false,
    this.biggenre,
    this.notbiggenre,
    this.genreId,
    this.notgenre,
    this.userid,
    this.isr15 = false,
    this.isbl = false,
    this.isgl = false,
    this.iszankoku = false,
    this.istensei = false,
    this.istenni = false,
    this.istt = false,
    this.notr15 = false,
    this.notbl = false,
    this.notgl = false,
    this.notzankoku = false,
    this.nottensei = false,
    this.nottenni = false,
    this.minlen,
    this.maxlen,
    this.length,
    this.kaiwaritu,
    this.sasie,
    this.mintime,
    this.maxtime,
    this.time,
    this.ncode,
    this.type,
    this.serialStatus,
    this.totalCharacterCountRange,
    this.buntai,
    this.stop,
    this.lastup,
    this.lastupdate,
    this.ispickup = false,
    this.order = 'new',
    this.lim = 20,
    this.st = 1,
  });

  /// [NovelSearchQuery]を生成するためのファクトリコンストラクタ。
  factory NovelSearchQuery.fromJson(Map<String, dynamic> json) =>
      _$NovelSearchQueryFromJson(json);

  /// JSONへ変換する。
  Map<String, dynamic> toJson() => _$NovelSearchQueryToJson(this);

  /// 提供サイト（プロバイダ）。
  final NovelSource source;

  /// 検索単語。
  ///
  /// 半角または全角スペースで区切るとAND抽出になる。
  final String? word;

  /// 除外単語。
  ///
  /// スペースで区切ることにより除外単語を増やせる。
  final String? notword;

  /// タイトルを検索対象にするか。
  final bool title;

  /// あらすじを検索対象にするか。
  final bool ex;

  /// キーワードを検索対象にするか。
  final bool keyword;

  /// 作者名を検索対象にするか。
  final bool wname;

  /// 大ジャンル。
  ///
  /// [大ジャンル一覧](https://dev.syosetu.com/man/api/#biggenre)
  final List<int>? biggenre;

  /// 除外大ジャンル。
  ///
  /// [大ジャンル一覧](https://dev.syosetu.com/man/api/#biggenre)
  final List<int>? notbiggenre;

  /// ジャンル。
  ///
  /// サイト共通のジャンルID（文字列）。
  /// なろうは [ジャンル一覧](https://dev.syosetu.com/man/api/#genre) のID文字列。
  @JsonKey(name: 'genre')
  final List<String>? genreId;

  /// 除外ジャンル。
  ///
  /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
  final List<int>? notgenre;

  /// ユーザID。
  final List<int>? userid;

  /// R15作品のみを対象とするか。
  final bool isr15;

  /// ボーイズラブ作品のみを対象とするか。
  final bool isbl;

  /// ガールズラブ作品のみを対象とするか。
  final bool isgl;

  /// 残酷な描写あり作品のみを対象とするか。
  final bool iszankoku;

  /// 異世界転生作品のみを対象とするか。
  final bool istensei;

  /// 異世界転移作品のみを対象とするか。
  final bool istenni;

  /// 異世界転生・転移作品のみを対象とするか。
  final bool istt;

  /// R15作品を除外するか。
  final bool notr15;

  /// ボーイズラブ作品を除外するか。
  final bool notbl;

  /// ガールズラブ作品を除外するか。
  final bool notgl;

  /// 残酷な描写あり作品を除外するか。
  final bool notzankoku;

  /// 異世界転生作品を除外するか。
  final bool nottensei;

  /// 異世界転移作品を除外するか。
  final bool nottenni;

  /// 最小文字数。
  final int? minlen;

  /// 最大文字数。
  final int? maxlen;

  /// 文字数範囲。
  ///
  /// `minlen` または `maxlen` と併用はできない。
  /// 範囲指定する場合は、最小文字数と最大文字数をハイフン(-)記号で区切る。
  final String? length;

  /// 会話率範囲。
  ///
  /// 範囲指定する場合は、最低数と最大数をハイフン(-)記号で区切る。
  final String? kaiwaritu;

  /// 挿絵数範囲。
  ///
  /// 範囲指定する場合は、最小数と最大数をハイフン(-)記号で区切る。
  final String? sasie;

  /// 最小読了時間(分単位)。
  final int? mintime;

  /// 最大読了時間(分単位)。
  final int? maxtime;

  /// 読了時間範囲。
  ///
  /// `mintime` または `maxtime` と併用はできない。
  /// 範囲指定する場合は、最小読了時間と最大読了時間をハイフン(-)記号で区切る。
  final String? time;

  /// Nコード。
  ///
  /// ハイフン(-)記号で区切ればOR検索ができる。
  /// 常に小文字で扱う
  final List<String>? ncode;

  /// 作品タイプ。
  ///
  /// * `t` - 短編
  /// * `r` - 連載中
  /// * `er` - 完結済連載作品
  /// * `re` - すべての連載作品(連載中および完結済)
  /// * `ter` - 短編と完結済連載作品
  final String? type;

  /// 連載状態（カクヨム専用）。
  ///
  /// カクヨム `/search` の `serial_status` パラメータに対応する。
  /// * `running` - 連載中
  /// * `completed` - 完結
  ///
  /// なろうでは [type] を使うため、なろうAPIには送信しない。
  final String? serialStatus;

  /// 総文字数範囲（カクヨム専用）。
  ///
  /// カクヨム `/search` の `total_character_count_range` パラメータに対応する。
  /// `20000-100000` のように最小値と最大値をハイフン(-)で区切る。
  /// 片側のみの場合は `-20000` / `100000-` のように指定する。
  ///
  /// なろうでは [minlen] / [maxlen] / [length] を使うため、
  /// なろうAPIには送信しない。
  final String? totalCharacterCountRange;

  /// 文体。
  ///
  /// ハイフン(-)記号で区切ればOR検索ができる。
  /// * `1` - 字下げされておらず、連続改行が多い作品
  /// * `2` - 字下げされていないが、改行数は平均な作品
  /// * `4` - 字下げが適切だが、連続改行が多い作品
  /// * `6` - 字下げが適切でかつ改行数も平均な作品
  final List<int>? buntai;

  /// 長期連載停止中作品に関する指定。
  ///
  /// * `1` - 長期連載停止中を除きます
  /// * `2` - 長期連載停止中のみ取得します
  final int? stop;

  /// 最終掲載日で抽出。
  ///
  /// * `thisweek` - 今週
  /// * `lastweek` - 先週
  /// * `sevenday` - 過去7日間
  /// * `thismonth` - 今月
  /// * `lastmonth` - 先月
  /// * `unixtime-unixtime` - UNIXタイムスタンプで範囲指定
  final String? lastup;

  /// 最終更新日で抽出。
  ///
  /// * `thisweek` - 今週
  /// * `lastweek` - 先週
  /// * `sevenday` - 過去7日間
  /// * `thismonth` - 今月
  /// * `lastmonth` - 先月
  /// * `unixtime-unixtime` - UNIXタイムスタンプで範囲指定
  final String? lastupdate;

  /// ピックアップ作品のみを対象とするか。
  final bool ispickup;

  /// 出力順序。
  ///
  /// デフォルトは `new` (新着更新順)。
  /// [出力順序一覧](https://dev.syosetu.com/man/api/#order)
  final String order;

  /// 最大出力数。
  ///
  /// 1～500。デフォルトは20。
  final int lim;

  /// 表示開始位置。
  ///
  /// 1～2000。デフォルトは1。
  final int st;

  /// 一部のフィールドだけ変えた新しいクエリを作る。
  ///
  /// 省略したフィールドは現在の値を保つ。null を渡すと null になる。
  NovelSearchQuery copyWith({
    Object? source = _unset,
    Object? word = _unset,
    Object? notword = _unset,
    Object? title = _unset,
    Object? ex = _unset,
    Object? keyword = _unset,
    Object? wname = _unset,
    Object? biggenre = _unset,
    Object? notbiggenre = _unset,
    Object? genreId = _unset,
    Object? notgenre = _unset,
    Object? userid = _unset,
    Object? isr15 = _unset,
    Object? isbl = _unset,
    Object? isgl = _unset,
    Object? iszankoku = _unset,
    Object? istensei = _unset,
    Object? istenni = _unset,
    Object? istt = _unset,
    Object? notr15 = _unset,
    Object? notbl = _unset,
    Object? notgl = _unset,
    Object? notzankoku = _unset,
    Object? nottensei = _unset,
    Object? nottenni = _unset,
    Object? minlen = _unset,
    Object? maxlen = _unset,
    Object? length = _unset,
    Object? kaiwaritu = _unset,
    Object? sasie = _unset,
    Object? mintime = _unset,
    Object? maxtime = _unset,
    Object? time = _unset,
    Object? ncode = _unset,
    Object? type = _unset,
    Object? serialStatus = _unset,
    Object? totalCharacterCountRange = _unset,
    Object? buntai = _unset,
    Object? stop = _unset,
    Object? lastup = _unset,
    Object? lastupdate = _unset,
    Object? ispickup = _unset,
    Object? order = _unset,
    Object? lim = _unset,
    Object? st = _unset,
  }) {
    return NovelSearchQuery(
      source: identical(source, _unset) ? this.source : source! as NovelSource,
      word: identical(word, _unset) ? this.word : word as String?,
      notword: identical(notword, _unset) ? this.notword : notword as String?,
      title: identical(title, _unset) ? this.title : title! as bool,
      ex: identical(ex, _unset) ? this.ex : ex! as bool,
      keyword: identical(keyword, _unset) ? this.keyword : keyword! as bool,
      wname: identical(wname, _unset) ? this.wname : wname! as bool,
      biggenre: identical(biggenre, _unset)
          ? this.biggenre
          : biggenre as List<int>?,
      notbiggenre: identical(notbiggenre, _unset)
          ? this.notbiggenre
          : notbiggenre as List<int>?,
      genreId: identical(genreId, _unset)
          ? this.genreId
          : genreId as List<String>?,
      notgenre: identical(notgenre, _unset)
          ? this.notgenre
          : notgenre as List<int>?,
      userid: identical(userid, _unset) ? this.userid : userid as List<int>?,
      isr15: identical(isr15, _unset) ? this.isr15 : isr15! as bool,
      isbl: identical(isbl, _unset) ? this.isbl : isbl! as bool,
      isgl: identical(isgl, _unset) ? this.isgl : isgl! as bool,
      iszankoku: identical(iszankoku, _unset)
          ? this.iszankoku
          : iszankoku! as bool,
      istensei: identical(istensei, _unset) ? this.istensei : istensei! as bool,
      istenni: identical(istenni, _unset) ? this.istenni : istenni! as bool,
      istt: identical(istt, _unset) ? this.istt : istt! as bool,
      notr15: identical(notr15, _unset) ? this.notr15 : notr15! as bool,
      notbl: identical(notbl, _unset) ? this.notbl : notbl! as bool,
      notgl: identical(notgl, _unset) ? this.notgl : notgl! as bool,
      notzankoku: identical(notzankoku, _unset)
          ? this.notzankoku
          : notzankoku! as bool,
      nottensei: identical(nottensei, _unset)
          ? this.nottensei
          : nottensei! as bool,
      nottenni: identical(nottenni, _unset) ? this.nottenni : nottenni! as bool,
      minlen: identical(minlen, _unset) ? this.minlen : minlen as int?,
      maxlen: identical(maxlen, _unset) ? this.maxlen : maxlen as int?,
      length: identical(length, _unset) ? this.length : length as String?,
      kaiwaritu: identical(kaiwaritu, _unset)
          ? this.kaiwaritu
          : kaiwaritu as String?,
      sasie: identical(sasie, _unset) ? this.sasie : sasie as String?,
      mintime: identical(mintime, _unset) ? this.mintime : mintime as int?,
      maxtime: identical(maxtime, _unset) ? this.maxtime : maxtime as int?,
      time: identical(time, _unset) ? this.time : time as String?,
      ncode: identical(ncode, _unset) ? this.ncode : ncode as List<String>?,
      type: identical(type, _unset) ? this.type : type as String?,
      serialStatus: identical(serialStatus, _unset)
          ? this.serialStatus
          : serialStatus as String?,
      totalCharacterCountRange: identical(totalCharacterCountRange, _unset)
          ? this.totalCharacterCountRange
          : totalCharacterCountRange as String?,
      buntai: identical(buntai, _unset) ? this.buntai : buntai as List<int>?,
      stop: identical(stop, _unset) ? this.stop : stop as int?,
      lastup: identical(lastup, _unset) ? this.lastup : lastup as String?,
      lastupdate: identical(lastupdate, _unset)
          ? this.lastupdate
          : lastupdate as String?,
      ispickup: identical(ispickup, _unset) ? this.ispickup : ispickup! as bool,
      order: identical(order, _unset) ? this.order : order! as String,
      lim: identical(lim, _unset) ? this.lim : lim! as int,
      st: identical(st, _unset) ? this.st : st! as int,
    );
  }

  /// ログとデバッグ用の文字列表現。
  @override
  String toString() {
    final parts = <String>[
      'source: $source',
      'word: $word',
      'notword: $notword',
      'title: $title',
      'ex: $ex',
      'keyword: $keyword',
      'wname: $wname',
      'biggenre: $biggenre',
      'notbiggenre: $notbiggenre',
      'genreId: $genreId',
      'notgenre: $notgenre',
      'userid: $userid',
      'isr15: $isr15',
      'isbl: $isbl',
      'isgl: $isgl',
      'iszankoku: $iszankoku',
      'istensei: $istensei',
      'istenni: $istenni',
      'istt: $istt',
      'notr15: $notr15',
      'notbl: $notbl',
      'notgl: $notgl',
      'notzankoku: $notzankoku',
      'nottensei: $nottensei',
      'nottenni: $nottenni',
      'minlen: $minlen',
      'maxlen: $maxlen',
      'length: $length',
      'kaiwaritu: $kaiwaritu',
      'sasie: $sasie',
      'mintime: $mintime',
      'maxtime: $maxtime',
      'time: $time',
      'ncode: $ncode',
      'type: $type',
      'serialStatus: $serialStatus',
      'totalCharacterCountRange: $totalCharacterCountRange',
      'buntai: $buntai',
      'stop: $stop',
      'lastup: $lastup',
      'lastupdate: $lastupdate',
      'ispickup: $ispickup',
      'order: $order',
      'lim: $lim',
      'st: $st',
    ];
    return 'NovelSearchQuery(${parts.join(', ')})';
  }

  /// Value equality over every field.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NovelSearchQuery &&
          other.source == source &&
          other.word == word &&
          other.notword == notword &&
          other.title == title &&
          other.ex == ex &&
          other.keyword == keyword &&
          other.wname == wname &&
          listEquals(other.biggenre, biggenre) &&
          listEquals(other.notbiggenre, notbiggenre) &&
          listEquals(other.genreId, genreId) &&
          listEquals(other.notgenre, notgenre) &&
          listEquals(other.userid, userid) &&
          other.isr15 == isr15 &&
          other.isbl == isbl &&
          other.isgl == isgl &&
          other.iszankoku == iszankoku &&
          other.istensei == istensei &&
          other.istenni == istenni &&
          other.istt == istt &&
          other.notr15 == notr15 &&
          other.notbl == notbl &&
          other.notgl == notgl &&
          other.notzankoku == notzankoku &&
          other.nottensei == nottensei &&
          other.nottenni == nottenni &&
          other.minlen == minlen &&
          other.maxlen == maxlen &&
          other.length == length &&
          other.kaiwaritu == kaiwaritu &&
          other.sasie == sasie &&
          other.mintime == mintime &&
          other.maxtime == maxtime &&
          other.time == time &&
          listEquals(other.ncode, ncode) &&
          other.type == type &&
          other.serialStatus == serialStatus &&
          other.totalCharacterCountRange == totalCharacterCountRange &&
          listEquals(other.buntai, buntai) &&
          other.stop == stop &&
          other.lastup == lastup &&
          other.lastupdate == lastupdate &&
          other.ispickup == ispickup &&
          other.order == order &&
          other.lim == lim &&
          other.st == st;

  @override
  int get hashCode => Object.hashAll([
    source,
    word,
    notword,
    title,
    ex,
    keyword,
    wname,
    Object.hashAll(biggenre ?? const []),
    Object.hashAll(notbiggenre ?? const []),
    Object.hashAll(genreId ?? const []),
    Object.hashAll(notgenre ?? const []),
    Object.hashAll(userid ?? const []),
    isr15,
    isbl,
    isgl,
    iszankoku,
    istensei,
    istenni,
    istt,
    notr15,
    notbl,
    notgl,
    notzankoku,
    nottensei,
    nottenni,
    minlen,
    maxlen,
    length,
    kaiwaritu,
    sasie,
    mintime,
    maxtime,
    time,
    Object.hashAll(ncode ?? const []),
    type,
    serialStatus,
    totalCharacterCountRange,
    Object.hashAll(buntai ?? const []),
    stop,
    lastup,
    lastupdate,
    ispickup,
    order,
    lim,
    st,
  ]);
}

/// [NovelSearchQuery]をMapに変換する拡張メソッド。
extension NovelSearchQueryEx on NovelSearchQuery {
  /// [NovelSearchQuery]をMapに変換するメソッド。
  ///
  /// なろう小説APIのGETパラメータ形式に変換する。
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'notword': notword,
      'title': title ? 1 : null,
      'ex': ex ? 1 : null,
      'keyword': keyword ? 1 : null,
      'wname': wname ? 1 : null,
      'biggenre': biggenre?.join('-'),
      'notbiggenre': notbiggenre?.join('-'),
      'genre': genreId?.join('-'),
      'notgenre': notgenre?.join('-'),
      'userid': userid?.join('-'),
      'isr15': isr15 ? 1 : null,
      'isbl': isbl ? 1 : null,
      'isgl': isgl ? 1 : null,
      'iszankoku': iszankoku ? 1 : null,
      'istensei': istensei ? 1 : null,
      'istenni': istenni ? 1 : null,
      'istt': istt ? 1 : null,
      'notr15': notr15 ? 1 : null,
      'notbl': notbl ? 1 : null,
      'notgl': notgl ? 1 : null,
      'notzankoku': notzankoku ? 1 : null,
      'nottensei': nottensei ? 1 : null,
      'nottenni': nottenni ? 1 : null,
      'minlen': minlen,
      'maxlen': maxlen,
      'length': length,
      'kaiwaritu': kaiwaritu,
      'sasie': sasie,
      'mintime': mintime,
      'maxtime': maxtime,
      'time': time,
      'ncode': ncode?.map((n) => n.toNormalizedNcode()).join('-'),
      'type': type,
      'buntai': buntai?.join('-'),
      'stop': stop,
      'lastup': lastup,
      'lastupdate': lastupdate,
      'ispickup': ispickup ? 1 : null,
      'order': order,
      'lim': lim,
      'st': st,
    }..removeWhere((key, value) => value == null);
  }
}
