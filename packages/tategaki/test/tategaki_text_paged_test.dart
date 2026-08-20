import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/painting/tategaki_painter.dart';
import 'package:tategaki/tategaki.dart';

void main() {
  group('TategakiTextPaged', () {
    final elements = TategakiParser.parse('あいうえおかきくけこさしすせそ');

    final customPaint = find
        .descendant(
          of: find.byType(TategakiTextPaged),
          matching: find.byType(CustomPaint),
        )
        .first;

    Widget buildWidget(
      List<TategakiElement> elems, {
      double width = 400,
      double height = 600,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: DefaultTextStyle(
            style: const TextStyle(fontSize: 20),
            child: TategakiTextPaged(
              elems,
              width: width,
              height: height,
            ),
          ),
        ),
      );
    }

    testWidgets('基本的なページ表示ができる', (tester) async {
      await tester.pumpWidget(buildWidget(elements));
      expect(find.byType(TategakiTextPaged), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('入力が同じならレイアウトを再計算しない', (tester) async {
      await tester.pumpWidget(buildWidget(elements));
      final before =
          tester.widget<CustomPaint>(customPaint).painter! as TategakiPainter;

      // 同じ入力で再ビルドしても、レイアウト結果（metrics）は再利用される
      await tester.pumpWidget(buildWidget(elements));
      final after =
          tester.widget<CustomPaint>(customPaint).painter! as TategakiPainter;

      expect(after.metrics, same(before.metrics));
    });

    testWidgets('入力（高さ）が変わればレイアウトを再計算する', (tester) async {
      await tester.pumpWidget(buildWidget(elements));
      final before =
          tester.widget<CustomPaint>(customPaint).painter! as TategakiPainter;

      await tester.pumpWidget(buildWidget(elements, height: 400));
      final after =
          tester.widget<CustomPaint>(customPaint).painter! as TategakiPainter;

      expect(after.metrics, isNot(same(before.metrics)));
    });
  });
}
