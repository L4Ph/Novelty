import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/tategaki_measurer.dart';
import 'package:tategaki/src/painting/tategaki_column_painter.dart';
import 'package:tategaki/tategaki.dart';

/// `drawParagraph` に渡された描画位置を記録する Canvas
class _RecordingCanvas extends Mock implements Canvas {
  /// 段落が描画された位置（呼び出し順）
  final List<Offset> paragraphOffsets = [];

  @override
  void drawParagraph(ui.Paragraph paragraph, Offset offset) {
    paragraphOffsets.add(offset);
  }
}

void main() {
  testWidgets('縦中横は列の中心軸に描画される', (tester) async {
    // 行送りを大きくし、列幅（=行送り）の中で TCY が中央に来ることを検証する
    const style = TextStyle(fontSize: 16, height: 3);
    final measurer = TategakiMeasurer(style);
    final measured = measurer.measure(const TategakiTcy('12'));

    final column = TategakiColumn(
      placedItems: [
        TategakiPlacedItem(
          item: measured,
          inlineOffset: 0,
          blockOffset: (measurer.linePitch - measured.baseExtent) / 2,
        ),
      ],
      width: measurer.linePitch,
      baseWidth: measurer.linePitch,
    );

    final canvas = _RecordingCanvas();
    TategakiColumnPainter(column: column).paint(canvas, const Size(200, 600));

    expect(canvas.paragraphOffsets, hasLength(1));
    final offset = canvas.paragraphOffsets.single;

    // 実際に描画された数字の中心が列の中心軸に一致する
    expect(
      offset.dx + measured.baseExtent / 2,
      closeTo(measurer.linePitch / 2, 0.001),
    );
  });
}
