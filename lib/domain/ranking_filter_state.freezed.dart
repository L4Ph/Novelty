// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RankingFilterState {

/// 連載中の作品のみを表示するかどうか。
 bool get showOnlyOngoing;/// 選択されたジャンル。
 int? get selectedGenre;
/// Create a copy of RankingFilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingFilterStateCopyWith<RankingFilterState> get copyWith => _$RankingFilterStateCopyWithImpl<RankingFilterState>(this as RankingFilterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingFilterState&&(identical(other.showOnlyOngoing, showOnlyOngoing) || other.showOnlyOngoing == showOnlyOngoing)&&(identical(other.selectedGenre, selectedGenre) || other.selectedGenre == selectedGenre));
}


@override
int get hashCode => Object.hash(runtimeType,showOnlyOngoing,selectedGenre);

@override
String toString() {
  return 'RankingFilterState(showOnlyOngoing: $showOnlyOngoing, selectedGenre: $selectedGenre)';
}


}

/// @nodoc
abstract mixin class $RankingFilterStateCopyWith<$Res>  {
  factory $RankingFilterStateCopyWith(RankingFilterState value, $Res Function(RankingFilterState) _then) = _$RankingFilterStateCopyWithImpl;
@useResult
$Res call({
 bool showOnlyOngoing, int? selectedGenre
});




}
/// @nodoc
class _$RankingFilterStateCopyWithImpl<$Res>
    implements $RankingFilterStateCopyWith<$Res> {
  _$RankingFilterStateCopyWithImpl(this._self, this._then);

  final RankingFilterState _self;
  final $Res Function(RankingFilterState) _then;

/// Create a copy of RankingFilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showOnlyOngoing = null,Object? selectedGenre = freezed,}) {
  return _then(_self.copyWith(
showOnlyOngoing: null == showOnlyOngoing ? _self.showOnlyOngoing : showOnlyOngoing // ignore: cast_nullable_to_non_nullable
as bool,selectedGenre: freezed == selectedGenre ? _self.selectedGenre : selectedGenre // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RankingFilterState].
extension RankingFilterStatePatterns on RankingFilterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingFilterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingFilterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingFilterState value)  $default,){
final _that = this;
switch (_that) {
case _RankingFilterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingFilterState value)?  $default,){
final _that = this;
switch (_that) {
case _RankingFilterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool showOnlyOngoing,  int? selectedGenre)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingFilterState() when $default != null:
return $default(_that.showOnlyOngoing,_that.selectedGenre);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool showOnlyOngoing,  int? selectedGenre)  $default,) {final _that = this;
switch (_that) {
case _RankingFilterState():
return $default(_that.showOnlyOngoing,_that.selectedGenre);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool showOnlyOngoing,  int? selectedGenre)?  $default,) {final _that = this;
switch (_that) {
case _RankingFilterState() when $default != null:
return $default(_that.showOnlyOngoing,_that.selectedGenre);case _:
  return null;

}
}

}

/// @nodoc


class _RankingFilterState implements RankingFilterState {
  const _RankingFilterState({this.showOnlyOngoing = false, this.selectedGenre});
  

/// 連載中の作品のみを表示するかどうか。
@override@JsonKey() final  bool showOnlyOngoing;
/// 選択されたジャンル。
@override final  int? selectedGenre;

/// Create a copy of RankingFilterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingFilterStateCopyWith<_RankingFilterState> get copyWith => __$RankingFilterStateCopyWithImpl<_RankingFilterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingFilterState&&(identical(other.showOnlyOngoing, showOnlyOngoing) || other.showOnlyOngoing == showOnlyOngoing)&&(identical(other.selectedGenre, selectedGenre) || other.selectedGenre == selectedGenre));
}


@override
int get hashCode => Object.hash(runtimeType,showOnlyOngoing,selectedGenre);

@override
String toString() {
  return 'RankingFilterState(showOnlyOngoing: $showOnlyOngoing, selectedGenre: $selectedGenre)';
}


}

/// @nodoc
abstract mixin class _$RankingFilterStateCopyWith<$Res> implements $RankingFilterStateCopyWith<$Res> {
  factory _$RankingFilterStateCopyWith(_RankingFilterState value, $Res Function(_RankingFilterState) _then) = __$RankingFilterStateCopyWithImpl;
@override @useResult
$Res call({
 bool showOnlyOngoing, int? selectedGenre
});




}
/// @nodoc
class __$RankingFilterStateCopyWithImpl<$Res>
    implements _$RankingFilterStateCopyWith<$Res> {
  __$RankingFilterStateCopyWithImpl(this._self, this._then);

  final _RankingFilterState _self;
  final $Res Function(_RankingFilterState) _then;

/// Create a copy of RankingFilterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showOnlyOngoing = null,Object? selectedGenre = freezed,}) {
  return _then(_RankingFilterState(
showOnlyOngoing: null == showOnlyOngoing ? _self.showOnlyOngoing : showOnlyOngoing // ignore: cast_nullable_to_non_nullable
as bool,selectedGenre: freezed == selectedGenre ? _self.selectedGenre : selectedGenre // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
