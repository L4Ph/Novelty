import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:narou_parser/src/models/novel_content_element.dart';
import 'package:narou_parser/src/parser_lookup.dart';

/// HTML文字列から小説のコンテンツをパースする関数。
///
/// 最適化されたLookupベースのパーサーを使用します。
List<NovelContentElement> parseNovelContent(String htmlString) {
  return parseNovelContentLookup(htmlString);
}

/// HTML文字列から小説のコンテンツをパースする関数（旧実装）。
///
/// package:html を使用したDOMベースの実装です。
/// 互換性のために残されています。

@deprecated
List<NovelContentElement> parseNovelContentLegacy(String htmlString) {
  final elements = <NovelContentElement>[];

  // 巨大なHTMLの場合、チャンクに分割して処理することでパフォーマンス低下（O(N^2)傾向）を防ぐ
  // 目安として5,000文字ごとに分割処理を行う
  // ベンチマーク検証結果（30万行処理時）:
  // - 10,000文字: 1278ms
  // - 5,000文字: 1138ms (約11%高速)
  // 1,000文字まで下げても1117msと大差ないため、バランスの良い5,000を採用
  const chunkSize = 5000;

  if (htmlString.length > chunkSize * 2) {
    var start = 0;
    final length = htmlString.length;

    while (start < length) {
      // チャンクサイズ分進んだ位置から、次の </p> を探す
      // これにより、HTMLタグの途中で分割されるのを防ぐ（<p>単位で処理）
      var end = -1;
      if (start + chunkSize < length) {
        end = htmlString.indexOf('</p>', start + chunkSize);
      }

      // </p>が見つからない、または残りがチャンクサイズ未満の場合は最後まで
      if (end == -1) {
        end = length;
      } else {
        end += 4; // </p> の長さ（4文字）分を含める
      }

      final chunk = htmlString.substring(start, end);
      _parseHtmlFragment(chunk, elements);

      start = end;
    }
  } else {
    // サイズが小さい場合は一括処理
    _parseHtmlFragment(htmlString, elements);
  }

  return elements;
}

void _parseHtmlFragment(
  String htmlFragment,
  List<NovelContentElement> elements,
) {
  final document = parser.parseFragment(htmlFragment);
  for (final node in document.nodes) {
    _parseNode(node, elements);
  }
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
        String? rbText;
        String? rtText;
        final textBuffer = StringBuffer();

        for (final child in node.nodes) {
          if (child is dom.Element) {
            if (child.localName == 'rb' && rbText == null) {
              rbText = child.text;
            } else if (child.localName == 'rt' && rtText == null) {
              rtText = child.text;
            }
          } else if (child is dom.Text) {
            textBuffer.write(child.text.trim());
          }
        }

        final baseText = rbText ?? textBuffer.toString();
        final rubyText = rtText ?? '';

        if (baseText.isNotEmpty) {
          elements.add(NovelContentElement.rubyText(baseText, rubyText));
        }
    }
  }
}
