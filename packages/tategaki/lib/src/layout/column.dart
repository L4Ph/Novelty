import 'package:flutter/painting.dart';

import 'package:tategaki/src/painting/paintable.dart';
import 'package:tategaki/src/painting/paintable_column_text.dart';

/// 列内の内容スロット
///
/// レイアウト計算時は文字の構造だけを持ち、描画時に [TategakiColumn.items]
/// が初めて TextPainter を生成する（遅延マテリアライズ）。
sealed class TategakiColumnSlot {
  const TategakiColumnSlot();
}

/// 連続する通常文字（\n 区切りのテキスト）
class TategakiCharRun extends TategakiColumnSlot {
  /// コンストラクタ
  const TategakiCharRun(this.text);

  /// 各行 = 1文字の \n 区切りテキスト
  final String text;
}

/// キャッシュ済みのインライン要素（縦中横・ルビ）
class TategakiInlineItem extends TategakiColumnSlot {
  /// コンストラクタ
  const TategakiInlineItem(this.item);

  /// 描画要素（TextPainter 保持）
  final Paintable item;
}

/// 縦書きの1列を表すクラス
class TategakiColumn {
  /// コンストラクタ
  TategakiColumn({
    required List<TategakiColumnSlot> slots,
    required this.width,
    required this.baseWidth,
    required TextStyle textStyle,
  }) : _slots = slots,
       _textStyle = textStyle;

  /// 内容スロット（未マテリアライズ）
  final List<TategakiColumnSlot> _slots;

  /// 描画用 TextPainter の生成に使うスタイル
  final TextStyle _textStyle;

  /// 列の総幅（ベース + ルビを含む）
  final double width;

  /// ベーステキストの最大幅
  final double baseWidth;

  List<Paintable>? _items;

  /// 描画要素リスト（初回アクセス時にマテリアライズされる）
  ///
  /// 未表示の列はこの getter が呼ばれないため、TextPainter は
  /// 描画する列の分だけしか生成されない。
  List<Paintable> get items => _items ??= _materialize();

  List<Paintable> _materialize() {
    final result = <Paintable>[];
    for (final slot in _slots) {
      switch (slot) {
        case TategakiCharRun(:final text):
          result.add(
            PaintableColumnText(
              TextPainter(
                text: TextSpan(text: text, style: _textStyle),
                textDirection: TextDirection.ltr,
              )..layout(),
            ),
          );
        case TategakiInlineItem(:final item):
          result.add(item);
      }
    }
    return result;
  }
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
