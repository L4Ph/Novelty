import 'dart:ui';

/// 描画可能な要素の基底クラス
abstract class Paintable {
  /// 要素の高さ
  double get height;

  /// 要素の幅（ベース + ルビを含む全体幅）
  double get width;

  /// ベーステキストの幅
  double get baseWidth => width;

  /// ルビテキストの幅
  double get rubyWidth => 0;

  /// ルビ付きテキストかどうか
  bool get isRuby => false;

  /// Canvasに描画する
  void paint(Canvas canvas, Offset offset);
}
