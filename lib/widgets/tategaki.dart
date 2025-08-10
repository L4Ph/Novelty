import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/utils/vertical_rotated.dart';

abstract class _Paintable {
  double get height;
  double get width;
  void paint(Canvas canvas, Offset offset);
  
  /// ルビ付きテキストかどうかを判定
  bool get isRuby => false;
  
  /// ベーステキストの幅（ルビ付きテキストのみ）
  double get baseWidth => width;
  
  /// ルビテキストの幅（ルビ付きテキストのみ）
  double get rubyWidth => 0;
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
    this._baseWidth,
    this._rubyWidth,
    this.rubyHeight,
  );
  final List<TextPainter> basePainters;
  final List<TextPainter> rubyPainters;
  final double _baseWidth;
  final double _rubyWidth;
  final double rubyHeight;

  @override
  double get height => basePainters.fold(0, (prev, p) => prev + p.height);

  @override
  double get width => _baseWidth + _rubyWidth;
  
  @override
  bool get isRuby => true;
  
  @override
  double get baseWidth => _baseWidth;
  
  @override
  double get rubyWidth => _rubyWidth;

  @override
  void paint(Canvas canvas, Offset offset) {
    var baseDy = offset.dy;
    for (final p in basePainters) {
      // ベーステキストを左寄せで配置（通常の文字位置と同じ）
      final charDx = offset.dx + (_baseWidth - p.width) / 2;
      p.paint(canvas, Offset(charDx, baseDy));
      baseDy += p.height;
    }

    var rubyDy = offset.dy + (height - rubyHeight) / 2;
    for (final p in rubyPainters) {
      // ルビテキストをベーステキストの右側に配置
      final charDx = offset.dx + _baseWidth + (_rubyWidth - p.width) / 2;
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
class Tategaki extends HookWidget {
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
  Widget build(BuildContext context) {
    // テキストスタイルの計算をメモ化
    final effectiveTextStyle = useMemoized(() {
      return style ?? DefaultTextStyle.of(context).style;
    }, [style, DefaultTextStyle.of(context).style]);

    // ルビテキストスタイルの計算をメモ化
    final rubyTextStyle = useMemoized(() {
      return effectiveTextStyle.copyWith(
        fontSize: (effectiveTextStyle.fontSize ?? 14) * 0.6,
      );
    }, [effectiveTextStyle]);

    // メトリクス計算をメモ化
    final metrics = useMemoized(() {
      return _calculateMetrics(effectiveTextStyle, rubyTextStyle);
    }, [content, effectiveTextStyle, rubyTextStyle, space, maxHeight]);

    if (content.isEmpty || metrics == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      size: metrics.size,
      painter: _TategakiPainter(
        metrics: metrics,
        space: space,
      ),
    );
  }

  /// メトリクスを計算する
  _TategakiMetrics? _calculateMetrics(
    TextStyle effectiveTextStyle,
    TextStyle rubyTextStyle,
  ) {
    final columns = <_TategakiColumn>[];
    var totalWidth = 0.0;

    var currentColumnItems = <_Paintable>[];
    var currentColumnHeight = 0.0;
    var currentColumnWidth = 0.0;

    void endColumn() {
      if (currentColumnItems.isNotEmpty) {
        final column = _TategakiColumn(currentColumnItems, currentColumnWidth);
        columns.add(column);
        totalWidth += column.width + space;
      }
      currentColumnItems = [];
      currentColumnHeight = 0.0;
      currentColumnWidth = 0.0;
    }

    void addToColumn(_Paintable item) {
      if (currentColumnHeight + item.height > maxHeight &&
          currentColumnItems.isNotEmpty) {
        endColumn();
      }
      currentColumnItems.add(item);
      currentColumnHeight += item.height;
      if (item.width > currentColumnWidth) {
        currentColumnWidth = item.width;
      }
    }

    for (final element in content) {
      switch (element) {
        case PlainText():
          for (final char in element.text.runes) {
            final character = String.fromCharCode(char);
            final rotatedChar = VerticalRotated.map[character] ?? character;
            final painter = TextPainter(
              text: TextSpan(text: rotatedChar, style: effectiveTextStyle),
              textDirection: TextDirection.ltr,
            )..layout();
            addToColumn(_PaintableChar(painter));
          }
        case RubyText():
          final item = _createRubyItem(element, effectiveTextStyle, rubyTextStyle);
          addToColumn(item);
        case NewLine():
          endColumn();
          columns.add(_TategakiColumn([], 0));
          totalWidth += space;
      }
    }
    if (currentColumnItems.isNotEmpty) {
      endColumn();
    }

    return _TategakiMetrics(
      columns: columns,
      size: Size(totalWidth, maxHeight),
    );
  }

  /// ルビアイテムを作成する
  _PaintableRuby _createRubyItem(
    RubyText element,
    TextStyle effectiveTextStyle,
    TextStyle rubyTextStyle,
  ) {
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

    return _PaintableRuby(
      basePainters,
      rubyPainters,
      baseWidth,
      rubyWidth,
      rubyHeight,
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
          final dx = item.isRuby
              // ルビ付きテキストの場合、ベーステキストが通常位置に来るように調整
              ? currentColumnX + space + (column.width - item.baseWidth) / 2 - item.rubyWidth
              // 通常テキストの場合、中央寄せ
              : currentColumnX + space + (column.width - item.width) / 2;
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
