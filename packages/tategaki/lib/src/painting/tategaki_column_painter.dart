import 'package:flutter/rendering.dart';

import 'package:tategaki/src/layout/column.dart';

/// 縦書きの1列を描画する CustomPainter
///
/// 列ごとに独立した Canvas（幅 = column.width、高さ = maxHeight）に
/// アイテムを縦に積み上げて描画する。
class TategakiColumnPainter extends CustomPainter {
  /// コンストラクタ
  const TategakiColumnPainter({
    required this.column,
  });

  /// 描画対象の列
  final TategakiColumn column;

  @override
  void paint(Canvas canvas, Size size) {
    var dy = 0.0;
    for (final item in column.items) {
      // ベース文字が column.baseWidth の中で中央に来るように dx を計算
      // （ルビなどのオーバーハングは右側へはみ出す）
      final dx = (column.baseWidth - item.baseWidth) / 2;
      item.paint(canvas, Offset(dx, dy));
      dy += item.height;
    }
  }

  @override
  bool shouldRepaint(covariant TategakiColumnPainter oldDelegate) {
    return oldDelegate.column != column;
  }
}
