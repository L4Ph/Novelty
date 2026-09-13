import 'package:flutter/painting.dart';
import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/painting/paintable.dart';

/// ルビの割り付け方式（JLREQ §3.3）
enum RubyLayoutMode {
  /// モノルビ（親文字1字）
  mono,

  /// グループルビ（熟語全体に1つのルビ）
  group,

  /// 熟語ルビ（親文字1字ずつに対応）
  jukugo,
}

/// ルビ付きテキストの描画要素（縦組み）
class PaintableRuby extends Paintable {
  /// コンストラクタ
  PaintableRuby({
    required this.basePainters,
    required this.rubyPainters,
    required this.baseAdvance,
    required this.rubyAdvance,
    required double baseWidth,
    required double rubyWidth,
    required this.mode,
    required this.align,
  }) : _baseWidth = baseWidth,
       _rubyWidth = rubyWidth;

  /// 親文字のペインターリスト（1文字ずつ）
  final List<TextPainter> basePainters;

  /// ルビ文字のペインターリスト（1文字ずつ）
  final List<TextPainter> rubyPainters;

  /// 親文字1文字分の字送り
  final double baseAdvance;

  /// ルビ文字1文字分の字送り
  final double rubyAdvance;

  /// 割り付け方式
  final RubyLayoutMode mode;

  /// 指定された割り付け（auto 以外で使用）
  final TategakiRubyAlign align;

  final double _baseWidth;
  final double _rubyWidth;

  @override
  double get height => baseAdvance * basePainters.length;

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
    // 親文字を縦に積む（ベース幅の中央に配置）
    var dy = offset.dy;
    for (final painter in basePainters) {
      final dx = offset.dx + (_baseWidth - painter.width) / 2;
      painter.paint(canvas, Offset(dx, dy));
      dy += baseAdvance;
    }

    if (rubyPainters.isEmpty) {
      return;
    }

    if (mode == RubyLayoutMode.jukugo) {
      _paintJukugo(canvas, offset);
      return;
    }

    final (start, gap) = _distribution();
    var rubyDy = offset.dy + start;
    for (final painter in rubyPainters) {
      final dx = offset.dx + _baseWidth + (_rubyWidth - painter.width) / 2;
      painter.paint(canvas, Offset(dx, rubyDy));
      rubyDy += rubyAdvance + gap;
    }
  }

  /// 熟語ルビ: 親文字1字ずつに対応させて中央に配置する
  void _paintJukugo(Canvas canvas, Offset offset) {
    for (var i = 0; i < rubyPainters.length; i++) {
      final painter = rubyPainters[i];
      final dx = offset.dx + _baseWidth + (_rubyWidth - painter.width) / 2;
      final cellTop = offset.dy + i * baseAdvance;
      final dy = cellTop + (baseAdvance - rubyAdvance) / 2;
      painter.paint(canvas, Offset(dx, dy));
    }
  }

  /// 開始位置とルビ文字間の空きを返す
  (double, double) _distribution() {
    final rubyCount = rubyPainters.length;
    final baseInline = baseAdvance * basePainters.length;
    final rubyInline = rubyAdvance * rubyCount;
    final extra = baseInline - rubyInline;

    switch (align) {
      case TategakiRubyAlign.justify:
        if (rubyCount <= 1) {
          return (extra / 2, 0);
        }
        return (0, extra / (rubyCount - 1));
      case TategakiRubyAlign.center:
        return (extra / 2, 0);
      case TategakiRubyAlign.jis:
      case TategakiRubyAlign.auto:
        break;
    }

    switch (mode) {
      case RubyLayoutMode.mono:
        return (extra / 2, 0);
      case RubyLayoutMode.group:
        // JIS X 4051 の 2:1 配分（先頭・末尾 : 文字間 = 1 : 2）
        if (rubyCount <= 1) {
          return (extra / 2, 0);
        }
        final unit = extra / (rubyCount * 2);
        return (unit, unit * 2);
      case RubyLayoutMode.jukugo:
        return (0, 0);
    }
  }
}
