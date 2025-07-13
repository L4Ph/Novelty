import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import '../models/novel_content_element.dart';

List<NovelContentElement> parseNovel(String htmlString) {
  final document = parser.parseFragment(htmlString);

  final elements = <NovelContentElement>[];
  for (final node in document.nodes) {
    _parseNode(node, elements);
  }

  return elements;
}

void _parseNode(dom.Node node, List<NovelContentElement> elements) {
  if (node is dom.Text) {
    final text = node.text.trim();
    if (text.isNotEmpty) {
      elements.add(NovelContentElement.plainText(text));
    }
  } else if (node is dom.Element) {
    switch (node.localName) {
      case 'p':
        for (final child in node.nodes) {
          _parseNode(child, elements);
        }
        // <p>タグの終わりで改行を追加
        if (elements.isNotEmpty && elements.last is! NewLine) {
          elements.add(NovelContentElement.newLine());
        }
      case 'br':
        elements.add(NovelContentElement.newLine());
      case 'ruby':
        String baseText;
        final rubyText = node.querySelector('rt')?.text ?? '';

        // <rb>タグがあればそれを優先、なければ<ruby>直下のテキストノードを本文とする
        final rbElement = node.querySelector('rb');
        if (rbElement != null) {
          baseText = rbElement.text;
        } else {
          baseText = node.nodes
              .whereType<dom.Text>()
              .map((e) => e.text.trim())
              .join('');
        }

        if (baseText.isNotEmpty) {
          elements.add(NovelContentElement.rubyText(baseText, rubyText));
        }
    }
  }
}
