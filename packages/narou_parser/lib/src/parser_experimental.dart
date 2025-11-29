import 'package:meta/meta.dart';
import 'package:narou_parser/src/models/novel_content_element.dart';

/// HonoのRegExp Routerに着想を得た、単一正規表現による高速パース処理。
/// DOMツリーを構築せず、HTMLをフラットなトークン列として処理する。
///
/// 注意: 厳密なHTMLパーサーではないため、タグのネスト構造が複雑な場合や、
/// 想定外のタグ属性がある場合は正しく動作しない可能性があります。
@experimental
List<NovelContentElement> parseNovelContentFast(String html) {
  final elements = <NovelContentElement>[];

  // 1. Master Regexの構築
  // 優先順位:
  // Group 1,2: Ruby (<ruby>...<rt>...</rt></ruby>)
  // Group 3: <br>
  // Group 4: </p> (段落終了)
  // Group 5: <p> (段落開始 - 無視するがテキストとして扱わないようにマッチさせる)
  // Group 6: その他のタグ (無視する)
  // Group 7: テキスト (タグ以外の文字)
  final masterRegex = RegExp(
    // ignore: unnecessary_raw_strings
    r'<ruby>(?:<rb>)?(.*?)(?:</rb>)?<rt>(.*?)</rt></ruby>|' // 1,2. Ruby
    r'(<br\s*/?>)|' // 3. BR
    // ignore: unnecessary_raw_strings
    r'(</p>)|' // 4. P End
    // ignore: unnecessary_raw_strings
    r'(<p>)|' // 5. P Start (Ignore)
    // ignore: unnecessary_raw_strings
    r'(<[^>]+>)|' // 6. Other Tags (Ignore)
    // ignore: unnecessary_raw_strings
    r'([^<]+)', // 7. Text
    caseSensitive: false,
    dotAll: true,
  );

  // 2. フラットスキャン (Linear Scan)
  // 文字列全体を一度だけ走査する
  final matches = masterRegex.allMatches(html);

  for (final match in matches) {
    // Ruby Match
    if (match.group(1) != null ||
        (match.groupCount >= 2 && match.group(2) != null)) {
      final base = _decodeEntity(match.group(1) ?? '');
      final ruby = _decodeEntity(match.group(2) ?? '');
      elements.add(NovelContentElement.rubyText(base, ruby));
      continue;
    }

    // BR Match
    if (match.group(3) != null) {
      elements.add(NovelContentElement.newLine());
      continue;
    }

    // P End Match (Add Newline if needed)
    if (match.group(4) != null) {
      if (elements.isNotEmpty && elements.last is! NewLine) {
        elements.add(NovelContentElement.newLine());
      }
      continue;
    }

    // P Start (Group 5) -> 無視
    if (match.group(5) != null) {
      continue;
    }

    // Other Tags (Group 6) -> 無視
    if (match.group(6) != null) {
      continue;
    }

    // Text Match (Group 7)
    final text = match.group(7);
    if (text != null) {
      final trimmed = text.trim(); // ここでtrimするかは要検討だが、今の仕様に合わせる
      if (trimmed.isNotEmpty) {
        elements.add(NovelContentElement.plainText(_decodeEntity(trimmed)));
      }
    }
  }

  return elements;
}

// 簡易HTMLデコード
String _decodeEntity(String text) {
  if (!text.contains('&')) return text;
  return text
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&nbsp;', ' ');
}
