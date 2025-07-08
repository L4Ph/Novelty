import 'package:flutter/material.dart';
import 'package:novelty/utils/vertical_rotated.dart';

class Tategaki extends StatelessWidget {
  const Tategaki(
    this.text, {
    super.key,
    this.style,
    this.space = 12,
    required this.maxHeight,
  });

  final String text;
  final TextStyle? style;
  final double space;
  final double maxHeight;

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
      maxHeight: maxHeight,
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
    required this.maxHeight,
  }) {
    _calculateMetrics();
  }

  final String text;
  final TextStyle textStyle;
  final double space;
  final double maxHeight;

  late final List<List<TextPainter>> _painters;
  late final List<double> _columnWidths;
  late final Size size;

  void _calculateMetrics() {
    _painters = [];
    _columnWidths = [];
    var totalWidth = 0.0;

    final lines = text.split('\n');

    for (final line in lines) {
      if (line.isEmpty) {
        _painters.add([]);
        _columnWidths.add(0);
        totalWidth += space;
        continue;
      }

      var currentColumnPainters = <TextPainter>[];
      var currentColumnHeight = 0.0;
      var currentColumnWidth = 0.0;

      for (final char in line.runes) {
        final character = String.fromCharCode(char);
        final rotatedChar = VerticalRotated.map[character] ?? character;

        final textPainter = TextPainter(
          text: TextSpan(text: rotatedChar, style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();

        if (currentColumnHeight + textPainter.height > maxHeight &&
            currentColumnPainters.isNotEmpty) {
          _painters.add(currentColumnPainters);
          _columnWidths.add(currentColumnWidth);
          totalWidth += currentColumnWidth + space;

          currentColumnPainters = [];
          currentColumnHeight = 0.0;
          currentColumnWidth = 0.0;
        }

        currentColumnPainters.add(textPainter);
        currentColumnHeight += textPainter.height;
        if (textPainter.width > currentColumnWidth) {
          currentColumnWidth = textPainter.width;
        }
      }

      if (currentColumnPainters.isNotEmpty) {
        _painters.add(currentColumnPainters);
        _columnWidths.add(currentColumnWidth);
        totalWidth += currentColumnWidth + space;
      }
    }

    size = Size(totalWidth, maxHeight);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var nextColumnX = size.width;

    for (var i = 0; i < _painters.length; i++) {
      final charPainters = _painters[i];
      final columnWidth = _columnWidths[i];

      final columnTotalWidth = columnWidth + space;
      final currentColumnX = nextColumnX - columnTotalWidth;

      if (charPainters.isNotEmpty) {
        var dy = 0.0;
        for (final textPainter in charPainters) {
          final dx =
              currentColumnX + space + (columnWidth - textPainter.width) / 2;
          textPainter.paint(canvas, Offset(dx, dy));
          dy += textPainter.height;
        }
      }

      nextColumnX = currentColumnX;
    }
  }

  @override
  bool shouldRepaint(covariant _TategakiPainter oldDelegate) {
    return text != oldDelegate.text ||
        textStyle != oldDelegate.textStyle ||
        space != oldDelegate.space ||
        maxHeight != oldDelegate.maxHeight;
  }
}
