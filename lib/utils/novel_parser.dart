import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import '../models/novel_content_element.dart';

class NovelParser {
  static List<NovelContentElement> parse(String htmlString) {
    final document = parser.parse(htmlString);
    final honbun = document.getElementById('novel_honbun');

    if (honbun == null) {
      return [];
    }

    final elements = <NovelContentElement>[];
    for (final node in honbun.nodes) {
      _parseNode(node, elements);
    }

    return elements;
  }

  static void _parseNode(dom.Node node, List<NovelContentElement> elements) {
    if (node is dom.Text) {
      final text = node.text.trim();
      if (text.isNotEmpty) {
        elements.add(PlainText(text));
      }
    } else if (node is dom.Element) {
      switch (node.localName) {
        case 'p':
          for (final child in node.nodes) {
            _parseNode(child, elements);
          }
          // <p>タグの終わりで改行を追加
          if (elements.isNotEmpty && elements.last is! NewLine) {
            elements.add(const NewLine());
          }
          break;
        case 'br':
          elements.add(const NewLine());
          break;
        case 'ruby':
          final baseText = node.querySelector('rb')?.text ?? '';
          final rubyText = node.querySelector('rt')?.text ?? '';
          if (baseText.isNotEmpty) {
            elements.add(RubyText(baseText, rubyText));
          }
          break;
        default:
          // 他のタグは今のところ無視
          break;
      }
    }
  }
}