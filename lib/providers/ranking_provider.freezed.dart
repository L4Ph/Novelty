// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RankingState {

 List<NovelInfo> get novels; bool get isLoading; bool get isLoadingMore; bool get hasMore; int get page; Object? get error;
/// Create a copy of RankingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingStateCopyWith<RankingState> get copyWith => _$RankingStateCopyWithImpl<RankingState>(this as RankingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingState&&const DeepCollectionEquality().equals(other.novels, novels)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(novels),isLoading,isLoadingMore,hasMore,page,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'RankingState(novels: $novels, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, page: $page, error: $error)';
}


}

/// @nodoc
abstract mixin class $RankingStateCopyWith<$Res>  {
  factory $RankingStateCopyWith(RankingState value, $Res Function(RankingState) _then) = _$RankingStateCopyWithImpl;
@useResult
$Res call({
 List<NovelInfo> novels, bool isLoading, bool isLoadingMore, bool hasMore, int page, Object? error
});




}
/// @nodoc
class _$RankingStateCopyWithImpl<$Res>
    implements $RankingStateCopyWith<$Res> {
  _$RankingStateCopyWithImpl(this._self, this._then);

  final RankingState _self;
  final $Res Function(RankingState) _then;

/// Create a copy of RankingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? novels = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? page = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
novels: null == novels ? _self.novels : novels // ignore: cast_nullable_to_non_nullable
as List<NovelInfo>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [RankingState].
extension RankingStatePatterns on RankingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingState value)  $default,){
final _that = this;
switch (_that) {
case _RankingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingState value)?  $default,){
final _that = this;
switch (_that) {
case _RankingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NovelInfo> novels,  bool isLoading,  bool isLoadingMore,  bool hasMore,  int page,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingState() when $default != null:
return $default(_that.novels,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.page,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NovelInfo> novels,  bool isLoading,  bool isLoadingMore,  bool hasMore,  int page,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _RankingState():
return $default(_that.novels,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.page,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NovelInfo> novels,  bool isLoading,  bool isLoadingMore,  bool hasMore,  int page,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _RankingState() when $default != null:
return $default(_that.novels,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.page,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _RankingState implements RankingState {
  const _RankingState({final  List<NovelInfo> novels = const [], this.isLoading = false, this.isLoadingMore = false, this.hasMore = true, this.page = 1, this.error}): _novels = novels;
  

 final  List<NovelInfo> _novels;
@override@JsonKey() List<NovelInfo> get novels {
  if (_novels is EqualUnmodifiableListView) return _novels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_novels);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  int page;
@override final  Object? error;

/// Create a copy of RankingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingStateCopyWith<_RankingState> get copyWith => __$RankingStateCopyWithImpl<_RankingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingState&&const DeepCollectionEquality().equals(other._novels, _novels)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_novels),isLoading,isLoadingMore,hasMore,page,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'RankingState(novels: $novels, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, page: $page, error: $error)';
}


}

/// @nodoc
abstract mixin class _$RankingStateCopyWith<$Res> implements $RankingStateCopyWith<$Res> {
  factory _$RankingStateCopyWith(_RankingState value, $Res Function(_RankingState) _then) = __$RankingStateCopyWithImpl;
@override @useResult
$Res call({
 List<NovelInfo> novels, bool isLoading, bool isLoadingMore, bool hasMore, int page, Object? error
});




}
/// @nodoc
class __$RankingStateCopyWithImpl<$Res>
    implements _$RankingStateCopyWith<$Res> {
  __$RankingStateCopyWithImpl(this._self, this._then);

  final _RankingState _self;
  final $Res Function(_RankingState) _then;

/// Create a copy of RankingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? novels = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? page = null,Object? error = freezed,}) {
  return _then(_RankingState(
novels: null == novels ? _self._novels : novels // ignore: cast_nullable_to_non_nullable
as List<NovelInfo>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
