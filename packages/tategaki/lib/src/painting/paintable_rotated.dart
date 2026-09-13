import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:tategaki/src/painting/paintable.dart';

/// 回転（縦向き）して描画する要素
///
/// JLREQ §3.2.3 方法2（時計回りに90度回転）に対応する。数字トークンや
/// 欧文ランを横書きのまま測定し、配置時に時計回りに90度回転する。
class PaintableRotated extends Paintable {
  /// コンストラクタ
  PaintableRotated(this.painter);

  /// 横書きでレイアウト済みのテキストペインター
  final TextPainter painter;

  /// テキスト内容
  String get text => painter.text?.toPlainText() ?? '';

  /// インライン方向（縦）の送り幅 = 横書き時の幅
  @override
  double get height => painter.width;

  /// ブロック方向（横）の幅 = 横書き時の高さ（行送り）
  @override
  double get width => painter.height;

  /// 中央寄せの基準幅
  @override
  double get baseWidth => painter.height;

  @override
  void paint(Canvas canvas, Offset offset) {
    canvas
      ..save()
      ..translate(offset.dx + width, offset.dy)
      // 時計回りに90度回転
      ..rotate(math.pi / 2);
    painter.paint(canvas, Offset.zero);
    canvas.restore();
  }
}
