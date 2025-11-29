import 'package:meta/meta.dart';
import 'package:narou_parser/src/models/novel_content_element.dart';

/// 文字列スキャンによる超高速パース処理。
/// 正規表現を使用せず、インデックス操作のみで解析を行うため、理論上最速。
///
/// 注意: 厳密なHTMLパーサーではないため、タグのネスト構造が複雑な場合や、
/// 想定外のタグ属性がある場合は正しく動作しない可能性があります。
@experimental
List<NovelContentElement> parseNovelContentUltra(String html) {
  final elements = <NovelContentElement>[];
  final len = html.length;
  var i = 0;
  var textStart = 0;

  while (i < len) {
    // 次のタグ開始位置 '<' を探す
    final ltIndex = html.indexOf('<', i);

    if (ltIndex == -1) {
      // タグがもうない場合、残りをテキストとして追加して終了
      if (textStart < len) {
        final text = html.substring(textStart, len).trim();
        if (text.isNotEmpty) {
          elements.add(NovelContentElement.plainText(_decodeEntity(text)));
        }
      }
      break;
    }

    // '<' の手前までをテキストとして追加
    if (ltIndex > textStart) {
      final text = html.substring(textStart, ltIndex).trim();
      if (text.isNotEmpty) {
        elements.add(NovelContentElement.plainText(_decodeEntity(text)));
      }
    }

    // タグの解析
    i = ltIndex; // i は '<' の位置

    // タグの中身を確認するための簡易先読み
    if (html.startsWith('<ruby', i)) {
      // Rubyタグの処理
      // <ruby>...<rt>...</rt></ruby> を探す
      // 簡易実装: 次の </ruby> までをルビブロックとして扱う
      final rubyEnd = html.indexOf('</ruby>', i);
      if (rubyEnd != -1) {
        final rubyContentStart = html.indexOf('>', i) + 1; // <ruby> の直後
        // <ruby>...</ruby> の中身
        final inner = html.substring(rubyContentStart, rubyEnd);

        // innerの中から rt を探す
        const rtStartTag = '<rt>';
        const rtEndTag = '</rt>';

        final rtStart = inner.indexOf(rtStartTag);

        if (rtStart != -1) {
          final baseTextPart = inner.substring(
            0,
            rtStart,
          ); // <rt>の前までがrb（または平文）
          final rtContentStart = rtStart + rtStartTag.length;
          final rtEnd = inner.indexOf(rtEndTag, rtContentStart);

          if (rtEnd != -1) {
            final rubyText = inner.substring(rtContentStart, rtEnd);

            // baseTextPart から <rb>, </rb>, <rp>, </rp> を除去
            final baseText = _cleanRubyBase(baseTextPart);

            elements.add(
              NovelContentElement.rubyText(
                _decodeEntity(baseText),
                _decodeEntity(rubyText),
              ),
            );
          }
        }

        i = rubyEnd + 7; // </ruby> の長さ(7)分進める
      } else {
        // 閉じタグがない場合、単なるタグとしてスキップ
        i = html.indexOf('>', i) + 1;
      }
    } else if (html.startsWith('<br', i)) {
      elements.add(NovelContentElement.newLine());
      i = html.indexOf('>', i) + 1;
    } else if (html.startsWith('</p>', i)) {
      if (elements.isNotEmpty && elements.last is! NewLine) {
        elements.add(NovelContentElement.newLine());
      }
      i = i + 4; // </p>
    } else {
      // その他のタグ（<p>, <rb>, <rt>単体, 未知のタグなど）はスキップ
      final gtIndex = html.indexOf('>', i);
      if (gtIndex != -1) {
        i = gtIndex + 1;
      } else {
        // 閉じ括弧がない場合（不正なHTML）、最後まで進めて終了
        i = len;
      }
    }

    textStart = i;
  }

  return elements;
}

// <rb>, </rb>, <rp>...</rp> などを除去してベーステキストを抽出
String _cleanRubyBase(String raw) {
  // 高速化のため、タグがない場合はそのまま返す
  if (!raw.contains('<')) return raw;

  // 文字列操作でタグを除去
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

    // タグの中身チェック (<rp>...</rp> は中身ごと消す必要がある)
    if (raw.startsWith('<rp', lt)) {
      final rpEnd = raw.indexOf('</rp>', lt);
      if (rpEnd != -1) {
        i = rpEnd + 5; // </rp>
        continue;
      }
    }

    // その他のタグ (<rb>, </rb>) はタグだけ消す
    final gt = raw.indexOf('>', lt);
    if (gt != -1) {
      i = gt + 1;
    } else {
      i = len;
    }
  }

  return sb.toString();
}

// 簡易HTMLデコード (Regex版と同じ)
String _decodeEntity(String text) {
  if (!text.contains('&')) return text;
  return text
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&nbsp;', ' ');
}
