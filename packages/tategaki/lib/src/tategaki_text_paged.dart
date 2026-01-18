import 'package:flutter/widgets.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/tategaki_painter.dart';

/// 縦書きテキストをページ送りで表示するウィジェット
class TategakiTextPaged extends StatelessWidget {
  /// コンストラクタ
  const TategakiTextPaged(
    this.elements, {
    required this.width,
    required this.height,
    this.padding = EdgeInsets.zero,
    this.onPageChanged,
    this.controller,
    super.key,
  });

  /// 表示する要素のリスト
  final List<TategakiElement> elements;

  /// 表示領域の幅
  final double width;

  /// 表示領域の高さ
  final double height;

  /// パディング
  final EdgeInsets padding;

  /// ページ変更時のコールバック
  final ValueChanged<int>? onPageChanged;

  /// ページコントローラー
  final PageController? controller;

  @override
  Widget build(BuildContext context) {
    if (elements.isEmpty) {
      return const SizedBox.shrink();
    }

    final textStyle = DefaultTextStyle.of(context).style;

    // 1. 全体をレイアウト計算して列を取得
    // 上下パディングを引いた高さで計算
    final availableHeight = height - padding.vertical;
    final metrics = TategakiLayout.calculate(
      elements: elements,
      maxHeight: availableHeight,
      textStyle: textStyle,
    );

    // 2. ページ分割
    // 左右パディングを引いた幅で分割
    final availableWidth = width - padding.horizontal;
    final pages = TategakiLayout.partition(
      columns: metrics.columns,
      maxWidth: availableWidth,
      height: availableHeight,
    );

    if (pages.isEmpty) {
      return const SizedBox.shrink();
    }

    // 縦書きの本のように右から左へ読み進めるため RTL を指定
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PageView.builder(
        controller: controller,
        onPageChanged: onPageChanged,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final pageMetrics = pages[index];

          return Padding(
            padding: padding,
            child: CustomPaint(
              size: Size(availableWidth, availableHeight),
              painter: TategakiPainter(metrics: pageMetrics),
            ),
          );
        },
      ),
    );
  }
}
