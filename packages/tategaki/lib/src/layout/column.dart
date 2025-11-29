import 'dart:ui' show Size;

import 'package:tategaki/src/painting/paintable.dart';

/// 縦書きの1列を表すクラス
class TategakiColumn {
  /// コンストラクタ
  const TategakiColumn({
    required this.items,
    required this.width,
    required this.baseWidth,
  });

  /// 列内の描画要素リスト
  final List<Paintable> items;

  /// 列の総幅（ベース + ルビを含む）
  final double width;

  /// ベーステキストの最大幅
  final double baseWidth;
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
