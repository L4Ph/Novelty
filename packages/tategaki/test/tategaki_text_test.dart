import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/tategaki.dart';

void main() {
  group('TategakiText', () {
    testWidgets('基本的なレンダリングができる', (tester) async {
      final elements = TategakiParser.parse('あいう');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiText(
              elements,
              height: 600,
            ),
          ),
        ),
      );

      expect(find.byType(TategakiText), findsOneWidget);
      // TategakiText内のCustomPaintを確認
      final customPaintFinder = find.descendant(
        of: find.byType(TategakiText),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, findsOneWidget);
    });

    testWidgets('空の要素リストでSizedBox.shrinkが表示される', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TategakiText(
              [],
              height: 600,
            ),
          ),
        ),
      );

      expect(find.byType(TategakiText), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('DefaultTextStyleからスタイルを継承する', (tester) async {
      final elements = TategakiParser.parse('テスト');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultTextStyle(
              style: const TextStyle(fontSize: 24, color: Colors.red),
              child: TategakiText(
                elements,
                height: 600,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TategakiText), findsOneWidget);
    });

    testWidgets('ルビ付きテキストをレンダリングできる', (tester) async {
      final elements = [
        const TategakiRuby(base: '猫', ruby: 'ねこ'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiText(
              elements,
              height: 600,
            ),
          ),
        ),
      );

      expect(find.byType(TategakiText), findsOneWidget);
    });

    testWidgets('縦中横をレンダリングできる', (tester) async {
      final elements = TategakiParser.parse('12時');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TategakiText(
              elements,
              height: 600,
            ),
          ),
        ),
      );

      expect(find.byType(TategakiText), findsOneWidget);
    });
  });
}
