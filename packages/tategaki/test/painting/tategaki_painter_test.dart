import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/tategaki_char_class.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/layout/tategaki_measurer.dart';
import 'package:tategaki/src/painting/paintable.dart';
import 'package:tategaki/src/painting/tategaki_painter.dart';

/// `getLocalClipBounds` を差し替えられる Canvas
class MockCanvas extends Mock implements Canvas {
  Rect testClipRect = Rect.largest;

  @override
  Rect getLocalClipBounds() => testClipRect;
}

/// 描画位置を記録する Paintable
class MockPaintable extends Mock implements Paintable {
  MockPaintable({
    double baseWidth = 20,
    double width = 20,
    double height = 100,
  }) : _baseWidth = baseWidth,
       _width = width,
       _height = height;

  final double _baseWidth;
  final double _width;
  final double _height;

  @override
  double get baseWidth => _baseWidth;

  @override
  double get width => _width;

  @override
  double get height => _height;

  final List<Offset> paintedOffsets = [];

  @override
  void paint(Canvas? canvas, Offset? offset) {
    if (offset != null) {
      paintedOffsets.add(offset);
    }
    super.noSuchMethod(Invocation.method(#paint, [canvas, offset]));
  }
}

TategakiMeasuredItem makeMeasured(Paintable paintable) {
  return TategakiMeasuredItem(
    element: const TategakiChar('あ'),
    advance: 100,
    baseExtent: 20,
    blockExtent: 20,
    firstClass: TategakiCharClass.others,
    lastClass: TategakiCharClass.others,
    paintable: paintable,
  );
}

TategakiColumn makeColumn(MockPaintable item, {double baseWidth = 20}) {
  return TategakiColumn(
    placedItems: [
      TategakiPlacedItem(
        item: makeMeasured(item),
        inlineOffset: 0,
        blockOffset: (baseWidth - item.baseWidth) / 2,
      ),
    ],
    width: baseWidth,
    baseWidth: baseWidth,
  );
}

void main() {
  group('TategakiPainter 描画位置', () {
    test('1列の場合、列はキャンバス中央に描画される', () {
      final item = MockPaintable();
      final metrics = TategakiMetrics(
        columns: [makeColumn(item)],
        size: const Size(20, 600),
      );

      final painter = TategakiPainter(metrics: metrics);
      final canvas = MockCanvas();
      painter.paint(canvas, const Size(100, 600));

      // horizontalPadding = (100-20)/2 = 40, 右端開始 = 60, 列左端 = 40
      expect(item.paintedOffsets, hasLength(1));
      expect(item.paintedOffsets[0].dx, 40);
      expect(item.paintedOffsets[0].dy, 0);
    });

    test('2列の場合、列間のスペースが正しく適用される', () {
      final item1 = MockPaintable();
      final item2 = MockPaintable();

      const contentWidth = 20 + TategakiLayout.columnSpacing + 20;
      final metrics = TategakiMetrics(
        columns: [makeColumn(item1), makeColumn(item2)],
        size: const Size(contentWidth, 600),
      );

      TategakiPainter(
        metrics: metrics,
      ).paint(MockCanvas(), const Size(contentWidth, 600));

      expect(item1.paintedOffsets, hasLength(1));
      expect(item2.paintedOffsets, hasLength(1));
      final gap = item1.paintedOffsets[0].dx - item2.paintedOffsets[0].dx;
      expect(gap, 20 + TategakiLayout.columnSpacing);
    });

    test('コンテンツがキャンバスより小さい場合、左右の余白が均等になる', () {
      final item = MockPaintable();
      final metrics = TategakiMetrics(
        columns: [makeColumn(item)],
        size: const Size(20, 600),
      );

      TategakiPainter(
        metrics: metrics,
      ).paint(MockCanvas(), const Size(200, 600));

      expect(item.paintedOffsets, hasLength(1));
      final dx = item.paintedOffsets[0].dx;
      final leftMargin = dx;
      final rightMargin = 200 - (dx + 20);
      expect(leftMargin, rightMargin);
      expect(leftMargin, 90);
    });
  });
}
