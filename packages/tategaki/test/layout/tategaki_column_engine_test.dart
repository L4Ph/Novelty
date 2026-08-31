import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/tategaki_column_engine.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/paintable_column_text.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';
import 'package:tategaki/tategaki.dart';

void main() {
  const style = TextStyle(fontSize: 16);

  group('TategakiColumnEngine', () {
    testWidgets('columnAtで指定した列を遅延生成できる', (tester) async {
      final engine = TategakiColumnEngine(
        elements: [const TategakiChar('あ')],
        maxHeight: 600,
        textStyle: style,
      );

      final column = engine.columnAt(0);

      expect(column.items.length, 1);
      expect(column.items[0], isA<PaintableColumnText>());
      final text = column.items[0] as PaintableColumnText;
      expect(text.text, 'あ');
    });

    testWidgets('列の高さがmaxHeightを超えない', (tester) async {
      // 1文字あたり約16px。maxHeight 100 なら 6文字/列になる
      final elements = List.generate(
        50,
        (i) => const TategakiChar('あ'),
      );

      final engine = TategakiColumnEngine(
        elements: elements,
        maxHeight: 100,
        textStyle: style,
      );

      final columns = engine.computeAll();

      expect(columns.length, greaterThan(1));
      for (final column in columns) {
        final columnHeight = column.items.fold<double>(
          0,
          (sum, item) => sum + item.height,
        );
        expect(columnHeight, lessThanOrEqualTo(100));
      }
    });

    testWidgets('改行で空の列が生成される（段落間スペース）', (tester) async {
      final engine = TategakiColumnEngine(
        elements: const [
          TategakiChar('あ'),
          TategakiNewLine(),
          TategakiChar('い'),
        ],
        maxHeight: 600,
        textStyle: style,
      );

      final columns = engine.computeAll();

      // 「あ」の列、空の列（改行）、「い」の列
      expect(columns.length, 3);
      expect(columns[0].items, isNotEmpty);
      expect(columns[1].items, isEmpty);
      expect(columns[2].items, isNotEmpty);
    });

    testWidgets('TCYがバッファリングされた文字の間に正しい順序で配置される', (tester) async {
      final engine = TategakiColumnEngine(
        elements: const [
          TategakiChar('あ'),
          TategakiChar('い'),
          TategakiChar('う'),
          TategakiTcy('123'),
          TategakiChar('え'),
          TategakiChar('お'),
        ],
        maxHeight: 600,
        textStyle: style,
      );

      final column = engine.columnAt(0);

      expect(column.items.length, 3);
      expect(column.items[0], isA<PaintableColumnText>());
      expect(column.items[1], isA<PaintableTcy>());
      expect(column.items[2], isA<PaintableColumnText>());

      final before = column.items[0] as PaintableColumnText;
      final after = column.items[2] as PaintableColumnText;
      expect(before.text, 'あ\nい\nう');
      expect(after.text, 'え\nお');
    });

    testWidgets('ルビを列に配置できる', (tester) async {
      final engine = TategakiColumnEngine(
        elements: const [
          TategakiChar('あ'),
          TategakiRuby(base: '猫', ruby: 'ねこ'),
          TategakiChar('い'),
        ],
        maxHeight: 600,
        textStyle: style,
      );

      final column = engine.columnAt(0);

      // 連続する「あ」+ ルビ + 「い」
      expect(column.items.length, 3);
      expect(column.items[1].isRuby, isTrue);
      expect(column.baseWidth, greaterThan(0));
    });

    testWidgets('行頭禁則文字の押し込みでmaxHeightを超えない', (tester) async {
      final probe = TategakiColumnEngine(
        elements: const [TategakiChar('あ')],
        maxHeight: 100,
        textStyle: style,
      );
      const elements = <TategakiElement>[
        TategakiChar('あ'),
        TategakiChar('い'),
        TategakiChar('。'),
        TategakiChar('。'),
      ];

      final engine = TategakiColumnEngine(
        elements: elements,
        maxHeight: probe.charHeight * 2,
        textStyle: style,
      );

      final columns = engine.computeAll();
      for (final column in columns) {
        final columnHeight = column.items.fold<double>(
          0,
          (sum, item) => sum + item.height,
        );
        expect(columnHeight, lessThanOrEqualTo(engine.maxHeight));
      }
      final text = columns
          .expand((column) => column.items)
          .whereType<PaintableColumnText>()
          .expand((item) => item.text.split('\n'));
      expect(text, elements.map((element) => (element as TategakiChar).char));
    });

    testWidgets('空きがある列では行末禁則文字をそのまま収集する', (tester) async {
      final engine = TategakiColumnEngine(
        elements: const [
          TategakiChar('あ'),
          TategakiChar('（'),
          TategakiTcy('12'),
        ],
        maxHeight: 600,
        textStyle: style,
      );

      final columns = engine.computeAll();

      expect(columns, hasLength(1));
      expect((columns.single.items.first as PaintableColumnText).text, 'あ\n（');
      expect(columns.single.items.last, isA<PaintableTcy>());
    });

    testWidgets('折り返し時に送り出した行末禁則文字を同じ列で再収集しない', (tester) async {
      final probe = TategakiColumnEngine(
        elements: const [TategakiChar('あ')],
        maxHeight: 100,
        textStyle: style,
      );
      final engine = TategakiColumnEngine(
        elements: const [
          TategakiChar('あ'),
          TategakiChar('（'),
          TategakiChar('い'),
        ],
        maxHeight: probe.charHeight * 2,
        textStyle: style,
      );

      final columns = engine.computeAll();

      expect((columns.first.items.single as PaintableColumnText).text, 'あ');
      expect((columns.last.items.single as PaintableColumnText).text, '（\nい');
    });

    testWidgets('columnAtは同じ列に対して同一インスタンスを返す（メモ化）', (tester) async {
      final engine = TategakiColumnEngine(
        elements: const [TategakiChar('あ')],
        maxHeight: 600,
        textStyle: style,
      );

      final first = engine.columnAt(0);
      final second = engine.columnAt(0);

      expect(identical(first, second), isTrue);
    });

    testWidgets('columnAtは要求した列までしか計算しない（遅延性）', (tester) async {
      final elements = List.generate(
        100,
        (i) => const TategakiChar('あ'),
      );

      final engine = TategakiColumnEngine(
        elements: elements,
        maxHeight: 100,
        textStyle: style,
      );

      final column = engine.columnAt(0);
      expect(column, isNotNull);
      // 1列だけ計算されている
      expect(engine.computedColumnCount, 1);
    });
  });

  group('TategakiLayout (エンジン統合)', () {
    testWidgets('calculateがエンジンと同じ列構造を返す', (tester) async {
      const elements = [
        TategakiChar('あ'),
        TategakiChar('い'),
        TategakiNewLine(),
        TategakiChar('う'),
      ];

      final metrics = TategakiLayout.calculate(
        elements: elements,
        maxHeight: 600,
        textStyle: style,
      );

      expect(metrics.columns.length, 3);
      expect(metrics.size.width, greaterThan(0));
    });
  });
}
