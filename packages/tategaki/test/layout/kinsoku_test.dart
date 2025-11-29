import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/kinsoku.dart';

void main() {
  group('Kinsoku', () {
    group('行頭禁則文字', () {
      test('句読点は行頭禁則', () {
        expect(Kinsoku.isHeadProhibited('。'), isTrue);
        expect(Kinsoku.isHeadProhibited('、'), isTrue);
        expect(Kinsoku.isHeadProhibited('．'), isTrue);
        expect(Kinsoku.isHeadProhibited('，'), isTrue);
      });

      test('閉じ括弧は行頭禁則', () {
        expect(Kinsoku.isHeadProhibited('）'), isTrue);
        expect(Kinsoku.isHeadProhibited('］'), isTrue);
        expect(Kinsoku.isHeadProhibited('｝'), isTrue);
        expect(Kinsoku.isHeadProhibited('」'), isTrue);
        expect(Kinsoku.isHeadProhibited('』'), isTrue);
      });

      test('疑問符・感嘆符は行頭禁則', () {
        expect(Kinsoku.isHeadProhibited('？'), isTrue);
        expect(Kinsoku.isHeadProhibited('！'), isTrue);
      });

      test('長音・波線は行頭禁則', () {
        expect(Kinsoku.isHeadProhibited('ー'), isTrue);
        expect(Kinsoku.isHeadProhibited('～'), isTrue);
      });

      test('三点リーダは行頭禁則', () {
        expect(Kinsoku.isHeadProhibited('…'), isTrue);
        expect(Kinsoku.isHeadProhibited('‥'), isTrue);
      });

      test('通常の文字は行頭禁則ではない', () {
        expect(Kinsoku.isHeadProhibited('あ'), isFalse);
        expect(Kinsoku.isHeadProhibited('猫'), isFalse);
        expect(Kinsoku.isHeadProhibited('A'), isFalse);
      });
    });

    group('行末禁則文字', () {
      test('開き括弧は行末禁則', () {
        expect(Kinsoku.isTailProhibited('（'), isTrue);
        expect(Kinsoku.isTailProhibited('［'), isTrue);
        expect(Kinsoku.isTailProhibited('｛'), isTrue);
        expect(Kinsoku.isTailProhibited('「'), isTrue);
        expect(Kinsoku.isTailProhibited('『'), isTrue);
        expect(Kinsoku.isTailProhibited('【'), isTrue);
      });

      test('通常の文字は行末禁則ではない', () {
        expect(Kinsoku.isTailProhibited('あ'), isFalse);
        expect(Kinsoku.isTailProhibited('猫'), isFalse);
        expect(Kinsoku.isTailProhibited('。'), isFalse);
      });
    });
  });
}
