import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/vertical_orientation.dart';
import 'package:tategaki/src/utils/glyph_mapper.dart';

/// 文字列を縦書き要素に変換するパーサー
///
/// 数字・欧文の「向きのラダー」（JLREQ §3.2.3 準拠）:
/// - 半角数字トークン（数字＋小数点・位取りコンマ）は数字の総数で判定する。
///   - 1桁: 正立（1文字）
///   - 2桁: 縦中横（TCY）
///   - 3桁以上 or 区切りを含む: トークン全体を回転（縦向き）
/// - 半角英字ラン: 1文字は正立、2文字以上はラン全体を回転。
class TategakiParser {
  TategakiParser._();

  /// 数字トークンの区切り文字（小数点・位取りコンマ）
  static const _numericSeparators = <String>{'.', ','};

  /// 文字列をパースして要素リストに変換する
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

      // 半角数字トークン
      if (_isHalfWidthDigit(char)) {
        final start = i;
        i++;
        var hasSeparator = false;
        while (i < runes.length) {
          final current = String.fromCharCode(runes[i]);
          if (_isHalfWidthDigit(current)) {
            i++;
            continue;
          }
          // 区切りの後ろに数字が続く場合のみトークンに含める
          if (_numericSeparators.contains(current) &&
              i + 1 < runes.length &&
              _isHalfWidthDigit(String.fromCharCode(runes[i + 1]))) {
            hasSeparator = true;
            i += 2;
            continue;
          }
          break;
        }
        final token = String.fromCharCodes(runes.sublist(start, i));
        elements.add(_numericElement(token, hasSeparator: hasSeparator));
        continue;
      }

      // 半角英字ラン
      if (_isHalfWidthLetter(char)) {
        final start = i;
        while (i < runes.length &&
            _isHalfWidthLetter(String.fromCharCode(runes[i]))) {
          i++;
        }
        final run = String.fromCharCodes(runes.sublist(start, i));
        if (run.runes.length == 1) {
          elements.add(TategakiChar(run));
        } else {
          elements.add(TategakiRotated(run));
        }
        continue;
      }

      // 通常の文字。縦書き字形があればそれを使い、無ければ UTR #50 で
      // 横倒し（R）と判定される文字は回転する。
      final mapped = GlyphMapper.map(char);
      if (mapped != char) {
        elements.add(TategakiChar(mapped));
      } else if (VerticalOrientation.isRotated(char.runes.first)) {
        elements.add(TategakiRotated(char));
      } else {
        elements.add(TategakiChar(char));
      }
      i++;
    }

    return elements;
  }

  /// 数字トークンを向きのラダーに従って要素化する
  static TategakiElement _numericElement(
    String token, {
    required bool hasSeparator,
  }) {
    final digitCount = token.runes
        .where((r) => r >= 0x30 && r <= 0x39)
        .length;
    if (!hasSeparator && digitCount == 1) {
      return TategakiChar(token);
    }
    if (!hasSeparator && digitCount == 2) {
      return TategakiTcy(token);
    }
    return TategakiRotated(token);
  }

  /// 半角数字かどうかを判定
  static bool _isHalfWidthDigit(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return code >= 0x30 && code <= 0x39; // '0' - '9'
  }

  /// 半角英字かどうかを判定
  static bool _isHalfWidthLetter(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 0x41 && code <= 0x5A) || (code >= 0x61 && code <= 0x7A);
  }
}
