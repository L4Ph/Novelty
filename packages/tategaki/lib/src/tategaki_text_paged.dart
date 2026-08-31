import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/tategaki_column_engine.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/tategaki_painter.dart';

/// 縦書きテキストをページ送りで表示するウィジェット
///
/// 列エンジンで全列を計算し、列を幅でページ分割する。各ページは
/// `ui.Picture` に**プリレンダ**して保持し、ページ遷移中は
/// `canvas.drawPicture` で描画するため、遷移アニメーションが
/// 重いレイアウト・ペイントでフレーム落ちしない。
///
/// レイアウト結果は State が保持するため、入力（要素リスト・幅・高さ・
/// パディング・スタイル）が変わらない限り再計算されない。同内容の
/// 要素リストは同じインスタンスを渡すこと（呼び出し側でメモ化する）。
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
  /// ページ分割結果（入力が変わらない限り再利用）
  List<TategakiMetrics>? _pages;

  /// 最後にレイアウト計算した入力値（再計算が必要かの判定用）
  List<TategakiElement>? _cachedElements;
  double? _cachedWidth;
  double? _cachedHeight;
  EdgeInsets? _cachedPadding;
  TextStyle? _cachedStyle;

  @override
  Widget build(BuildContext context) {
    if (widget.elements.isEmpty) {
      return const SizedBox.shrink();
    }

    final textStyle = DefaultTextStyle.of(context).style;

    // 入力が変わった場合のみページ分割を再計算する
    if (_pages == null ||
        !identical(_cachedElements, widget.elements) ||
        _cachedWidth != widget.width ||
        _cachedHeight != widget.height ||
        _cachedPadding != widget.padding ||
        _cachedStyle != textStyle) {
      _cachedElements = widget.elements;
      _cachedWidth = widget.width;
      _cachedHeight = widget.height;
      _cachedPadding = widget.padding;
      _cachedStyle = textStyle;

      // 1. 列エンジンで全列を計算
      // 上下パディングを引いた高さで計算
      final availableHeight = widget.height - widget.padding.vertical;
      final engine = TategakiColumnEngine(
        elements: widget.elements,
        maxHeight: availableHeight,
        textStyle: textStyle,
      );
      final columns = engine.computeAll();

      // 2. ページ分割
      // 左右パディングを引いた幅で分割
      final availableWidth = widget.width - widget.padding.horizontal;
      _pages = TategakiLayout.partition(
        columns: columns,
        maxWidth: availableWidth,
        height: availableHeight,
      );
    }

    final pages = _pages!;
    if (pages.isEmpty) {
      return const SizedBox.shrink();
    }

    final availableWidth = widget.width - widget.padding.horizontal;
    final availableHeight = widget.height - widget.padding.vertical;
    final pageSize = Size(availableWidth, availableHeight);

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
            child: RepaintBoundary(
              child: _TategakiPagedPage(
                metrics: pageMetrics,
                size: pageSize,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ページを `ui.Picture` にプリレンダして描画するウィジェット
///
/// ページの Picture は初回描画時に生成され、その後はキャッシュされる。
/// ページ遷移アニメーション中はキャッシュ済み Picture の描画のみで済む。
class _TategakiPagedPage extends StatefulWidget {
  /// コンストラクタ
  const _TategakiPagedPage({
    required this.metrics,
    required this.size,
  });

  /// ページのメトリクス
  final TategakiMetrics metrics;

  /// ページのサイズ
  final Size size;

  @override
  State<_TategakiPagedPage> createState() => _TategakiPagedPageState();
}

class _TategakiPagedPageState extends State<_TategakiPagedPage> {
  /// プリレンダ済みの Picture（初回描画時に生成）
  ui.Picture? _picture;

  /// 現在のページの Picture を返す（未生成なら生成してキャッシュする）
  ui.Picture get _currentPicture {
    final cached = _picture;
    if (cached != null) {
      return cached;
    }
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)
      // クリップ領域をページサイズに制限してカリングを効かせる
      ..clipRect(Offset.zero & widget.size);
    TategakiPainter(metrics: widget.metrics).paint(canvas, widget.size);
    final picture = recorder.endRecording();
    _picture = picture;
    return picture;
  }

  @override
  void didUpdateWidget(covariant _TategakiPagedPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.metrics, widget.metrics)) {
      // ページ内容が変わった場合は Picture を作り直す
      _picture?.dispose();
      _picture = null;
    }
  }

  @override
  void dispose() {
    _picture?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: _PicturePainter(_currentPicture),
    );
  }
}

/// プリレンダ済みの Picture を描画する CustomPainter
class _PicturePainter extends CustomPainter {
  /// コンストラクタ
  _PicturePainter(this.picture);

  /// 描画する Picture
  final ui.Picture picture;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(picture);
  }

  @override
  bool shouldRepaint(covariant _PicturePainter oldDelegate) {
    return oldDelegate.picture != picture;
  }
}
