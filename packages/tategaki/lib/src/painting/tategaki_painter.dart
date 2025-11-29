import 'package:flutter/rendering.dart';

import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';

/// 縦書きテキストを描画するCustomPainter
class TategakiPainter extends CustomPainter {
  /// コンストラクタ
  const TategakiPainter({
    required this.metrics,
  });

  /// レイアウトメトリクス
  final TategakiMetrics metrics;

  @override
  void paint(Canvas canvas, Size size) {
    var nextColumnX = size.width;

    for (final column in metrics.columns) {
      final columnTotalWidth = column.width + TategakiLayout.columnSpacing;
      final currentColumnX = nextColumnX - columnTotalWidth;

      if (column.items.isNotEmpty) {
        var dy = 0.0;
        for (final item in column.items) {
          // ベース文字が column.baseWidth の中で中央に来るように dx を計算
          final dx = currentColumnX +
              TategakiLayout.columnSpacing +
              (column.baseWidth - item.baseWidth) / 2;
          item.paint(canvas, Offset(dx, dy));
          dy += item.height;
        }
      }
      nextColumnX = currentColumnX;
    }
  }

  @override
  bool shouldRepaint(covariant TategakiPainter oldDelegate) {
    return metrics != oldDelegate.metrics;
  }
}
