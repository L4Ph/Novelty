import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/tategaki_char_class.dart';
import 'package:tategaki/src/painting/paintable.dart';
import 'package:tategaki/src/painting/paintable_column_text.dart';
import 'package:tategaki/src/painting/paintable_kenten.dart';
import 'package:tategaki/src/painting/paintable_rotated.dart';
import 'package:tategaki/src/painting/paintable_ruby.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';
import 'package:tategaki/src/utils/glyph_mapper.dart';

/// レイアウトに必要な計測結果と描画要素
class TategakiMeasuredItem {
  /// コンストラクタ
  TategakiMeasuredItem({
    required this.element,
    required this.advance,
    required this.baseExtent,
    required this.blockExtent,
    required this.firstClass,
    required this.lastClass,
    required Paintable Function() buildPaintable,
  }) : _buildPaintable = buildPaintable;

  /// 元の要素
  ///
  /// [TategakiMeasurer] のキャッシュヒット時は、渡されたインスタンスと
  /// 値は等しいが同一ではない代表インスタンスを指す場合がある。
  final TategakiElement element;

  /// インライン方向（縦）の字送り
  final double advance;

  /// ブロック方向（横）の基準幅（中央寄せに使う）
  final double baseExtent;

  /// ブロック方向の総幅（ルビ等のはみ出しを含む）
  final double blockExtent;

  /// 先頭文字のクラス
  final TategakiCharClass firstClass;

  /// 末尾文字のクラス
  final TategakiCharClass lastClass;

  final Paintable Function() _buildPaintable;

  /// 描画要素
  ///
  /// 生成は初回アクセス時まで遅延する。レイアウト時に全異なり要素分の
  /// [TextPainter] を生成すると、エピソードを開くだけで異なり文字数分の
  /// 計測が走るため。
  late final Paintable paintable = _buildPaintable();
}

/// 要素を計測し、字送り・前後幅・描画要素を生成する
///
/// 字送り（インライン方向）は `fontSize`（em）、行送り（ブロック方向）は
/// `fontSize × lineHeight` を基準にする（Q23: 軸の取り違えを修正）。
class TategakiMeasurer {
  /// コンストラクタ
  TategakiMeasurer(this.textStyle, {this.maxAdvance});

  /// 本文スタイル
  final TextStyle textStyle;

  /// 1要素が収まるべき最大の字送り（列高）。超える回転トークンは縮小する。
  final double? maxAdvance;

  /// 1文字分の字送り（em）
  late final double em = textStyle.fontSize ?? 16.0;

  /// 行送り（列幅の基準）
  late final double linePitch = em * (textStyle.height ?? 1.0);

  /// ルビ・傍点の文字サイズ比率
  static const double rubyScale = 0.5;

  /// テスト用: [TextPainter] を生成した回数
  ///
  /// 「レイアウト時は生成せず、描画時に遅延生成する」契約を検証する。
  @visibleForTesting
  static int debugPainterCreationCount = 0;

  final Map<TategakiElement, TategakiMeasuredItem> _cache = {};

  /// 縦書き用字形（`vert`）を有効にした描画用スタイル（Q17）
  ///
  /// 行高は 1.0 にする。ユーザーの行間設定は列幅（行送り）として反映済みで、
  /// セル内の行ボックスに行送りを含めると字面がセルからはみ出すため。
  late final TextStyle verticalStyle = textStyle.copyWith(
    height: 1,
    fontFeatures: [
      ...?textStyle.fontFeatures,
      const FontFeature('vert'),
    ],
  );

  /// 回転・縦中横の横書き描画用スタイル（行高 1.0、`vert` なし）
  late final TextStyle horizontalStyle = textStyle.copyWith(height: 1);

  /// 要素を計測する（同一要素はキャッシュ）
  TategakiMeasuredItem measure(TategakiElement element) {
    return _cache.putIfAbsent(element, () => _measure(element));
  }

  TextPainter _painter(String text, [TextStyle? style]) {
    debugPainterCreationCount++;
    return TextPainter(
      text: TextSpan(text: text, style: style ?? verticalStyle),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  final Map<String, double> _charExtentCache = {};

  /// 1文字のブロック方向の幅（列幅と中央寄せの基準）
  ///
  /// 全角文字は字面幅 = em として算術で求める。ここで [TextPainter] を
  /// 生成すると、レイアウト時に異なり文字数分の計測が走るため。
  /// 半角・ASCII など em とみなせない文字だけ実測し、文字ごとに再利用する。
  double _charExtent(String char) {
    final runes = char.runes;
    if (runes.length == 1 && _isFullWidth(runes.first)) {
      return em;
    }
    return _charExtentCache.putIfAbsent(char, () => _painter(char).width);
  }

  /// 字面幅が em になる Unicode 範囲かどうか
  static bool _isFullWidth(int code) {
    return (code >= 0x3000 && code <= 0x303F) || // 全角約物・和字間隔
        (code >= 0x3041 && code <= 0x30FF) || // かな・長音記号
        (code >= 0x3400 && code <= 0x4DBF) || // 拡張漢字A
        (code >= 0x4E00 && code <= 0x9FFF) || // 漢字
        (code >= 0xF900 && code <= 0xFAFF) || // 互換漢字
        (code >= 0xFE10 && code <= 0xFE4F) || // 縦書き変体
        (code >= 0xFF01 && code <= 0xFF60) || // 全角英数記号
        (code >= 0xFFE0 && code <= 0xFFE6) || // 全角記号
        (code >= 0x20000 && code <= 0x2FFFF); // 拡張漢字B以降
  }

  TategakiMeasuredItem _measure(TategakiElement element) {
    switch (element) {
      case TategakiChar(:final char):
        final charClass = TategakiCharClassifier.of(char);
        final extent = _charExtent(char);
        return TategakiMeasuredItem(
          element: element,
          advance: em,
          baseExtent: extent,
          blockExtent: extent,
          firstClass: charClass,
          lastClass: charClass,
          // 描画用の TextPainter は初回描画時まで生成しない
          buildPaintable: () => PaintableColumnText(_painter(char)),
        );
      case TategakiTcy(:final text):
        // 縦中横は横書きのまま描画するため vert を適用しない
        final painter = _painter(text, horizontalStyle);
        return TategakiMeasuredItem(
          element: element,
          advance: em,
          baseExtent: painter.width,
          blockExtent: painter.width,
          firstClass: TategakiCharClass.digit,
          lastClass: TategakiCharClass.digit,
          buildPaintable: () => PaintableTcy(painter),
        );
      case TategakiRotated(:final text):
        // 回転対象は横書き字形のまま計測する（vert を適用しない）
        final painter = _painter(text, horizontalStyle);
        // 列高を超える分割不可トークンは縮小して収める
        final limit = maxAdvance;
        final scale = (limit != null && painter.width > limit)
            ? limit / painter.width
            : 1.0;
        return TategakiMeasuredItem(
          element: element,
          advance: painter.width * scale,
          baseExtent: painter.height * scale,
          blockExtent: painter.height * scale,
          firstClass: TategakiCharClassifier.of(text[0]),
          lastClass: TategakiCharClassifier.of(text[text.length - 1]),
          buildPaintable: () => PaintableRotated(painter, scale: scale),
        );
      case TategakiRuby(:final base, :final ruby, :final align):
        return _measureRuby(element, base, ruby, align);
      case TategakiKenten(:final base, :final mark):
        return _measureKenten(element, base, mark);
      case TategakiNewLine():
        return TategakiMeasuredItem(
          element: element,
          advance: 0,
          baseExtent: 0,
          blockExtent: 0,
          firstClass: TategakiCharClass.others,
          lastClass: TategakiCharClass.others,
          buildPaintable: _EmptyPaintable.new,
        );
    }
  }

  TategakiMeasuredItem _measureRuby(
    TategakiElement element,
    String base,
    String ruby,
    TategakiRubyAlign align,
  ) {
    final baseRunes = base.runes.toList();
    final rubyRunes = ruby.runes.toList();
    final rubyStyle = verticalStyle.copyWith(fontSize: em * rubyScale);

    final basePainters = <TextPainter>[];
    var baseWidth = 0.0;
    for (final rune in baseRunes) {
      final painter = _painter(GlyphMapper.map(String.fromCharCode(rune)));
      basePainters.add(painter);
      baseWidth = math.max(baseWidth, painter.width);
    }

    final rubyPainters = <TextPainter>[];
    var rubyWidth = 0.0;
    for (final rune in rubyRunes) {
      final painter = _painter(
        GlyphMapper.map(String.fromCharCode(rune)),
        rubyStyle,
      );
      rubyPainters.add(painter);
      rubyWidth = math.max(rubyWidth, painter.width);
    }

    final mode = _rubyMode(baseRunes.length, rubyRunes.length, align);
    final rubyAdvance = em * rubyScale;

    return TategakiMeasuredItem(
      element: element,
      advance: em * baseRunes.length,
      baseExtent: baseWidth,
      blockExtent: baseWidth + rubyWidth,
      firstClass: TategakiCharClassifier.of(
        String.fromCharCode(baseRunes.first),
      ),
      lastClass: TategakiCharClassifier.of(
        String.fromCharCode(baseRunes.last),
      ),
      buildPaintable: () => PaintableRuby(
        basePainters: basePainters,
        rubyPainters: rubyPainters,
        baseAdvance: em,
        rubyAdvance: rubyAdvance,
        baseWidth: baseWidth,
        rubyWidth: rubyWidth,
        mode: mode,
        align: align,
      ),
    );
  }

  RubyLayoutMode _rubyMode(
    int baseCount,
    int rubyCount,
    TategakiRubyAlign align,
  ) {
    if (baseCount <= 1) {
      return RubyLayoutMode.mono;
    }
    if (baseCount == rubyCount) {
      return RubyLayoutMode.jukugo;
    }
    return RubyLayoutMode.group;
  }

  TategakiMeasuredItem _measureKenten(
    TategakiElement element,
    String base,
    String mark,
  ) {
    final baseRunes = base.runes.toList();
    final basePainters = <TextPainter>[];
    var baseWidth = 0.0;
    for (final rune in baseRunes) {
      final painter = _painter(GlyphMapper.map(String.fromCharCode(rune)));
      basePainters.add(painter);
      baseWidth = math.max(baseWidth, painter.width);
    }
    final markStyle = verticalStyle.copyWith(fontSize: em * rubyScale);
    final markPainter = _painter(mark, markStyle);

    return TategakiMeasuredItem(
      element: element,
      advance: em * baseRunes.length,
      baseExtent: baseWidth,
      blockExtent: baseWidth + markPainter.width,
      firstClass: TategakiCharClassifier.of(
        String.fromCharCode(baseRunes.first),
      ),
      lastClass: TategakiCharClassifier.of(
        String.fromCharCode(baseRunes.last),
      ),
      buildPaintable: () => PaintableKenten(
        basePainters: basePainters,
        markPainter: markPainter,
        charAdvance: em,
      ),
    );
  }
}

/// 改行など描画しない要素用の空 Paintable
class _EmptyPaintable extends Paintable {
  @override
  double get height => 0;

  @override
  double get width => 0;

  @override
  void paint(Canvas canvas, Offset offset) {}
}
