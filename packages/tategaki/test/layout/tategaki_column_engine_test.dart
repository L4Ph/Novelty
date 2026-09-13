import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/tategaki_column_engine.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/paintable_column_text.dart';
import 'package:tategaki/src/painting/paintable_rotated.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';
import 'package:tategaki/tategaki.dart';

void main() {
  const style = TextStyle(fontSize: 16);

  group('TategakiColumnEngine', () {
    testWidgets('字送りはfontSize、行送りはfontSize×lineHeightになる', (tester) async {
      const lineHeightStyle = TextStyle(fontSize: 20, height: 1.5);
      final engine = TategakiColumnEngine(
        elements: const [TategakiChar('あ')],
        maxHeight: 600,
        textStyle: lineHeightStyle,
      );

      expect(engine.charHeight, 20);
      expect(engine.linePitch, 30);
    });

    testWidgets('columnAtで指定した列を遅延生成できる', (tester) async {
      final engine = TategakiColumnEngine(
        elements: const [TategakiChar('あ')],
        maxHeight: 600,
        textStyle: style,
      );

      final column = engine.columnAt(0);

      expect(column.items.length, 1);
      expect(column.items[0], isA<PaintableColumnText>());
      expect((column.items[0] as PaintableColumnText).text, 'あ');
    });

    testWidgets('各アイテムは列の中心軸に中央寄せされる', (tester) async {
      final engine = TategakiColumnEngine(
        elements: TategakiParser.parse('あI1'),
        maxHeight: 600,
        textStyle: style,
      );

      final column = engine.columnAt(0);
      for (final placed in column.placedItems) {
        final center = placed.blockOffset + placed.item.baseExtent / 2;
        expect(center, closeTo(column.baseWidth / 2, 0.001));
      }
    });

    testWidgets('列の高さがmaxHeightを超えない', (tester) async {
      final elements = List.generate(50, (i) => const TategakiChar('あ'));

      final engine = TategakiColumnEngine(
        elements: elements,
        maxHeight: 100,
        textStyle: style,
      );

      for (final column in engine.computeAll()) {
        final last = column.placedItems.last;
        expect(
          last.inlineOffset + last.item.advance,
          lessThanOrEqualTo(100.001),
        );
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

      expect(columns.length, 3);
      expect(columns[0].items, isNotEmpty);
      expect(columns[1].items, isEmpty);
      expect(columns[2].items, isNotEmpty);
    });

    testWidgets('TCYが正しい順序で配置される', (tester) async {
      final engine = TategakiColumnEngine(
        elements: const [
          TategakiChar('あ'),
          TategakiTcy('12'),
          TategakiChar('い'),
        ],
        maxHeight: 600,
        textStyle: style,
      );

      final column = engine.columnAt(0);

      expect(column.items.length, 3);
      expect(column.items[0], isA<PaintableColumnText>());
      expect(column.items[1], isA<PaintableTcy>());
      expect(column.items[2], isA<PaintableColumnText>());
      expect((column.items[1] as PaintableTcy).text, '12');
    });

    testWidgets('桁区切り付き数値トークンは列をまたいで分割されない', (tester) async {
      final engine = TategakiColumnEngine(
        elements: TategakiParser.parse('あ16,844円'),
        maxHeight: style.fontSize! * 2,
        textStyle: style,
      );

      final columns = engine.computeAll();

      expect(columns.length, 3);
      expect((columns[0].items.single as PaintableColumnText).text, 'あ');
      expect(columns[1].items.single, isA<PaintableRotated>());
      expect((columns[1].items.single as PaintableRotated).text, '16,844');
      expect((columns[2].items.single as PaintableColumnText).text, '円');
    });

    testWidgets('非最終行は行末調整でmaxHeightまで揃えられる', (tester) async {
      // maxHeight を 5 文字強にし、最終行以外が揃うことを確認する
      final elements = List.generate(12, (i) => const TategakiChar('あ'));
      final engine = TategakiColumnEngine(
        elements: elements,
        maxHeight: style.fontSize! * 5,
        textStyle: style,
      );

      final columns = engine.computeAll();
      // 最初の列（最終行ではない）は末尾が maxHeight に一致する
      final first = columns.first;
      final last = first.placedItems.last;
      expect(
        last.inlineOffset + last.item.advance,
        closeTo(style.fontSize! * 5, 0.001),
      );
    });

    testWidgets('columnAtは同じ列に対して同一インスタンスを返す（メモ化）', (tester) async {
      final engine = TategakiColumnEngine(
        elements: const [TategakiChar('あ')],
        maxHeight: 600,
        textStyle: style,
      );

      expect(identical(engine.columnAt(0), engine.columnAt(0)), isTrue);
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
