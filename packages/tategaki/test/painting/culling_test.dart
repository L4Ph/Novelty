import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/painting/paintable.dart';
import 'package:tategaki/src/painting/tategaki_painter.dart';

// Simple Mock Class using Mockito-style manual mock
class MockCanvas extends Mock implements Canvas {
  Rect testClipRect = Rect.largest;

  @override
  Rect getLocalClipBounds() => testClipRect;
}

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

void main() {
  test('TategakiPainter culls invisible columns', () {
    // 1. Setup Data
    // Create 5 columns. Each 20px wide + 12px spacing = 32px stride.
    // Total width = 32 * 5 = 160px.
    // X positions (Right to Left):
    // Col 0: Right 160, Left 128
    // Col 1: Right 128, Left 96
    // ...
    final columns = <TategakiColumn>[];
    final mockItems = <MockPaintable>[];

    for (var i = 0; i < 5; i++) {
      final item = MockPaintable();
      mockItems.add(item);
      columns.add(
        TategakiColumn(
          items: [item],
          width: 20,
          baseWidth: 20,
        ),
      );
    }

    // Total width calculation in painter:
    // nextColumnX starts at size.width (160)
    // Col 0: 160 - (20+12) = 128 (Left edge)

    final metrics = TategakiMetrics(
      columns: columns,
      size: const Size(160, 600),
    );

    final painter = TategakiPainter(metrics: metrics);
    final canvas = MockCanvas()
      ..testClipRect = const Rect.fromLTWH(0, 0, 160, 600);

    // 2. Scenario A: Full Viewport (Everything visible)
    painter.paint(canvas, const Size(160, 600));

    // Verify ALL items painted
    for (final item in mockItems) {
      verify(item.paint(canvas, argThat(isA<Offset>()))).called(1);
    }

    clearInteractions(canvas);
    mockItems.forEach(reset);

    // 3. Scenario B: Left Viewport (Only last 2 columns visible)
    // Columns are RTL.
    // Col 0 (Rightmost): X=128
    // Col 1: X=96
    // Col 2: X=64
    // Col 3: X=32
    // Col 4 (Leftmost): X=0

    // Viewport from 0 to 60 (Left side). Should show Col 4 and Col 3.
    canvas.testClipRect = const Rect.fromLTWH(0, 0, 60, 600);
    painter.paint(canvas, const Size(160, 600));

    // Verify Col 3 and 4 are painted
    verify(
      mockItems[3].paint(canvas, argThat(isA<Offset>())),
    ).called(1); // Col 3
    verify(
      mockItems[4].paint(canvas, argThat(isA<Offset>())),
    ).called(1); // Col 4

    // Verify Col 0, 1, 2 are NOT painted
    verifyNever(mockItems[0].paint(canvas, any));
    verifyNever(mockItems[1].paint(canvas, any));
    verifyNever(mockItems[2].paint(canvas, any));
  });
}
