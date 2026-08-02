import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'novel_content_element.freezed.dart';
part 'novel_content_element.g.dart';

/// 小説のコンテンツ要素を表すクラス。
@freezed
sealed class NovelContentElement with _$NovelContentElement {
  /// プレーンテキスト
  factory NovelContentElement.plainText(String text) = PlainText;

  /// ルビ付きテキスト（base: 親文字, ruby: ルビ）
  factory NovelContentElement.rubyText(String base, String ruby) = RubyText;

  /// 改行
  factory NovelContentElement.newLine() = NewLine;

  /// JSONからの変換
  factory NovelContentElement.fromJson(Map<String, dynamic> json) =>
      _$NovelContentElementFromJson(json);
}

/// [NovelContentElement]のリストに対する拡張
extension NovelContentListExtension on List<NovelContentElement> {
  /// JSON文字列に変換（Minify適用）
  String toJsonString() {
    return json.encode(map((e) => e.toJson()).toList());
  }
}
