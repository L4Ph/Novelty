import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/painting/paintable_column_text.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';

void main() {
  group('PaintableColumnText', () {
    group('text getter', () {
      test('単一文字のテキストスパンを返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: 'あ'),
          textDirection: TextDirection.ltr,
        );
        final paintable = PaintableColumnText(painter);
        expect(paintable.text, 'あ');
      });

      test('改行区切りの複数文字テキストを返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: 'あ\nい\nう'),
          textDirection: TextDirection.ltr,
        );
        final paintable = PaintableColumnText(painter);
        expect(paintable.text, 'あ\nい\nう');
      });

      test('空文字列のテキストスパンで空文字を返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: ''),
          textDirection: TextDirection.ltr,
        );
        final paintable = PaintableColumnText(painter);
        expect(paintable.text, '');
      });

      test('nullのtextスパンで空文字を返す', () {
        final painter = TextPainter(
          textDirection: TextDirection.ltr,
        );
        final paintable = PaintableColumnText(painter);
        expect(paintable.text, '');
      });

      test('ASCII文字のテキストスパンを正しく返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: 'Hello'),
          textDirection: TextDirection.ltr,
        );
        final paintable = PaintableColumnText(painter);
        expect(paintable.text, 'Hello');
      });
    });
  });

  group('PaintableTcy', () {
    group('text getter', () {
      test('数字文字列を正しく返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: '123'),
          textDirection: TextDirection.ltr,
        );
        final paintable = PaintableTcy(painter);
        expect(paintable.text, '123');
      });

      test('2桁の数字を正しく返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: '42'),
          textDirection: TextDirection.ltr,
        );
        final paintable = PaintableTcy(painter);
        expect(paintable.text, '42');
      });

      test('空文字列のテキストスパンで空文字を返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: ''),
          textDirection: TextDirection.ltr,
        );
        final paintable = PaintableTcy(painter);
        expect(paintable.text, '');
      });

      test('nullのtextスパンで空文字を返す', () {
        final painter = TextPainter(
          textDirection: TextDirection.ltr,
        );
        final paintable = PaintableTcy(painter);
        expect(paintable.text, '');
      });

      test('英数字混在テキストを正しく返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: 'AB12'),
          textDirection: TextDirection.ltr,
        );
        final paintable = PaintableTcy(painter);
        expect(paintable.text, 'AB12');
      });
    });
  });
}