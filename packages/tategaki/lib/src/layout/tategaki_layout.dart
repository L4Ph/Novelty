import 'package:flutter/painting.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/tategaki_column_engine.dart';

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
  ///
  /// [TategakiColumnEngine] に委譲し、列単位の遅延生成・メモ化を利用する。
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

    final engine = TategakiColumnEngine(
      elements: elements,
      maxHeight: maxHeight,
      textStyle: textStyle,
    );
    final columns = engine.computeAll();

    return TategakiMetrics(
      columns: columns,
      size: Size(calculateTotalWidth(columns), maxHeight),
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
}
