import 'package:narou_parser/src/parser_lookup.dart';
import 'package:novel_parser_core/novel_parser_core.dart';

/// HTML文字列から小説のコンテンツをパースする関数。
///
/// 最適化されたLookupベースのパーサーを使用します。
List<NovelContentElement> parseNovelContent(String htmlString) {
  return parseNovelContentLookup(htmlString);
}
