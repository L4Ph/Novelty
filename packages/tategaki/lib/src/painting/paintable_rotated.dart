import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:tategaki/src/painting/paintable.dart';

/// 回転（縦向き）して描画する要素
///
/// JLREQ §3.2.3 方法2（時計回りに90度回転）に対応する。数字トークンや
/// 欧文ランを横書きのまま測定し、配置時に時計回りに90度回転する。
/// 分割不可トークンが列高を超える場合は [scale] で縮小して収める。
class PaintableRotated extends Paintable {
  /// コンストラクタ
  PaintableRotated(this.painter, {this.scale = 1.0});

  /// 横書きでレイアウト済みのテキストペインター
  final TextPainter painter;

  /// 列高に収めるための縮小率
  final double scale;

  /// テキスト内容
  String get text => painter.text?.toPlainText() ?? '';

  /// インライン方向（縦）の送り幅 = 横書き時の幅 × 縮小率
  @override
  double get height => painter.width * scale;

  /// ブロック方向（横）の幅 = 横書き時の高さ × 縮小率
  @override
  double get width => painter.height * scale;

  /// 中央寄せの基準幅
  @override
  double get baseWidth => painter.height * scale;

  @override
  void paint(Canvas canvas, Offset offset) {
    canvas
      ..save()
      ..translate(offset.dx + width, offset.dy)
      // 時計回りに90度回転
      ..rotate(math.pi / 2)
      ..scale(scale);
    painter.paint(canvas, Offset.zero);
    canvas.restore();
  }
}
