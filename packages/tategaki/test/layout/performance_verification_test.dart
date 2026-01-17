import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Compare per-character rendering vs newline-based rendering', (tester) async {
    const text = '吾輩は猫である。';
    const style = TextStyle(fontSize: 20, height: 1, fontFamily: 'Courier'); // Use a generic mono font

    // 1. Per-character rendering logic (Control)
    final perCharPositions = <Offset>[];
    var currentY = 0.0;
    for (var i = 0; i < text.length; i++) {
      final painter = TextPainter(
        text: TextSpan(text: text[i], style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      perCharPositions.add(Offset(0, currentY));
      currentY += painter.height;
    }
    final perCharTotalHeight = currentY;

    // 2. Newline-based rendering (Experimental)
    final newlineText = text.split('').join('\n');
    final newlinePainter = TextPainter(
      text: TextSpan(text: newlineText, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    // Basic height comparison
    expect(newlinePainter.height, closeTo(perCharTotalHeight, 0.001), 
      reason: 'Total height should match');

    // Box-by-box comparison would be better but we can use getOffsetForCaret to check internal positions
    for (var i = 0; i < text.length; i++) {
      // Index in newlineText: char is at i*2 (since every second char is \n)
      final offset = newlinePainter.getOffsetForCaret(
        TextPosition(offset: i * 2),
        Rect.zero,
      );
      // We expect the Y positions to match
      expect(offset.dy, closeTo(perCharPositions[i].dy, 0.001),
        reason: 'Character at index $i should have same Y position');
    }
  });
}
