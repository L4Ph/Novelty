import 'package:narou_parser/narou_parser.dart';
import 'package:tategaki/tategaki.dart';

/// NovelContentElementからTategakiElementへの変換ユーティリティ
class TategakiConverter {
  TategakiConverter._();

  /// NovelContentElementのリストをTategakiElementのリストに変換する
  static List<TategakiElement> convert(List<NovelContentElement> elements) {
    final result = <TategakiElement>[];

    for (final element in elements) {
      switch (element) {
        case PlainText(:final text):
          // PlainTextはTategakiParserでパースして縦中横などを適用
          result.addAll(TategakiParser.parse(text));
        case RubyText(:final base, :final ruby):
          result.add(TategakiElement.ruby(base: base, ruby: ruby));
        case NewLine():
          result.add(const TategakiElement.newLine());
      }
    }

    return result;
  }
}
