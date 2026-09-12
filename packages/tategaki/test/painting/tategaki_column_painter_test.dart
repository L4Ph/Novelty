import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';
import 'package:tategaki/src/painting/tategaki_column_painter.dart';

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
  testWidgets('縦中横は実際の描画幅で列の中央に描画される', (tester) async {
    // lineHeight を大きくすると TextPainter.height（行送り）だけが大きくなる。
    // TCY は横書きのまま描画するため、中央寄せは行送りではなく
    // 数字の実描画幅（painter.width）を基準にしなければ左に偏る。
    const style = TextStyle(fontSize: 16, height: 3);
    final tcyPainter = TextPainter(
      text: const TextSpan(text: '12', style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final tcy = PaintableTcy(tcyPainter);

    // 数字の描画幅より広い基準幅を持たせ、dx > 0 の中央寄せを検証する
    const columnBaseWidth = 60.0;
    final column = TategakiColumn(
      slots: [TategakiInlineItem(tcy)],
      width: columnBaseWidth,
      baseWidth: columnBaseWidth,
      textStyle: style,
    );

    final canvas = _RecordingCanvas();
    TategakiColumnPainter(column: column).paint(canvas, const Size(200, 600));

    expect(canvas.paragraphOffsets, hasLength(1));
    final offset = canvas.paragraphOffsets.single;

    // 実際に描画された数字の中心が列の中心軸に一致する
    final expectedWidth = (TextPainter(
      text: const TextSpan(text: '12', style: style),
      textDirection: TextDirection.ltr,
    )..layout()).width;
    expect(offset.dx + expectedWidth / 2, closeTo(columnBaseWidth / 2, 0.001));
  });
}
