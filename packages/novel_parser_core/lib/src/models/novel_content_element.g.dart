// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_content_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlainText _$PlainTextFromJson(Map<String, dynamic> json) =>
    PlainText(json['text'] as String, $type: json['runtimeType'] as String?);

Map<String, dynamic> _$PlainTextToJson(PlainText instance) => <String, dynamic>{
  'text': instance.text,
  'runtimeType': instance.$type,
};

RubyText _$RubyTextFromJson(Map<String, dynamic> json) => RubyText(
  json['base'] as String,
  json['ruby'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$RubyTextToJson(RubyText instance) => <String, dynamic>{
  'base': instance.base,
  'ruby': instance.ruby,
  'runtimeType': instance.$type,
};

Kenten _$KentenFromJson(Map<String, dynamic> json) => Kenten(
  json['base'] as String,
  json['mark'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$KentenToJson(Kenten instance) => <String, dynamic>{
  'base': instance.base,
  'mark': instance.mark,
  'runtimeType': instance.$type,
};

NewLine _$NewLineFromJson(Map<String, dynamic> json) =>
    NewLine($type: json['runtimeType'] as String?);

Map<String, dynamic> _$NewLineToJson(NewLine instance) => <String, dynamic>{
  'runtimeType': instance.$type,
};
