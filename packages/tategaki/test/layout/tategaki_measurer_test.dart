import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/tategaki_measurer.dart';
import 'package:tategaki/src/painting/paintable_column_text.dart';
import 'package:tategaki/src/painting/paintable_kenten.dart';
import 'package:tategaki/src/painting/paintable_rotated.dart';
import 'package:tategaki/src/painting/paintable_ruby.dart';
import 'package:tategaki/tategaki.dart';

/// 実行時に別インスタンスの要素を生成するヘルパー（const 正準化を回避）
TategakiElement runtimeChar(String char) => TategakiChar(char);

void main() {
  const style = TextStyle(fontSize: 16);
  final measurer = TategakiMeasurer(style);

  group('TategakiMeasurer', () {
    test('1文字の字送りはem', () {
      final measured = measurer.measure(const TategakiChar('あ'));
      expect(measured.advance, 16);
    });

    test('同じ内容の要素は計測結果を再利用する', () {
      final first = runtimeChar('あ');
      final second = runtimeChar('あ');

      // 実行時生成なので別インスタンス（const 正準化されない）
      expect(identical(first, second), isFalse);
      expect(
        identical(measurer.measure(first), measurer.measure(second)),
        isTrue,
      );
    });

    test('内容が異なる要素は計測結果を共有しない', () {
      final first = measurer.measure(runtimeChar('あ'));
      final second = measurer.measure(runtimeChar('い'));

      expect(identical(first, second), isFalse);
    });

    test('モノルビ（親文字1字）', () {
      final measured = measurer.measure(
        const TategakiRuby(base: '猫', ruby: 'ねこ'),
      );
      expect((measured.paintable as PaintableRuby).mode, RubyLayoutMode.mono);
      expect(measured.advance, 16);
      expect(measured.baseExtent, greaterThan(0));
    });

    test('グループルビ（親文字数 ≠ ルビ文字数）', () {
      final measured = measurer.measure(
        const TategakiRuby(base: '東京', ruby: 'とうきょう'),
      );
      expect((measured.paintable as PaintableRuby).mode, RubyLayoutMode.group);
      expect(measured.advance, 32);
    });

    test('熟語ルビ（親文字数 = ルビ文字数）', () {
      final measured = measurer.measure(
        const TategakiRuby(base: '漢字', ruby: 'かじ'),
      );
      expect((measured.paintable as PaintableRuby).mode, RubyLayoutMode.jukugo);
    });

    test('傍点は親文字数分の字送りを消費する', () {
      final measured = measurer.measure(
        const TategakiKenten(base: '重要', mark: '・'),
      );
      expect(measured.advance, 32);
      expect(measured.paintable, isA<PaintableKenten>());
      expect(measured.blockExtent, greaterThan(measured.baseExtent));
    });

    test('傍点のマークはルビと同じ比率(0.5)で縮小される', () {
      final measured = measurer.measure(
        const TategakiKenten(base: '重要', mark: '・'),
      );
      final markPainter = (measured.paintable as PaintableKenten).markPainter;
      expect(markPainter.text?.style?.fontSize, 16 * 0.5);
    });

    test('傍点マークは縦書き用字形に変換される', () {
      // 長音記号などの横線系のマークは、縦書き字形(丨)へ変換して描画する。
      // 変換せずに描画すると縦組みでも横棒のままになり、傍点として機能しない。
      final kenten = measurer.measure(
        const TategakiKenten(base: '重要', mark: 'ー'),
      );
      final markPainter = (kenten.paintable as PaintableKenten).markPainter;
      expect(markPainter.text?.toPlainText(), '丨');
    });

    test('傍点マークの中黒は縦書き用字形(｜)に変換される', () {
      // なろうの点ルビで一般的な中黒(・)は、縦書きでは縦線(｜)として描画する。
      final kenten = measurer.measure(
        const TategakiKenten(base: '重要', mark: '・'),
      );
      final markPainter = (kenten.paintable as PaintableKenten).markPainter;
      expect(markPainter.text?.toPlainText(), '｜');
    });

    test('縦書き字形を持たないマークはそのまま描画される', () {
      // 変換表にないマーク(カクヨムのゴマ点など)は変更しない。
      final kenten = measurer.measure(
        const TategakiKenten(base: '重要', mark: '﹅'),
      );
      final markPainter = (kenten.paintable as PaintableKenten).markPainter;
      expect(markPainter.text?.toPlainText(), '﹅');
    });

    test('列高を超える回転トークンは縮小されて収まる', () {
      final limited = TategakiMeasurer(style, maxAdvance: 20);
      final measured = limited.measure(const TategakiRotated('1234567890'));
      expect(measured.advance, lessThanOrEqualTo(20.001));
      expect((measured.paintable as PaintableRotated).scale, lessThan(1));
    });
  });

  group('遅延マテリアライズ', () {
    setUp(() => TategakiMeasurer.debugPainterCreationCount = 0);

    test('全角文字の計測は TextPainter を生成しない', () {
      TategakiMeasurer(style).measure(const TategakiChar('あ'));

      expect(TategakiMeasurer.debugPainterCreationCount, 0);
    });

    test('半角文字の幅は実測にフォールバックする', () {
      TategakiMeasurer(style).measure(const TategakiChar('1'));

      expect(TategakiMeasurer.debugPainterCreationCount, 1);
    });

    test('描画要素は初回アクセス時まで生成されない', () {
      final measurer = TategakiMeasurer(style);
      final measured = measurer.measure(const TategakiChar('あ'));
      expect(TategakiMeasurer.debugPainterCreationCount, 0);

      final paintable = measured.paintable;

      expect(paintable, isA<PaintableColumnText>());
      expect((paintable as PaintableColumnText).text, 'あ');
      expect(TategakiMeasurer.debugPainterCreationCount, 1);

      // 2回目以降は生成済みの描画要素を再利用する
      expect(identical(measured.paintable, paintable), isTrue);
      expect(TategakiMeasurer.debugPainterCreationCount, 1);
    });
  });
}
