import 'package:freezed_annotation/freezed_annotation.dart';

part 'novel_content_element.freezed.dart';
part 'novel_content_element.g.dart';

@freezed
sealed class NovelContentElement with _$NovelContentElement {
  factory NovelContentElement.plainText(String text) = PlainText;
  factory NovelContentElement.rubyText(String base, String ruby) = RubyText;
  factory NovelContentElement.newLine() = NewLine;

  factory NovelContentElement.fromJson(Map<String, dynamic> json) =>
      _$NovelContentElementFromJson(json);
}
