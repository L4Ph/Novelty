// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Episode {

/// サブタイトル。
 String? get subtitle;/// エピソードへのURL。
 String? get url;/// 更新日時。
///
/// `YYYY/MM/DD HH:MM` の形式。
 String? get update;/// 改稿日時。
///
/// `YYYY/MM/DD HH:MM` の形式。
 String? get revised;/// Nコード
///
/// 常に小文字で扱う
 String? get ncode;/// 話数。
 int? get index;/// 本文。
///
/// HTML形式。
 String? get body;/// 小説の更新日時。
///
/// `YYYY-MM-DD HH:MM:SS` の形式。
 String? get novelUpdatedAt;
/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeCopyWith<Episode> get copyWith => _$EpisodeCopyWithImpl<Episode>(this as Episode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Episode&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.url, url) || other.url == url)&&(identical(other.update, update) || other.update == update)&&(identical(other.revised, revised) || other.revised == revised)&&(identical(other.ncode, ncode) || other.ncode == ncode)&&(identical(other.index, index) || other.index == index)&&(identical(other.body, body) || other.body == body)&&(identical(other.novelUpdatedAt, novelUpdatedAt) || other.novelUpdatedAt == novelUpdatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,subtitle,url,update,revised,ncode,index,body,novelUpdatedAt);

@override
String toString() {
  return 'Episode(subtitle: $subtitle, url: $url, update: $update, revised: $revised, ncode: $ncode, index: $index, body: $body, novelUpdatedAt: $novelUpdatedAt)';
}


}

/// @nodoc
abstract mixin class $EpisodeCopyWith<$Res>  {
  factory $EpisodeCopyWith(Episode value, $Res Function(Episode) _then) = _$EpisodeCopyWithImpl;
@useResult
$Res call({
 String? subtitle, String? url, String? update, String? revised, String? ncode, int? index, String? body, String? novelUpdatedAt
});




}
/// @nodoc
class _$EpisodeCopyWithImpl<$Res>
    implements $EpisodeCopyWith<$Res> {
  _$EpisodeCopyWithImpl(this._self, this._then);

  final Episode _self;
  final $Res Function(Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subtitle = freezed,Object? url = freezed,Object? update = freezed,Object? revised = freezed,Object? ncode = freezed,Object? index = freezed,Object? body = freezed,Object? novelUpdatedAt = freezed,}) {
  return _then(_self.copyWith(
subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,update: freezed == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as String?,revised: freezed == revised ? _self.revised : revised // ignore: cast_nullable_to_non_nullable
as String?,ncode: freezed == ncode ? _self.ncode : ncode // ignore: cast_nullable_to_non_nullable
as String?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,novelUpdatedAt: freezed == novelUpdatedAt ? _self.novelUpdatedAt : novelUpdatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Episode].
extension EpisodePatterns on Episode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Episode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Episode value)  $default,){
final _that = this;
switch (_that) {
case _Episode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Episode value)?  $default,){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? subtitle,  String? url,  String? update,  String? revised,  String? ncode,  int? index,  String? body,  String? novelUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.subtitle,_that.url,_that.update,_that.revised,_that.ncode,_that.index,_that.body,_that.novelUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? subtitle,  String? url,  String? update,  String? revised,  String? ncode,  int? index,  String? body,  String? novelUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _Episode():
return $default(_that.subtitle,_that.url,_that.update,_that.revised,_that.ncode,_that.index,_that.body,_that.novelUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? subtitle,  String? url,  String? update,  String? revised,  String? ncode,  int? index,  String? body,  String? novelUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.subtitle,_that.url,_that.update,_that.revised,_that.ncode,_that.index,_that.body,_that.novelUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Episode implements Episode {
  const _Episode({this.subtitle, this.url, this.update, this.revised, this.ncode, this.index, this.body, this.novelUpdatedAt});
  

/// サブタイトル。
@override final  String? subtitle;
/// エピソードへのURL。
@override final  String? url;
/// 更新日時。
///
/// `YYYY/MM/DD HH:MM` の形式。
@override final  String? update;
/// 改稿日時。
///
/// `YYYY/MM/DD HH:MM` の形式。
@override final  String? revised;
/// Nコード
///
/// 常に小文字で扱う
@override final  String? ncode;
/// 話数。
@override final  int? index;
/// 本文。
///
/// HTML形式。
@override final  String? body;
/// 小説の更新日時。
///
/// `YYYY-MM-DD HH:MM:SS` の形式。
@override final  String? novelUpdatedAt;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeCopyWith<_Episode> get copyWith => __$EpisodeCopyWithImpl<_Episode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Episode&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.url, url) || other.url == url)&&(identical(other.update, update) || other.update == update)&&(identical(other.revised, revised) || other.revised == revised)&&(identical(other.ncode, ncode) || other.ncode == ncode)&&(identical(other.index, index) || other.index == index)&&(identical(other.body, body) || other.body == body)&&(identical(other.novelUpdatedAt, novelUpdatedAt) || other.novelUpdatedAt == novelUpdatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,subtitle,url,update,revised,ncode,index,body,novelUpdatedAt);

@override
String toString() {
  return 'Episode(subtitle: $subtitle, url: $url, update: $update, revised: $revised, ncode: $ncode, index: $index, body: $body, novelUpdatedAt: $novelUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$EpisodeCopyWith<$Res> implements $EpisodeCopyWith<$Res> {
  factory _$EpisodeCopyWith(_Episode value, $Res Function(_Episode) _then) = __$EpisodeCopyWithImpl;
@override @useResult
$Res call({
 String? subtitle, String? url, String? update, String? revised, String? ncode, int? index, String? body, String? novelUpdatedAt
});




}
/// @nodoc
class __$EpisodeCopyWithImpl<$Res>
    implements _$EpisodeCopyWith<$Res> {
  __$EpisodeCopyWithImpl(this._self, this._then);

  final _Episode _self;
  final $Res Function(_Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subtitle = freezed,Object? url = freezed,Object? update = freezed,Object? revised = freezed,Object? ncode = freezed,Object? index = freezed,Object? body = freezed,Object? novelUpdatedAt = freezed,}) {
  return _then(_Episode(
subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,update: freezed == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as String?,revised: freezed == revised ? _self.revised : revised // ignore: cast_nullable_to_non_nullable
as String?,ncode: freezed == ncode ? _self.ncode : ncode // ignore: cast_nullable_to_non_nullable
as String?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,novelUpdatedAt: freezed == novelUpdatedAt ? _self.novelUpdatedAt : novelUpdatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
