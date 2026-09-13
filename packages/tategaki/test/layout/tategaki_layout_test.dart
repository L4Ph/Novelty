import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/paintable_column_text.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';
import 'package:tategaki/tategaki.dart';

void main() {
  group('TategakiLayout', () {
    const textStyle = TextStyle(fontSize: 16);

    test('空の要素リストでは空のメトリクスを返す', () {
      final metrics = TategakiLayout.calculate(
        elements: [],
        maxHeight: 600,
        textStyle: textStyle,
      );

      expect(metrics.columns, isEmpty);
      expect(metrics.size.width, 0);
    });

    test('単一文字を1列に配置する', () {
      final metrics = TategakiLayout.calculate(
        elements: const [TategakiChar('あ')],
        maxHeight: 600,
        textStyle: textStyle,
      );

      expect(metrics.columns.length, 1);
      expect(metrics.columns[0].items.length, 1);
    });

    test('改行で空の列を作成する', () {
      final metrics = TategakiLayout.calculate(
        elements: const [
          TategakiChar('あ'),
          TategakiNewLine(),
          TategakiChar('い'),
        ],
        maxHeight: 600,
        textStyle: textStyle,
      );

      expect(metrics.columns.length, 3);
    });

    test('maxHeightを超えると自動的に列を分割する', () {
      final metrics = TategakiLayout.calculate(
        elements: List.generate(50, (i) => const TategakiChar('あ')),
        maxHeight: 100,
        textStyle: textStyle,
      );

      expect(metrics.columns.length, greaterThan(1));
    });

    group('columnSpacing の計算', () {
      test('1列の場合はcolumnSpacingを含まない', () {
        final metrics = TategakiLayout.calculate(
          elements: const [TategakiChar('あ')],
          maxHeight: 600,
          textStyle: textStyle,
        );

        expect(metrics.columns.length, 1);
        expect(metrics.size.width, metrics.columns[0].width);
      });

      test('複数列の合計幅は列幅の合計に一致する（columnSpacing=0）', () {
        final metrics = TategakiLayout.calculate(
          elements: const [
            TategakiChar('あ'),
            TategakiNewLine(),
            TategakiChar('い'),
          ],
          maxHeight: 600,
          textStyle: textStyle,
        );

        final columnsWidth = metrics.columns.fold<double>(
          0,
          (sum, c) => sum + c.width,
        );
        expect(
          metrics.size.width,
          columnsWidth + TategakiLayout.columnSpacing * 2,
        );
        expect(TategakiLayout.columnSpacing, 0);
      });
    });

    group('TCY（縦中横数字）のレイアウト順序', () {
      test('通常文字とTCYが要素順に配置される', () {
        final metrics = TategakiLayout.calculate(
          elements: const [
            TategakiChar('あ'),
            TategakiChar('い'),
            TategakiTcy('12'),
            TategakiChar('え'),
          ],
          maxHeight: 600,
          textStyle: textStyle,
        );

        final column = metrics.columns[0];
        expect(column.items, hasLength(4));
        expect((column.items[0] as PaintableColumnText).text, 'あ');
        expect((column.items[1] as PaintableColumnText).text, 'い');
        expect((column.items[2] as PaintableTcy).text, '12');
        expect((column.items[3] as PaintableColumnText).text, 'え');
      });

      test('TCYのみの要素リストで配置される', () {
        final metrics = TategakiLayout.calculate(
          elements: const [TategakiTcy('99')],
          maxHeight: 600,
          textStyle: textStyle,
        );

        expect(metrics.columns.length, 1);
        expect((metrics.columns[0].items.single as PaintableTcy).text, '99');
      });

      test('TCYがmaxHeightを超える場合に新しい列を開始する', () {
        final metrics = TategakiLayout.calculate(
          elements: [
            ...List.generate(10, (_) => const TategakiChar('あ')),
            const TategakiTcy('99'),
          ],
          maxHeight: 50,
          textStyle: textStyle,
        );

        expect(metrics.columns.length, greaterThan(1));
        final tcyItems = metrics.columns
            .expand((col) => col.items)
            .whereType<PaintableTcy>()
            .toList();
        expect(tcyItems, hasLength(1));
        expect(tcyItems.first.text, '99');
      });
    });
  });
}
