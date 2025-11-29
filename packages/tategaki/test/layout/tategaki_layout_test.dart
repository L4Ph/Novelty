import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/tategaki.dart';

void main() {
  group('TategakiLayout', () {
    late TextStyle textStyle;

    setUp(() {
      textStyle = const TextStyle(fontSize: 16);
    });

    testWidgets('空の要素リストでは空のメトリクスを返す', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final metrics = TategakiLayout.calculate(
                elements: [],
                maxHeight: 600,
                textStyle: textStyle,
              );

              expect(metrics.columns, isEmpty);
              expect(metrics.size.width, 0);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('単一文字を1列に配置する', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final elements = [
                const TategakiChar('あ'),
              ];

              final metrics = TategakiLayout.calculate(
                elements: elements,
                maxHeight: 600,
                textStyle: textStyle,
              );

              expect(metrics.columns.length, 1);
              expect(metrics.columns[0].items.length, 1);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('改行で新しい列を作成する', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final elements = [
                const TategakiChar('あ'),
                const TategakiNewLine(),
                const TategakiChar('い'),
              ];

              final metrics = TategakiLayout.calculate(
                elements: elements,
                maxHeight: 600,
                textStyle: textStyle,
              );

              // 「あ」の列、空の列（改行）、「い」の列
              expect(metrics.columns.length, 3);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('maxHeightを超えると自動的に列を分割する', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // 多くの文字を追加
              final elements = List.generate(
                50,
                (i) => const TategakiChar('あ'),
              );

              final metrics = TategakiLayout.calculate(
                elements: elements,
                maxHeight: 100, // 小さい高さで強制的に列分割
                textStyle: textStyle,
              );

              expect(metrics.columns.length, greaterThan(1));
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
