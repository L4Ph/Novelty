// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_content_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlainText _$PlainTextFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlainText', json, ($checkedConvert) {
      final val = PlainText(
        $checkedConvert('text', (v) => v as String),
        $type: $checkedConvert('runtimeType', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'runtimeType'});

Map<String, dynamic> _$PlainTextToJson(PlainText instance) => <String, dynamic>{
  'text': instance.text,
  'runtimeType': instance.$type,
};

RubyText _$RubyTextFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RubyText', json, ($checkedConvert) {
      final val = RubyText(
        $checkedConvert('base', (v) => v as String),
        $checkedConvert('ruby', (v) => v as String),
        $type: $checkedConvert('runtimeType', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'runtimeType'});

Map<String, dynamic> _$RubyTextToJson(RubyText instance) => <String, dynamic>{
  'base': instance.base,
  'ruby': instance.ruby,
  'runtimeType': instance.$type,
};

Kenten _$KentenFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Kenten', json, ($checkedConvert) {
      final val = Kenten(
        $checkedConvert('base', (v) => v as String),
        $checkedConvert('mark', (v) => v as String),
        $type: $checkedConvert('runtimeType', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'runtimeType'});

Map<String, dynamic> _$KentenToJson(Kenten instance) => <String, dynamic>{
  'base': instance.base,
  'mark': instance.mark,
  'runtimeType': instance.$type,
};

NewLine _$NewLineFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NewLine', json, ($checkedConvert) {
      final val = NewLine(
        $type: $checkedConvert('runtimeType', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'runtimeType'});

Map<String, dynamic> _$NewLineToJson(NewLine instance) => <String, dynamic>{
  'runtimeType': instance.$type,
};
