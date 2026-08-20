import 'package:flutter/widgets.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/tategaki_painter.dart';

/// 縦書きテキストを表示するウィジェット
class TategakiText extends StatefulWidget {
  /// コンストラクタ
  const TategakiText(
    this.elements, {
    required this.height,
    super.key,
  });

  /// 表示する要素のリスト
  ///
  /// レイアウト計算をキャッシュするため、リストは同じ内容なら同じ
  /// インスタンスを渡すこと（内容を書き換える場合は新しいリストを渡す）。
  final List<TategakiElement> elements;

  /// 列の高さ（必須）
  final double height;

  @override
  State<TategakiText> createState() => _TategakiTextState();
}

class _TategakiTextState extends State<TategakiText> {
  /// 最後にレイアウト計算した入力値（再計算が必要かの判定用）
  List<TategakiElement>? _cachedElements;
  double? _cachedHeight;
  TextStyle? _cachedTextStyle;

  /// キャッシュしたレイアウト結果
  TategakiMetrics? _cachedMetrics;

  @override
  Widget build(BuildContext context) {
    if (widget.elements.isEmpty) {
      return const SizedBox.shrink();
    }

    final textStyle = DefaultTextStyle.of(context).style;

    // 入力値が変わっていない場合はキャッシュを再利用して
    // 再ビルドごとの重いレイアウト計算を回避する
    if (_cachedMetrics == null ||
        !identical(_cachedElements, widget.elements) ||
        _cachedHeight != widget.height ||
        _cachedTextStyle != textStyle) {
      _cachedElements = widget.elements;
      _cachedHeight = widget.height;
      _cachedTextStyle = textStyle;
      _cachedMetrics = TategakiLayout.calculate(
        elements: widget.elements,
        maxHeight: widget.height,
        textStyle: textStyle,
      );
    }

    return CustomPaint(
      size: _cachedMetrics!.size,
      painter: TategakiPainter(metrics: _cachedMetrics!),
    );
  }
}
