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

NewLine _$NewLineFromJson(Map<String, dynamic> json) =>
    NewLine($type: json['runtimeType'] as String?);

Map<String, dynamic> _$NewLineToJson(NewLine instance) => <String, dynamic>{
  'runtimeType': instance.$type,
};
