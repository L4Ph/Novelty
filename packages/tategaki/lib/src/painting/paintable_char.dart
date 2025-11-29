import 'package:flutter/painting.dart';

import 'package:tategaki/src/painting/paintable.dart';

/// 単一文字の描画要素
class PaintableChar extends Paintable {
  /// コンストラクタ
  PaintableChar(this.painter);

  /// テキストペインター
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
