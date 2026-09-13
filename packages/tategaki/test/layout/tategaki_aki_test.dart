import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/tategaki_aki.dart';
import 'package:tategaki/src/layout/tategaki_char_class.dart';

void main() {
  group('TategakiAki', () {
    test('読点・句点の後ろは二分アキ(0.5em)', () {
      expect(
        TategakiAki.em(TategakiCharClass.comma, TategakiCharClass.kana),
        0.5,
      );
      expect(
        TategakiAki.em(TategakiCharClass.period, TategakiCharClass.kanji),
        0.5,
      );
    });

    test('約物が連続する場合はベタ', () {
      expect(
        TategakiAki.em(TategakiCharClass.comma, TategakiCharClass.closingBracket),
        0,
      );
    });

    test('中点類の前後は四分アキ(0.25em)', () {
      expect(
        TategakiAki.em(TategakiCharClass.middleDot, TategakiCharClass.kana),
        0.25,
      );
      expect(
        TategakiAki.em(TategakiCharClass.kana, TategakiCharClass.middleDot),
        0.25,
      );
    });

    test('和欧間は四分アキ(0.25em)', () {
      expect(
        TategakiAki.em(TategakiCharClass.kana, TategakiCharClass.latin),
        0.25,
      );
    });

    test('始め括弧の後ろはベタ', () {
      expect(
        TategakiAki.em(TategakiCharClass.openingBracket, TategakiCharClass.kanji),
        0,
      );
    });

    test('括弧のベタ組は行末調整でも広げない', () {
      expect(
        TategakiAki.canExpand(
          TategakiCharClass.openingBracket,
          TategakiCharClass.kanji,
        ),
        isFalse,
      );
      expect(
        TategakiAki.canExpand(
          TategakiCharClass.kanji,
          TategakiCharClass.closingBracket,
        ),
        isFalse,
      );
    });
  });
}
