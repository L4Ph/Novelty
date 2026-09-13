import 'dart:math' as math;

import 'package:flutter/painting.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/tategaki_aki.dart';
import 'package:tategaki/src/layout/tategaki_char_class.dart';
import 'package:tategaki/src/layout/tategaki_measurer.dart';

/// 縦書きの列構造を遅延生成するエンジン
///
/// 列は要求されたときだけ計算する。字送りは `fontSize`（em）、行送りは
/// `fontSize × lineHeight` を基準にする（Q23）。計測は要素単位でキャッシュ
/// されるため、列を追加計算しても同じ要素の再計測は発生しない。
class TategakiColumnEngine {
  /// コンストラクタ
  TategakiColumnEngine({
    required this.elements,
    required this.maxHeight,
    required this.textStyle,
  }) : _measurer = TategakiMeasurer(textStyle, maxAdvance: maxHeight);

  /// 表示する要素のリスト
  final List<TategakiElement> elements;

  /// 列の高さ（インライン方向の最大長）
  final double maxHeight;

  /// 文字スタイル
  final TextStyle textStyle;

  final TategakiMeasurer _measurer;
  final List<TategakiColumn> _columns = [];
  int _elementIndex = 0;
  bool _pendingEmptyColumn = false;

  /// 1文字分の字送り（em）
  double get charHeight => _measurer.em;

  /// 行送り（列幅の基準）
  double get linePitch => _measurer.linePitch;

  /// 列幅の基準（行送り）
  double get charWidth => _measurer.linePitch;

  /// 計算済みの列数
  int get computedColumnCount => _columns.length;

  /// 指定インデックスの列を返す（未計算なら計算する）
  TategakiColumn columnAt(int index) {
    while (_columns.length <= index) {
      computeNextColumn();
    }
    return _columns[index];
  }

  /// 次の列を1つ計算して返す（もう列がなければ null）
  TategakiColumn? computeNextColumn() {
    // 改行で保留された空の列を先に返す
    if (_pendingEmptyColumn) {
      _pendingEmptyColumn = false;
      final empty = _emptyColumn();
      _columns.add(empty);
      return empty;
    }
    final column = _buildColumn();
    if (column != null) {
      _columns.add(column);
      return column;
    }
    // 空行の連続などで列が空になった場合も、保留中の空列を返す。
    // これを返さないと computeAll が途中で終了し、残りの内容が欠落する。
    if (_pendingEmptyColumn) {
      _pendingEmptyColumn = false;
      final empty = _emptyColumn();
      _columns.add(empty);
      return empty;
    }
    return null;
  }

  /// すべての列を計算して返す
  List<TategakiColumn> computeAll() {
    while (computeNextColumn() != null) {
      // 列が尽きるまで計算
    }
    return List.unmodifiable(_columns);
  }

  TategakiColumn _emptyColumn() {
    return TategakiColumn(placedItems: const [], width: 0, baseWidth: linePitch);
  }

  /// 現在位置から1つの列を組み立てる（空の改行列なら null）
  TategakiColumn? _buildColumn() {
    final placed = <TategakiPlacedItem>[];
    var used = 0.0;
    var endedByNewLine = false;

    while (_elementIndex < elements.length) {
      final element = elements[_elementIndex];

      if (element is TategakiNewLine) {
        _elementIndex++;
        _pendingEmptyColumn = true;
        endedByNewLine = true;
        break;
      }

      final measured = _measurer.measure(element);
      final aki = placed.isEmpty
          ? 0.0
          : TategakiAki.em(placed.last.item.lastClass, measured.firstClass) * _measurer.em;
      final needed = used + aki + measured.advance;

      if (needed > maxHeight && placed.isNotEmpty) {
        // 行頭禁則文字は押し込む（追込み）。それ以外は折り返す。
        if (!TategakiCharClassifier.isHeadProhibitedClass(
          measured.firstClass,
        )) {
          // 行末禁則: 末尾が開き括弧なら次列へ送る。
          // ただしその 1 文字だけの列になってしまう場合は送り出さない
          // （列が空になると内容欠落や columnAt の無限ループを招く）。
          if (placed.length > 1 &&
              TategakiCharClassifier.isTailProhibitedClass(
                placed.last.item.lastClass,
              )) {
            placed.removeLast();
            _elementIndex--;
            // 送り出しで使用済み高さが変わるため再計算する
            used = _columnBottom(placed);
          }
          break;
        }
      }

      final inlineOffset = used + aki;
      placed.add(
        TategakiPlacedItem(
          item: measured,
          inlineOffset: inlineOffset,
          blockOffset: 0,
        ),
      );
      used = inlineOffset + measured.advance;
      _elementIndex++;
    }

    if (placed.isEmpty) {
      return null;
    }

    // 段落末（改行または要素終端）は行調整しない
    final isLast = endedByNewLine || _elementIndex >= elements.length;
    final adjusted = _adjust(placed, used, isLast);

    // 追込みの押し込みや単一の長い要素で列高を超えたままの場合は、
    // 末尾から要素を次列へ戻してクリッピングを防ぐ（単一要素は許容）。
    var finalUsed = _columnBottom(adjusted);
    while (adjusted.length > 1 && finalUsed > maxHeight + 0.01) {
      adjusted.removeLast();
      _elementIndex--;
      finalUsed = _columnBottom(adjusted);
    }
    return _makeColumn(adjusted);
  }

  double _columnBottom(List<TategakiPlacedItem> placed) {
    if (placed.isEmpty) return 0;
    final last = placed.last;
    return last.inlineOffset + last.item.advance;
  }

  /// 行末調整（ジャスティフィケーション）
  ///
  /// 余りは分離可能なギャップへ均等に配分し（トラッキング）、不足時は
  /// アキを詰める（追込み）。
  List<TategakiPlacedItem> _adjust(
    List<TategakiPlacedItem> placed,
    double used,
    bool isLast,
  ) {
    if (placed.length < 2 || isLast) {
      return placed;
    }
    final remaining = maxHeight - used;
    if (remaining.abs() < 0.01) {
      return placed;
    }

    if (remaining > 0) {
      final gaps = <int>[];
      for (var i = 1; i < placed.length; i++) {
        if (TategakiAki.canExpand(
          placed[i - 1].item.lastClass,
          placed[i].item.firstClass,
        )) {
          gaps.add(i);
        }
      }
      if (gaps.isEmpty) {
        return placed;
      }
      final each = remaining / gaps.length;
      final result = <TategakiPlacedItem>[placed.first];
      var shift = 0.0;
      for (var i = 1; i < placed.length; i++) {
        if (gaps.contains(i)) {
          shift += each;
        }
        result.add(
          placed[i].copyWith(inlineOffset: placed[i].inlineOffset + shift),
        );
      }
      return result;
    }

    // 不足: アキを詰める
    final capacities = <int, double>{};
    var totalCapacity = 0.0;
    for (var i = 1; i < placed.length; i++) {
      final capacity = TategakiAki.maxShrink(
            placed[i - 1].item.lastClass,
            placed[i].item.firstClass,
          ) *
          _measurer.em;
      if (capacity > 0) {
        capacities[i] = capacity;
        totalCapacity += capacity;
      }
    }
    if (totalCapacity <= 0) {
      return placed;
    }
    final reduction = math.min(-remaining, totalCapacity);
    final result = <TategakiPlacedItem>[placed.first];
    var shift = 0.0;
    for (var i = 1; i < placed.length; i++) {
      final capacity = capacities[i] ?? 0;
      if (capacity > 0) {
        shift -= reduction * (capacity / totalCapacity);
      }
      result.add(
        placed[i].copyWith(inlineOffset: placed[i].inlineOffset + shift),
      );
    }
    return result;
  }

  TategakiColumn _makeColumn(List<TategakiPlacedItem> placed) {
    var maxRight = linePitch;
    final result = <TategakiPlacedItem>[];
    for (final p in placed) {
      final blockOffset = (linePitch - p.item.baseExtent) / 2;
      result.add(p.copyWith(blockOffset: blockOffset));
      final right = blockOffset + p.item.blockExtent;
      if (right > maxRight) {
        maxRight = right;
      }
    }
    return TategakiColumn(
      placedItems: result,
      width: maxRight,
      baseWidth: linePitch,
    );
  }

}
