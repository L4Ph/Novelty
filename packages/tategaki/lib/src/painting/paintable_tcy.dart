import 'package:flutter/painting.dart';

import 'package:tategaki/src/painting/paintable.dart';

/// 縦中横（横書きで挿入する文字列）の描画要素
class PaintableTcy extends Paintable {
  /// コンストラクタ
  PaintableTcy(this.painter);

  /// テキストペインター（横書きでレイアウト済み）
  final TextPainter painter;

  @override
  double get height => painter.width; // 横幅が縦の高さになる

  @override
  double get width => painter.height; // 縦幅が横の幅になる

  @override
  void paint(Canvas canvas, Offset offset) {
    // 横書きのまま描画（回転しない）
    painter.paint(canvas, offset);
  }
}
