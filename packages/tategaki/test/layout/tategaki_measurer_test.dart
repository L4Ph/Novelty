import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/tategaki_measurer.dart';
import 'package:tategaki/src/painting/paintable_kenten.dart';
import 'package:tategaki/src/painting/paintable_ruby.dart';
import 'package:tategaki/tategaki.dart';

void main() {
  const style = TextStyle(fontSize: 16);
  final measurer = TategakiMeasurer(style);

  group('TategakiMeasurer', () {
    test('1文字の字送りはem', () {
      final measured = measurer.measure(const TategakiChar('あ'));
      expect(measured.advance, 16);
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
  });
}
