import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:novel_parser_core/novel_parser_core.dart';

/// カクヨムのエピソード本文HTMLをパースする関数。
///
/// 入力は `widget-episodeBody` を含む完全なページHTML、
/// もしくは `<p>` 要素の断片のどちらにも対応する。
/// 段落ごとに末尾へ改行要素を付与し、ルビは [RubyText] に変換する。
List<NovelContentElement> parseKakuyomuEpisodeBody(String html) {
  final document = html_parser.parse(html);
  final body =
      document.querySelector('.widget-episodeBody') ??
      document.body ??
      document;

  final elements = <NovelContentElement>[];
  for (final paragraph in body.querySelectorAll('p')) {
    // 空行（class="blank"）は改行要素1つとして扱う
    final isBlank =
        paragraph.classes.contains('blank') || paragraph.text.trim().isEmpty;
    if (isBlank) {
      elements.add(NovelContentElement.newLine());
      continue;
    }
    _parseInline(paragraph, elements);
    // 段落の区切りとして改行を付与する
    elements.add(NovelContentElement.newLine());
  }
  return elements;
}

/// 段落内の子ノードを再帰的に走査し、要素へ変換する。
void _parseInline(dom.Node node, List<NovelContentElement> elements) {
  for (final child in node.nodes) {
    if (child is dom.Element) {
      switch (child.localName) {
        case 'ruby':
          final base = child.querySelector('rb')?.text;
          final ruby = child.querySelector('rt')?.text;
          if (base != null && base.isNotEmpty && ruby != null) {
            elements.add(
              NovelContentElement.rubyText(base.trim(), ruby.trim()),
            );
          } else if (base != null && base.isNotEmpty) {
            _addPlainText(elements, base);
          }
        case 'br':
          elements.add(NovelContentElement.newLine());
        default:
          // span 等の未知タグは子要素を再帰的に処理する
          _parseInline(child, elements);
      }
    } else if (child is dom.Text) {
      _addPlainText(elements, child.text);
    }
  }
}

/// テキストをトリムして非空なら [PlainText] として追加する。
///
/// なろうパーサーと同様に、段落先頭の全角スペース（字下げ）は除去する。
void _addPlainText(List<NovelContentElement> elements, String text) {
  final trimmed = text.trim();
  if (trimmed.isNotEmpty) {
    elements.add(NovelContentElement.plainText(trimmed));
  }
}
