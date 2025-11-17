// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'novel_download_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NovelDownloadSummary {

/// 小説のncode
 String get ncode;/// ダウンロード成功したエピソード数
 int get successCount;/// ダウンロード失敗したエピソード数
 int get failureCount;/// ダウンロード対象の総エピソード数
 int get totalEpisodes;
/// Create a copy of NovelDownloadSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NovelDownloadSummaryCopyWith<NovelDownloadSummary> get copyWith => _$NovelDownloadSummaryCopyWithImpl<NovelDownloadSummary>(this as NovelDownloadSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NovelDownloadSummary&&(identical(other.ncode, ncode) || other.ncode == ncode)&&(identical(other.successCount, successCount) || other.successCount == successCount)&&(identical(other.failureCount, failureCount) || other.failureCount == failureCount)&&(identical(other.totalEpisodes, totalEpisodes) || other.totalEpisodes == totalEpisodes));
}


@override
int get hashCode => Object.hash(runtimeType,ncode,successCount,failureCount,totalEpisodes);

@override
String toString() {
  return 'NovelDownloadSummary(ncode: $ncode, successCount: $successCount, failureCount: $failureCount, totalEpisodes: $totalEpisodes)';
}


}

/// @nodoc
abstract mixin class $NovelDownloadSummaryCopyWith<$Res>  {
  factory $NovelDownloadSummaryCopyWith(NovelDownloadSummary value, $Res Function(NovelDownloadSummary) _then) = _$NovelDownloadSummaryCopyWithImpl;
@useResult
$Res call({
 String ncode, int successCount, int failureCount, int totalEpisodes
});




}
/// @nodoc
class _$NovelDownloadSummaryCopyWithImpl<$Res>
    implements $NovelDownloadSummaryCopyWith<$Res> {
  _$NovelDownloadSummaryCopyWithImpl(this._self, this._then);

  final NovelDownloadSummary _self;
  final $Res Function(NovelDownloadSummary) _then;

/// Create a copy of NovelDownloadSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ncode = null,Object? successCount = null,Object? failureCount = null,Object? totalEpisodes = null,}) {
  return _then(_self.copyWith(
ncode: null == ncode ? _self.ncode : ncode // ignore: cast_nullable_to_non_nullable
as String,successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,failureCount: null == failureCount ? _self.failureCount : failureCount // ignore: cast_nullable_to_non_nullable
as int,totalEpisodes: null == totalEpisodes ? _self.totalEpisodes : totalEpisodes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NovelDownloadSummary].
extension NovelDownloadSummaryPatterns on NovelDownloadSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NovelDownloadSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NovelDownloadSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NovelDownloadSummary value)  $default,){
final _that = this;
switch (_that) {
case _NovelDownloadSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NovelDownloadSummary value)?  $default,){
final _that = this;
switch (_that) {
case _NovelDownloadSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ncode,  int successCount,  int failureCount,  int totalEpisodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NovelDownloadSummary() when $default != null:
return $default(_that.ncode,_that.successCount,_that.failureCount,_that.totalEpisodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ncode,  int successCount,  int failureCount,  int totalEpisodes)  $default,) {final _that = this;
switch (_that) {
case _NovelDownloadSummary():
return $default(_that.ncode,_that.successCount,_that.failureCount,_that.totalEpisodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ncode,  int successCount,  int failureCount,  int totalEpisodes)?  $default,) {final _that = this;
switch (_that) {
case _NovelDownloadSummary() when $default != null:
return $default(_that.ncode,_that.successCount,_that.failureCount,_that.totalEpisodes);case _:
  return null;

}
}

}

/// @nodoc


class _NovelDownloadSummary extends NovelDownloadSummary {
  const _NovelDownloadSummary({required this.ncode, required this.successCount, required this.failureCount, required this.totalEpisodes}): super._();
  

/// 小説のncode
@override final  String ncode;
/// ダウンロード成功したエピソード数
@override final  int successCount;
/// ダウンロード失敗したエピソード数
@override final  int failureCount;
/// ダウンロード対象の総エピソード数
@override final  int totalEpisodes;

/// Create a copy of NovelDownloadSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NovelDownloadSummaryCopyWith<_NovelDownloadSummary> get copyWith => __$NovelDownloadSummaryCopyWithImpl<_NovelDownloadSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NovelDownloadSummary&&(identical(other.ncode, ncode) || other.ncode == ncode)&&(identical(other.successCount, successCount) || other.successCount == successCount)&&(identical(other.failureCount, failureCount) || other.failureCount == failureCount)&&(identical(other.totalEpisodes, totalEpisodes) || other.totalEpisodes == totalEpisodes));
}


@override
int get hashCode => Object.hash(runtimeType,ncode,successCount,failureCount,totalEpisodes);

@override
String toString() {
  return 'NovelDownloadSummary(ncode: $ncode, successCount: $successCount, failureCount: $failureCount, totalEpisodes: $totalEpisodes)';
}


}

/// @nodoc
abstract mixin class _$NovelDownloadSummaryCopyWith<$Res> implements $NovelDownloadSummaryCopyWith<$Res> {
  factory _$NovelDownloadSummaryCopyWith(_NovelDownloadSummary value, $Res Function(_NovelDownloadSummary) _then) = __$NovelDownloadSummaryCopyWithImpl;
@override @useResult
$Res call({
 String ncode, int successCount, int failureCount, int totalEpisodes
});




}
/// @nodoc
class __$NovelDownloadSummaryCopyWithImpl<$Res>
    implements _$NovelDownloadSummaryCopyWith<$Res> {
  __$NovelDownloadSummaryCopyWithImpl(this._self, this._then);

  final _NovelDownloadSummary _self;
  final $Res Function(_NovelDownloadSummary) _then;

/// Create a copy of NovelDownloadSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ncode = null,Object? successCount = null,Object? failureCount = null,Object? totalEpisodes = null,}) {
  return _then(_NovelDownloadSummary(
ncode: null == ncode ? _self.ncode : ncode // ignore: cast_nullable_to_non_nullable
as String,successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,failureCount: null == failureCount ? _self.failureCount : failureCount // ignore: cast_nullable_to_non_nullable
as int,totalEpisodes: null == totalEpisodes ? _self.totalEpisodes : totalEpisodes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
