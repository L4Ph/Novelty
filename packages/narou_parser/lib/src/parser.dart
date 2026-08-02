import 'package:narou_parser/src/models/novel_content_element.dart';
import 'package:narou_parser/src/parser_lookup.dart';

/// HTML文字列から小説のコンテンツをパースする関数。
///
/// 最適化されたLookupベースのパーサーを使用します。
List<NovelContentElement> parseNovelContent(String htmlString) {
  return parseNovelContentLookup(htmlString);
}
