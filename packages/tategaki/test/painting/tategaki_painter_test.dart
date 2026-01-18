import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/paintable.dart';
import 'package:tategaki/src/painting/tategaki_painter.dart';

// MockCanvas: getLocalClipBounds をオーバーライド
class MockCanvas extends Mock implements Canvas {
  Rect testClipRect = Rect.largest;

  @override
  Rect getLocalClipBounds() => testClipRect;
}

// MockPaintable: 描画位置を記録する
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

  // 記録された描画位置
  final List<Offset> paintedOffsets = [];

  @override
  void paint(Canvas? canvas, Offset? offset) {
    if (offset != null) {
      paintedOffsets.add(offset);
    }
    super.noSuchMethod(Invocation.method(#paint, [canvas, offset]));
  }
}

void main() {
  group('TategakiPainter 描画位置', () {
    test('1列の場合、列はキャンバス中央に描画される', () {
      // 1列を作成（幅20px）
      final item = MockPaintable();
      final column = TategakiColumn(
        items: [item],
        width: 20,
        baseWidth: 20,
      );

      // 1列の場合、totalWidth = column.width = 20
      // （columnSpacing は含まれない）
      final metrics = TategakiMetrics(
        columns: [column],
        size: const Size(20, 600), // スペースなしの幅
      );

      final painter = TategakiPainter(metrics: metrics);
      final canvas = MockCanvas();

      // キャンバスサイズ 100x600 で描画
      // 中央揃え: horizontalPadding = (100 - 20) / 2 = 40
      // 右端開始位置 = 100 - 40 = 60
      painter.paint(canvas, const Size(100, 600));

      // 描画された位置を確認
      expect(item.paintedOffsets.length, 1);
      // dx = currentColumnX + (column.baseWidth - item.baseWidth) / 2
      // currentColumnX = 60 - 20 = 40
      // dx = 40 + (20 - 20) / 2 = 40
      expect(item.paintedOffsets[0].dx, 40);
      expect(item.paintedOffsets[0].dy, 0);
    });

    test('2列の場合、列間のスペースが正しく適用される', () {
      // 2列を作成（各幅20px）
      final item1 = MockPaintable();
      final item2 = MockPaintable();

      final column1 = TategakiColumn(
        items: [item1],
        width: 20,
        baseWidth: 20,
      );
      final column2 = TategakiColumn(
        items: [item2],
        width: 20,
        baseWidth: 20,
      );

      // 2列の場合、totalWidth = 20 + 12 + 20 = 52
      const contentWidth = 20 + TategakiLayout.columnSpacing + 20;
      final metrics = TategakiMetrics(
        columns: [column1, column2],
        size: const Size(contentWidth, 600),
      );

      final painter = TategakiPainter(metrics: metrics);
      final canvas = MockCanvas();

      // キャンバスサイズをコンテンツ幅と同じに設定（中央揃えなし）
      painter.paint(canvas, const Size(contentWidth, 600));

      // 期待される描画位置:
      // 右端から開始: nextColumnX = 52
      // 1列目: columnTotalWidth = 20 (最初の列なのでスペースなし)
      //        currentColumnX = 52 - 20 = 32
      //        dx = 32 + 0 = 32
      // 2列目: columnTotalWidth = 20 + 12 = 32 (2列目以降はスペースあり)
      //        currentColumnX = 32 - 32 = 0
      //        dx = 0 + 12 = 12 (スペース分のオフセット)
      //
      // 実際の正しい動作:
      // 右端から開始: nextColumnX = 52
      // 1列目: currentColumnX = 52 - 20 = 32, dx = 32
      // 2列目: currentColumnX = 32 - 12 - 20 = 0, dx = 0
      expect(item1.paintedOffsets.length, 1);
      expect(item2.paintedOffsets.length, 1);

      // item1 は右端の列（1列目）
      // item2 は左端の列（2列目）
      // 両者の間に columnSpacing 分のスペースがあるべき
      final gap = item1.paintedOffsets[0].dx - item2.paintedOffsets[0].dx;
      expect(gap, 20 + TategakiLayout.columnSpacing);
    });

    test('コンテンツがキャンバスより小さい場合、左右の余白が均等になる', () {
      // 1列を作成（幅20px）
      final item = MockPaintable();
      final column = TategakiColumn(
        items: [item],
        width: 20,
        baseWidth: 20,
      );

      final metrics = TategakiMetrics(
        columns: [column],
        size: const Size(20, 600),
      );

      final painter = TategakiPainter(metrics: metrics);
      final canvas = MockCanvas();

      // キャンバスサイズ 200x600 で描画
      // 中央揃え: horizontalPadding = (200 - 20) / 2 = 90
      painter.paint(canvas, const Size(200, 600));

      expect(item.paintedOffsets.length, 1);

      // 列が中央に配置されているか確認
      final dx = item.paintedOffsets[0].dx;
      // 左の余白
      final leftMargin = dx;
      // 右の余白 = canvasWidth - (dx + columnWidth)
      final rightMargin = 200 - (dx + 20);

      expect(leftMargin, rightMargin);
      expect(leftMargin, 90);
    });
  });
}
