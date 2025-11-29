import 'package:flutter/widgets.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/tategaki_painter.dart';

/// 縦書きテキストを表示するウィジェット
class TategakiText extends StatelessWidget {
  /// コンストラクタ
  const TategakiText(
    this.elements, {
    required this.height,
    super.key,
  });

  /// 表示する要素のリスト
  final List<TategakiElement> elements;

  /// 列の高さ（必須）
  final double height;

  @override
  Widget build(BuildContext context) {
    if (elements.isEmpty) {
      return const SizedBox.shrink();
    }

    final textStyle = DefaultTextStyle.of(context).style;

    final metrics = TategakiLayout.calculate(
      elements: elements,
      maxHeight: height,
      textStyle: textStyle,
    );

    return CustomPaint(
      size: metrics.size,
      painter: TategakiPainter(metrics: metrics),
    );
  }
}
