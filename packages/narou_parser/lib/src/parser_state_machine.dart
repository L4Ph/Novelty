import 'package:meta/meta.dart';
import 'package:narou_parser/src/models/novel_content_element.dart';

/// 状態機械による超高速パース処理。
/// 各文字を読んで状態を遷移させることで、最小限の分岐で処理を行う。
///
/// 注意: 厳密なHTMLパーサーではないため、タグのネスト構造が複雑な場合や、
/// 想定外のタグ属性がある場合は正しく動作しない可能性があります。
@experimental
List<NovelContentElement> parseNovelContentStateMachine(String html) {
  final elements = <NovelContentElement>[];
  final len = html.length;

  // 状態定義
  var state = _State.text;
  var textStart = 0;
  var tagStart = 0;

  // Ruby関連のバッファ
  var rubyBase = '';
  var rubyText = '';
  var inRubyBase = false;
  var inRubyText = false;

  for (var i = 0; i < len; i++) {
    final char = html.codeUnitAt(i);

    switch (state) {
      case _State.text:
        if (char == 60) { // '<'
          // テキストを保存
          if (i > textStart) {
            final text = html.substring(textStart, i).trim();
            if (text.isNotEmpty) {
              elements.add(NovelContentElement.plainText(_decodeEntity(text)));
            }
          }
          tagStart = i;
          state = _State.tagOpen;
        }

      case _State.tagOpen:
        if (char == 112) { // 'p'
          state = _State.inP;
        } else if (char == 98) { // 'b' (br)
          state = _State.inBr;
        } else if (char == 114) { // 'r' (ruby)
          state = _State.inRuby;
        } else if (char == 47) { // '/' (closing tag)
          state = _State.inClosingTag;
        } else {
          state = _State.skipTag;
        }

      case _State.inP:
        if (char == 62) { // '>'
          textStart = i + 1;
          state = _State.text;
        }

      case _State.inBr:
        if (char == 62) { // '>'
          elements.add(NovelContentElement.newLine());
          textStart = i + 1;
          state = _State.text;
        }

      case _State.inRuby:
        if (char == 62) { // '>'
          inRubyBase = false;
          inRubyText = false;
          rubyBase = '';
          rubyText = '';
          textStart = i + 1;
          state = _State.rubyContent;
        }

      case _State.rubyContent:
        if (char == 60) { // '<'
          // タグの開始
          final text = html.substring(textStart, i);
          if (!inRubyBase && !inRubyText && text.isNotEmpty) {
            // タグの外のテキスト = ベーステキスト
            rubyBase = text.trim();
          }
          tagStart = i;
          state = _State.rubyTag;
        }

      case _State.rubyTag:
        if (char == 114) { // 'r'
          // rb または rt
          if (i + 1 < len && html.codeUnitAt(i + 1) == 98) { // 'b'
            state = _State.rubyRb;
          } else if (i + 1 < len && html.codeUnitAt(i + 1) == 116) { // 't'
            state = _State.rubyRt;
          } else if (i + 1 < len && html.codeUnitAt(i + 1) == 112) { // 'p' (rp)
            state = _State.rubyRp;
          } else {
            state = _State.skipTag;
          }
        } else if (char == 47) { // '/' (closing tag)
          state = _State.rubyClosingTag;
        } else {
          state = _State.skipTag;
        }

      case _State.rubyRb:
        if (char == 62) { // '>'
          inRubyBase = true;
          textStart = i + 1;
          state = _State.rubyRbContent;
        }

      case _State.rubyRbContent:
        if (char == 60) { // '<'
          rubyBase = html.substring(textStart, i).trim();
          inRubyBase = false;
          tagStart = i;
          state = _State.rubyTag;
        }

      case _State.rubyRt:
        if (char == 62) { // '>'
          inRubyText = true;
          textStart = i + 1;
          state = _State.rubyRtContent;
        }

      case _State.rubyRtContent:
        if (char == 60) { // '<'
          rubyText = html.substring(textStart, i).trim();
          inRubyText = false;
          tagStart = i;
          state = _State.rubyTag;
        }

      case _State.rubyRp:
        if (char == 62) { // '>'
          // rp タグの内容はスキップ
          state = _State.rubyRpContent;
        }

      case _State.rubyRpContent:
        if (char == 60) { // '<'
          tagStart = i;
          state = _State.rubyTag;
        }

      case _State.rubyClosingTag:
        if (char == 114 && i + 3 < len &&
            html.substring(i, i + 4) == 'ruby') { // '/ruby>'
          // Ruby要素を追加
          if (rubyBase.isNotEmpty) {
            elements.add(NovelContentElement.rubyText(
              _decodeEntity(rubyBase),
              _decodeEntity(rubyText),
            ));
          }
          // </ruby> をスキップ
          i = html.indexOf('>', i);
          if (i == -1) break;
          textStart = i + 1;
          state = _State.text;
        } else {
          state = _State.skipTag;
        }

      case _State.inClosingTag:
        if (char == 112 && i + 1 < len && html.codeUnitAt(i + 1) == 62) { // 'p>'
          // </p> で改行を追加
          if (elements.isNotEmpty && elements.last is! NewLine) {
            elements.add(NovelContentElement.newLine());
          }
          i++; // '>' をスキップ
          textStart = i + 1;
          state = _State.text;
        } else {
          state = _State.skipTag;
        }

      case _State.skipTag:
        if (char == 62) { // '>'
          textStart = i + 1;
          // Ruby中なら rubyContent に戻る
          if (inRubyBase || inRubyText || rubyBase.isNotEmpty || rubyText.isNotEmpty) {
            state = _State.rubyContent;
          } else {
            state = _State.text;
          }
        }
    }
  }

  return elements;
}

/// パーサーの状態
enum _State {
  text,           // テキスト領域
  tagOpen,        // タグ開始 '<' の直後
  inP,            // <p> タグ内
  inBr,           // <br> タグ内
  inRuby,         // <ruby> タグ内
  rubyContent,    // <ruby>...</ruby> のコンテンツ部分
  rubyTag,        // Ruby内のタグ開始
  rubyRb,         // <rb> タグ
  rubyRbContent,  // <rb>...</rb> のコンテンツ
  rubyRt,         // <rt> タグ
  rubyRtContent,  // <rt>...</rt> のコンテンツ
  rubyRp,         // <rp> タグ
  rubyRpContent,  // <rp>...</rp> のコンテンツ（スキップ）
  rubyClosingTag, // Ruby内の閉じタグ
  inClosingTag,   // 閉じタグ '</' の直後
  skipTag,        // タグをスキップ
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
