import 'package:tategaki/src/layout/tategaki_char_class.dart';

/// 文字クラス間の空き量（アキ）を em 単位で返す（JLREQ 表1の規則版）
class TategakiAki {
  TategakiAki._();

  /// 終わり括弧・読点・句点の後ろに確保する空き
  static const double _afterClosing = 0.5;

  /// 中点類の前後に確保する空き
  static const double _aroundMiddleDot = 0.25;

  /// 和欧間の空き
  static const double _cjkLatin = 0.25;

  /// 始め括弧の前後に確保する空き
  static const double _beforeOpening = 0.5;

  /// 前の文字クラスと次の文字クラスの間のアキ（em）
  static double em(
    TategakiCharClass previous,
    TategakiCharClass next,
  ) {
    // 括弧類は前後の文字とベタ組にする（中に約物が連続する場合もベタ）
    if (previous == TategakiCharClass.openingBracket) {
      return 0;
    }
    if (next == TategakiCharClass.closingBracket) {
      return 0;
    }

    // 終わり括弧・読点・句点の後ろ
    if (_isClosingPunctuation(previous)) {
      if (_isClosingPunctuation(next) ||
          next == TategakiCharClass.middleDot) {
        return 0;
      }
      return _afterClosing;
    }

    // 中点類の前後
    if (previous == TategakiCharClass.middleDot ||
        next == TategakiCharClass.middleDot) {
      return _aroundMiddleDot;
    }

    // 始め括弧の前
    if (next == TategakiCharClass.openingBracket) {
      return _beforeOpening;
    }

    // 和欧間
    final previousIsCjk = _isCjkLike(previous);
    final nextIsCjk = _isCjkLike(next);
    if (previousIsCjk != nextIsCjk) {
      if (previous == TategakiCharClass.latin ||
          next == TategakiCharClass.latin) {
        return _cjkLatin;
      }
    }

    return 0;
  }

  /// 行調整でこのギャップを広げてよいかどうか（分離禁止の緩い近似）
  static bool canExpand(
    TategakiCharClass previous,
    TategakiCharClass next,
  ) {
    // 始め括弧の直後・終わり括弧の直前はベタ組を維持する
    if (previous == TategakiCharClass.openingBracket ||
        next == TategakiCharClass.closingBracket) {
      return false;
    }
    // 欧文同士・連数字同士は分割・分離禁止
    if (previous == TategakiCharClass.latin &&
        next == TategakiCharClass.latin) {
      return false;
    }
    if (previous == TategakiCharClass.digit &&
        next == TategakiCharClass.digit) {
      return false;
    }
    return true;
  }

  /// 行調整でこのギャップを詰められる最大量（em）
  static double maxShrink(
    TategakiCharClass previous,
    TategakiCharClass next,
  ) {
    return em(previous, next);
  }

  static bool _isClosingPunctuation(TategakiCharClass value) {
    return value == TategakiCharClass.closingBracket ||
        value == TategakiCharClass.comma ||
        value == TategakiCharClass.period;
  }

  static bool _isCjkLike(TategakiCharClass value) {
    return value == TategakiCharClass.kana ||
        value == TategakiCharClass.kanji ||
        value == TategakiCharClass.sutegana ||
        value == TategakiCharClass.prolongedSound ||
        value == TategakiCharClass.space;
  }
}
