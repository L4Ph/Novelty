import 'package:flutter/painting.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/painting/paintable.dart';
import 'package:tategaki/src/painting/paintable_column_text.dart';
import 'package:tategaki/src/painting/paintable_ruby.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';
import 'package:tategaki/src/utils/glyph_mapper.dart';

/// 縦書きレイアウトを計算するクラス
class TategakiLayout {
  TategakiLayout._();

  /// 列間のスペース
  ///
  /// N列ある場合、スペースは N-1 個になる。
  /// 例: 2列の場合、totalWidth = column1.width + columnSpacing + column2.width
  static const double columnSpacing = 12;

  /// ルビのフォントサイズ比率
  static const double rubyScale = 0.6;

  /// 列リストの合計幅を計算する
  ///
  /// N列の場合、totalWidth = Σ(column.width) + columnSpacing × (N-1)
  static double calculateTotalWidth(List<TategakiColumn> columns) {
    if (columns.isEmpty) return 0;
    final columnsWidth = columns.fold<double>(0, (sum, c) => sum + c.width);
    final spacingWidth = columnSpacing * (columns.length - 1);
    return columnsWidth + spacingWidth;
  }

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

    // バッファリング用の変数
    var bufferedChars = <String>[];
    var bufferedHeight = 0.0;

    final measurementPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    void flushBuffer() {
      if (bufferedChars.isNotEmpty) {
        final text = bufferedChars.join('\n');
        final painter = TextPainter(
          text: TextSpan(text: text, style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        currentColumnItems.add(PaintableColumnText(painter));
        bufferedChars = [];
        bufferedHeight = 0.0;
      }
    }

    void endColumn() {
      flushBuffer();
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

        // 2列目以降の場合のみスペースを加算
        if (columns.isNotEmpty) {
          totalWidth += columnSpacing;
        }
        columns.add(column);
        totalWidth += column.width;
      }
      currentColumnItems = [];
      currentColumnHeight = 0.0;
      currentColumnBaseWidth = 0.0;
    }

    void addToColumn(Paintable item) {
      flushBuffer();
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

    void addCharToColumn(String char) {
      measurementPainter
        ..text = TextSpan(text: char, style: textStyle)
        ..layout();
      final charHeight = measurementPainter.height;
      final charWidth = measurementPainter.width;

      if (currentColumnHeight + bufferedHeight + charHeight > maxHeight &&
          (currentColumnItems.isNotEmpty || bufferedChars.isNotEmpty)) {
        endColumn();
      }

      bufferedChars.add(char);
      bufferedHeight += charHeight;
      if (charWidth > currentColumnBaseWidth) {
        currentColumnBaseWidth = charWidth;
      }
    }

    for (final element in elements) {
      switch (element) {
        case TategakiChar(:final char):
          addCharToColumn(char);

        case TategakiTcy(:final text):
          currentColumnItems.add(
            PaintableTcy(
              TextPainter(
                text: TextSpan(text: text, style: textStyle),
                textDirection: TextDirection.ltr,
              )..layout(),
            ),
          );

        case TategakiRuby(:final base, :final ruby):
          final item = _createRubyItem(base, ruby, textStyle, rubyStyle);
          addToColumn(item);

        case TategakiNewLine():
          endColumn();
          // 改行で空の列を追加（スペースは列間に必要）
          if (columns.isNotEmpty) {
            totalWidth += columnSpacing;
          }
          columns.add(const TategakiColumn(items: [], width: 0, baseWidth: 0));
      }
    }

    if (currentColumnItems.isNotEmpty || bufferedChars.isNotEmpty) {
      endColumn();
    }

    return TategakiMetrics(
      columns: columns,
      size: Size(totalWidth, maxHeight),
    );
  }

  /// 列リストを指定された幅に収まるようにページ分割する
  static List<TategakiMetrics> partition({
    required List<TategakiColumn> columns,
    required double maxWidth,
    required double height,
  }) {
    final pages = <TategakiMetrics>[];
    var currentPageColumns = <TategakiColumn>[];
    var currentWidth = 0.0;

    void flushPage() {
      if (currentPageColumns.isNotEmpty) {
        pages.add(
          TategakiMetrics(
            columns: currentPageColumns,
            size: Size(currentWidth, height),
          ),
        );
      }
    }

    for (final column in columns) {
      // この列を追加した場合の幅を計算
      // 最初の列ならスペースなし、それ以降はスペースあり
      final spacing = currentPageColumns.isEmpty ? 0.0 : columnSpacing;
      final columnWidth = column.width;

      // 1列だけで幅を超えている場合は強制的に追加（無限ループ防止）
      // または、現在のページに収まるなら追加
      if (currentPageColumns.isEmpty ||
          (currentWidth + spacing + columnWidth <= maxWidth)) {
        currentPageColumns.add(column);
        currentWidth += spacing + columnWidth;
      } else {
        // 次のページへ
        flushPage();
        currentPageColumns = [column];
        currentWidth = columnWidth; // 新しいページの最初の列なのでスペースなし
      }
    }

    flushPage();

    return pages;
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
