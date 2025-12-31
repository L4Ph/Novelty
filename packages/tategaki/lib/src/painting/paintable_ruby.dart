import 'package:flutter/painting.dart';
import 'package:tategaki/src/painting/paintable.dart';

/// ルビ付きテキストの描画要素
class PaintableRuby extends Paintable {
  /// コンストラクタ
  PaintableRuby({
    required this.basePainters,
    required this.rubyPainters,
    required double baseWidth,
    required double rubyWidth,
    required this.rubyHeight,
  }) : _baseWidth = baseWidth,
       _rubyWidth = rubyWidth;

  /// ベーステキストのペインターリスト
  final List<TextPainter> basePainters;

  /// ルビテキストのペインターリスト
  final List<TextPainter> rubyPainters;

  final double _baseWidth;
  final double _rubyWidth;

  /// ルビテキストの高さ
  final double rubyHeight;

  @override
  double get height {
    final baseHeight = basePainters.fold<double>(
      0,
      (prev, p) => prev + p.height,
    );
    return baseHeight > rubyHeight ? baseHeight : rubyHeight;
  }

  @override
  double get width => _baseWidth + _rubyWidth;

  @override
  double get baseWidth => _baseWidth;

  @override
  double get rubyWidth => _rubyWidth;

  @override
  bool get isRuby => true;

  @override
  void paint(Canvas canvas, Offset offset) {
    final baseTotalHeight = basePainters.fold<double>(
      0,
      (prev, p) => prev + p.height,
    );

    // ベーステキストを描画 (高さの中央に配置)
    var baseDy = offset.dy + (height - baseTotalHeight) / 2;
    for (final p in basePainters) {
      final charDx = offset.dx + (_baseWidth - p.width) / 2;
      p.paint(canvas, Offset(charDx, baseDy));
      baseDy += p.height;
    }

    // ルビテキストをベーステキストの右側に描画 (高さの中央に配置)
    var rubyDy = offset.dy + (height - rubyHeight) / 2;
    for (final p in rubyPainters) {
      final charDx = offset.dx + _baseWidth + (_rubyWidth - p.width) / 2;
      p.paint(canvas, Offset(charDx, rubyDy));
      rubyDy += p.height;
    }
  }
}
