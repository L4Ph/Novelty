import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:tategaki/src/painting/paintable.dart';

/// 傍点（圏点）付きテキストの描画要素
///
/// 縦組みでは各親文字の右側に点を配置する（JLREQ §3.3.9）。
class PaintableKenten extends Paintable {
  /// コンストラクタ
  PaintableKenten({
    required this.basePainters,
    required this.markPainter,
    required this.charAdvance,
  });

  /// 親文字のペインターリスト（1文字ずつ）
  final List<TextPainter> basePainters;

  /// 点のペインター
  final TextPainter markPainter;

  /// 1文字分の字送り
  final double charAdvance;

  double get _baseWidth =>
      basePainters.fold<double>(0, (m, p) => math.max(m, p.width));

  @override
  double get height => charAdvance * basePainters.length;

  @override
  double get width => _baseWidth + markPainter.width;

  @override
  double get baseWidth => _baseWidth;

  @override
  void paint(Canvas canvas, Offset offset) {
    var dy = offset.dy;
    for (final p in basePainters) {
      // 親文字をセル中央に配置
      final dx = offset.dx + (_baseWidth - p.width) / 2;
      p.paint(canvas, Offset(dx, dy));

      // 点を親文字の右側・セル中央に配置
      final markDx = dx + p.width;
      final markDy = dy + (charAdvance - markPainter.height) / 2;
      markPainter.paint(canvas, Offset(markDx, markDy));

      dy += charAdvance;
    }
  }
}
