import 'package:flutter/material.dart';
import 'package:novelty/utils/vertical_rotated.dart';

class Tategaki extends StatelessWidget {
  const Tategaki(
    this.text,
    {
    super.key,
    this.style,
    this.space = 12,
  });

  final String text;
  final TextStyle? style;
  final double space;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    final effectiveTextStyle = style ?? DefaultTextStyle.of(context).style;
    final painter = _TategakiPainter(
      text: text,
      textStyle: effectiveTextStyle,
      space: space,
    );

    return CustomPaint(
      size: painter.size,
      painter: painter,
    );
  }
}

class _TategakiPainter extends CustomPainter {
  _TategakiPainter({
    required this.text,
    required this.textStyle,
    required this.space,
  }) {
    _calculateMetrics();
  }

  final String text;
  final TextStyle textStyle;
  final double space;

  late final List<List<TextPainter>> _linesPainters;
  late final List<double> _lineWidths;
  late final Size size;

  void _calculateMetrics() {
    _linesPainters = [];
    _lineWidths = [];
    var totalWidth = 0.0;
    var maxHeight = 0.0;

    final lines = text.split('\n');

    for (final line in lines) {
      if (line.isEmpty) {
        _lineWidths.add(0);
        _linesPainters.add([]);
        continue;
      }

      final charPainters = <TextPainter>[];
      var maxCharWidth = 0.0;
      var currentHeight = 0.0;

      for (final char in line.runes) {
        final character = String.fromCharCode(char);
        final rotatedChar = VerticalRotated.map[character] ?? character;

        final textPainter = TextPainter(
          text: TextSpan(text: rotatedChar, style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        charPainters.add(textPainter);

        if (textPainter.width > maxCharWidth) {
          maxCharWidth = textPainter.width;
        }
        currentHeight += textPainter.height;
      }

      _lineWidths.add(maxCharWidth);
      _linesPainters.add(charPainters);
      totalWidth += maxCharWidth + space;
      if (currentHeight > maxHeight) {
        maxHeight = currentHeight;
      }
    }

    size = Size(totalWidth, maxHeight);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var nextLineLeftBoundary = size.width;

    for (var i = 0; i < _linesPainters.length; i++) {
      final charPainters = _linesPainters[i];
      final lineWidth = _lineWidths[i];

      final lineTotalWidth = charPainters.isEmpty ? 0 : lineWidth + space;
      final currentLineLeftBoundary = nextLineLeftBoundary - lineTotalWidth;

      if (charPainters.isNotEmpty) {
        var dy = 0.0;
        for (final textPainter in charPainters) {
          textPainter.paint(canvas, Offset(currentLineLeftBoundary + space, dy));
          dy += textPainter.height;
        }
      }

      nextLineLeftBoundary = currentLineLeftBoundary;
    }
  }

  @override
  bool shouldRepaint(covariant _TategakiPainter oldDelegate) {
    return text != oldDelegate.text ||
        textStyle != oldDelegate.textStyle ||
        space != oldDelegate.space;
  }
}
