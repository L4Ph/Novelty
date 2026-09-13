import 'package:flutter/rendering.dart';

import 'package:tategaki/src/layout/column.dart';

/// 縦書きの1列を描画する CustomPainter
///
/// 列ごとに独立した Canvas（幅 = column.width、高さ = maxHeight）に、
/// 配置済みアイテムを座標どおりに描画する。
class TategakiColumnPainter extends CustomPainter {
  /// コンストラクタ
  const TategakiColumnPainter({
    required this.column,
  });

  /// 描画対象の列
  final TategakiColumn column;

  @override
  void paint(Canvas canvas, Size size) {
    for (final placed in column.placedItems) {
      placed.item.paintable.paint(
        canvas,
        Offset(placed.blockOffset, placed.inlineOffset),
      );
    }
  }

  @override
  bool shouldRepaint(covariant TategakiColumnPainter oldDelegate) {
    return oldDelegate.column != column;
  }
}
