import 'package:flutter/painting.dart';
import 'package:tategaki/src/painting/paintable.dart';

/// 複数の文字を縦に並べて一度に描画する要素
class PaintableColumnText extends Paintable {
  /// コンストラクタ
  PaintableColumnText(this.painter);

  /// テキストペインター（内部に \n を含む想定）
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
