// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'novel_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NovelSearchResult {

/// 検索結果の小説リスト
 List<RankingResponse> get novels;/// 検索条件に一致する全件数
 int get allCount;
/// Create a copy of NovelSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NovelSearchResultCopyWith<NovelSearchResult> get copyWith => _$NovelSearchResultCopyWithImpl<NovelSearchResult>(this as NovelSearchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NovelSearchResult&&const DeepCollectionEquality().equals(other.novels, novels)&&(identical(other.allCount, allCount) || other.allCount == allCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(novels),allCount);

@override
String toString() {
  return 'NovelSearchResult(novels: $novels, allCount: $allCount)';
}


}

/// @nodoc
abstract mixin class $NovelSearchResultCopyWith<$Res>  {
  factory $NovelSearchResultCopyWith(NovelSearchResult value, $Res Function(NovelSearchResult) _then) = _$NovelSearchResultCopyWithImpl;
@useResult
$Res call({
 List<RankingResponse> novels, int allCount
});




}
/// @nodoc
class _$NovelSearchResultCopyWithImpl<$Res>
    implements $NovelSearchResultCopyWith<$Res> {
  _$NovelSearchResultCopyWithImpl(this._self, this._then);

  final NovelSearchResult _self;
  final $Res Function(NovelSearchResult) _then;

/// Create a copy of NovelSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? novels = null,Object? allCount = null,}) {
  return _then(_self.copyWith(
novels: null == novels ? _self.novels : novels // ignore: cast_nullable_to_non_nullable
as List<RankingResponse>,allCount: null == allCount ? _self.allCount : allCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NovelSearchResult].
extension NovelSearchResultPatterns on NovelSearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NovelSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NovelSearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NovelSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _NovelSearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NovelSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _NovelSearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RankingResponse> novels,  int allCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NovelSearchResult() when $default != null:
return $default(_that.novels,_that.allCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RankingResponse> novels,  int allCount)  $default,) {final _that = this;
switch (_that) {
case _NovelSearchResult():
return $default(_that.novels,_that.allCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RankingResponse> novels,  int allCount)?  $default,) {final _that = this;
switch (_that) {
case _NovelSearchResult() when $default != null:
return $default(_that.novels,_that.allCount);case _:
  return null;

}
}

}

/// @nodoc


class _NovelSearchResult implements NovelSearchResult {
  const _NovelSearchResult({required final  List<RankingResponse> novels, required this.allCount}): _novels = novels;
  

/// 検索結果の小説リスト
 final  List<RankingResponse> _novels;
/// 検索結果の小説リスト
@override List<RankingResponse> get novels {
  if (_novels is EqualUnmodifiableListView) return _novels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_novels);
}

/// 検索条件に一致する全件数
@override final  int allCount;

/// Create a copy of NovelSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NovelSearchResultCopyWith<_NovelSearchResult> get copyWith => __$NovelSearchResultCopyWithImpl<_NovelSearchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NovelSearchResult&&const DeepCollectionEquality().equals(other._novels, _novels)&&(identical(other.allCount, allCount) || other.allCount == allCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_novels),allCount);

@override
String toString() {
  return 'NovelSearchResult(novels: $novels, allCount: $allCount)';
}


}

/// @nodoc
abstract mixin class _$NovelSearchResultCopyWith<$Res> implements $NovelSearchResultCopyWith<$Res> {
  factory _$NovelSearchResultCopyWith(_NovelSearchResult value, $Res Function(_NovelSearchResult) _then) = __$NovelSearchResultCopyWithImpl;
@override @useResult
$Res call({
 List<RankingResponse> novels, int allCount
});




}
/// @nodoc
class __$NovelSearchResultCopyWithImpl<$Res>
    implements _$NovelSearchResultCopyWith<$Res> {
  __$NovelSearchResultCopyWithImpl(this._self, this._then);

  final _NovelSearchResult _self;
  final $Res Function(_NovelSearchResult) _then;

/// Create a copy of NovelSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? novels = null,Object? allCount = null,}) {
  return _then(_NovelSearchResult(
novels: null == novels ? _self._novels : novels // ignore: cast_nullable_to_non_nullable
as List<RankingResponse>,allCount: null == allCount ? _self.allCount : allCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
