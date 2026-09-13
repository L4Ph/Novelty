import 'package:flutter/painting.dart';

import 'package:tategaki/src/layout/tategaki_measurer.dart';
import 'package:tategaki/src/painting/paintable.dart';

/// 列内に配置された要素（計測結果＋インライン位置）
class TategakiPlacedItem {
  /// コンストラクタ
  const TategakiPlacedItem({
    required this.item,
    required this.inlineOffset,
    required this.blockOffset,
  });

  /// 計測済みの要素
  final TategakiMeasuredItem item;

  /// インライン方向（縦）の開始位置
  final double inlineOffset;

  /// ブロック方向（横）の開始位置
  final double blockOffset;

  /// 計測結果を複製して位置を差し替えたものを返す
  TategakiPlacedItem copyWith({double? inlineOffset, double? blockOffset}) {
    return TategakiPlacedItem(
      item: item,
      inlineOffset: inlineOffset ?? this.inlineOffset,
      blockOffset: blockOffset ?? this.blockOffset,
    );
  }
}

/// 縦書きの1列を表すクラス
class TategakiColumn {
  /// コンストラクタ
  TategakiColumn({
    required this.placedItems,
    required this.width,
    required this.baseWidth,
  });

  /// 配置済みの要素
  final List<TategakiPlacedItem> placedItems;

  /// 列の総幅（ルビなどのオーバーハングを含む）
  final double width;

  /// ベーステキストの基準幅（行送り）
  final double baseWidth;

  /// 描画要素のリスト（配置順）
  List<Paintable> get items =>
      [for (final p in placedItems) p.item.paintable];

  /// 内容が空かどうか
  bool get isEmpty => placedItems.isEmpty;
}

/// レイアウト計算結果のメトリクス
class TategakiMetrics {
  /// コンストラクタ
  const TategakiMetrics({
    required this.columns,
    required this.size,
  });

  /// 列のリスト
  final List<TategakiColumn> columns;

  /// 全体のサイズ
  final Size size;
}
