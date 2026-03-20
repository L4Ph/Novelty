import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';

void main() {
  group('PaintableTcy', () {
    group('text getter', () {
      test('通常テキストを返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: '123'),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableTcy(painter);
        expect(item.text, '123');
      });

      test('空文字列を持つTextSpanで空文字列を返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: ''),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableTcy(painter);
        expect(item.text, '');
      });

      test('TextSpanがnullの場合は空文字列を返す', () {
        final painter = TextPainter(
          textDirection: TextDirection.ltr,
        );
        final item = PaintableTcy(painter);
        expect(item.text, '');
      });

      test('2桁の数字を返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: '42'),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableTcy(painter);
        expect(item.text, '42');
      });

      test('アルファベットを返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: 'AB'),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableTcy(painter);
        expect(item.text, 'AB');
      });

      test('単一文字を返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: '1'),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableTcy(painter);
        expect(item.text, '1');
      });

      test('layout()呼び出し後もテキストが変わらない', () {
        final painter = TextPainter(
          text: const TextSpan(
            text: '99',
            style: TextStyle(fontSize: 16),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final item = PaintableTcy(painter);
        expect(item.text, '99');
      });
    });

    group('height/width の軸交換', () {
      testWidgets('heightはpainterのwidthと等しい（縦中横の軸交換）', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: SizedBox()),
        );
        final painter = TextPainter(
          text: const TextSpan(
            text: '12',
            style: TextStyle(fontSize: 16),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final item = PaintableTcy(painter);
        expect(item.height, painter.width);
      });

      testWidgets('widthはpainterのheightと等しい（縦中横の軸交換）', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: SizedBox()),
        );
        final painter = TextPainter(
          text: const TextSpan(
            text: '12',
            style: TextStyle(fontSize: 16),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final item = PaintableTcy(painter);
        expect(item.width, painter.height);
      });
    });
  });
}