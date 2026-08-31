import 'package:flutter/widgets.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/tategaki_column_engine.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/tategaki_column_painter.dart';

/// 縦書きテキストを表示するウィジェット（横スクロール）
///
/// エピソード全体をレイアウトするのではなく、列単位の**遅延レンダリング**
/// を行う。横スクロールは [ListView.builder] で実装し、可視領域に近づいた
/// 列だけを [TategakiColumnEngine] で計算・描画する（列はバッチ単位で
/// 追加計算され、スクロール位置が末尾に近づくと拡張される）。
///
/// レイアウト結果は State が保持するため、入力（要素リスト・高さ・
/// スタイル）が変わらない限り再計算されない。同内容の要素リストは
/// 同じインスタンスを渡すこと（呼び出し側でメモ化する）。
class TategakiText extends StatefulWidget {
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
  State<TategakiText> createState() => _TategakiTextState();
}

class _TategakiTextState extends State<TategakiText> {
  /// 列エンジン（入力が変わらない限り再利用）
  TategakiColumnEngine? _engine;

  /// 最後にレイアウト計算した入力値（再計算が必要かの判定用）
  List<TategakiElement>? _cachedElements;
  double? _cachedHeight;
  TextStyle? _cachedStyle;

  /// ListView に渡す itemCount（= 計算済みの列数）
  int _computedCount = 0;

  /// 追加計算のスケジュール済みフラグ
  bool _extendScheduled = false;

  /// 追加計算する列数（1画面分 + 余裕）
  static const int _extendBatch = 60;

  /// スクロール末尾からこの距離に近づいたら追加計算する
  static const double _extendThreshold = 800;

  /// 現在の入力に対応する列エンジンを返す
  TategakiColumnEngine get _currentEngine {
    final style = DefaultTextStyle.of(context).style;
    if (_engine == null ||
        !identical(_cachedElements, widget.elements) ||
        _cachedHeight != widget.height ||
        _cachedStyle != style) {
      _engine = TategakiColumnEngine(
        elements: widget.elements,
        maxHeight: widget.height,
        textStyle: style,
      );
      _cachedElements = widget.elements;
      _cachedHeight = widget.height;
      _cachedStyle = style;
      _computedCount = 0;
      _extendScheduled = false;
    }
    return _engine!;
  }

  /// 列を [_extendBatch] 個だけ追加計算して _computedCount を更新する
  void _extendColumns(TategakiColumnEngine engine, {required bool notify}) {
    var count = 0;
    while (count < _extendBatch) {
      if (engine.computeNextColumn() == null) {
        break; // 列の終端に到達
      }
      count++;
    }
    final newCount = engine.computedColumnCount;
    if (newCount != _computedCount) {
      _computedCount = newCount;
      if (notify && mounted) {
        setState(() {});
      }
    }
  }

  /// 追加計算を次フレーム以降にスケジュールする
  void _scheduleExtend() {
    if (_extendScheduled) {
      return;
    }
    _extendScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _extendScheduled = false;
      if (!mounted) {
        return;
      }
      _extendColumns(_currentEngine, notify: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.elements.isEmpty) {
      return const SizedBox.shrink();
    }

    final engine = _currentEngine;

    // 初回はビルド中に最初のバッチを計算して itemCount を確保する
    if (_computedCount == 0) {
      _extendColumns(engine, notify: false);
    }

    final scrollPositionKey = PageStorageKey<Object>(widget.key ?? this);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // スクロール位置が末尾に近づいたら列を追加計算する
        if (notification.metrics.axis == Axis.horizontal &&
            notification.metrics.extentAfter < _extendThreshold) {
          _scheduleExtend();
        }
        return false;
      },
      child: ListView.separated(
        // PageStorageKey でスクロール位置を保持する
        key: scrollPositionKey,
        scrollDirection: Axis.horizontal,
        itemCount: _computedCount,
        // 列間のスペース（旧実装の columnSpacing に相当）
        separatorBuilder: (context, index) =>
            const SizedBox(width: TategakiLayout.columnSpacing),
        itemBuilder: (context, index) {
          // 末尾の列をビルドしたら追加計算を予約する
          if (index >= _computedCount - 1) {
            _scheduleExtend();
          }
          final column = engine.columnAt(index);
          return CustomPaint(
            size: Size(column.width, widget.height),
            painter: TategakiColumnPainter(column: column),
          );
        },
      ),
    );
  }
}
