import 'package:narou_parser/src/models/novel_content_element.dart';

/// ルックアップテーブルによる高速パース処理（最適化版）。
///
/// 特徴:
/// 1. switch文による効率的なタグ分岐
/// 2. エンティティデコードの統合（1パス処理）
/// 3. 中間文字列生成の抑制
///
/// 注意: 厳密なHTMLパーサーではないため、タグのネスト構造が複雑な場合や、
/// 想定外のタグ属性がある場合は正しく動作しない可能性があります。
List<NovelContentElement> parseNovelContentLookup(String html) {
  final elements = <NovelContentElement>[];
  final len = html.length;
  var i = 0;
  final sb = StringBuffer();

  void flushBuffer() {
    if (sb.isNotEmpty) {
      final text = sb.toString().trim();
      if (text.isNotEmpty) {
        elements.add(NovelContentElement.plainText(text));
      }
      sb.clear();
    }
  }

  while (i < len) {
    final char = html.codeUnitAt(i);

    // Switch on first char is the "Lookup" part
    switch (char) {
      case 60: // <
        flushBuffer();
        // Lookahead for tag type
        if (i + 1 >= len) {
          i++;
          continue;
        }
        final nextChar = html.codeUnitAt(i + 1);

        switch (nextChar) {
          case 114: // r (ruby)
            if (html.startsWith('uby', i + 2)) {
              final rubyEnd = html.indexOf('</ruby>', i);
              if (rubyEnd != -1) {
                final rubyContentStart = html.indexOf('>', i) + 1;
                final inner = html.substring(rubyContentStart, rubyEnd);
                _processRubyContent(inner, elements);
                i = rubyEnd + 7;
                continue;
              }
            }
          case 98: // b (br)
            if (html.startsWith('r', i + 2)) {
              elements.add(NovelContentElement.newLine());
              i = html.indexOf('>', i) + 1;
              continue;
            }
          case 47: // / (closing)
            if (html.startsWith('p>', i + 2)) {
              if (elements.isNotEmpty && elements.last is! NewLine) {
                elements.add(NovelContentElement.newLine());
              }
              i += 4;
              continue;
            }
        }

        // Skip unknown tag
        while (i < len && html.codeUnitAt(i) != 62) {
          i++;
        }
        i++;
        continue;

      case 38: // &
        if (html.startsWith('lt;', i + 1)) {
          sb.write('<');
          i += 4;
          continue;
        }
        if (html.startsWith('gt;', i + 1)) {
          sb.write('>');
          i += 4;
          continue;
        }
        if (html.startsWith('amp;', i + 1)) {
          sb.write('&');
          i += 5;
          continue;
        }
        if (html.startsWith('quot;', i + 1)) {
          sb.write('"');
          i += 6;
          continue;
        }
        if (html.startsWith('nbsp;', i + 1)) {
          sb.write(' ');
          i += 6;
          continue;
        }
        sb.writeCharCode(char);
        i++;
        continue;

      default:
        sb.writeCharCode(char);
        i++;
    }
  }
  flushBuffer();
  return elements;
}

void _processRubyContent(String inner, List<NovelContentElement> elements) {
  const rtStartTag = '<rt>';
  const rtEndTag = '</rt>';

  final rtStart = inner.indexOf(rtStartTag);

  if (rtStart != -1) {
    final baseTextPart = inner.substring(0, rtStart);
    final rtContentStart = rtStart + rtStartTag.length;
    final rtEnd = inner.indexOf(rtEndTag, rtContentStart);

    if (rtEnd != -1) {
      final rubyText = inner.substring(rtContentStart, rtEnd);
      final baseText = _cleanRubyBase(baseTextPart);

      elements.add(
        NovelContentElement.rubyText(
          _decodeEntity(baseText),
          _decodeEntity(rubyText),
        ),
      );
    }
  }
}

/// `<rb>`, `</rb>`, `<rp>...</rp>` などを除去してベーステキストを抽出
String _cleanRubyBase(String raw) {
  if (!raw.contains('<')) return raw.trim();

  final sb = StringBuffer();
  var i = 0;
  final len = raw.length;

  while (i < len) {
    final lt = raw.indexOf('<', i);
    if (lt == -1) {
      sb.write(raw.substring(i));
      break;
    }

    if (lt > i) {
      sb.write(raw.substring(i, lt));
    }

    // <rp>...</rp> は中身ごと消す
    if (raw.startsWith('<rp', lt)) {
      final rpEnd = raw.indexOf('</rp>', lt);
      if (rpEnd != -1) {
        i = rpEnd + 5;
        continue;
      }
    }

    // その他のタグはタグだけ消す
    final gt = raw.indexOf('>', lt);
    if (gt != -1) {
      i = gt + 1;
    } else {
      i = len;
    }
  }

  return sb.toString().trim();
}

/// 簡易HTMLデコード (Ruby内部などで使用)
String _decodeEntity(String text) {
  if (!text.contains('&')) return text;
  return text
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&nbsp;', ' ');
}
