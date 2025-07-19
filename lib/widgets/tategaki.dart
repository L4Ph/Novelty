import 'package:flutter/material.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/utils/vertical_rotated.dart';

abstract class _Paintable {
  double get height;
  double get width;
  void paint(Canvas canvas, Offset offset);
}

class _PaintableChar extends _Paintable {
  _PaintableChar(this.painter);
  final TextPainter painter;

  @override
  double get height => painter.height;
  @override
  double get width => painter.width;

  @override
  void paint(Canvas canvas, Offset offset) {
    painter.paint(canvas, offset);
  }
}

class _PaintableRuby extends _Paintable {
  _PaintableRuby(
    this.basePainters,
    this.rubyPainters,
    this.baseWidth,
    this.rubyWidth,
    this.rubyHeight,
  );
  final List<TextPainter> basePainters;
  final List<TextPainter> rubyPainters;
  final double baseWidth;
  final double rubyWidth;
  final double rubyHeight;

  @override
  double get height => basePainters.fold(0, (prev, p) => prev + p.height);

  @override
  double get width => baseWidth + rubyWidth;

  @override
  void paint(Canvas canvas, Offset offset) {
    var baseDy = offset.dy;
    for (final p in basePainters) {
      final charDx = offset.dx + (baseWidth - p.width) / 2;
      p.paint(canvas, Offset(charDx, baseDy));
      baseDy += p.height;
    }

    var rubyDy = offset.dy + (height - rubyHeight) / 2;
    for (final p in rubyPainters) {
      final charDx = offset.dx + baseWidth + (rubyWidth - p.width) / 2;
      p.paint(canvas, Offset(charDx, rubyDy));
      rubyDy += p.height;
    }
  }
}

class _TategakiColumn {
  _TategakiColumn(this.items, this.width);
  final List<_Paintable> items;
  final double width;
}

class _TategakiMetrics {
  const _TategakiMetrics({
    required this.columns,
    required this.size,
  });

  final List<_TategakiColumn> columns;
  final Size size;
}

/// 縦書きの小説コンテンツを表示するウィジェット。
class Tategaki extends StatefulWidget {
  /// コンストラクタ。
  const Tategaki(
    this.content, {
    required this.maxHeight,
    super.key,
    this.style,
    this.space = 12,
  });

  /// 小説のコンテンツ要素のリスト。
  /// `PlainText`, `RubyText`, `NewLine`のいずれか
  final List<NovelContentElement> content;

  /// テキストのスタイル。
  final TextStyle? style;

  /// 列間のスペース。
  final double space;

  /// 最大の高さ。
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
    if (widget.content != oldWidget.content ||
        widget.style != oldWidget.style ||
        widget.space != oldWidget.space ||
        widget.maxHeight != oldWidget.maxHeight) {
      _calculateMetrics();
    }
  }

  void _calculateMetrics() {
    final effectiveTextStyle =
        widget.style ?? DefaultTextStyle.of(context).style;
    final rubyTextStyle = effectiveTextStyle.copyWith(
      fontSize: (effectiveTextStyle.fontSize ?? 14) * 0.6,
    );

    final columns = <_TategakiColumn>[];
    var totalWidth = 0.0;

    var currentColumnItems = <_Paintable>[];
    var currentColumnHeight = 0.0;
    var currentColumnWidth = 0.0;

    void endColumn() {
      if (currentColumnItems.isNotEmpty) {
        final column = _TategakiColumn(currentColumnItems, currentColumnWidth);
        columns.add(column);
        totalWidth += column.width + widget.space;
      }
      currentColumnItems = [];
      currentColumnHeight = 0.0;
      currentColumnWidth = 0.0;
    }

    for (final element in widget.content) {
      switch (element) {
        case PlainText():
          for (final char in element.text.runes) {
            final character = String.fromCharCode(char);
            final rotatedChar = VerticalRotated.map[character] ?? character;
            final painter = TextPainter(
              text: TextSpan(text: rotatedChar, style: effectiveTextStyle),
              textDirection: TextDirection.ltr,
            )..layout();
            final item = _PaintableChar(painter);

            if (currentColumnHeight + item.height > widget.maxHeight &&
                currentColumnItems.isNotEmpty) {
              endColumn();
            }
            currentColumnItems.add(item);
            currentColumnHeight += item.height;
            if (item.width > currentColumnWidth) {
              currentColumnWidth = item.width;
            }
          }
        case RubyText():
          final basePainters = <TextPainter>[];
          var baseWidth = 0.0;
          for (final char in element.base.runes) {
            final character = String.fromCharCode(char);
            final rotatedChar = VerticalRotated.map[character] ?? character;
            final painter = TextPainter(
              text: TextSpan(text: rotatedChar, style: effectiveTextStyle),
              textDirection: TextDirection.ltr,
            )..layout();
            basePainters.add(painter);
            if (painter.width > baseWidth) {
              baseWidth = painter.width;
            }
          }

          final rubyPainters = <TextPainter>[];
          var rubyWidth = 0.0;
          var rubyHeight = 0.0;
          for (final char in element.ruby.runes) {
            final character = String.fromCharCode(char);
            final rotatedChar = VerticalRotated.map[character] ?? character;
            final painter = TextPainter(
              text: TextSpan(text: rotatedChar, style: rubyTextStyle),
              textDirection: TextDirection.ltr,
            )..layout();
            rubyPainters.add(painter);
            rubyHeight += painter.height;
            if (painter.width > rubyWidth) {
              rubyWidth = painter.width;
            }
          }

          final item = _PaintableRuby(
            basePainters,
            rubyPainters,
            baseWidth,
            rubyWidth,
            rubyHeight,
          );

          if (currentColumnHeight + item.height > widget.maxHeight &&
              currentColumnItems.isNotEmpty) {
            endColumn();
          }
          currentColumnItems.add(item);
          currentColumnHeight += item.height;
          if (item.width > currentColumnWidth) {
            currentColumnWidth = item.width;
          }
        case NewLine():
          endColumn();
          columns.add(_TategakiColumn([], 0));
          totalWidth += widget.space;
      }
    }
    if (currentColumnItems.isNotEmpty) {
      endColumn();
    }

    setState(() {
      _metrics = _TategakiMetrics(
        columns: columns,
        size: Size(totalWidth, widget.maxHeight),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.content.isEmpty || _metrics == null) {
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

    for (final column in metrics.columns) {
      final columnTotalWidth = column.width + space;
      final currentColumnX = nextColumnX - columnTotalWidth;

      if (column.items.isNotEmpty) {
        var dy = 0.0;
        for (final item in column.items) {
          final dx = currentColumnX + space + (column.width - item.width) / 2;
          item.paint(canvas, Offset(dx, dy));
          dy += item.height;
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
