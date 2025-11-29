import 'package:meta/meta.dart';
import 'package:narou_parser/src/models/novel_content_element.dart';

/// ルックアップテーブルによる高速パース処理。
/// 文字ごとにアクションテーブルを参照して処理を行うことで、分岐を最小化。
///
/// 注意: 厳密なHTMLパーサーではないため、タグのネスト構造が複雑な場合や、
/// 想定外のタグ属性がある場合は正しく動作しない可能性があります。
@experimental
List<NovelContentElement> parseNovelContentLookup(String html) {
  final elements = <NovelContentElement>[];
  final len = html.length;
  var i = 0;

  while (i < len) {
    // '<' を探す
    final ltIndex = html.indexOf('<', i);

    if (ltIndex == -1) {
      // タグがもうない場合、残りをテキストとして追加
      if (i < len) {
        final text = html.substring(i).trim();
        if (text.isNotEmpty) {
          elements.add(NovelContentElement.plainText(_decodeEntity(text)));
        }
      }
      break;
    }

    // '<' の手前までをテキストとして追加
    if (ltIndex > i) {
      final text = html.substring(i, ltIndex).trim();
      if (text.isNotEmpty) {
        elements.add(NovelContentElement.plainText(_decodeEntity(text)));
      }
    }

    // タグの処理
    i = ltIndex;

    // タグの種類をルックアップテーブルで判定
    final tagType = _lookupTagType(html, i);

    switch (tagType) {
      case _TagType.ruby:
        i = _processRubyTag(html, i, elements);
      case _TagType.br:
        elements.add(NovelContentElement.newLine());
        i = html.indexOf('>', i) + 1;
      case _TagType.pClose:
        if (elements.isNotEmpty && elements.last is! NewLine) {
          elements.add(NovelContentElement.newLine());
        }
        i = i + 4; // </p>
      case _TagType.pOpen:
        i = html.indexOf('>', i) + 1;
      case _TagType.unknown:
        final gtIndex = html.indexOf('>', i);
        i = gtIndex != -1 ? gtIndex + 1 : len;
    }
  }

  return elements;
}

/// タグの種類
enum _TagType {
  ruby,
  br,
  pOpen,
  pClose,
  unknown,
}

/// ルックアップテーブルでタグの種類を判定
_TagType _lookupTagType(String html, int pos) {
  // 最小限のチェックで判定
  if (pos + 1 >= html.length) return _TagType.unknown;

  final char = html.codeUnitAt(pos + 1);

  // ルックアップテーブル（ASCII コード順）
  switch (char) {
    case 47: // '/' (closing tag)
      if (pos + 3 < html.length && html.codeUnitAt(pos + 2) == 112) { // 'p'
        return _TagType.pClose;
      }
      return _TagType.unknown;

    case 98: // 'b' (br)
      if (pos + 3 < html.length && html.codeUnitAt(pos + 2) == 114) { // 'r'
        return _TagType.br;
      }
      return _TagType.unknown;

    case 112: // 'p'
      return _TagType.pOpen;

    case 114: // 'r' (ruby)
      if (pos + 5 < html.length &&
          html.codeUnitAt(pos + 2) == 117 && // 'u'
          html.codeUnitAt(pos + 3) == 98 &&   // 'b'
          html.codeUnitAt(pos + 4) == 121) {  // 'y'
        return _TagType.ruby;
      }
      return _TagType.unknown;

    default:
      return _TagType.unknown;
  }
}

/// Ruby タグを処理
int _processRubyTag(String html, int pos, List<NovelContentElement> elements) {
  final rubyEnd = html.indexOf('</ruby>', pos);
  if (rubyEnd == -1) {
    // 閉じタグがない場合
    return html.indexOf('>', pos) + 1;
  }

  final rubyContentStart = html.indexOf('>', pos) + 1;
  final inner = html.substring(rubyContentStart, rubyEnd);

  // rt タグを探す
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

  return rubyEnd + 7; // </ruby> の長さ(7)分進める
}

/// <rb>, </rb>, <rp>...</rp> などを除去してベーステキストを抽出
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

/// 簡易HTMLデコード
String _decodeEntity(String text) {
  if (!text.contains('&')) return text;
  return text
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&nbsp;', ' ');
}
