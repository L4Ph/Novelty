import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:novelty/utils/ncode_utils.dart';

part 'novel_search_query.g.dart';

/// なろう小説APIの検索クエリを表すクラス。
///
/// [なろう小説API](https://dev.syosetu.com/man/api/) のGETパラメータを表現する。
@immutable
@JsonSerializable()
class NovelSearchQuery {
  /// [NovelSearchQuery]のコンストラクタ
  const NovelSearchQuery({
    this.word,
    this.notword,
    this.title = false,
    this.ex = false,
    this.keyword = false,
    this.wname = false,
    this.biggenre,
    this.notbiggenre,
    this.genre,
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
    this.buntai,
    this.stop,
    this.lastup,
    this.lastupdate,
    this.ispickup = false,
    this.order = 'new',
    this.lim = 20,
    this.st = 1,
  });

  /// 検索単語。
  ///
  /// 半角または全角スペースで区切るとAND抽出になる。
  final String? word;

  /// 除外単語。
  ///
  /// スペースで区切ることにより除外単語を増やせる。
  final String? notword;

  /// タイトルを検索対象にするか。
  @JsonKey(defaultValue: false)
  final bool title;

  /// あらすじを検索対象にするか。
  @JsonKey(defaultValue: false)
  final bool ex;

  /// キーワードを検索対象にするか。
  @JsonKey(defaultValue: false)
  final bool keyword;

  /// 作者名を検索対象にするか。
  @JsonKey(defaultValue: false)
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
  /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
  final List<int>? genre;

  /// 除外ジャンル。
  ///
  /// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
  final List<int>? notgenre;

  /// ユーザID。
  final List<int>? userid;

  /// R15作品のみを対象とするか。
  @JsonKey(defaultValue: false)
  final bool isr15;

  /// ボーイズラブ作品のみを対象とするか。
  @JsonKey(defaultValue: false)
  final bool isbl;

  /// ガールズラブ作品のみを対象とするか。
  @JsonKey(defaultValue: false)
  final bool isgl;

  /// 残酷な描写あり作品のみを対象とするか。
  @JsonKey(defaultValue: false)
  final bool iszankoku;

  /// 異世界転生作品のみを対象とするか。
  @JsonKey(defaultValue: false)
  final bool istensei;

  /// 異世界転移作品のみを対象とするか。
  @JsonKey(defaultValue: false)
  final bool istenni;

  /// 異世界転生・転移作品のみを対象とするか。
  @JsonKey(defaultValue: false)
  final bool istt;

  /// R15作品を除外するか。
  @JsonKey(defaultValue: false)
  final bool notr15;

  /// ボーイズラブ作品を除外するか。
  @JsonKey(defaultValue: false)
  final bool notbl;

  /// ガールズラブ作品を除外するか。
  @JsonKey(defaultValue: false)
  final bool notgl;

  /// 残酷な描写あり作品を除外するか。
  @JsonKey(defaultValue: false)
  final bool notzankoku;

  /// 異世界転生作品を除外するか。
  @JsonKey(defaultValue: false)
  final bool nottensei;

  /// 異世界転移作品を除外するか。
  @JsonKey(defaultValue: false)
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
  @JsonKey(defaultValue: false)
  final bool ispickup;

  /// 出力順序。
  ///
  /// デフォルトは `new` (新着更新順)。
  /// [出力順序一覧](https://dev.syosetu.com/man/api/#order)
  @JsonKey(defaultValue: 'new')
  final String order;

  /// 最大出力数。
  ///
  /// 1～500。デフォルトは20。
  @JsonKey(defaultValue: 20)
  final int lim;

  /// 表示開始位置。
  ///
  /// 1～2000。デフォルトは1。
  @JsonKey(defaultValue: 1)
  final int st;

  /// [NovelSearchQuery]を生成するためのファクトリコンストラクタ。
  factory NovelSearchQuery.fromJson(Map<String, dynamic> json) =>
      _$NovelSearchQueryFromJson(json);

  /// JSONに変換する
  Map<String, dynamic> toJson() => _$NovelSearchQueryToJson(this);

  /// フィールドを変更した新しいインスタンスを作成する
  NovelSearchQuery copyWith({
    String? word,
    String? notword,
    bool? title,
    bool? ex,
    bool? keyword,
    bool? wname,
    List<int>? biggenre,
    List<int>? notbiggenre,
    List<int>? genre,
    List<int>? notgenre,
    List<int>? userid,
    bool? isr15,
    bool? isbl,
    bool? isgl,
    bool? iszankoku,
    bool? istensei,
    bool? istenni,
    bool? istt,
    bool? notr15,
    bool? notbl,
    bool? notgl,
    bool? notzankoku,
    bool? nottensei,
    bool? nottenni,
    int? minlen,
    int? maxlen,
    String? length,
    String? kaiwaritu,
    String? sasie,
    int? mintime,
    int? maxtime,
    String? time,
    List<String>? ncode,
    String? type,
    List<int>? buntai,
    int? stop,
    String? lastup,
    String? lastupdate,
    bool? ispickup,
    String? order,
    int? lim,
    int? st,
  }) {
    return NovelSearchQuery(
      word: word ?? this.word,
      notword: notword ?? this.notword,
      title: title ?? this.title,
      ex: ex ?? this.ex,
      keyword: keyword ?? this.keyword,
      wname: wname ?? this.wname,
      biggenre: biggenre ?? this.biggenre,
      notbiggenre: notbiggenre ?? this.notbiggenre,
      genre: genre ?? this.genre,
      notgenre: notgenre ?? this.notgenre,
      userid: userid ?? this.userid,
      isr15: isr15 ?? this.isr15,
      isbl: isbl ?? this.isbl,
      isgl: isgl ?? this.isgl,
      iszankoku: iszankoku ?? this.iszankoku,
      istensei: istensei ?? this.istensei,
      istenni: istenni ?? this.istenni,
      istt: istt ?? this.istt,
      notr15: notr15 ?? this.notr15,
      notbl: notbl ?? this.notbl,
      notgl: notgl ?? this.notgl,
      notzankoku: notzankoku ?? this.notzankoku,
      nottensei: nottensei ?? this.nottensei,
      nottenni: nottenni ?? this.nottenni,
      minlen: minlen ?? this.minlen,
      maxlen: maxlen ?? this.maxlen,
      length: length ?? this.length,
      kaiwaritu: kaiwaritu ?? this.kaiwaritu,
      sasie: sasie ?? this.sasie,
      mintime: mintime ?? this.mintime,
      maxtime: maxtime ?? this.maxtime,
      time: time ?? this.time,
      ncode: ncode ?? this.ncode,
      type: type ?? this.type,
      buntai: buntai ?? this.buntai,
      stop: stop ?? this.stop,
      lastup: lastup ?? this.lastup,
      lastupdate: lastupdate ?? this.lastupdate,
      ispickup: ispickup ?? this.ispickup,
      order: order ?? this.order,
      lim: lim ?? this.lim,
      st: st ?? this.st,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NovelSearchQuery &&
          runtimeType == other.runtimeType &&
          word == other.word &&
          notword == other.notword &&
          title == other.title &&
          ex == other.ex &&
          keyword == other.keyword &&
          wname == other.wname &&
          biggenre == other.biggenre &&
          notbiggenre == other.notbiggenre &&
          genre == other.genre &&
          notgenre == other.notgenre &&
          userid == other.userid &&
          isr15 == other.isr15 &&
          isbl == other.isbl &&
          isgl == other.isgl &&
          iszankoku == other.iszankoku &&
          istensei == other.istensei &&
          istenni == other.istenni &&
          istt == other.istt &&
          notr15 == other.notr15 &&
          notbl == other.notbl &&
          notgl == other.notgl &&
          notzankoku == other.notzankoku &&
          nottensei == other.nottensei &&
          nottenni == other.nottenni &&
          minlen == other.minlen &&
          maxlen == other.maxlen &&
          length == other.length &&
          kaiwaritu == other.kaiwaritu &&
          sasie == other.sasie &&
          mintime == other.mintime &&
          maxtime == other.maxtime &&
          time == other.time &&
          ncode == other.ncode &&
          type == other.type &&
          buntai == other.buntai &&
          stop == other.stop &&
          lastup == other.lastup &&
          lastupdate == other.lastupdate &&
          ispickup == other.ispickup &&
          order == other.order &&
          lim == other.lim &&
          st == other.st;

  @override
  int get hashCode => Object.hash(
    word,
    title,
    ex,
    keyword,
    wname,
    biggenre,
    genre,
    userid,
    isr15,
    isbl,
    isgl,
    iszankoku,
    istensei,
    istenni,
    minlen,
    maxlen,
    ncode,
    type,
    order,
    st,
  );

  @override
  String toString() =>
      'NovelSearchQuery(word: $word, order: $order, lim: $lim, st: $st)';
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
      'genre': genre?.join('-'),
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
