import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/vertical_orientation.dart';

void main() {
  group('VerticalOrientation (UAX #50)', () {
    test('ASCII数字・ラテン文字は横倒し(R)', () {
      expect(VerticalOrientation.isRotated(0x31), isTrue); // '1'
      expect(VerticalOrientation.isRotated(0x41), isTrue); // 'A'
      expect(VerticalOrientation.isRotated(0x61), isTrue); // 'a'
    });

    test('全角数字・全角ラテン文字は正立(U)', () {
      expect(VerticalOrientation.isRotated(0xFF11), isFalse); // '１'
      expect(VerticalOrientation.isRotated(0xFF21), isFalse); // 'Ａ'
    });

    test('句読点は縦書き字形(Tu/Tr)として扱う', () {
      expect(
        VerticalOrientation.of(0x3001), // 、
        TategakiOrientation.transformedUpright,
      );
      expect(
        VerticalOrientation.of(0x300C), // 「
        TategakiOrientation.transformedRotated,
      );
    });

    test('漢字は表に依存せず正立(U)になる', () {
      expect(VerticalOrientation.of(0x6F22), TategakiOrientation.upright);
    });
  });
}
