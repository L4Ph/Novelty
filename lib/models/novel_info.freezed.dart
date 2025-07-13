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
@JsonKey(name: 'novel_type') int? get novelType;/// 連載状態。
///
/// [0] 短編作品と完結済作品
/// [1] 連載中
 int? get end;/// 全掲��エピソード数。
///
/// 短編の場合は 1。
@JsonKey(name: 'general_all_no') int? get generalAllNo;/// ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
 int? get genre;/// キーワード。
 String? get keyword;/// 初回掲載日。
///
/// `YYYY-MM-DD HH:MM:SS` の形式。
@JsonKey(name: 'general_firstup') String? get generalFirstup;/// 最終掲載日。
///
/// `YYYY-MM-DD HH:MM:SS` の形式。
@JsonKey(name: 'general_lastup') String? get generalLastup;/// 総合評価ポイント。
///
/// (ブックマーク数×2)+評価ポイント。
@JsonKey(name: 'global_point') int? get globalPoint;/// 日間ポイント。
@JsonKey(name: 'daily_point') int? get dailyPoint;/// 週間ポイント。
@JsonKey(name: 'weekly_point') int? get weeklyPoint;/// 月間ポイント。
@JsonKey(name: 'monthly_point') int? get monthlyPoint;/// 四半期ポイント。
@JsonKey(name: 'quarter_point') int? get quarterPoint;/// 年間ポイント。
@JsonKey(name: 'yearly_point') int? get yearlyPoint;/// ブックマーク数。
@JsonKey(name: 'fav_novel_cnt') int? get favNovelCnt;/// 感想数。
@JsonKey(name: 'impression_cnt') int? get impressionCnt;/// レビュー数。
@JsonKey(name: 'review_cnt') int? get reviewCnt;/// 評価ポイント。
@JsonKey(name: 'all_point') int? get allPoint;/// 評価者数。
@JsonKey(name: 'all_hyoka_cnt') int? get allHyokaCnt;/// 挿絵の数。
@JsonKey(name: 'sasie_cnt') int? get sasieCnt;/// 会話率。
 int? get kaiwaritu;/// 作品の更新日時。
@JsonKey(name: 'novelupdated_at') int? get novelupdatedAt;/// 最終更新日時。
///
/// システム用で作品更新時とは関係ない。
@JsonKey(name: 'updated_at') int? get updatedAt;/// エピソードのリスト。
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
 String? title, String? ncode, String? writer, String? story,@JsonKey(name: 'novel_type') int? novelType, int? end,@JsonKey(name: 'general_all_no') int? generalAllNo, int? genre, String? keyword,@JsonKey(name: 'general_firstup') String? generalFirstup,@JsonKey(name: 'general_lastup') String? generalLastup,@JsonKey(name: 'global_point') int? globalPoint,@JsonKey(name: 'daily_point') int? dailyPoint,@JsonKey(name: 'weekly_point') int? weeklyPoint,@JsonKey(name: 'monthly_point') int? monthlyPoint,@JsonKey(name: 'quarter_point') int? quarterPoint,@JsonKey(name: 'yearly_point') int? yearlyPoint,@JsonKey(name: 'fav_novel_cnt') int? favNovelCnt,@JsonKey(name: 'impression_cnt') int? impressionCnt,@JsonKey(name: 'review_cnt') int? reviewCnt,@JsonKey(name: 'all_point') int? allPoint,@JsonKey(name: 'all_hyoka_cnt') int? allHyokaCnt,@JsonKey(name: 'sasie_cnt') int? sasieCnt, int? kaiwaritu,@JsonKey(name: 'novelupdated_at') int? novelupdatedAt,@JsonKey(name: 'updated_at') int? updatedAt, List<Episode>? episodes, int? isr15, int? isbl, int? isgl, int? iszankoku, int? istensei, int? istenni
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? ncode,  String? writer,  String? story, @JsonKey(name: 'novel_type')  int? novelType,  int? end, @JsonKey(name: 'general_all_no')  int? generalAllNo,  int? genre,  String? keyword, @JsonKey(name: 'general_firstup')  String? generalFirstup, @JsonKey(name: 'general_lastup')  String? generalLastup, @JsonKey(name: 'global_point')  int? globalPoint, @JsonKey(name: 'daily_point')  int? dailyPoint, @JsonKey(name: 'weekly_point')  int? weeklyPoint, @JsonKey(name: 'monthly_point')  int? monthlyPoint, @JsonKey(name: 'quarter_point')  int? quarterPoint, @JsonKey(name: 'yearly_point')  int? yearlyPoint, @JsonKey(name: 'fav_novel_cnt')  int? favNovelCnt, @JsonKey(name: 'impression_cnt')  int? impressionCnt, @JsonKey(name: 'review_cnt')  int? reviewCnt, @JsonKey(name: 'all_point')  int? allPoint, @JsonKey(name: 'all_hyoka_cnt')  int? allHyokaCnt, @JsonKey(name: 'sasie_cnt')  int? sasieCnt,  int? kaiwaritu, @JsonKey(name: 'novelupdated_at')  int? novelupdatedAt, @JsonKey(name: 'updated_at')  int? updatedAt,  List<Episode>? episodes,  int? isr15,  int? isbl,  int? isgl,  int? iszankoku,  int? istensei,  int? istenni)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? ncode,  String? writer,  String? story, @JsonKey(name: 'novel_type')  int? novelType,  int? end, @JsonKey(name: 'general_all_no')  int? generalAllNo,  int? genre,  String? keyword, @JsonKey(name: 'general_firstup')  String? generalFirstup, @JsonKey(name: 'general_lastup')  String? generalLastup, @JsonKey(name: 'global_point')  int? globalPoint, @JsonKey(name: 'daily_point')  int? dailyPoint, @JsonKey(name: 'weekly_point')  int? weeklyPoint, @JsonKey(name: 'monthly_point')  int? monthlyPoint, @JsonKey(name: 'quarter_point')  int? quarterPoint, @JsonKey(name: 'yearly_point')  int? yearlyPoint, @JsonKey(name: 'fav_novel_cnt')  int? favNovelCnt, @JsonKey(name: 'impression_cnt')  int? impressionCnt, @JsonKey(name: 'review_cnt')  int? reviewCnt, @JsonKey(name: 'all_point')  int? allPoint, @JsonKey(name: 'all_hyoka_cnt')  int? allHyokaCnt, @JsonKey(name: 'sasie_cnt')  int? sasieCnt,  int? kaiwaritu, @JsonKey(name: 'novelupdated_at')  int? novelupdatedAt, @JsonKey(name: 'updated_at')  int? updatedAt,  List<Episode>? episodes,  int? isr15,  int? isbl,  int? isgl,  int? iszankoku,  int? istensei,  int? istenni)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? ncode,  String? writer,  String? story, @JsonKey(name: 'novel_type')  int? novelType,  int? end, @JsonKey(name: 'general_all_no')  int? generalAllNo,  int? genre,  String? keyword, @JsonKey(name: 'general_firstup')  String? generalFirstup, @JsonKey(name: 'general_lastup')  String? generalLastup, @JsonKey(name: 'global_point')  int? globalPoint, @JsonKey(name: 'daily_point')  int? dailyPoint, @JsonKey(name: 'weekly_point')  int? weeklyPoint, @JsonKey(name: 'monthly_point')  int? monthlyPoint, @JsonKey(name: 'quarter_point')  int? quarterPoint, @JsonKey(name: 'yearly_point')  int? yearlyPoint, @JsonKey(name: 'fav_novel_cnt')  int? favNovelCnt, @JsonKey(name: 'impression_cnt')  int? impressionCnt, @JsonKey(name: 'review_cnt')  int? reviewCnt, @JsonKey(name: 'all_point')  int? allPoint, @JsonKey(name: 'all_hyoka_cnt')  int? allHyokaCnt, @JsonKey(name: 'sasie_cnt')  int? sasieCnt,  int? kaiwaritu, @JsonKey(name: 'novelupdated_at')  int? novelupdatedAt, @JsonKey(name: 'updated_at')  int? updatedAt,  List<Episode>? episodes,  int? isr15,  int? isbl,  int? isgl,  int? iszankoku,  int? istensei,  int? istenni)?  $default,) {final _that = this;
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
  const _NovelInfo({this.title, this.ncode, this.writer, this.story, @JsonKey(name: 'novel_type') this.novelType, this.end, @JsonKey(name: 'general_all_no') this.generalAllNo, this.genre, this.keyword, @JsonKey(name: 'general_firstup') this.generalFirstup, @JsonKey(name: 'general_lastup') this.generalLastup, @JsonKey(name: 'global_point') this.globalPoint, @JsonKey(name: 'daily_point') this.dailyPoint, @JsonKey(name: 'weekly_point') this.weeklyPoint, @JsonKey(name: 'monthly_point') this.monthlyPoint, @JsonKey(name: 'quarter_point') this.quarterPoint, @JsonKey(name: 'yearly_point') this.yearlyPoint, @JsonKey(name: 'fav_novel_cnt') this.favNovelCnt, @JsonKey(name: 'impression_cnt') this.impressionCnt, @JsonKey(name: 'review_cnt') this.reviewCnt, @JsonKey(name: 'all_point') this.allPoint, @JsonKey(name: 'all_hyoka_cnt') this.allHyokaCnt, @JsonKey(name: 'sasie_cnt') this.sasieCnt, this.kaiwaritu, @JsonKey(name: 'novelupdated_at') this.novelupdatedAt, @JsonKey(name: 'updated_at') this.updatedAt, final  List<Episode>? episodes, this.isr15, this.isbl, this.isgl, this.iszankoku, this.istensei, this.istenni}): _episodes = episodes;
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
@override@JsonKey(name: 'novel_type') final  int? novelType;
/// 連載状態。
///
/// [0] 短編作品と完結済作品
/// [1] 連載中
@override final  int? end;
/// 全掲��エピソード数。
///
/// 短編の場合は 1。
@override@JsonKey(name: 'general_all_no') final  int? generalAllNo;
/// ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
@override final  int? genre;
/// キーワード。
@override final  String? keyword;
/// 初回掲載日。
///
/// `YYYY-MM-DD HH:MM:SS` の形式。
@override@JsonKey(name: 'general_firstup') final  String? generalFirstup;
/// 最終掲載日。
///
/// `YYYY-MM-DD HH:MM:SS` の形式。
@override@JsonKey(name: 'general_lastup') final  String? generalLastup;
/// 総合評価ポイント。
///
/// (ブックマーク数×2)+評価ポイント。
@override@JsonKey(name: 'global_point') final  int? globalPoint;
/// 日間ポイント。
@override@JsonKey(name: 'daily_point') final  int? dailyPoint;
/// 週間ポイント。
@override@JsonKey(name: 'weekly_point') final  int? weeklyPoint;
/// 月間ポイント。
@override@JsonKey(name: 'monthly_point') final  int? monthlyPoint;
/// 四半期ポイント。
@override@JsonKey(name: 'quarter_point') final  int? quarterPoint;
/// 年間ポイント。
@override@JsonKey(name: 'yearly_point') final  int? yearlyPoint;
/// ブックマーク数。
@override@JsonKey(name: 'fav_novel_cnt') final  int? favNovelCnt;
/// 感想数。
@override@JsonKey(name: 'impression_cnt') final  int? impressionCnt;
/// レビュー数。
@override@JsonKey(name: 'review_cnt') final  int? reviewCnt;
/// 評価ポイント。
@override@JsonKey(name: 'all_point') final  int? allPoint;
/// 評価者数。
@override@JsonKey(name: 'all_hyoka_cnt') final  int? allHyokaCnt;
/// 挿絵の数。
@override@JsonKey(name: 'sasie_cnt') final  int? sasieCnt;
/// 会話率。
@override final  int? kaiwaritu;
/// 作品の更新日時。
@override@JsonKey(name: 'novelupdated_at') final  int? novelupdatedAt;
/// 最終更新日時。
///
/// システム用で作品更新時とは関係ない。
@override@JsonKey(name: 'updated_at') final  int? updatedAt;
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
 String? title, String? ncode, String? writer, String? story,@JsonKey(name: 'novel_type') int? novelType, int? end,@JsonKey(name: 'general_all_no') int? generalAllNo, int? genre, String? keyword,@JsonKey(name: 'general_firstup') String? generalFirstup,@JsonKey(name: 'general_lastup') String? generalLastup,@JsonKey(name: 'global_point') int? globalPoint,@JsonKey(name: 'daily_point') int? dailyPoint,@JsonKey(name: 'weekly_point') int? weeklyPoint,@JsonKey(name: 'monthly_point') int? monthlyPoint,@JsonKey(name: 'quarter_point') int? quarterPoint,@JsonKey(name: 'yearly_point') int? yearlyPoint,@JsonKey(name: 'fav_novel_cnt') int? favNovelCnt,@JsonKey(name: 'impression_cnt') int? impressionCnt,@JsonKey(name: 'review_cnt') int? reviewCnt,@JsonKey(name: 'all_point') int? allPoint,@JsonKey(name: 'all_hyoka_cnt') int? allHyokaCnt,@JsonKey(name: 'sasie_cnt') int? sasieCnt, int? kaiwaritu,@JsonKey(name: 'novelupdated_at') int? novelupdatedAt,@JsonKey(name: 'updated_at') int? updatedAt, List<Episode>? episodes, int? isr15, int? isbl, int? isgl, int? iszankoku, int? istensei, int? istenni
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
