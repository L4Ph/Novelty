import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/paintable_column_text.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';
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

    group('columnSpacing の計算', () {
      // 1列の場合: totalWidth = column.width（スペースなし）
      testWidgets('1列の場合はcolumnSpacingを含まない', (tester) async {
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
                final columnWidth = metrics.columns[0].width;
                // 1列の場合、totalWidth = column.width のみ
                expect(metrics.size.width, columnWidth);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      // 2列の場合: totalWidth = column1.width + columnSpacing + column2.width
      testWidgets('2列の場合はcolumnSpacing×1を含む', (tester) async {
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

                // 「あ」の列、空の列（改行）、「い」の列 = 3列
                expect(metrics.columns.length, 3);
                final columnsWidth = metrics.columns.fold<double>(
                  0,
                  (sum, c) => sum + c.width,
                );
                // N列の場合、totalWidth = Σ(column.width) + columnSpacing × (N-1)
                final expectedWidth =
                    columnsWidth + TategakiLayout.columnSpacing * 2;
                expect(metrics.size.width, expectedWidth);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      // N列の場合: totalWidth = Σ(column.width) + columnSpacing × (N-1)
      testWidgets('N列の場合はcolumnSpacing×(N-1)を含む', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // 高さを制限して複数列を強制生成
                final elements = List.generate(
                  30,
                  (i) => const TategakiChar('あ'),
                );

                final metrics = TategakiLayout.calculate(
                  elements: elements,
                  maxHeight: 50, // 強制的に列分割
                  textStyle: textStyle,
                );

                expect(metrics.columns.length, greaterThan(1));
                final n = metrics.columns.length;
                final columnsWidth = metrics.columns.fold<double>(
                  0,
                  (sum, c) => sum + c.width,
                );
                // N列の場合、totalWidth = Σ(column.width) + columnSpacing × (N-1)
                final expectedWidth =
                    columnsWidth + TategakiLayout.columnSpacing * (n - 1);
                expect(metrics.size.width, expectedWidth);
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('partition() との一貫性', () {
      testWidgets('calculate()とpartition()で同じ幅計算ロジックを使用する', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final elements = List.generate(
                  30,
                  (i) => const TategakiChar('あ'),
                );

                final metrics = TategakiLayout.calculate(
                  elements: elements,
                  maxHeight: 50,
                  textStyle: textStyle,
                );

                // partition で1ページに全ての列を収める（幅を十分大きく）
                final pages = TategakiLayout.partition(
                  columns: metrics.columns,
                  maxWidth: 10000,
                  height: 50,
                );

                expect(pages.length, 1);
                // calculate() と partition() で同じ幅になるべき
                expect(pages[0].size.width, metrics.size.width);
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('TCY（縦中横数字）のレイアウト順序', () {
      testWidgets('通常文字とTCYが混在する場合、正しい順序で配置される', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // 「あいう123えお」のようなパターン
                // バグ: TCYがバッファされた文字より先に追加されてしまう
                final elements = [
                  const TategakiChar('あ'),
                  const TategakiChar('い'),
                  const TategakiChar('う'),
                  const TategakiTcy('123'),
                  const TategakiChar('え'),
                  const TategakiChar('お'),
                ];

                final metrics = TategakiLayout.calculate(
                  elements: elements,
                  maxHeight: 600,
                  textStyle: textStyle,
                );

                expect(metrics.columns.length, 1);
                final column = metrics.columns[0];

                // 順序を検証: 「あいう」→「123」→「えお」
                // 連続する文字はバッファリングされて1つのPaintableColumnTextにまとめられる
                expect(column.items.length, 3);
                expect(column.items[0], isA<PaintableColumnText>());
                expect(column.items[1], isA<PaintableTcy>());
                expect(column.items[2], isA<PaintableColumnText>());

                // PaintableColumnTextの内容を検証
                final beforeTcy = column.items[0] as PaintableColumnText;
                final afterTcy = column.items[2] as PaintableColumnText;

                // 「あいう」がTCYの前に来ることを確認
                expect(beforeTcy.text.contains('あ'), isTrue);
                expect(beforeTcy.text.contains('い'), isTrue);
                expect(beforeTcy.text.contains('う'), isTrue);

                // 「えお」がTCYの後に来ることを確認
                expect(afterTcy.text.contains('え'), isTrue);
                expect(afterTcy.text.contains('お'), isTrue);

                // TCYの内容を検証
                final tcy = column.items[1] as PaintableTcy;
                expect(tcy.text, '123');

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('TCYが文頭にある場合、先頭に配置される', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // 「123番目」のようなパターン
                final elements = [
                  const TategakiTcy('123'),
                  const TategakiChar('番'),
                  const TategakiChar('目'),
                ];

                final metrics = TategakiLayout.calculate(
                  elements: elements,
                  maxHeight: 600,
                  textStyle: textStyle,
                );

                expect(metrics.columns.length, 1);
                final column = metrics.columns[0];

                // 順序: 123→番→目
                expect(column.items.length, 2);
                expect(column.items[0], isA<PaintableTcy>());
                expect(column.items[1], isA<PaintableColumnText>());

                final tcy = column.items[0] as PaintableTcy;
                expect(tcy.text, '123');

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('複数のTCYが含まれる場合、それぞれ正しい位置に配置される', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // 「第12話の34ページ」のようなパターン
                final elements = [
                  const TategakiChar('第'),
                  const TategakiTcy('12'),
                  const TategakiChar('話'),
                  const TategakiChar('の'),
                  const TategakiTcy('34'),
                  const TategakiChar('ペ'),
                  const TategakiChar('ー'),
                  const TategakiChar('ジ'),
                ];

                final metrics = TategakiLayout.calculate(
                  elements: elements,
                  maxHeight: 600,
                  textStyle: textStyle,
                );

                expect(metrics.columns.length, 1);
                final column = metrics.columns[0];

                // 順序を検証
                // items[0]: 「第」
                // items[1]: 「12」
                // items[2]: 「話の」
                // items[3]: 「34」
                // items[4]: 「ページ」
                expect(column.items.length, 5);
                expect(column.items[0], isA<PaintableColumnText>());
                expect(column.items[1], isA<PaintableTcy>());
                expect(column.items[2], isA<PaintableColumnText>());
                expect(column.items[3], isA<PaintableTcy>());
                expect(column.items[4], isA<PaintableColumnText>());

                // TCYの内容を検証
                final tcy1 = column.items[1] as PaintableTcy;
                final tcy2 = column.items[3] as PaintableTcy;
                expect(tcy1.text, '12');
                expect(tcy2.text, '34');

                return const SizedBox();
              },
            ),
          ),
        );
      });
    });
  });
}
