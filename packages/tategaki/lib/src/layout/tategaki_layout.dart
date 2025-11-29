import 'package:flutter/painting.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/painting/paintable.dart';
import 'package:tategaki/src/painting/paintable_char.dart';
import 'package:tategaki/src/painting/paintable_ruby.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';
import 'package:tategaki/src/utils/glyph_mapper.dart';

/// 縦書きレイアウトを計算するクラス
class TategakiLayout {
  TategakiLayout._();

  /// 列間のスペース
  static const double columnSpacing = 12;

  /// ルビのフォントサイズ比率
  static const double rubyScale = 0.6;

  /// 要素リストからレイアウトを計算する
  static TategakiMetrics calculate({
    required List<TategakiElement> elements,
    required double maxHeight,
    required TextStyle textStyle,
  }) {
    if (elements.isEmpty) {
      return const TategakiMetrics(
        columns: [],
        size: Size.zero,
      );
    }

    final rubyStyle = textStyle.copyWith(
      fontSize: (textStyle.fontSize ?? 14) * rubyScale,
    );

    final columns = <TategakiColumn>[];
    var totalWidth = 0.0;

    var currentColumnItems = <Paintable>[];
    var currentColumnHeight = 0.0;
    var currentColumnBaseWidth = 0.0;

    void endColumn() {
      if (currentColumnItems.isNotEmpty) {
        var requiredWidth = currentColumnBaseWidth;
        for (final item in currentColumnItems) {
          final baseOffset = (currentColumnBaseWidth - item.baseWidth) / 2;
          final itemTotalWidth = baseOffset + item.width;
          if (itemTotalWidth > requiredWidth) {
            requiredWidth = itemTotalWidth;
          }
        }

        final column = TategakiColumn(
          items: currentColumnItems,
          width: requiredWidth,
          baseWidth: currentColumnBaseWidth,
        );
        columns.add(column);
        totalWidth += column.width + columnSpacing;
      }
      currentColumnItems = [];
      currentColumnHeight = 0.0;
      currentColumnBaseWidth = 0.0;
    }

    void addToColumn(Paintable item) {
      if (currentColumnHeight + item.height > maxHeight &&
          currentColumnItems.isNotEmpty) {
        endColumn();
      }
      currentColumnItems.add(item);
      currentColumnHeight += item.height;
      if (item.baseWidth > currentColumnBaseWidth) {
        currentColumnBaseWidth = item.baseWidth;
      }
    }

    for (final element in elements) {
      switch (element) {
        case TategakiChar(:final char):
          final painter = TextPainter(
            text: TextSpan(text: char, style: textStyle),
            textDirection: TextDirection.ltr,
          )..layout();
          addToColumn(PaintableChar(painter));

        case TategakiTcy(:final text):
          final painter = TextPainter(
            text: TextSpan(text: text, style: textStyle),
            textDirection: TextDirection.ltr,
          )..layout();
          addToColumn(PaintableTcy(painter));

        case TategakiRuby(:final base, :final ruby):
          final item = _createRubyItem(base, ruby, textStyle, rubyStyle);
          addToColumn(item);

        case TategakiNewLine():
          endColumn();
          columns.add(const TategakiColumn(items: [], width: 0, baseWidth: 0));
          totalWidth += columnSpacing;
      }
    }

    if (currentColumnItems.isNotEmpty) {
      endColumn();
    }

    return TategakiMetrics(
      columns: columns,
      size: Size(totalWidth, maxHeight),
    );
  }

  /// ルビ付きテキストの描画要素を作成する
  static PaintableRuby _createRubyItem(
    String base,
    String ruby,
    TextStyle textStyle,
    TextStyle rubyStyle,
  ) {
    final basePainters = <TextPainter>[];
    var baseWidth = 0.0;

    for (final char in base.runes) {
      final character = String.fromCharCode(char);
      final mappedChar = GlyphMapper.map(character);
      final painter = TextPainter(
        text: TextSpan(text: mappedChar, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      basePainters.add(painter);
      if (painter.width > baseWidth) {
        baseWidth = painter.width;
      }
    }

    final rubyPainters = <TextPainter>[];
    var rubyWidth = 0.0;
    var rubyHeight = 0.0;

    for (final char in ruby.runes) {
      final character = String.fromCharCode(char);
      final mappedChar = GlyphMapper.map(character);
      final painter = TextPainter(
        text: TextSpan(text: mappedChar, style: rubyStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      rubyPainters.add(painter);
      rubyHeight += painter.height;
      if (painter.width > rubyWidth) {
        rubyWidth = painter.width;
      }
    }

    return PaintableRuby(
      basePainters: basePainters,
      rubyPainters: rubyPainters,
      baseWidth: baseWidth,
      rubyWidth: rubyWidth,
      rubyHeight: rubyHeight,
    );
  }
}
