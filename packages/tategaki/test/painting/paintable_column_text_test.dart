import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/painting/paintable_column_text.dart';

void main() {
  group('PaintableColumnText', () {
    group('text getter', () {
      test('通常テキストを返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: 'あいう'),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableColumnText(painter);
        expect(item.text, 'あいう');
      });

      test('改行を含むテキストを返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: 'あ\nい\nう'),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableColumnText(painter);
        expect(item.text, 'あ\nい\nう');
      });

      test('空文字列を持つTextSpanで空文字列を返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: ''),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableColumnText(painter);
        expect(item.text, '');
      });

      test('TextSpanがnullの場合は空文字列を返す', () {
        final painter = TextPainter(
          textDirection: TextDirection.ltr,
        );
        final item = PaintableColumnText(painter);
        expect(item.text, '');
      });

      test('ASCII文字を返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: 'Hello'),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableColumnText(painter);
        expect(item.text, 'Hello');
      });

      test('数字を含むテキストを返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: '123'),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableColumnText(painter);
        expect(item.text, '123');
      });

      test('単一文字を返す', () {
        final painter = TextPainter(
          text: const TextSpan(text: 'A'),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableColumnText(painter);
        expect(item.text, 'A');
      });

      test('layout()呼び出し後もテキストが変わらない', () {
        final painter = TextPainter(
          text: const TextSpan(
            text: 'テスト',
            style: TextStyle(fontSize: 16),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final item = PaintableColumnText(painter);
        expect(item.text, 'テスト');
      });

      test('子TextSpanを持つ場合にネストされたテキストをフラット化して返す', () {
        // toPlainText() はネストされた TextSpan の子も含めて平坦化する
        final painter = TextPainter(
          text: const TextSpan(
            children: [
              TextSpan(text: 'あ'),
              TextSpan(text: '\n'),
              TextSpan(text: 'い'),
            ],
          ),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableColumnText(painter);
        expect(item.text, 'あ\nい');
      });

      test('textがpainterのtext?.toPlainText()を委譲していることを確認する（回帰テスト）', () {
        // PaintableColumnText.textは painter.text?.toPlainText() ?? '' を返す
        // painter.textがnullではなく、正しいテキストを返すことを確認
        const expectedText = 'あ\nい\nう';
        final painter = TextPainter(
          text: const TextSpan(text: expectedText),
          textDirection: TextDirection.ltr,
        );
        final item = PaintableColumnText(painter);
        expect(item.text, equals(expectedText));
        // painterのtextが変わればitemのtextも変わることを間接的に確認
        expect(item.text, painter.text?.toPlainText() ?? '');
      });
    });
  });
}