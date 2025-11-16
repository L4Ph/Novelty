// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadResult {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadResult()';
}


}

/// @nodoc
class $DownloadResultCopyWith<$Res>  {
$DownloadResultCopyWith(DownloadResult _, $Res Function(DownloadResult) __);
}


/// Adds pattern-matching-related methods to [DownloadResult].
extension DownloadResultPatterns on DownloadResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Success value)?  success,TResult Function( _PermissionDenied value)?  permissionDenied,TResult Function( _Cancelled value)?  cancelled,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Success() when success != null:
return success(_that);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _Cancelled() when cancelled != null:
return cancelled(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Success value)  success,required TResult Function( _PermissionDenied value)  permissionDenied,required TResult Function( _Cancelled value)  cancelled,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Success():
return success(_that);case _PermissionDenied():
return permissionDenied(_that);case _Cancelled():
return cancelled(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Success value)?  success,TResult? Function( _PermissionDenied value)?  permissionDenied,TResult? Function( _Cancelled value)?  cancelled,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Success() when success != null:
return success(_that);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _Cancelled() when cancelled != null:
return cancelled(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool needsLibraryAddition)?  success,TResult Function()?  permissionDenied,TResult Function()?  cancelled,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Success() when success != null:
return success(_that.needsLibraryAddition);case _PermissionDenied() when permissionDenied != null:
return permissionDenied();case _Cancelled() when cancelled != null:
return cancelled();case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool needsLibraryAddition)  success,required TResult Function()  permissionDenied,required TResult Function()  cancelled,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Success():
return success(_that.needsLibraryAddition);case _PermissionDenied():
return permissionDenied();case _Cancelled():
return cancelled();case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool needsLibraryAddition)?  success,TResult? Function()?  permissionDenied,TResult? Function()?  cancelled,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Success() when success != null:
return success(_that.needsLibraryAddition);case _PermissionDenied() when permissionDenied != null:
return permissionDenied();case _Cancelled() when cancelled != null:
return cancelled();case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Success implements DownloadResult {
  const _Success({this.needsLibraryAddition = false});
  

/// ライブラリへの追加が必要かどうか
@JsonKey() final  bool needsLibraryAddition;

/// Create a copy of DownloadResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.needsLibraryAddition, needsLibraryAddition) || other.needsLibraryAddition == needsLibraryAddition));
}


@override
int get hashCode => Object.hash(runtimeType,needsLibraryAddition);

@override
String toString() {
  return 'DownloadResult.success(needsLibraryAddition: $needsLibraryAddition)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $DownloadResultCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 bool needsLibraryAddition
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of DownloadResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? needsLibraryAddition = null,}) {
  return _then(_Success(
needsLibraryAddition: null == needsLibraryAddition ? _self.needsLibraryAddition : needsLibraryAddition // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _PermissionDenied implements DownloadResult {
  const _PermissionDenied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadResult.permissionDenied()';
}


}




/// @nodoc


class _Cancelled implements DownloadResult {
  const _Cancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadResult.cancelled()';
}


}




/// @nodoc


class _Error implements DownloadResult {
  const _Error(this.message);
  

/// エラーメッセージ
 final  String message;

/// Create a copy of DownloadResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DownloadResult.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $DownloadResultCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of DownloadResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
