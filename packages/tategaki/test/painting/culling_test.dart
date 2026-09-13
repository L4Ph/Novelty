import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/tategaki_char_class.dart';
import 'package:tategaki/src/layout/tategaki_measurer.dart';
import 'package:tategaki/src/painting/paintable.dart';
import 'package:tategaki/src/painting/tategaki_painter.dart';

/// `getLocalClipBounds` を差し替えられる Canvas
class MockCanvas extends Mock implements Canvas {
  Rect testClipRect = Rect.largest;

  @override
  Rect getLocalClipBounds() => testClipRect;
}

/// 描画呼び出しを記録する Paintable
class MockPaintable extends Mock implements Paintable {
  @override
  double get baseWidth => 20;

  @override
  double get width => 20;

  @override
  double get height => 100;

  @override
  void paint(Canvas? canvas, Offset? offset) =>
      super.noSuchMethod(Invocation.method(#paint, [canvas, offset]));
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

void main() {
  test('TategakiPainter culls invisible columns', () {
    // 列幅20px・列間0で5列。右から左へ X=80,60,40,20,0。
    final columns = <TategakiColumn>[];
    final mockItems = <MockPaintable>[];

    for (var i = 0; i < 5; i++) {
      final item = MockPaintable();
      mockItems.add(item);
      columns.add(
        TategakiColumn(
          placedItems: [
            TategakiPlacedItem(
              item: makeMeasured(item),
              inlineOffset: 0,
              blockOffset: 0,
            ),
          ],
          width: 20,
          baseWidth: 20,
        ),
      );
    }

    final metrics = TategakiMetrics(
      columns: columns,
      size: const Size(100, 600),
    );

    final painter = TategakiPainter(metrics: metrics);
    final canvas = MockCanvas()
      ..testClipRect = const Rect.fromLTWH(0, 0, 100, 600);

    // 全列可視
    painter.paint(canvas, const Size(100, 600));
    for (final item in mockItems) {
      verify(item.paint(canvas, argThat(isA<Offset>()))).called(1);
    }

    clearInteractions(canvas);
    mockItems.forEach(reset);

    // 左端 0..40 のみ可視 → 列3(20..40) と 列4(0..20) のみ
    canvas.testClipRect = const Rect.fromLTWH(0, 0, 40, 600);
    painter.paint(canvas, const Size(100, 600));

    verify(mockItems[3].paint(canvas, argThat(isA<Offset>()))).called(1);
    verify(mockItems[4].paint(canvas, argThat(isA<Offset>()))).called(1);
    verifyNever(mockItems[0].paint(canvas, any));
    verifyNever(mockItems[1].paint(canvas, any));
    verifyNever(mockItems[2].paint(canvas, any));
  });
}
