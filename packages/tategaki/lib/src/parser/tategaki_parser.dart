import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/utils/glyph_mapper.dart';

/// 文字列を縦書き要素に変換するパーサー
class TategakiParser {
  TategakiParser._();

  /// 文字列をパースして要素リストに変換する
  ///
  /// - 改行（\n）を検出して [TategakiNewLine] に
  /// - 連続する半角数字（2〜3桁）を検出して [TategakiTcy] に
  /// - 残りの文字を1文字ずつ [TategakiChar] に（字形変換適用）
  static List<TategakiElement> parse(String text) {
    if (text.isEmpty) return [];

    final elements = <TategakiElement>[];
    final runes = text.runes.toList();
    var i = 0;

    while (i < runes.length) {
      final char = String.fromCharCode(runes[i]);

      // 改行の処理
      if (char == '\n') {
        elements.add(const TategakiNewLine());
        i++;
        continue;
      }

      // 半角数字の検出
      if (_isHalfWidthDigit(char)) {
        final digitStart = i;
        var digitEnd = i;

        // 連続する数字を探す
        while (digitEnd < runes.length &&
            _isHalfWidthDigit(String.fromCharCode(runes[digitEnd]))) {
          digitEnd++;
        }

        final digitCount = digitEnd - digitStart;

        if (digitCount >= 2 && digitCount <= 3) {
          // 2〜3桁は縦中横
          final digits = String.fromCharCodes(runes.sublist(digitStart, digitEnd));
          elements.add(TategakiTcy(digits));
          i = digitEnd;
        } else {
          // 1桁または4桁以上は1文字ずつ
          for (var j = digitStart; j < digitEnd; j++) {
            final digit = String.fromCharCode(runes[j]);
            elements.add(TategakiChar(digit));
          }
          i = digitEnd;
        }
        continue;
      }

      // 通常の文字（字形変換を適用）
      final mappedChar = GlyphMapper.map(char);
      elements.add(TategakiChar(mappedChar));
      i++;
    }

    return elements;
  }

  /// 半角数字かどうかを判定
  static bool _isHalfWidthDigit(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return code >= 0x30 && code <= 0x39; // '0' - '9'
  }
}
