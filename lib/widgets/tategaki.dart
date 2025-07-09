import 'package:flutter/material.dart';
import 'package:novelty/utils/vertical_rotated.dart';

class _TategakiMetrics {
  const _TategakiMetrics({
    required this.painters,
    required this.columnWidths,
    required this.size,
  });

  final List<List<TextPainter>> painters;
  final List<double> columnWidths;
  final Size size;
}

class Tategaki extends StatefulWidget {
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
  State<Tategaki> createState() => _TategakiState();
}

class _TategakiState extends State<Tategaki> {
  _TategakiMetrics? _metrics;

  @override
  void initState() {
    super.initState();
    _calculateMetrics();
  }

  @override
  void didUpdateWidget(Tategaki oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text ||
        widget.style != oldWidget.style ||
        widget.space != oldWidget.space ||
        widget.maxHeight != oldWidget.maxHeight) {
      _calculateMetrics();
    }
  }

  void _calculateMetrics() {
    final effectiveTextStyle =
        widget.style ?? DefaultTextStyle.of(context).style;

    final painters = <List<TextPainter>>[];
    final columnWidths = <double>[];
    var totalWidth = 0.0;

    final lines = widget.text.split('\n');

    for (final line in lines) {
      if (line.isEmpty) {
        painters.add([]);
        columnWidths.add(0);
        totalWidth += widget.space;
        continue;
      }

      var currentColumnPainters = <TextPainter>[];
      var currentColumnHeight = 0.0;
      var currentColumnWidth = 0.0;

      for (final char in line.runes) {
        final character = String.fromCharCode(char);
        final rotatedChar = VerticalRotated.map[character] ?? character;

        final textPainter = TextPainter(
          text: TextSpan(text: rotatedChar, style: effectiveTextStyle),
          textDirection: TextDirection.ltr,
        )..layout();

        if (currentColumnHeight + textPainter.height > widget.maxHeight &&
            currentColumnPainters.isNotEmpty) {
          painters.add(currentColumnPainters);
          columnWidths.add(currentColumnWidth);
          totalWidth += currentColumnWidth + widget.space;

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
        painters.add(currentColumnPainters);
        columnWidths.add(currentColumnWidth);
        totalWidth += currentColumnWidth + widget.space;
      }
    }

    setState(() {
      _metrics = _TategakiMetrics(
        painters: painters,
        columnWidths: columnWidths,
        size: Size(totalWidth, widget.maxHeight),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.isEmpty || _metrics == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      size: _metrics!.size,
      painter: _TategakiPainter(
        metrics: _metrics!,
        space: widget.space,
      ),
    );
  }
}

class _TategakiPainter extends CustomPainter {
  const _TategakiPainter({
    required this.metrics,
    required this.space,
  });

  final _TategakiMetrics metrics;
  final double space;

  @override
  void paint(Canvas canvas, Size size) {
    var nextColumnX = size.width;

    for (var i = 0; i < metrics.painters.length; i++) {
      final charPainters = metrics.painters[i];
      final columnWidth = metrics.columnWidths[i];

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
    return metrics != oldDelegate.metrics || space != oldDelegate.space;
  }
}