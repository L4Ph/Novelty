// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'novel_search_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NovelSearchQuery {

/// 検索単語。
///
/// 半角または全角スペースで区切るとAND抽出になる。
 String? get word;/// 除外単語。
///
/// スペースで区切ることにより除外単語を増やせる。
 String? get notword;/// タイトルを検索対象にするか。
 bool get title;/// あらすじを検索対象にするか。
 bool get ex;/// キーワードを検索対象にするか。
 bool get keyword;/// 作者名を検索対象にするか。
 bool get wname;/// 大ジャンル。
///
/// [大ジャンル一覧](https://dev.syosetu.com/man/api/#biggenre)
 List<int>? get biggenre;/// 除外大ジャンル。
///
/// [大ジャンル一覧](https://dev.syosetu.com/man/api/#biggenre)
 List<int>? get notbiggenre;/// ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
 List<int>? get genre;/// 除外ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
 List<int>? get notgenre;/// ユーザID。
 List<int>? get userid;/// R15作品のみを対象とするか。
 bool get isr15;/// ボーイズラブ作品のみを対象とするか。
 bool get isbl;/// ガールズラブ作品のみを対象とするか。
 bool get isgl;/// 残酷な描写あり作品のみを対象とするか。
 bool get iszankoku;/// 異世界転生作品のみを対象とするか。
 bool get istensei;/// 異世界転移作品のみを対象とするか。
 bool get istenni;/// 異世界転生・転移作品のみを対象とするか。
 bool get istt;/// R15作品を除外するか。
 bool get notr15;/// ボーイズラブ作品を除外するか。
 bool get notbl;/// ガールズラブ作品を除外するか。
 bool get notgl;/// 残酷な描写あり作品を除外するか。
 bool get notzankoku;/// 異世界転生作品を除外するか。
 bool get nottensei;/// 異世界転移作品を除外するか。
 bool get nottenni;/// 最小文字数。
 int? get minlen;/// 最大文字数。
 int? get maxlen;/// 文字数範囲。
///
/// `minlen` または `maxlen` と併用はできない。
/// 範囲指定する場合は、最小文字数と最大文字数をハイフン(-)記号で区切る。
 String? get length;/// 会話率範囲。
///
/// 範囲指定する場合は、最低数と最大数をハイフン(-)記号で区切る。
 String? get kaiwaritu;/// 挿絵数範囲。
///
/// 範囲指定する場合は、最小数と最大数をハイフン(-)記号で区切る。
 String? get sasie;/// 最小読了時間(分単位)。
 int? get mintime;/// 最大読了時間(分単位)。
 int? get maxtime;/// 読了時間範囲。
///
/// `mintime` または `maxtime` と併用はできない。
/// 範囲指定する場合は、最小読了時間と最大読了時間をハイフン(-)記号で区切る。
 String? get time;/// Nコード。
///
/// ハイフン(-)記号で区切ればOR検索ができる。
 List<String>? get ncode;/// 作品タイプ。
///
/// * `t` - 短編
/// * `r` - 連載中
/// * `er` - 完結済連載作品
/// * `re` - すべての連載作品(連載中および完結済)
/// * `ter` - 短編と完結済連載作品
 String? get type;/// 文体。
///
/// ハイフン(-)記号で区切ればOR検索ができる。
/// * `1` - 字下げされておらず、連続改行が多い作品
/// * `2` - 字下げされていないが、改行数は平均な作品
/// * `4` - 字下げが適切だが、連続改行が多い作品
/// * `6` - 字下げが適切でかつ改行数も平均な作品
 List<int>? get buntai;/// 長期連載停止中作品に関する指定。
///
/// * `1` - 長期連載停止中を除きます
/// * `2` - 長期連載停止中のみ取得します
 int? get stop;/// 最終掲載日で抽出。
///
/// * `thisweek` - 今週
/// * `lastweek` - 先週
/// * `sevenday` - 過去7日間
/// * `thismonth` - 今月
/// * `lastmonth` - 先月
/// * `unixtime-unixtime` - UNIXタイムスタンプで範囲指定
 String? get lastup;/// 最終更新日で抽出。
///
/// * `thisweek` - 今週
/// * `lastweek` - 先週
/// * `sevenday` - 過去7日間
/// * `thismonth` - 今月
/// * `lastmonth` - 先月
/// * `unixtime-unixtime` - UNIXタイムスタンプで範囲指定
 String? get lastupdate;/// ピックアップ作品のみを対象とするか。
 bool get ispickup;/// 出力順序。
///
/// デフォルトは `new` (新着更新順)。
/// [出力順序一覧](https://dev.syosetu.com/man/api/#order)
 String get order;/// 最大出力数。
///
/// 1～500。���フォルトは20。
 int get lim;/// 表示開始位置。
///
/// 1～2000。デフォルトは1。
 int get st;
/// Create a copy of NovelSearchQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NovelSearchQueryCopyWith<NovelSearchQuery> get copyWith => _$NovelSearchQueryCopyWithImpl<NovelSearchQuery>(this as NovelSearchQuery, _$identity);

  /// Serializes this NovelSearchQuery to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NovelSearchQuery&&(identical(other.word, word) || other.word == word)&&(identical(other.notword, notword) || other.notword == notword)&&(identical(other.title, title) || other.title == title)&&(identical(other.ex, ex) || other.ex == ex)&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.wname, wname) || other.wname == wname)&&const DeepCollectionEquality().equals(other.biggenre, biggenre)&&const DeepCollectionEquality().equals(other.notbiggenre, notbiggenre)&&const DeepCollectionEquality().equals(other.genre, genre)&&const DeepCollectionEquality().equals(other.notgenre, notgenre)&&const DeepCollectionEquality().equals(other.userid, userid)&&(identical(other.isr15, isr15) || other.isr15 == isr15)&&(identical(other.isbl, isbl) || other.isbl == isbl)&&(identical(other.isgl, isgl) || other.isgl == isgl)&&(identical(other.iszankoku, iszankoku) || other.iszankoku == iszankoku)&&(identical(other.istensei, istensei) || other.istensei == istensei)&&(identical(other.istenni, istenni) || other.istenni == istenni)&&(identical(other.istt, istt) || other.istt == istt)&&(identical(other.notr15, notr15) || other.notr15 == notr15)&&(identical(other.notbl, notbl) || other.notbl == notbl)&&(identical(other.notgl, notgl) || other.notgl == notgl)&&(identical(other.notzankoku, notzankoku) || other.notzankoku == notzankoku)&&(identical(other.nottensei, nottensei) || other.nottensei == nottensei)&&(identical(other.nottenni, nottenni) || other.nottenni == nottenni)&&(identical(other.minlen, minlen) || other.minlen == minlen)&&(identical(other.maxlen, maxlen) || other.maxlen == maxlen)&&(identical(other.length, length) || other.length == length)&&(identical(other.kaiwaritu, kaiwaritu) || other.kaiwaritu == kaiwaritu)&&(identical(other.sasie, sasie) || other.sasie == sasie)&&(identical(other.mintime, mintime) || other.mintime == mintime)&&(identical(other.maxtime, maxtime) || other.maxtime == maxtime)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other.ncode, ncode)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.buntai, buntai)&&(identical(other.stop, stop) || other.stop == stop)&&(identical(other.lastup, lastup) || other.lastup == lastup)&&(identical(other.lastupdate, lastupdate) || other.lastupdate == lastupdate)&&(identical(other.ispickup, ispickup) || other.ispickup == ispickup)&&(identical(other.order, order) || other.order == order)&&(identical(other.lim, lim) || other.lim == lim)&&(identical(other.st, st) || other.st == st));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,word,notword,title,ex,keyword,wname,const DeepCollectionEquality().hash(biggenre),const DeepCollectionEquality().hash(notbiggenre),const DeepCollectionEquality().hash(genre),const DeepCollectionEquality().hash(notgenre),const DeepCollectionEquality().hash(userid),isr15,isbl,isgl,iszankoku,istensei,istenni,istt,notr15,notbl,notgl,notzankoku,nottensei,nottenni,minlen,maxlen,length,kaiwaritu,sasie,mintime,maxtime,time,const DeepCollectionEquality().hash(ncode),type,const DeepCollectionEquality().hash(buntai),stop,lastup,lastupdate,ispickup,order,lim,st]);

@override
String toString() {
  return 'NovelSearchQuery(word: $word, notword: $notword, title: $title, ex: $ex, keyword: $keyword, wname: $wname, biggenre: $biggenre, notbiggenre: $notbiggenre, genre: $genre, notgenre: $notgenre, userid: $userid, isr15: $isr15, isbl: $isbl, isgl: $isgl, iszankoku: $iszankoku, istensei: $istensei, istenni: $istenni, istt: $istt, notr15: $notr15, notbl: $notbl, notgl: $notgl, notzankoku: $notzankoku, nottensei: $nottensei, nottenni: $nottenni, minlen: $minlen, maxlen: $maxlen, length: $length, kaiwaritu: $kaiwaritu, sasie: $sasie, mintime: $mintime, maxtime: $maxtime, time: $time, ncode: $ncode, type: $type, buntai: $buntai, stop: $stop, lastup: $lastup, lastupdate: $lastupdate, ispickup: $ispickup, order: $order, lim: $lim, st: $st)';
}


}

/// @nodoc
abstract mixin class $NovelSearchQueryCopyWith<$Res>  {
  factory $NovelSearchQueryCopyWith(NovelSearchQuery value, $Res Function(NovelSearchQuery) _then) = _$NovelSearchQueryCopyWithImpl;
@useResult
$Res call({
 String? word, String? notword, bool title, bool ex, bool keyword, bool wname, List<int>? biggenre, List<int>? notbiggenre, List<int>? genre, List<int>? notgenre, List<int>? userid, bool isr15, bool isbl, bool isgl, bool iszankoku, bool istensei, bool istenni, bool istt, bool notr15, bool notbl, bool notgl, bool notzankoku, bool nottensei, bool nottenni, int? minlen, int? maxlen, String? length, String? kaiwaritu, String? sasie, int? mintime, int? maxtime, String? time, List<String>? ncode, String? type, List<int>? buntai, int? stop, String? lastup, String? lastupdate, bool ispickup, String order, int lim, int st
});




}
/// @nodoc
class _$NovelSearchQueryCopyWithImpl<$Res>
    implements $NovelSearchQueryCopyWith<$Res> {
  _$NovelSearchQueryCopyWithImpl(this._self, this._then);

  final NovelSearchQuery _self;
  final $Res Function(NovelSearchQuery) _then;

/// Create a copy of NovelSearchQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = freezed,Object? notword = freezed,Object? title = null,Object? ex = null,Object? keyword = null,Object? wname = null,Object? biggenre = freezed,Object? notbiggenre = freezed,Object? genre = freezed,Object? notgenre = freezed,Object? userid = freezed,Object? isr15 = null,Object? isbl = null,Object? isgl = null,Object? iszankoku = null,Object? istensei = null,Object? istenni = null,Object? istt = null,Object? notr15 = null,Object? notbl = null,Object? notgl = null,Object? notzankoku = null,Object? nottensei = null,Object? nottenni = null,Object? minlen = freezed,Object? maxlen = freezed,Object? length = freezed,Object? kaiwaritu = freezed,Object? sasie = freezed,Object? mintime = freezed,Object? maxtime = freezed,Object? time = freezed,Object? ncode = freezed,Object? type = freezed,Object? buntai = freezed,Object? stop = freezed,Object? lastup = freezed,Object? lastupdate = freezed,Object? ispickup = null,Object? order = null,Object? lim = null,Object? st = null,}) {
  return _then(_self.copyWith(
word: freezed == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String?,notword: freezed == notword ? _self.notword : notword // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as bool,ex: null == ex ? _self.ex : ex // ignore: cast_nullable_to_non_nullable
as bool,keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as bool,wname: null == wname ? _self.wname : wname // ignore: cast_nullable_to_non_nullable
as bool,biggenre: freezed == biggenre ? _self.biggenre : biggenre // ignore: cast_nullable_to_non_nullable
as List<int>?,notbiggenre: freezed == notbiggenre ? _self.notbiggenre : notbiggenre // ignore: cast_nullable_to_non_nullable
as List<int>?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as List<int>?,notgenre: freezed == notgenre ? _self.notgenre : notgenre // ignore: cast_nullable_to_non_nullable
as List<int>?,userid: freezed == userid ? _self.userid : userid // ignore: cast_nullable_to_non_nullable
as List<int>?,isr15: null == isr15 ? _self.isr15 : isr15 // ignore: cast_nullable_to_non_nullable
as bool,isbl: null == isbl ? _self.isbl : isbl // ignore: cast_nullable_to_non_nullable
as bool,isgl: null == isgl ? _self.isgl : isgl // ignore: cast_nullable_to_non_nullable
as bool,iszankoku: null == iszankoku ? _self.iszankoku : iszankoku // ignore: cast_nullable_to_non_nullable
as bool,istensei: null == istensei ? _self.istensei : istensei // ignore: cast_nullable_to_non_nullable
as bool,istenni: null == istenni ? _self.istenni : istenni // ignore: cast_nullable_to_non_nullable
as bool,istt: null == istt ? _self.istt : istt // ignore: cast_nullable_to_non_nullable
as bool,notr15: null == notr15 ? _self.notr15 : notr15 // ignore: cast_nullable_to_non_nullable
as bool,notbl: null == notbl ? _self.notbl : notbl // ignore: cast_nullable_to_non_nullable
as bool,notgl: null == notgl ? _self.notgl : notgl // ignore: cast_nullable_to_non_nullable
as bool,notzankoku: null == notzankoku ? _self.notzankoku : notzankoku // ignore: cast_nullable_to_non_nullable
as bool,nottensei: null == nottensei ? _self.nottensei : nottensei // ignore: cast_nullable_to_non_nullable
as bool,nottenni: null == nottenni ? _self.nottenni : nottenni // ignore: cast_nullable_to_non_nullable
as bool,minlen: freezed == minlen ? _self.minlen : minlen // ignore: cast_nullable_to_non_nullable
as int?,maxlen: freezed == maxlen ? _self.maxlen : maxlen // ignore: cast_nullable_to_non_nullable
as int?,length: freezed == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as String?,kaiwaritu: freezed == kaiwaritu ? _self.kaiwaritu : kaiwaritu // ignore: cast_nullable_to_non_nullable
as String?,sasie: freezed == sasie ? _self.sasie : sasie // ignore: cast_nullable_to_non_nullable
as String?,mintime: freezed == mintime ? _self.mintime : mintime // ignore: cast_nullable_to_non_nullable
as int?,maxtime: freezed == maxtime ? _self.maxtime : maxtime // ignore: cast_nullable_to_non_nullable
as int?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,ncode: freezed == ncode ? _self.ncode : ncode // ignore: cast_nullable_to_non_nullable
as List<String>?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,buntai: freezed == buntai ? _self.buntai : buntai // ignore: cast_nullable_to_non_nullable
as List<int>?,stop: freezed == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as int?,lastup: freezed == lastup ? _self.lastup : lastup // ignore: cast_nullable_to_non_nullable
as String?,lastupdate: freezed == lastupdate ? _self.lastupdate : lastupdate // ignore: cast_nullable_to_non_nullable
as String?,ispickup: null == ispickup ? _self.ispickup : ispickup // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,lim: null == lim ? _self.lim : lim // ignore: cast_nullable_to_non_nullable
as int,st: null == st ? _self.st : st // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NovelSearchQuery].
extension NovelSearchQueryPatterns on NovelSearchQuery {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NovelSearchQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NovelSearchQuery() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NovelSearchQuery value)  $default,){
final _that = this;
switch (_that) {
case _NovelSearchQuery():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NovelSearchQuery value)?  $default,){
final _that = this;
switch (_that) {
case _NovelSearchQuery() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? word,  String? notword,  bool title,  bool ex,  bool keyword,  bool wname,  List<int>? biggenre,  List<int>? notbiggenre,  List<int>? genre,  List<int>? notgenre,  List<int>? userid,  bool isr15,  bool isbl,  bool isgl,  bool iszankoku,  bool istensei,  bool istenni,  bool istt,  bool notr15,  bool notbl,  bool notgl,  bool notzankoku,  bool nottensei,  bool nottenni,  int? minlen,  int? maxlen,  String? length,  String? kaiwaritu,  String? sasie,  int? mintime,  int? maxtime,  String? time,  List<String>? ncode,  String? type,  List<int>? buntai,  int? stop,  String? lastup,  String? lastupdate,  bool ispickup,  String order,  int lim,  int st)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NovelSearchQuery() when $default != null:
return $default(_that.word,_that.notword,_that.title,_that.ex,_that.keyword,_that.wname,_that.biggenre,_that.notbiggenre,_that.genre,_that.notgenre,_that.userid,_that.isr15,_that.isbl,_that.isgl,_that.iszankoku,_that.istensei,_that.istenni,_that.istt,_that.notr15,_that.notbl,_that.notgl,_that.notzankoku,_that.nottensei,_that.nottenni,_that.minlen,_that.maxlen,_that.length,_that.kaiwaritu,_that.sasie,_that.mintime,_that.maxtime,_that.time,_that.ncode,_that.type,_that.buntai,_that.stop,_that.lastup,_that.lastupdate,_that.ispickup,_that.order,_that.lim,_that.st);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? word,  String? notword,  bool title,  bool ex,  bool keyword,  bool wname,  List<int>? biggenre,  List<int>? notbiggenre,  List<int>? genre,  List<int>? notgenre,  List<int>? userid,  bool isr15,  bool isbl,  bool isgl,  bool iszankoku,  bool istensei,  bool istenni,  bool istt,  bool notr15,  bool notbl,  bool notgl,  bool notzankoku,  bool nottensei,  bool nottenni,  int? minlen,  int? maxlen,  String? length,  String? kaiwaritu,  String? sasie,  int? mintime,  int? maxtime,  String? time,  List<String>? ncode,  String? type,  List<int>? buntai,  int? stop,  String? lastup,  String? lastupdate,  bool ispickup,  String order,  int lim,  int st)  $default,) {final _that = this;
switch (_that) {
case _NovelSearchQuery():
return $default(_that.word,_that.notword,_that.title,_that.ex,_that.keyword,_that.wname,_that.biggenre,_that.notbiggenre,_that.genre,_that.notgenre,_that.userid,_that.isr15,_that.isbl,_that.isgl,_that.iszankoku,_that.istensei,_that.istenni,_that.istt,_that.notr15,_that.notbl,_that.notgl,_that.notzankoku,_that.nottensei,_that.nottenni,_that.minlen,_that.maxlen,_that.length,_that.kaiwaritu,_that.sasie,_that.mintime,_that.maxtime,_that.time,_that.ncode,_that.type,_that.buntai,_that.stop,_that.lastup,_that.lastupdate,_that.ispickup,_that.order,_that.lim,_that.st);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? word,  String? notword,  bool title,  bool ex,  bool keyword,  bool wname,  List<int>? biggenre,  List<int>? notbiggenre,  List<int>? genre,  List<int>? notgenre,  List<int>? userid,  bool isr15,  bool isbl,  bool isgl,  bool iszankoku,  bool istensei,  bool istenni,  bool istt,  bool notr15,  bool notbl,  bool notgl,  bool notzankoku,  bool nottensei,  bool nottenni,  int? minlen,  int? maxlen,  String? length,  String? kaiwaritu,  String? sasie,  int? mintime,  int? maxtime,  String? time,  List<String>? ncode,  String? type,  List<int>? buntai,  int? stop,  String? lastup,  String? lastupdate,  bool ispickup,  String order,  int lim,  int st)?  $default,) {final _that = this;
switch (_that) {
case _NovelSearchQuery() when $default != null:
return $default(_that.word,_that.notword,_that.title,_that.ex,_that.keyword,_that.wname,_that.biggenre,_that.notbiggenre,_that.genre,_that.notgenre,_that.userid,_that.isr15,_that.isbl,_that.isgl,_that.iszankoku,_that.istensei,_that.istenni,_that.istt,_that.notr15,_that.notbl,_that.notgl,_that.notzankoku,_that.nottensei,_that.nottenni,_that.minlen,_that.maxlen,_that.length,_that.kaiwaritu,_that.sasie,_that.mintime,_that.maxtime,_that.time,_that.ncode,_that.type,_that.buntai,_that.stop,_that.lastup,_that.lastupdate,_that.ispickup,_that.order,_that.lim,_that.st);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NovelSearchQuery implements NovelSearchQuery {
  const _NovelSearchQuery({this.word, this.notword, this.title = false, this.ex = false, this.keyword = false, this.wname = false, final  List<int>? biggenre, final  List<int>? notbiggenre, final  List<int>? genre, final  List<int>? notgenre, final  List<int>? userid, this.isr15 = false, this.isbl = false, this.isgl = false, this.iszankoku = false, this.istensei = false, this.istenni = false, this.istt = false, this.notr15 = false, this.notbl = false, this.notgl = false, this.notzankoku = false, this.nottensei = false, this.nottenni = false, this.minlen, this.maxlen, this.length, this.kaiwaritu, this.sasie, this.mintime, this.maxtime, this.time, final  List<String>? ncode, this.type, final  List<int>? buntai, this.stop, this.lastup, this.lastupdate, this.ispickup = false, this.order = 'new', this.lim = 20, this.st = 1}): _biggenre = biggenre,_notbiggenre = notbiggenre,_genre = genre,_notgenre = notgenre,_userid = userid,_ncode = ncode,_buntai = buntai;
  factory _NovelSearchQuery.fromJson(Map<String, dynamic> json) => _$NovelSearchQueryFromJson(json);

/// 検索単語。
///
/// 半角または全角スペースで区切るとAND抽出になる。
@override final  String? word;
/// 除外単語。
///
/// スペースで区切ることにより除外単語を増やせる。
@override final  String? notword;
/// タイトルを検索対象にするか。
@override@JsonKey() final  bool title;
/// あらすじを検索対象にするか。
@override@JsonKey() final  bool ex;
/// キーワードを検索対象にするか。
@override@JsonKey() final  bool keyword;
/// 作者名を検索対象にするか。
@override@JsonKey() final  bool wname;
/// 大ジャンル。
///
/// [大ジャンル一覧](https://dev.syosetu.com/man/api/#biggenre)
 final  List<int>? _biggenre;
/// 大ジャンル。
///
/// [大ジャンル一覧](https://dev.syosetu.com/man/api/#biggenre)
@override List<int>? get biggenre {
  final value = _biggenre;
  if (value == null) return null;
  if (_biggenre is EqualUnmodifiableListView) return _biggenre;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// 除外大ジャンル。
///
/// [大ジャンル一覧](https://dev.syosetu.com/man/api/#biggenre)
 final  List<int>? _notbiggenre;
/// 除外大ジャンル。
///
/// [大ジャンル一覧](https://dev.syosetu.com/man/api/#biggenre)
@override List<int>? get notbiggenre {
  final value = _notbiggenre;
  if (value == null) return null;
  if (_notbiggenre is EqualUnmodifiableListView) return _notbiggenre;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
 final  List<int>? _genre;
/// ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
@override List<int>? get genre {
  final value = _genre;
  if (value == null) return null;
  if (_genre is EqualUnmodifiableListView) return _genre;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// 除外ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
 final  List<int>? _notgenre;
/// 除外ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
@override List<int>? get notgenre {
  final value = _notgenre;
  if (value == null) return null;
  if (_notgenre is EqualUnmodifiableListView) return _notgenre;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// ユーザID。
 final  List<int>? _userid;
/// ユーザID。
@override List<int>? get userid {
  final value = _userid;
  if (value == null) return null;
  if (_userid is EqualUnmodifiableListView) return _userid;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// R15作品のみを対象とするか。
@override@JsonKey() final  bool isr15;
/// ボーイズラブ作品のみを対象とするか。
@override@JsonKey() final  bool isbl;
/// ガールズラブ作品のみを対象とするか。
@override@JsonKey() final  bool isgl;
/// 残酷な描写あり作品のみを対象とするか。
@override@JsonKey() final  bool iszankoku;
/// 異世界転生作品のみを対象とするか。
@override@JsonKey() final  bool istensei;
/// 異世界転移作品のみを対象とするか。
@override@JsonKey() final  bool istenni;
/// 異世界転生・転移作品のみを対象とするか。
@override@JsonKey() final  bool istt;
/// R15作品を除外するか。
@override@JsonKey() final  bool notr15;
/// ボーイズラブ作品を除外するか。
@override@JsonKey() final  bool notbl;
/// ガールズラブ作品を除外するか。
@override@JsonKey() final  bool notgl;
/// 残酷な描写あり作品を除外するか。
@override@JsonKey() final  bool notzankoku;
/// 異世界転生作品を除外するか。
@override@JsonKey() final  bool nottensei;
/// 異世界転移作品を除外するか。
@override@JsonKey() final  bool nottenni;
/// 最小文字数。
@override final  int? minlen;
/// 最大文字数。
@override final  int? maxlen;
/// 文字数範囲。
///
/// `minlen` または `maxlen` と併用はできない。
/// 範囲指定する場合は、最小文字数と最大文字数をハイフン(-)記号で区切る。
@override final  String? length;
/// 会話率範囲。
///
/// 範囲指定する場合は、最低数と最大数をハイフン(-)記号で区切る。
@override final  String? kaiwaritu;
/// 挿絵数範囲。
///
/// 範囲指定する場合は、最小数と最大数をハイフン(-)記号で区切る。
@override final  String? sasie;
/// 最小読了時間(分単位)。
@override final  int? mintime;
/// 最大読了時間(分単位)。
@override final  int? maxtime;
/// 読了時間範囲。
///
/// `mintime` または `maxtime` と併用はできない。
/// 範囲指定する場合は、最小読了時間と最大読了時間をハイフン(-)記号で区切る。
@override final  String? time;
/// Nコード。
///
/// ハイフン(-)記号で区切ればOR検索ができる。
 final  List<String>? _ncode;
/// Nコード。
///
/// ハイフン(-)記号で区切ればOR検索ができる。
@override List<String>? get ncode {
  final value = _ncode;
  if (value == null) return null;
  if (_ncode is EqualUnmodifiableListView) return _ncode;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// 作品タイプ。
///
/// * `t` - 短編
/// * `r` - 連載中
/// * `er` - 完結済連載作品
/// * `re` - すべての連載作品(連載中および完結済)
/// * `ter` - 短編と完結済連載作品
@override final  String? type;
/// 文体。
///
/// ハイフン(-)記号で区切ればOR検索ができる。
/// * `1` - 字下げされておらず、連続改行が多い作品
/// * `2` - 字下げされていないが、改行数は平均な作品
/// * `4` - 字下げが適切だが、連続改行が多い作品
/// * `6` - 字下げが適切でかつ改行数も平均な作品
 final  List<int>? _buntai;
/// 文体。
///
/// ハイフン(-)記号で区切ればOR検索ができる。
/// * `1` - 字下げされておらず、連続改行が多い作品
/// * `2` - 字下げされていないが、改行数は平均な作品
/// * `4` - 字下げが適切だが、連続改行が多い作品
/// * `6` - 字下げが適切でかつ改行数も平均な作品
@override List<int>? get buntai {
  final value = _buntai;
  if (value == null) return null;
  if (_buntai is EqualUnmodifiableListView) return _buntai;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// 長期連載停止中作品に関する指定。
///
/// * `1` - 長期連載停止中を除きます
/// * `2` - 長期連載停止中のみ取得します
@override final  int? stop;
/// 最終掲載日で抽出。
///
/// * `thisweek` - 今週
/// * `lastweek` - 先週
/// * `sevenday` - 過去7日間
/// * `thismonth` - 今月
/// * `lastmonth` - 先月
/// * `unixtime-unixtime` - UNIXタイムスタンプで範囲指定
@override final  String? lastup;
/// 最終更新日で抽出。
///
/// * `thisweek` - 今週
/// * `lastweek` - 先週
/// * `sevenday` - 過去7日間
/// * `thismonth` - 今月
/// * `lastmonth` - 先月
/// * `unixtime-unixtime` - UNIXタイムスタンプで範囲指定
@override final  String? lastupdate;
/// ピックアップ作品のみを対象とするか。
@override@JsonKey() final  bool ispickup;
/// 出力順序。
///
/// デフォルトは `new` (新着更新順)。
/// [出力順序一覧](https://dev.syosetu.com/man/api/#order)
@override@JsonKey() final  String order;
/// 最大出力数。
///
/// 1～500。���フォルトは20。
@override@JsonKey() final  int lim;
/// 表示開始位置。
///
/// 1～2000。デフォルトは1。
@override@JsonKey() final  int st;

/// Create a copy of NovelSearchQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NovelSearchQueryCopyWith<_NovelSearchQuery> get copyWith => __$NovelSearchQueryCopyWithImpl<_NovelSearchQuery>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NovelSearchQueryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NovelSearchQuery&&(identical(other.word, word) || other.word == word)&&(identical(other.notword, notword) || other.notword == notword)&&(identical(other.title, title) || other.title == title)&&(identical(other.ex, ex) || other.ex == ex)&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.wname, wname) || other.wname == wname)&&const DeepCollectionEquality().equals(other._biggenre, _biggenre)&&const DeepCollectionEquality().equals(other._notbiggenre, _notbiggenre)&&const DeepCollectionEquality().equals(other._genre, _genre)&&const DeepCollectionEquality().equals(other._notgenre, _notgenre)&&const DeepCollectionEquality().equals(other._userid, _userid)&&(identical(other.isr15, isr15) || other.isr15 == isr15)&&(identical(other.isbl, isbl) || other.isbl == isbl)&&(identical(other.isgl, isgl) || other.isgl == isgl)&&(identical(other.iszankoku, iszankoku) || other.iszankoku == iszankoku)&&(identical(other.istensei, istensei) || other.istensei == istensei)&&(identical(other.istenni, istenni) || other.istenni == istenni)&&(identical(other.istt, istt) || other.istt == istt)&&(identical(other.notr15, notr15) || other.notr15 == notr15)&&(identical(other.notbl, notbl) || other.notbl == notbl)&&(identical(other.notgl, notgl) || other.notgl == notgl)&&(identical(other.notzankoku, notzankoku) || other.notzankoku == notzankoku)&&(identical(other.nottensei, nottensei) || other.nottensei == nottensei)&&(identical(other.nottenni, nottenni) || other.nottenni == nottenni)&&(identical(other.minlen, minlen) || other.minlen == minlen)&&(identical(other.maxlen, maxlen) || other.maxlen == maxlen)&&(identical(other.length, length) || other.length == length)&&(identical(other.kaiwaritu, kaiwaritu) || other.kaiwaritu == kaiwaritu)&&(identical(other.sasie, sasie) || other.sasie == sasie)&&(identical(other.mintime, mintime) || other.mintime == mintime)&&(identical(other.maxtime, maxtime) || other.maxtime == maxtime)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other._ncode, _ncode)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._buntai, _buntai)&&(identical(other.stop, stop) || other.stop == stop)&&(identical(other.lastup, lastup) || other.lastup == lastup)&&(identical(other.lastupdate, lastupdate) || other.lastupdate == lastupdate)&&(identical(other.ispickup, ispickup) || other.ispickup == ispickup)&&(identical(other.order, order) || other.order == order)&&(identical(other.lim, lim) || other.lim == lim)&&(identical(other.st, st) || other.st == st));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,word,notword,title,ex,keyword,wname,const DeepCollectionEquality().hash(_biggenre),const DeepCollectionEquality().hash(_notbiggenre),const DeepCollectionEquality().hash(_genre),const DeepCollectionEquality().hash(_notgenre),const DeepCollectionEquality().hash(_userid),isr15,isbl,isgl,iszankoku,istensei,istenni,istt,notr15,notbl,notgl,notzankoku,nottensei,nottenni,minlen,maxlen,length,kaiwaritu,sasie,mintime,maxtime,time,const DeepCollectionEquality().hash(_ncode),type,const DeepCollectionEquality().hash(_buntai),stop,lastup,lastupdate,ispickup,order,lim,st]);

@override
String toString() {
  return 'NovelSearchQuery(word: $word, notword: $notword, title: $title, ex: $ex, keyword: $keyword, wname: $wname, biggenre: $biggenre, notbiggenre: $notbiggenre, genre: $genre, notgenre: $notgenre, userid: $userid, isr15: $isr15, isbl: $isbl, isgl: $isgl, iszankoku: $iszankoku, istensei: $istensei, istenni: $istenni, istt: $istt, notr15: $notr15, notbl: $notbl, notgl: $notgl, notzankoku: $notzankoku, nottensei: $nottensei, nottenni: $nottenni, minlen: $minlen, maxlen: $maxlen, length: $length, kaiwaritu: $kaiwaritu, sasie: $sasie, mintime: $mintime, maxtime: $maxtime, time: $time, ncode: $ncode, type: $type, buntai: $buntai, stop: $stop, lastup: $lastup, lastupdate: $lastupdate, ispickup: $ispickup, order: $order, lim: $lim, st: $st)';
}


}

/// @nodoc
abstract mixin class _$NovelSearchQueryCopyWith<$Res> implements $NovelSearchQueryCopyWith<$Res> {
  factory _$NovelSearchQueryCopyWith(_NovelSearchQuery value, $Res Function(_NovelSearchQuery) _then) = __$NovelSearchQueryCopyWithImpl;
@override @useResult
$Res call({
 String? word, String? notword, bool title, bool ex, bool keyword, bool wname, List<int>? biggenre, List<int>? notbiggenre, List<int>? genre, List<int>? notgenre, List<int>? userid, bool isr15, bool isbl, bool isgl, bool iszankoku, bool istensei, bool istenni, bool istt, bool notr15, bool notbl, bool notgl, bool notzankoku, bool nottensei, bool nottenni, int? minlen, int? maxlen, String? length, String? kaiwaritu, String? sasie, int? mintime, int? maxtime, String? time, List<String>? ncode, String? type, List<int>? buntai, int? stop, String? lastup, String? lastupdate, bool ispickup, String order, int lim, int st
});




}
/// @nodoc
class __$NovelSearchQueryCopyWithImpl<$Res>
    implements _$NovelSearchQueryCopyWith<$Res> {
  __$NovelSearchQueryCopyWithImpl(this._self, this._then);

  final _NovelSearchQuery _self;
  final $Res Function(_NovelSearchQuery) _then;

/// Create a copy of NovelSearchQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = freezed,Object? notword = freezed,Object? title = null,Object? ex = null,Object? keyword = null,Object? wname = null,Object? biggenre = freezed,Object? notbiggenre = freezed,Object? genre = freezed,Object? notgenre = freezed,Object? userid = freezed,Object? isr15 = null,Object? isbl = null,Object? isgl = null,Object? iszankoku = null,Object? istensei = null,Object? istenni = null,Object? istt = null,Object? notr15 = null,Object? notbl = null,Object? notgl = null,Object? notzankoku = null,Object? nottensei = null,Object? nottenni = null,Object? minlen = freezed,Object? maxlen = freezed,Object? length = freezed,Object? kaiwaritu = freezed,Object? sasie = freezed,Object? mintime = freezed,Object? maxtime = freezed,Object? time = freezed,Object? ncode = freezed,Object? type = freezed,Object? buntai = freezed,Object? stop = freezed,Object? lastup = freezed,Object? lastupdate = freezed,Object? ispickup = null,Object? order = null,Object? lim = null,Object? st = null,}) {
  return _then(_NovelSearchQuery(
word: freezed == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String?,notword: freezed == notword ? _self.notword : notword // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as bool,ex: null == ex ? _self.ex : ex // ignore: cast_nullable_to_non_nullable
as bool,keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as bool,wname: null == wname ? _self.wname : wname // ignore: cast_nullable_to_non_nullable
as bool,biggenre: freezed == biggenre ? _self._biggenre : biggenre // ignore: cast_nullable_to_non_nullable
as List<int>?,notbiggenre: freezed == notbiggenre ? _self._notbiggenre : notbiggenre // ignore: cast_nullable_to_non_nullable
as List<int>?,genre: freezed == genre ? _self._genre : genre // ignore: cast_nullable_to_non_nullable
as List<int>?,notgenre: freezed == notgenre ? _self._notgenre : notgenre // ignore: cast_nullable_to_non_nullable
as List<int>?,userid: freezed == userid ? _self._userid : userid // ignore: cast_nullable_to_non_nullable
as List<int>?,isr15: null == isr15 ? _self.isr15 : isr15 // ignore: cast_nullable_to_non_nullable
as bool,isbl: null == isbl ? _self.isbl : isbl // ignore: cast_nullable_to_non_nullable
as bool,isgl: null == isgl ? _self.isgl : isgl // ignore: cast_nullable_to_non_nullable
as bool,iszankoku: null == iszankoku ? _self.iszankoku : iszankoku // ignore: cast_nullable_to_non_nullable
as bool,istensei: null == istensei ? _self.istensei : istensei // ignore: cast_nullable_to_non_nullable
as bool,istenni: null == istenni ? _self.istenni : istenni // ignore: cast_nullable_to_non_nullable
as bool,istt: null == istt ? _self.istt : istt // ignore: cast_nullable_to_non_nullable
as bool,notr15: null == notr15 ? _self.notr15 : notr15 // ignore: cast_nullable_to_non_nullable
as bool,notbl: null == notbl ? _self.notbl : notbl // ignore: cast_nullable_to_non_nullable
as bool,notgl: null == notgl ? _self.notgl : notgl // ignore: cast_nullable_to_non_nullable
as bool,notzankoku: null == notzankoku ? _self.notzankoku : notzankoku // ignore: cast_nullable_to_non_nullable
as bool,nottensei: null == nottensei ? _self.nottensei : nottensei // ignore: cast_nullable_to_non_nullable
as bool,nottenni: null == nottenni ? _self.nottenni : nottenni // ignore: cast_nullable_to_non_nullable
as bool,minlen: freezed == minlen ? _self.minlen : minlen // ignore: cast_nullable_to_non_nullable
as int?,maxlen: freezed == maxlen ? _self.maxlen : maxlen // ignore: cast_nullable_to_non_nullable
as int?,length: freezed == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as String?,kaiwaritu: freezed == kaiwaritu ? _self.kaiwaritu : kaiwaritu // ignore: cast_nullable_to_non_nullable
as String?,sasie: freezed == sasie ? _self.sasie : sasie // ignore: cast_nullable_to_non_nullable
as String?,mintime: freezed == mintime ? _self.mintime : mintime // ignore: cast_nullable_to_non_nullable
as int?,maxtime: freezed == maxtime ? _self.maxtime : maxtime // ignore: cast_nullable_to_non_nullable
as int?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,ncode: freezed == ncode ? _self._ncode : ncode // ignore: cast_nullable_to_non_nullable
as List<String>?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,buntai: freezed == buntai ? _self._buntai : buntai // ignore: cast_nullable_to_non_nullable
as List<int>?,stop: freezed == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as int?,lastup: freezed == lastup ? _self.lastup : lastup // ignore: cast_nullable_to_non_nullable
as String?,lastupdate: freezed == lastupdate ? _self.lastupdate : lastupdate // ignore: cast_nullable_to_non_nullable
as String?,ispickup: null == ispickup ? _self.ispickup : ispickup // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,lim: null == lim ? _self.lim : lim // ignore: cast_nullable_to_non_nullable
as int,st: null == st ? _self.st : st // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
