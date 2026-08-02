// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'novel_content_element.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
NovelContentElement _$NovelContentElementFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'plainText':
          return PlainText.fromJson(
            json
          );
                case 'rubyText':
          return RubyText.fromJson(
            json
          );
                case 'newLine':
          return NewLine.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'NovelContentElement',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$NovelContentElement {



  /// Serializes this NovelContentElement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NovelContentElement);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NovelContentElement()';
}


}

/// @nodoc
class $NovelContentElementCopyWith<$Res>  {
$NovelContentElementCopyWith(NovelContentElement _, $Res Function(NovelContentElement) __);
}


/// Adds pattern-matching-related methods to [NovelContentElement].
extension NovelContentElementPatterns on NovelContentElement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PlainText value)?  plainText,TResult Function( RubyText value)?  rubyText,TResult Function( NewLine value)?  newLine,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PlainText() when plainText != null:
return plainText(_that);case RubyText() when rubyText != null:
return rubyText(_that);case NewLine() when newLine != null:
return newLine(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PlainText value)  plainText,required TResult Function( RubyText value)  rubyText,required TResult Function( NewLine value)  newLine,}){
final _that = this;
switch (_that) {
case PlainText():
return plainText(_that);case RubyText():
return rubyText(_that);case NewLine():
return newLine(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PlainText value)?  plainText,TResult? Function( RubyText value)?  rubyText,TResult? Function( NewLine value)?  newLine,}){
final _that = this;
switch (_that) {
case PlainText() when plainText != null:
return plainText(_that);case RubyText() when rubyText != null:
return rubyText(_that);case NewLine() when newLine != null:
return newLine(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String text)?  plainText,TResult Function( String base,  String ruby)?  rubyText,TResult Function()?  newLine,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PlainText() when plainText != null:
return plainText(_that.text);case RubyText() when rubyText != null:
return rubyText(_that.base,_that.ruby);case NewLine() when newLine != null:
return newLine();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String text)  plainText,required TResult Function( String base,  String ruby)  rubyText,required TResult Function()  newLine,}) {final _that = this;
switch (_that) {
case PlainText():
return plainText(_that.text);case RubyText():
return rubyText(_that.base,_that.ruby);case NewLine():
return newLine();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String text)?  plainText,TResult? Function( String base,  String ruby)?  rubyText,TResult? Function()?  newLine,}) {final _that = this;
switch (_that) {
case PlainText() when plainText != null:
return plainText(_that.text);case RubyText() when rubyText != null:
return rubyText(_that.base,_that.ruby);case NewLine() when newLine != null:
return newLine();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class PlainText implements NovelContentElement {
   PlainText(this.text, {final  String? $type}): $type = $type ?? 'plainText';
  factory PlainText.fromJson(Map<String, dynamic> json) => _$PlainTextFromJson(json);

 final  String text;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of NovelContentElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlainTextCopyWith<PlainText> get copyWith => _$PlainTextCopyWithImpl<PlainText>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlainTextToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlainText&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'NovelContentElement.plainText(text: $text)';
}


}

/// @nodoc
abstract mixin class $PlainTextCopyWith<$Res> implements $NovelContentElementCopyWith<$Res> {
  factory $PlainTextCopyWith(PlainText value, $Res Function(PlainText) _then) = _$PlainTextCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$PlainTextCopyWithImpl<$Res>
    implements $PlainTextCopyWith<$Res> {
  _$PlainTextCopyWithImpl(this._self, this._then);

  final PlainText _self;
  final $Res Function(PlainText) _then;

/// Create a copy of NovelContentElement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(PlainText(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class RubyText implements NovelContentElement {
   RubyText(this.base, this.ruby, {final  String? $type}): $type = $type ?? 'rubyText';
  factory RubyText.fromJson(Map<String, dynamic> json) => _$RubyTextFromJson(json);

 final  String base;
 final  String ruby;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of NovelContentElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RubyTextCopyWith<RubyText> get copyWith => _$RubyTextCopyWithImpl<RubyText>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RubyTextToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RubyText&&(identical(other.base, base) || other.base == base)&&(identical(other.ruby, ruby) || other.ruby == ruby));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,base,ruby);

@override
String toString() {
  return 'NovelContentElement.rubyText(base: $base, ruby: $ruby)';
}


}

/// @nodoc
abstract mixin class $RubyTextCopyWith<$Res> implements $NovelContentElementCopyWith<$Res> {
  factory $RubyTextCopyWith(RubyText value, $Res Function(RubyText) _then) = _$RubyTextCopyWithImpl;
@useResult
$Res call({
 String base, String ruby
});




}
/// @nodoc
class _$RubyTextCopyWithImpl<$Res>
    implements $RubyTextCopyWith<$Res> {
  _$RubyTextCopyWithImpl(this._self, this._then);

  final RubyText _self;
  final $Res Function(RubyText) _then;

/// Create a copy of NovelContentElement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? base = null,Object? ruby = null,}) {
  return _then(RubyText(
null == base ? _self.base : base // ignore: cast_nullable_to_non_nullable
as String,null == ruby ? _self.ruby : ruby // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class NewLine implements NovelContentElement {
   NewLine({final  String? $type}): $type = $type ?? 'newLine';
  factory NewLine.fromJson(Map<String, dynamic> json) => _$NewLineFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$NewLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewLine);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NovelContentElement.newLine()';
}


}




// dart format on
