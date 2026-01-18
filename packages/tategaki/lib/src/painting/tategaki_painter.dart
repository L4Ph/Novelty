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
    // クリップ領域（可視領域）を取得
    // 親ウィジェット（SingleChildScrollViewなど）がクリップしていない場合は
    // Rect.largestなどが返るため、常に描画される（安全）
    final clipRect = canvas.getLocalClipBounds();

    // コンテンツ幅がキャンバス幅より小さい場合、中央揃えにする
    final contentWidth = metrics.size.width;
    final horizontalPadding = (size.width - contentWidth) / 2;

    // 右端の開始位置
    // 通常は size.width だが、中央揃えの場合は右側に padding 分の余白ができる
    // つまり size.width - horizontalPadding
    // コンテンツ幅の方が大きい場合（スクロール時など）は通常通り size.width から開始
    var nextColumnX =
        size.width - (horizontalPadding > 0 ? horizontalPadding : 0);

    for (var i = 0; i < metrics.columns.length; i++) {
      final column = metrics.columns[i];
      // 最初の列はスペースなし、2列目以降はスペースあり
      final spacing = i == 0 ? 0.0 : TategakiLayout.columnSpacing;
      final columnTotalWidth = spacing + column.width;
      final currentColumnX = nextColumnX - columnTotalWidth;

      // 描画最適化: 列が可視領域に含まれているか判定
      // Tategakiは右から左へ並ぶため
      // 列の描画範囲: Left = currentColumnX, Right = nextColumnX
      final columnRect = Rect.fromLTRB(
        currentColumnX,
        0, // 上端
        nextColumnX,
        size.height, // 下端
      );

      // overlapsは境界線上も含むため安全
      if (!clipRect.overlaps(columnRect)) {
        nextColumnX = currentColumnX;
        continue;
      }

      if (column.items.isNotEmpty) {
        var dy = 0.0;
        for (final item in column.items) {
          // ベース文字が column.baseWidth の中で中央に来るように dx を計算
          // 列は currentColumnX から始まり、その右側にスペースがある
          final dx = currentColumnX + (column.baseWidth - item.baseWidth) / 2;
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
