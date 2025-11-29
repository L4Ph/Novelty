import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/utils/glyph_mapper.dart';

void main() {
  group('GlyphMapper', () {
    group('句読点', () {
      test('。を︒に変換する', () {
        expect(GlyphMapper.map('。'), '︒');
      });

      test('、を︑に変換する', () {
        expect(GlyphMapper.map('、'), '︑');
      });
    });

    group('長音・ダッシュ', () {
      test('ーを丨に変換する', () {
        expect(GlyphMapper.map('ー'), '丨');
      });

      test('—を丨に変換する', () {
        expect(GlyphMapper.map('—'), '丨');
      });
    });

    group('括弧', () {
      test('「を﹁に変換する', () {
        expect(GlyphMapper.map('「'), '﹁');
      });

      test('」を﹂に変換する', () {
        expect(GlyphMapper.map('」'), '﹂');
      });

      test('（を︵に変換する', () {
        expect(GlyphMapper.map('（'), '︵');
      });

      test('）を︶に変換する', () {
        expect(GlyphMapper.map('）'), '︶');
      });
    });

    group('変換不要な文字', () {
      test('ひらがなはそのまま', () {
        expect(GlyphMapper.map('あ'), 'あ');
      });

      test('カタカナはそのまま', () {
        expect(GlyphMapper.map('ア'), 'ア');
      });

      test('漢字はそのまま', () {
        expect(GlyphMapper.map('猫'), '猫');
      });
    });
  });
}
