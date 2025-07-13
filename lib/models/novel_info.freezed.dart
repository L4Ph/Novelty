// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'novel_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NovelInfo {

/// 作品名。
 String? get title;/// Nコード。
 String? get ncode;/// 作者名。
 String? get writer;/// 作品のあらすじ。
 String? get story;/// 小説タイプ。
///
/// [1] 連載
/// [2] 短編
 int? get novelType;/// 連載状態。
///
/// [0] 短編作品と��結済作品
/// [1] 連載中
 int? get end;/// 全掲載エピソード数。
///
/// 短編の場合は 1。
 int? get generalAllNo;/// ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
 int? get genre;/// キーワード。
 String? get keyword;/// 初回掲載日。
///
/// `YYYY-MM-DD HH:MM:SS` の形式。
 String? get generalFirstup;/// 最終掲載日。
///
/// `YYYY-MM-DD HH:MM:SS` の形式。
 String? get generalLastup;/// 総合評価ポイント。
///
/// (ブックマーク数×2)+評価ポイント。
 int? get globalPoint;/// 日間ポイント。
 int? get dailyPoint;/// 週間ポイント。
 int? get weeklyPoint;/// 月間ポイント。
 int? get monthlyPoint;/// 四半期ポイント。
 int? get quarterPoint;/// 年間ポイント。
 int? get yearlyPoint;/// ブックマーク数。
 int? get favNovelCnt;/// 感想数。
 int? get impressionCnt;/// レビュー数。
 int? get reviewCnt;/// 評価ポイント。
 int? get allPoint;/// 評価者数。
 int? get allHyokaCnt;/// 挿絵の数。
 int? get sasieCnt;/// 会話率。
 int? get kaiwaritu;/// 作品の更新日時。
 int? get novelupdatedAt;/// 最終更新日時。
///
/// システム用で作品更新時とは関係ない。
 int? get updatedAt;/// エピソードのリスト。
 List<Episode>? get episodes;/// R15作品か。
///
/// [1] R15
/// [0] それ以外
 int? get isr15;/// ボーイズラブ作品か。
///
/// [1] ボーイズラブ
/// [0] それ以外
 int? get isbl;/// ガールズラブ作品か。
///
/// [1] ガールズラブ
/// [0] それ以外
 int? get isgl;/// 残酷な描写あり作品か。
///
/// [1] 残酷な描写あり
/// [0] それ以外
 int? get iszankoku;/// 異世界転生作品か。
///
/// [1] 異世界転生
/// [0] それ以外
 int? get istensei;/// 異世界転移作品か。
///
/// [1] 異世界転移
/// [0] それ以外
 int? get istenni;
/// Create a copy of NovelInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NovelInfoCopyWith<NovelInfo> get copyWith => _$NovelInfoCopyWithImpl<NovelInfo>(this as NovelInfo, _$identity);

  /// Serializes this NovelInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NovelInfo&&(identical(other.title, title) || other.title == title)&&(identical(other.ncode, ncode) || other.ncode == ncode)&&(identical(other.writer, writer) || other.writer == writer)&&(identical(other.story, story) || other.story == story)&&(identical(other.novelType, novelType) || other.novelType == novelType)&&(identical(other.end, end) || other.end == end)&&(identical(other.generalAllNo, generalAllNo) || other.generalAllNo == generalAllNo)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.generalFirstup, generalFirstup) || other.generalFirstup == generalFirstup)&&(identical(other.generalLastup, generalLastup) || other.generalLastup == generalLastup)&&(identical(other.globalPoint, globalPoint) || other.globalPoint == globalPoint)&&(identical(other.dailyPoint, dailyPoint) || other.dailyPoint == dailyPoint)&&(identical(other.weeklyPoint, weeklyPoint) || other.weeklyPoint == weeklyPoint)&&(identical(other.monthlyPoint, monthlyPoint) || other.monthlyPoint == monthlyPoint)&&(identical(other.quarterPoint, quarterPoint) || other.quarterPoint == quarterPoint)&&(identical(other.yearlyPoint, yearlyPoint) || other.yearlyPoint == yearlyPoint)&&(identical(other.favNovelCnt, favNovelCnt) || other.favNovelCnt == favNovelCnt)&&(identical(other.impressionCnt, impressionCnt) || other.impressionCnt == impressionCnt)&&(identical(other.reviewCnt, reviewCnt) || other.reviewCnt == reviewCnt)&&(identical(other.allPoint, allPoint) || other.allPoint == allPoint)&&(identical(other.allHyokaCnt, allHyokaCnt) || other.allHyokaCnt == allHyokaCnt)&&(identical(other.sasieCnt, sasieCnt) || other.sasieCnt == sasieCnt)&&(identical(other.kaiwaritu, kaiwaritu) || other.kaiwaritu == kaiwaritu)&&(identical(other.novelupdatedAt, novelupdatedAt) || other.novelupdatedAt == novelupdatedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.episodes, episodes)&&(identical(other.isr15, isr15) || other.isr15 == isr15)&&(identical(other.isbl, isbl) || other.isbl == isbl)&&(identical(other.isgl, isgl) || other.isgl == isgl)&&(identical(other.iszankoku, iszankoku) || other.iszankoku == iszankoku)&&(identical(other.istensei, istensei) || other.istensei == istensei)&&(identical(other.istenni, istenni) || other.istenni == istenni));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,ncode,writer,story,novelType,end,generalAllNo,genre,keyword,generalFirstup,generalLastup,globalPoint,dailyPoint,weeklyPoint,monthlyPoint,quarterPoint,yearlyPoint,favNovelCnt,impressionCnt,reviewCnt,allPoint,allHyokaCnt,sasieCnt,kaiwaritu,novelupdatedAt,updatedAt,const DeepCollectionEquality().hash(episodes),isr15,isbl,isgl,iszankoku,istensei,istenni]);

@override
String toString() {
  return 'NovelInfo(title: $title, ncode: $ncode, writer: $writer, story: $story, novelType: $novelType, end: $end, generalAllNo: $generalAllNo, genre: $genre, keyword: $keyword, generalFirstup: $generalFirstup, generalLastup: $generalLastup, globalPoint: $globalPoint, dailyPoint: $dailyPoint, weeklyPoint: $weeklyPoint, monthlyPoint: $monthlyPoint, quarterPoint: $quarterPoint, yearlyPoint: $yearlyPoint, favNovelCnt: $favNovelCnt, impressionCnt: $impressionCnt, reviewCnt: $reviewCnt, allPoint: $allPoint, allHyokaCnt: $allHyokaCnt, sasieCnt: $sasieCnt, kaiwaritu: $kaiwaritu, novelupdatedAt: $novelupdatedAt, updatedAt: $updatedAt, episodes: $episodes, isr15: $isr15, isbl: $isbl, isgl: $isgl, iszankoku: $iszankoku, istensei: $istensei, istenni: $istenni)';
}


}

/// @nodoc
abstract mixin class $NovelInfoCopyWith<$Res>  {
  factory $NovelInfoCopyWith(NovelInfo value, $Res Function(NovelInfo) _then) = _$NovelInfoCopyWithImpl;
@useResult
$Res call({
 String? title, String? ncode, String? writer, String? story, int? novelType, int? end, int? generalAllNo, int? genre, String? keyword, String? generalFirstup, String? generalLastup, int? globalPoint, int? dailyPoint, int? weeklyPoint, int? monthlyPoint, int? quarterPoint, int? yearlyPoint, int? favNovelCnt, int? impressionCnt, int? reviewCnt, int? allPoint, int? allHyokaCnt, int? sasieCnt, int? kaiwaritu, int? novelupdatedAt, int? updatedAt, List<Episode>? episodes, int? isr15, int? isbl, int? isgl, int? iszankoku, int? istensei, int? istenni
});




}
/// @nodoc
class _$NovelInfoCopyWithImpl<$Res>
    implements $NovelInfoCopyWith<$Res> {
  _$NovelInfoCopyWithImpl(this._self, this._then);

  final NovelInfo _self;
  final $Res Function(NovelInfo) _then;

/// Create a copy of NovelInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? ncode = freezed,Object? writer = freezed,Object? story = freezed,Object? novelType = freezed,Object? end = freezed,Object? generalAllNo = freezed,Object? genre = freezed,Object? keyword = freezed,Object? generalFirstup = freezed,Object? generalLastup = freezed,Object? globalPoint = freezed,Object? dailyPoint = freezed,Object? weeklyPoint = freezed,Object? monthlyPoint = freezed,Object? quarterPoint = freezed,Object? yearlyPoint = freezed,Object? favNovelCnt = freezed,Object? impressionCnt = freezed,Object? reviewCnt = freezed,Object? allPoint = freezed,Object? allHyokaCnt = freezed,Object? sasieCnt = freezed,Object? kaiwaritu = freezed,Object? novelupdatedAt = freezed,Object? updatedAt = freezed,Object? episodes = freezed,Object? isr15 = freezed,Object? isbl = freezed,Object? isgl = freezed,Object? iszankoku = freezed,Object? istensei = freezed,Object? istenni = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,ncode: freezed == ncode ? _self.ncode : ncode // ignore: cast_nullable_to_non_nullable
as String?,writer: freezed == writer ? _self.writer : writer // ignore: cast_nullable_to_non_nullable
as String?,story: freezed == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as String?,novelType: freezed == novelType ? _self.novelType : novelType // ignore: cast_nullable_to_non_nullable
as int?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int?,generalAllNo: freezed == generalAllNo ? _self.generalAllNo : generalAllNo // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as int?,keyword: freezed == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String?,generalFirstup: freezed == generalFirstup ? _self.generalFirstup : generalFirstup // ignore: cast_nullable_to_non_nullable
as String?,generalLastup: freezed == generalLastup ? _self.generalLastup : generalLastup // ignore: cast_nullable_to_non_nullable
as String?,globalPoint: freezed == globalPoint ? _self.globalPoint : globalPoint // ignore: cast_nullable_to_non_nullable
as int?,dailyPoint: freezed == dailyPoint ? _self.dailyPoint : dailyPoint // ignore: cast_nullable_to_non_nullable
as int?,weeklyPoint: freezed == weeklyPoint ? _self.weeklyPoint : weeklyPoint // ignore: cast_nullable_to_non_nullable
as int?,monthlyPoint: freezed == monthlyPoint ? _self.monthlyPoint : monthlyPoint // ignore: cast_nullable_to_non_nullable
as int?,quarterPoint: freezed == quarterPoint ? _self.quarterPoint : quarterPoint // ignore: cast_nullable_to_non_nullable
as int?,yearlyPoint: freezed == yearlyPoint ? _self.yearlyPoint : yearlyPoint // ignore: cast_nullable_to_non_nullable
as int?,favNovelCnt: freezed == favNovelCnt ? _self.favNovelCnt : favNovelCnt // ignore: cast_nullable_to_non_nullable
as int?,impressionCnt: freezed == impressionCnt ? _self.impressionCnt : impressionCnt // ignore: cast_nullable_to_non_nullable
as int?,reviewCnt: freezed == reviewCnt ? _self.reviewCnt : reviewCnt // ignore: cast_nullable_to_non_nullable
as int?,allPoint: freezed == allPoint ? _self.allPoint : allPoint // ignore: cast_nullable_to_non_nullable
as int?,allHyokaCnt: freezed == allHyokaCnt ? _self.allHyokaCnt : allHyokaCnt // ignore: cast_nullable_to_non_nullable
as int?,sasieCnt: freezed == sasieCnt ? _self.sasieCnt : sasieCnt // ignore: cast_nullable_to_non_nullable
as int?,kaiwaritu: freezed == kaiwaritu ? _self.kaiwaritu : kaiwaritu // ignore: cast_nullable_to_non_nullable
as int?,novelupdatedAt: freezed == novelupdatedAt ? _self.novelupdatedAt : novelupdatedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,episodes: freezed == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>?,isr15: freezed == isr15 ? _self.isr15 : isr15 // ignore: cast_nullable_to_non_nullable
as int?,isbl: freezed == isbl ? _self.isbl : isbl // ignore: cast_nullable_to_non_nullable
as int?,isgl: freezed == isgl ? _self.isgl : isgl // ignore: cast_nullable_to_non_nullable
as int?,iszankoku: freezed == iszankoku ? _self.iszankoku : iszankoku // ignore: cast_nullable_to_non_nullable
as int?,istensei: freezed == istensei ? _self.istensei : istensei // ignore: cast_nullable_to_non_nullable
as int?,istenni: freezed == istenni ? _self.istenni : istenni // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [NovelInfo].
extension NovelInfoPatterns on NovelInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NovelInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NovelInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NovelInfo value)  $default,){
final _that = this;
switch (_that) {
case _NovelInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NovelInfo value)?  $default,){
final _that = this;
switch (_that) {
case _NovelInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? ncode,  String? writer,  String? story,  int? novelType,  int? end,  int? generalAllNo,  int? genre,  String? keyword,  String? generalFirstup,  String? generalLastup,  int? globalPoint,  int? dailyPoint,  int? weeklyPoint,  int? monthlyPoint,  int? quarterPoint,  int? yearlyPoint,  int? favNovelCnt,  int? impressionCnt,  int? reviewCnt,  int? allPoint,  int? allHyokaCnt,  int? sasieCnt,  int? kaiwaritu,  int? novelupdatedAt,  int? updatedAt,  List<Episode>? episodes,  int? isr15,  int? isbl,  int? isgl,  int? iszankoku,  int? istensei,  int? istenni)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NovelInfo() when $default != null:
return $default(_that.title,_that.ncode,_that.writer,_that.story,_that.novelType,_that.end,_that.generalAllNo,_that.genre,_that.keyword,_that.generalFirstup,_that.generalLastup,_that.globalPoint,_that.dailyPoint,_that.weeklyPoint,_that.monthlyPoint,_that.quarterPoint,_that.yearlyPoint,_that.favNovelCnt,_that.impressionCnt,_that.reviewCnt,_that.allPoint,_that.allHyokaCnt,_that.sasieCnt,_that.kaiwaritu,_that.novelupdatedAt,_that.updatedAt,_that.episodes,_that.isr15,_that.isbl,_that.isgl,_that.iszankoku,_that.istensei,_that.istenni);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? ncode,  String? writer,  String? story,  int? novelType,  int? end,  int? generalAllNo,  int? genre,  String? keyword,  String? generalFirstup,  String? generalLastup,  int? globalPoint,  int? dailyPoint,  int? weeklyPoint,  int? monthlyPoint,  int? quarterPoint,  int? yearlyPoint,  int? favNovelCnt,  int? impressionCnt,  int? reviewCnt,  int? allPoint,  int? allHyokaCnt,  int? sasieCnt,  int? kaiwaritu,  int? novelupdatedAt,  int? updatedAt,  List<Episode>? episodes,  int? isr15,  int? isbl,  int? isgl,  int? iszankoku,  int? istensei,  int? istenni)  $default,) {final _that = this;
switch (_that) {
case _NovelInfo():
return $default(_that.title,_that.ncode,_that.writer,_that.story,_that.novelType,_that.end,_that.generalAllNo,_that.genre,_that.keyword,_that.generalFirstup,_that.generalLastup,_that.globalPoint,_that.dailyPoint,_that.weeklyPoint,_that.monthlyPoint,_that.quarterPoint,_that.yearlyPoint,_that.favNovelCnt,_that.impressionCnt,_that.reviewCnt,_that.allPoint,_that.allHyokaCnt,_that.sasieCnt,_that.kaiwaritu,_that.novelupdatedAt,_that.updatedAt,_that.episodes,_that.isr15,_that.isbl,_that.isgl,_that.iszankoku,_that.istensei,_that.istenni);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? ncode,  String? writer,  String? story,  int? novelType,  int? end,  int? generalAllNo,  int? genre,  String? keyword,  String? generalFirstup,  String? generalLastup,  int? globalPoint,  int? dailyPoint,  int? weeklyPoint,  int? monthlyPoint,  int? quarterPoint,  int? yearlyPoint,  int? favNovelCnt,  int? impressionCnt,  int? reviewCnt,  int? allPoint,  int? allHyokaCnt,  int? sasieCnt,  int? kaiwaritu,  int? novelupdatedAt,  int? updatedAt,  List<Episode>? episodes,  int? isr15,  int? isbl,  int? isgl,  int? iszankoku,  int? istensei,  int? istenni)?  $default,) {final _that = this;
switch (_that) {
case _NovelInfo() when $default != null:
return $default(_that.title,_that.ncode,_that.writer,_that.story,_that.novelType,_that.end,_that.generalAllNo,_that.genre,_that.keyword,_that.generalFirstup,_that.generalLastup,_that.globalPoint,_that.dailyPoint,_that.weeklyPoint,_that.monthlyPoint,_that.quarterPoint,_that.yearlyPoint,_that.favNovelCnt,_that.impressionCnt,_that.reviewCnt,_that.allPoint,_that.allHyokaCnt,_that.sasieCnt,_that.kaiwaritu,_that.novelupdatedAt,_that.updatedAt,_that.episodes,_that.isr15,_that.isbl,_that.isgl,_that.iszankoku,_that.istensei,_that.istenni);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NovelInfo implements NovelInfo {
  const _NovelInfo({this.title, this.ncode, this.writer, this.story, this.novelType, this.end, this.generalAllNo, this.genre, this.keyword, this.generalFirstup, this.generalLastup, this.globalPoint, this.dailyPoint, this.weeklyPoint, this.monthlyPoint, this.quarterPoint, this.yearlyPoint, this.favNovelCnt, this.impressionCnt, this.reviewCnt, this.allPoint, this.allHyokaCnt, this.sasieCnt, this.kaiwaritu, this.novelupdatedAt, this.updatedAt, final  List<Episode>? episodes, this.isr15, this.isbl, this.isgl, this.iszankoku, this.istensei, this.istenni}): _episodes = episodes;
  factory _NovelInfo.fromJson(Map<String, dynamic> json) => _$NovelInfoFromJson(json);

/// 作品名。
@override final  String? title;
/// Nコード。
@override final  String? ncode;
/// 作者名。
@override final  String? writer;
/// 作品のあらすじ。
@override final  String? story;
/// 小説タイプ。
///
/// [1] 連載
/// [2] 短編
@override final  int? novelType;
/// 連載状態。
///
/// [0] 短編作品と��結済作品
/// [1] 連載中
@override final  int? end;
/// 全掲載エピソード数。
///
/// 短編の場合は 1。
@override final  int? generalAllNo;
/// ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
@override final  int? genre;
/// キーワード。
@override final  String? keyword;
/// 初回掲載日。
///
/// `YYYY-MM-DD HH:MM:SS` の形式。
@override final  String? generalFirstup;
/// 最終掲載日。
///
/// `YYYY-MM-DD HH:MM:SS` の形式。
@override final  String? generalLastup;
/// 総合評価ポイント。
///
/// (ブックマーク数×2)+評価ポイント。
@override final  int? globalPoint;
/// 日間ポイント。
@override final  int? dailyPoint;
/// 週間ポイント。
@override final  int? weeklyPoint;
/// 月間ポイント。
@override final  int? monthlyPoint;
/// 四半期ポイント。
@override final  int? quarterPoint;
/// 年間ポイント。
@override final  int? yearlyPoint;
/// ブックマーク数。
@override final  int? favNovelCnt;
/// 感想数。
@override final  int? impressionCnt;
/// レビュー数。
@override final  int? reviewCnt;
/// 評価ポイント。
@override final  int? allPoint;
/// 評価者数。
@override final  int? allHyokaCnt;
/// 挿絵の数。
@override final  int? sasieCnt;
/// 会話率。
@override final  int? kaiwaritu;
/// 作品の更新日時。
@override final  int? novelupdatedAt;
/// 最終更新日時。
///
/// システム用で作品更新時とは関係ない。
@override final  int? updatedAt;
/// エピソードのリスト。
 final  List<Episode>? _episodes;
/// エピソードのリスト。
@override List<Episode>? get episodes {
  final value = _episodes;
  if (value == null) return null;
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// R15作品か。
///
/// [1] R15
/// [0] それ以外
@override final  int? isr15;
/// ボーイズラブ作品か。
///
/// [1] ボーイズラブ
/// [0] それ以外
@override final  int? isbl;
/// ガールズラブ作品か。
///
/// [1] ガールズラブ
/// [0] それ以外
@override final  int? isgl;
/// 残酷な描写あり作品か。
///
/// [1] 残酷な描写あり
/// [0] それ以外
@override final  int? iszankoku;
/// 異世界転生作品か。
///
/// [1] 異世界転生
/// [0] それ以外
@override final  int? istensei;
/// 異世界転移作品か。
///
/// [1] 異世界転移
/// [0] それ以外
@override final  int? istenni;

/// Create a copy of NovelInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NovelInfoCopyWith<_NovelInfo> get copyWith => __$NovelInfoCopyWithImpl<_NovelInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NovelInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NovelInfo&&(identical(other.title, title) || other.title == title)&&(identical(other.ncode, ncode) || other.ncode == ncode)&&(identical(other.writer, writer) || other.writer == writer)&&(identical(other.story, story) || other.story == story)&&(identical(other.novelType, novelType) || other.novelType == novelType)&&(identical(other.end, end) || other.end == end)&&(identical(other.generalAllNo, generalAllNo) || other.generalAllNo == generalAllNo)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.generalFirstup, generalFirstup) || other.generalFirstup == generalFirstup)&&(identical(other.generalLastup, generalLastup) || other.generalLastup == generalLastup)&&(identical(other.globalPoint, globalPoint) || other.globalPoint == globalPoint)&&(identical(other.dailyPoint, dailyPoint) || other.dailyPoint == dailyPoint)&&(identical(other.weeklyPoint, weeklyPoint) || other.weeklyPoint == weeklyPoint)&&(identical(other.monthlyPoint, monthlyPoint) || other.monthlyPoint == monthlyPoint)&&(identical(other.quarterPoint, quarterPoint) || other.quarterPoint == quarterPoint)&&(identical(other.yearlyPoint, yearlyPoint) || other.yearlyPoint == yearlyPoint)&&(identical(other.favNovelCnt, favNovelCnt) || other.favNovelCnt == favNovelCnt)&&(identical(other.impressionCnt, impressionCnt) || other.impressionCnt == impressionCnt)&&(identical(other.reviewCnt, reviewCnt) || other.reviewCnt == reviewCnt)&&(identical(other.allPoint, allPoint) || other.allPoint == allPoint)&&(identical(other.allHyokaCnt, allHyokaCnt) || other.allHyokaCnt == allHyokaCnt)&&(identical(other.sasieCnt, sasieCnt) || other.sasieCnt == sasieCnt)&&(identical(other.kaiwaritu, kaiwaritu) || other.kaiwaritu == kaiwaritu)&&(identical(other.novelupdatedAt, novelupdatedAt) || other.novelupdatedAt == novelupdatedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&(identical(other.isr15, isr15) || other.isr15 == isr15)&&(identical(other.isbl, isbl) || other.isbl == isbl)&&(identical(other.isgl, isgl) || other.isgl == isgl)&&(identical(other.iszankoku, iszankoku) || other.iszankoku == iszankoku)&&(identical(other.istensei, istensei) || other.istensei == istensei)&&(identical(other.istenni, istenni) || other.istenni == istenni));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,ncode,writer,story,novelType,end,generalAllNo,genre,keyword,generalFirstup,generalLastup,globalPoint,dailyPoint,weeklyPoint,monthlyPoint,quarterPoint,yearlyPoint,favNovelCnt,impressionCnt,reviewCnt,allPoint,allHyokaCnt,sasieCnt,kaiwaritu,novelupdatedAt,updatedAt,const DeepCollectionEquality().hash(_episodes),isr15,isbl,isgl,iszankoku,istensei,istenni]);

@override
String toString() {
  return 'NovelInfo(title: $title, ncode: $ncode, writer: $writer, story: $story, novelType: $novelType, end: $end, generalAllNo: $generalAllNo, genre: $genre, keyword: $keyword, generalFirstup: $generalFirstup, generalLastup: $generalLastup, globalPoint: $globalPoint, dailyPoint: $dailyPoint, weeklyPoint: $weeklyPoint, monthlyPoint: $monthlyPoint, quarterPoint: $quarterPoint, yearlyPoint: $yearlyPoint, favNovelCnt: $favNovelCnt, impressionCnt: $impressionCnt, reviewCnt: $reviewCnt, allPoint: $allPoint, allHyokaCnt: $allHyokaCnt, sasieCnt: $sasieCnt, kaiwaritu: $kaiwaritu, novelupdatedAt: $novelupdatedAt, updatedAt: $updatedAt, episodes: $episodes, isr15: $isr15, isbl: $isbl, isgl: $isgl, iszankoku: $iszankoku, istensei: $istensei, istenni: $istenni)';
}


}

/// @nodoc
abstract mixin class _$NovelInfoCopyWith<$Res> implements $NovelInfoCopyWith<$Res> {
  factory _$NovelInfoCopyWith(_NovelInfo value, $Res Function(_NovelInfo) _then) = __$NovelInfoCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? ncode, String? writer, String? story, int? novelType, int? end, int? generalAllNo, int? genre, String? keyword, String? generalFirstup, String? generalLastup, int? globalPoint, int? dailyPoint, int? weeklyPoint, int? monthlyPoint, int? quarterPoint, int? yearlyPoint, int? favNovelCnt, int? impressionCnt, int? reviewCnt, int? allPoint, int? allHyokaCnt, int? sasieCnt, int? kaiwaritu, int? novelupdatedAt, int? updatedAt, List<Episode>? episodes, int? isr15, int? isbl, int? isgl, int? iszankoku, int? istensei, int? istenni
});




}
/// @nodoc
class __$NovelInfoCopyWithImpl<$Res>
    implements _$NovelInfoCopyWith<$Res> {
  __$NovelInfoCopyWithImpl(this._self, this._then);

  final _NovelInfo _self;
  final $Res Function(_NovelInfo) _then;

/// Create a copy of NovelInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? ncode = freezed,Object? writer = freezed,Object? story = freezed,Object? novelType = freezed,Object? end = freezed,Object? generalAllNo = freezed,Object? genre = freezed,Object? keyword = freezed,Object? generalFirstup = freezed,Object? generalLastup = freezed,Object? globalPoint = freezed,Object? dailyPoint = freezed,Object? weeklyPoint = freezed,Object? monthlyPoint = freezed,Object? quarterPoint = freezed,Object? yearlyPoint = freezed,Object? favNovelCnt = freezed,Object? impressionCnt = freezed,Object? reviewCnt = freezed,Object? allPoint = freezed,Object? allHyokaCnt = freezed,Object? sasieCnt = freezed,Object? kaiwaritu = freezed,Object? novelupdatedAt = freezed,Object? updatedAt = freezed,Object? episodes = freezed,Object? isr15 = freezed,Object? isbl = freezed,Object? isgl = freezed,Object? iszankoku = freezed,Object? istensei = freezed,Object? istenni = freezed,}) {
  return _then(_NovelInfo(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,ncode: freezed == ncode ? _self.ncode : ncode // ignore: cast_nullable_to_non_nullable
as String?,writer: freezed == writer ? _self.writer : writer // ignore: cast_nullable_to_non_nullable
as String?,story: freezed == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as String?,novelType: freezed == novelType ? _self.novelType : novelType // ignore: cast_nullable_to_non_nullable
as int?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int?,generalAllNo: freezed == generalAllNo ? _self.generalAllNo : generalAllNo // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as int?,keyword: freezed == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String?,generalFirstup: freezed == generalFirstup ? _self.generalFirstup : generalFirstup // ignore: cast_nullable_to_non_nullable
as String?,generalLastup: freezed == generalLastup ? _self.generalLastup : generalLastup // ignore: cast_nullable_to_non_nullable
as String?,globalPoint: freezed == globalPoint ? _self.globalPoint : globalPoint // ignore: cast_nullable_to_non_nullable
as int?,dailyPoint: freezed == dailyPoint ? _self.dailyPoint : dailyPoint // ignore: cast_nullable_to_non_nullable
as int?,weeklyPoint: freezed == weeklyPoint ? _self.weeklyPoint : weeklyPoint // ignore: cast_nullable_to_non_nullable
as int?,monthlyPoint: freezed == monthlyPoint ? _self.monthlyPoint : monthlyPoint // ignore: cast_nullable_to_non_nullable
as int?,quarterPoint: freezed == quarterPoint ? _self.quarterPoint : quarterPoint // ignore: cast_nullable_to_non_nullable
as int?,yearlyPoint: freezed == yearlyPoint ? _self.yearlyPoint : yearlyPoint // ignore: cast_nullable_to_non_nullable
as int?,favNovelCnt: freezed == favNovelCnt ? _self.favNovelCnt : favNovelCnt // ignore: cast_nullable_to_non_nullable
as int?,impressionCnt: freezed == impressionCnt ? _self.impressionCnt : impressionCnt // ignore: cast_nullable_to_non_nullable
as int?,reviewCnt: freezed == reviewCnt ? _self.reviewCnt : reviewCnt // ignore: cast_nullable_to_non_nullable
as int?,allPoint: freezed == allPoint ? _self.allPoint : allPoint // ignore: cast_nullable_to_non_nullable
as int?,allHyokaCnt: freezed == allHyokaCnt ? _self.allHyokaCnt : allHyokaCnt // ignore: cast_nullable_to_non_nullable
as int?,sasieCnt: freezed == sasieCnt ? _self.sasieCnt : sasieCnt // ignore: cast_nullable_to_non_nullable
as int?,kaiwaritu: freezed == kaiwaritu ? _self.kaiwaritu : kaiwaritu // ignore: cast_nullable_to_non_nullable
as int?,novelupdatedAt: freezed == novelupdatedAt ? _self.novelupdatedAt : novelupdatedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,episodes: freezed == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>?,isr15: freezed == isr15 ? _self.isr15 : isr15 // ignore: cast_nullable_to_non_nullable
as int?,isbl: freezed == isbl ? _self.isbl : isbl // ignore: cast_nullable_to_non_nullable
as int?,isgl: freezed == isgl ? _self.isgl : isgl // ignore: cast_nullable_to_non_nullable
as int?,iszankoku: freezed == iszankoku ? _self.iszankoku : iszankoku // ignore: cast_nullable_to_non_nullable
as int?,istensei: freezed == istensei ? _self.istensei : istensei // ignore: cast_nullable_to_non_nullable
as int?,istenni: freezed == istenni ? _self.istenni : istenni // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
