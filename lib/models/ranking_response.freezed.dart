// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RankingResponse {

/// 順位。
///
/// 1～300位。
/// ランキングAPIで取得。
 int? get rank;/// ポイント。
///
/// ランキングAPIで取得。
 int? get pt;/// 総合評価ポイント。
///
/// (ブックマーク数×2)+評価ポイント。
/// 小説APIで取得。
 int? get allPoint;/// Nコード。
 String get ncode;/// 作品名。
 String? get title;/// 小説タイプ。
///
/// [1] 連載
/// [2] 短編
 int? get novelType;/// 連載状態。
///
/// [0] 短編作品と完結済作品
/// [1] 連載中
 int? get end;/// ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
 int? get genre;/// 作者名。
 String? get writer;/// 作品のあらすじ。
 String? get story;/// 作者のユーザID(数値)。
 int? get userId;/// 全掲載エピソード数。
///
/// 短編の場合は 1。
 int? get generalAllNo;/// キーワード。
 String? get keyword;
/// Create a copy of RankingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingResponseCopyWith<RankingResponse> get copyWith => _$RankingResponseCopyWithImpl<RankingResponse>(this as RankingResponse, _$identity);

  /// Serializes this RankingResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingResponse&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.pt, pt) || other.pt == pt)&&(identical(other.allPoint, allPoint) || other.allPoint == allPoint)&&(identical(other.ncode, ncode) || other.ncode == ncode)&&(identical(other.title, title) || other.title == title)&&(identical(other.novelType, novelType) || other.novelType == novelType)&&(identical(other.end, end) || other.end == end)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.writer, writer) || other.writer == writer)&&(identical(other.story, story) || other.story == story)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.generalAllNo, generalAllNo) || other.generalAllNo == generalAllNo)&&(identical(other.keyword, keyword) || other.keyword == keyword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,pt,allPoint,ncode,title,novelType,end,genre,writer,story,userId,generalAllNo,keyword);

@override
String toString() {
  return 'RankingResponse(rank: $rank, pt: $pt, allPoint: $allPoint, ncode: $ncode, title: $title, novelType: $novelType, end: $end, genre: $genre, writer: $writer, story: $story, userId: $userId, generalAllNo: $generalAllNo, keyword: $keyword)';
}


}

/// @nodoc
abstract mixin class $RankingResponseCopyWith<$Res>  {
  factory $RankingResponseCopyWith(RankingResponse value, $Res Function(RankingResponse) _then) = _$RankingResponseCopyWithImpl;
@useResult
$Res call({
 int? rank, int? pt, int? allPoint, String ncode, String? title, int? novelType, int? end, int? genre, String? writer, String? story, int? userId, int? generalAllNo, String? keyword
});




}
/// @nodoc
class _$RankingResponseCopyWithImpl<$Res>
    implements $RankingResponseCopyWith<$Res> {
  _$RankingResponseCopyWithImpl(this._self, this._then);

  final RankingResponse _self;
  final $Res Function(RankingResponse) _then;

/// Create a copy of RankingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = freezed,Object? pt = freezed,Object? allPoint = freezed,Object? ncode = null,Object? title = freezed,Object? novelType = freezed,Object? end = freezed,Object? genre = freezed,Object? writer = freezed,Object? story = freezed,Object? userId = freezed,Object? generalAllNo = freezed,Object? keyword = freezed,}) {
  return _then(_self.copyWith(
rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,pt: freezed == pt ? _self.pt : pt // ignore: cast_nullable_to_non_nullable
as int?,allPoint: freezed == allPoint ? _self.allPoint : allPoint // ignore: cast_nullable_to_non_nullable
as int?,ncode: null == ncode ? _self.ncode : ncode // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,novelType: freezed == novelType ? _self.novelType : novelType // ignore: cast_nullable_to_non_nullable
as int?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as int?,writer: freezed == writer ? _self.writer : writer // ignore: cast_nullable_to_non_nullable
as String?,story: freezed == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,generalAllNo: freezed == generalAllNo ? _self.generalAllNo : generalAllNo // ignore: cast_nullable_to_non_nullable
as int?,keyword: freezed == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RankingResponse].
extension RankingResponsePatterns on RankingResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingResponse value)  $default,){
final _that = this;
switch (_that) {
case _RankingResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RankingResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? rank,  int? pt,  int? allPoint,  String ncode,  String? title,  int? novelType,  int? end,  int? genre,  String? writer,  String? story,  int? userId,  int? generalAllNo,  String? keyword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingResponse() when $default != null:
return $default(_that.rank,_that.pt,_that.allPoint,_that.ncode,_that.title,_that.novelType,_that.end,_that.genre,_that.writer,_that.story,_that.userId,_that.generalAllNo,_that.keyword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? rank,  int? pt,  int? allPoint,  String ncode,  String? title,  int? novelType,  int? end,  int? genre,  String? writer,  String? story,  int? userId,  int? generalAllNo,  String? keyword)  $default,) {final _that = this;
switch (_that) {
case _RankingResponse():
return $default(_that.rank,_that.pt,_that.allPoint,_that.ncode,_that.title,_that.novelType,_that.end,_that.genre,_that.writer,_that.story,_that.userId,_that.generalAllNo,_that.keyword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? rank,  int? pt,  int? allPoint,  String ncode,  String? title,  int? novelType,  int? end,  int? genre,  String? writer,  String? story,  int? userId,  int? generalAllNo,  String? keyword)?  $default,) {final _that = this;
switch (_that) {
case _RankingResponse() when $default != null:
return $default(_that.rank,_that.pt,_that.allPoint,_that.ncode,_that.title,_that.novelType,_that.end,_that.genre,_that.writer,_that.story,_that.userId,_that.generalAllNo,_that.keyword);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingResponse implements RankingResponse {
  const _RankingResponse({this.rank, this.pt, this.allPoint, required this.ncode, this.title, this.novelType, this.end, this.genre, this.writer, this.story, this.userId, this.generalAllNo, this.keyword});
  factory _RankingResponse.fromJson(Map<String, dynamic> json) => _$RankingResponseFromJson(json);

/// 順位。
///
/// 1～300位。
/// ランキングAPIで取得。
@override final  int? rank;
/// ポイント。
///
/// ランキングAPIで取得。
@override final  int? pt;
/// 総合評価ポイント。
///
/// (ブックマーク数×2)+評価ポイント。
/// 小説APIで取得。
@override final  int? allPoint;
/// Nコード。
@override final  String ncode;
/// 作品名。
@override final  String? title;
/// 小説タイプ。
///
/// [1] 連載
/// [2] 短編
@override final  int? novelType;
/// 連載状態。
///
/// [0] 短編作品と完結済作品
/// [1] 連載中
@override final  int? end;
/// ジャンル。
///
/// [ジャンル一覧](https://dev.syosetu.com/man/api/#genre)
@override final  int? genre;
/// 作者名。
@override final  String? writer;
/// 作品のあらすじ。
@override final  String? story;
/// 作者のユーザID(数値)。
@override final  int? userId;
/// 全掲載エピソード数。
///
/// 短編の場合は 1。
@override final  int? generalAllNo;
/// キーワード。
@override final  String? keyword;

/// Create a copy of RankingResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingResponseCopyWith<_RankingResponse> get copyWith => __$RankingResponseCopyWithImpl<_RankingResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingResponse&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.pt, pt) || other.pt == pt)&&(identical(other.allPoint, allPoint) || other.allPoint == allPoint)&&(identical(other.ncode, ncode) || other.ncode == ncode)&&(identical(other.title, title) || other.title == title)&&(identical(other.novelType, novelType) || other.novelType == novelType)&&(identical(other.end, end) || other.end == end)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.writer, writer) || other.writer == writer)&&(identical(other.story, story) || other.story == story)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.generalAllNo, generalAllNo) || other.generalAllNo == generalAllNo)&&(identical(other.keyword, keyword) || other.keyword == keyword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,pt,allPoint,ncode,title,novelType,end,genre,writer,story,userId,generalAllNo,keyword);

@override
String toString() {
  return 'RankingResponse(rank: $rank, pt: $pt, allPoint: $allPoint, ncode: $ncode, title: $title, novelType: $novelType, end: $end, genre: $genre, writer: $writer, story: $story, userId: $userId, generalAllNo: $generalAllNo, keyword: $keyword)';
}


}

/// @nodoc
abstract mixin class _$RankingResponseCopyWith<$Res> implements $RankingResponseCopyWith<$Res> {
  factory _$RankingResponseCopyWith(_RankingResponse value, $Res Function(_RankingResponse) _then) = __$RankingResponseCopyWithImpl;
@override @useResult
$Res call({
 int? rank, int? pt, int? allPoint, String ncode, String? title, int? novelType, int? end, int? genre, String? writer, String? story, int? userId, int? generalAllNo, String? keyword
});




}
/// @nodoc
class __$RankingResponseCopyWithImpl<$Res>
    implements _$RankingResponseCopyWith<$Res> {
  __$RankingResponseCopyWithImpl(this._self, this._then);

  final _RankingResponse _self;
  final $Res Function(_RankingResponse) _then;

/// Create a copy of RankingResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = freezed,Object? pt = freezed,Object? allPoint = freezed,Object? ncode = null,Object? title = freezed,Object? novelType = freezed,Object? end = freezed,Object? genre = freezed,Object? writer = freezed,Object? story = freezed,Object? userId = freezed,Object? generalAllNo = freezed,Object? keyword = freezed,}) {
  return _then(_RankingResponse(
rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,pt: freezed == pt ? _self.pt : pt // ignore: cast_nullable_to_non_nullable
as int?,allPoint: freezed == allPoint ? _self.allPoint : allPoint // ignore: cast_nullable_to_non_nullable
as int?,ncode: null == ncode ? _self.ncode : ncode // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,novelType: freezed == novelType ? _self.novelType : novelType // ignore: cast_nullable_to_non_nullable
as int?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as int?,writer: freezed == writer ? _self.writer : writer // ignore: cast_nullable_to_non_nullable
as String?,story: freezed == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,generalAllNo: freezed == generalAllNo ? _self.generalAllNo : generalAllNo // ignore: cast_nullable_to_non_nullable
as int?,keyword: freezed == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
