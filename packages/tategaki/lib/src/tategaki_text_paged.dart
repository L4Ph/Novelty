import 'package:flutter/widgets.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/tategaki_painter.dart';

/// 縦書きテキストをページ送りで表示するウィジェット
class TategakiTextPaged extends StatefulWidget {
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
  ///
  /// レイアウト計算をキャッシュするため、リストは同じ内容なら同じ
  /// インスタンスを渡すこと（内容を書き換える場合は新しいリストを渡す）。
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
  State<TategakiTextPaged> createState() => _TategakiTextPagedState();
}

class _TategakiTextPagedState extends State<TategakiTextPaged> {
  /// 最後にレイアウト計算した入力値（再計算が必要かの判定用）
  List<TategakiElement>? _cachedElements;
  double? _cachedWidth;
  double? _cachedHeight;
  EdgeInsets? _cachedPadding;
  TextStyle? _cachedTextStyle;

  /// キャッシュしたページ分割結果
  List<TategakiMetrics>? _cachedPages;

  @override
  Widget build(BuildContext context) {
    if (widget.elements.isEmpty) {
      return const SizedBox.shrink();
    }

    final textStyle = DefaultTextStyle.of(context).style;

    // 入力値が変わっていない場合はキャッシュを再利用して
    // ページ送り・再ビルドごとの重いレイアウト計算を回避する
    if (_cachedPages == null ||
        !identical(_cachedElements, widget.elements) ||
        _cachedHeight != widget.height ||
        _cachedWidth != widget.width ||
        _cachedPadding != widget.padding ||
        _cachedTextStyle != textStyle) {
      _cachedElements = widget.elements;
      _cachedHeight = widget.height;
      _cachedWidth = widget.width;
      _cachedPadding = widget.padding;
      _cachedTextStyle = textStyle;

      // 1. 全体をレイアウト計算して列を取得
      // 上下パディングを引いた高さで計算
      final availableHeight = widget.height - widget.padding.vertical;
      final metrics = TategakiLayout.calculate(
        elements: widget.elements,
        maxHeight: availableHeight,
        textStyle: textStyle,
      );

      // 2. ページ分割
      // 左右パディングを引いた幅で分割
      final availableWidth = widget.width - widget.padding.horizontal;
      _cachedPages = TategakiLayout.partition(
        columns: metrics.columns,
        maxWidth: availableWidth,
        height: availableHeight,
      );
    }

    final pages = _cachedPages!;

    if (pages.isEmpty) {
      return const SizedBox.shrink();
    }

    // 縦書きの本のように右から左へ読み進めるため RTL を指定
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PageView.builder(
        controller: widget.controller,
        onPageChanged: widget.onPageChanged,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final pageMetrics = pages[index];

          return Padding(
            padding: widget.padding,
            child: CustomPaint(
              size: Size(
                widget.width - widget.padding.horizontal,
                widget.height - widget.padding.vertical,
              ),
              painter: TategakiPainter(metrics: pageMetrics),
            ),
          );
        },
      ),
    );
  }
}
