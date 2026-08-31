import 'dart:math' as math;

import 'package:flutter/painting.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/kinsoku.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/paintable.dart';
import 'package:tategaki/src/painting/paintable_column_text.dart';
import 'package:tategaki/src/painting/paintable_ruby.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';
import 'package:tategaki/src/utils/glyph_mapper.dart';

/// 縦書きの列を遅延生成するエンジン
///
/// 連続する通常文字は「\n 連結の単一 TextPainter」で一括計測し、行高
/// （= `painter.height / 行数`）で列の折り返し位置を決定する。これにより
/// 文字単位の TextPainter 生成を廃止し、計測コストを列あたり O(1) 回の
/// レイアウトに抑える。
class TategakiColumnEngine {
  /// コンストラクタ
  TategakiColumnEngine({
    required this.elements,
    required this.maxHeight,
    required this.textStyle,
  });

  /// 表示する要素のリスト
  final List<TategakiElement> elements;

  /// 列の高さ（この値を超えないように列分割する）
  final double maxHeight;

  /// 文字スタイル
  final TextStyle textStyle;

  /// 生成済み列のキャッシュ
  final List<TategakiColumn> _columns = [];

  /// 次に消費する要素のインデックス
  int _elementIndex = 0;

  /// 改行によって発生した空の列が未返却かどうか
  bool _pendingEmptyColumn = false;

  /// 1文字の高さ（遅延計測）
  double? _cachedCharHeight;

  /// ルビ用スタイル（遅延生成）
  TextStyle? _cachedRubyStyle;

  /// 縦中横の計測キャッシュ（同一テキストは1回だけ計測する）
  final Map<String, PaintableTcy> _tcyCache = {};

  /// ルビの計測キャッシュ（同一の組み合わせは1回だけ計測する）
  final Map<({String base, String ruby}), PaintableRuby> _rubyCache = {};

  /// 計算済みの列数
  int get computedColumnCount => _columns.length;


  /// 指定インデックスの列を返す
  ///
  /// 未計算の場合は遅延生成してメモ化する。同じインデックスに対しては
  /// 常に同一インスタンスを返す。**index は計算済みの列数より小さい
  /// ことを前提とする**（終端判定は [computeNextColumn] を使うこと）。
  TategakiColumn columnAt(int index) {
    while (_columns.length <= index) {
      computeNextColumn();
    }
    return _columns[index];
  }

  /// 次の列を1つ計算して返す（もう列がなければ null）
  ///
  /// 遅延レンダリングの「追加計算」はこのメソッドを使う。
  TategakiColumn? computeNextColumn() {
    // 前回の改行で保留された空の列を返す
    if (_pendingEmptyColumn) {
      _pendingEmptyColumn = false;
      final column = _emptyColumn();
      _columns.add(column);
      return column;
    }
    if (_elementIndex >= elements.length) {
      return null;
    }

    final column = _buildColumn();
    if (column != null) {
      _columns.add(column);
      return column;
    }

    // _buildColumn が空の列を返した場合、改行による空の列が保留されている
    if (_pendingEmptyColumn) {
      _pendingEmptyColumn = false;
      final emptyColumn = _emptyColumn();
      _columns.add(emptyColumn);
      return emptyColumn;
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

  /// 段落間スペース用の空の列を返す
  TategakiColumn _emptyColumn() {
    return const TategakiColumn(items: [], width: 0, baseWidth: 0);
  }

  /// 現在位置から1つの列を組み立てる
  ///
  /// 改行で現在の列が空のまま終了した場合は null を返し、
  /// 空の列を [_pendingEmptyColumn] として保留する。
  TategakiColumn? _buildColumn() {
    final items = <Paintable>[];
    var columnHeight = 0.0;
    var baseWidth = 0.0;
    var pendingText = <String>[];
    var pendingHeight = 0.0;

    // pendingText と正確に一致する TextPainter（計測結果の再利用用）。
    // 計測チャンクが丸ごと pendingText になった場合のみ非 null。
    TextPainter? pendingPainter;

    // バッファリング中の連続文字を列アイテムとして確定する
    void flush() {
      if (pendingText.isEmpty) {
        pendingPainter = null;
        return;
      }
      final reusable = pendingPainter;
      if (reusable != null) {
        // 計測済みの TextPainter をそのまま描画に使う（二重レイアウト回避）
        items.add(PaintableColumnText(reusable));
      } else {
        final text = pendingText.join('\n');
        final painter = TextPainter(
          text: TextSpan(text: text, style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        items.add(PaintableColumnText(painter));
      }
      pendingPainter = null;
      columnHeight += pendingHeight;
      pendingText = [];
      pendingHeight = 0.0;
    }

    // 現在の列の使用済み高さ
    double usedHeight() => columnHeight + pendingHeight;

    // 列を確定して返す
    TategakiColumn finishColumn() {
      flush();
      return _makeColumn(items, baseWidth);
    }

    // インライン要素（縦中横・ルビ）を列に追加する
    //
    // 収まらない場合は現在の列を確定して返し、この要素は次列で処理する
    // （_elementIndex は進めない）。収まる場合は null を返す。
    TategakiColumn? addInlineItem(Paintable item) {
      if (usedHeight() + item.height > maxHeight &&
          (items.isNotEmpty || pendingText.isNotEmpty)) {
        return finishColumn();
      }
      flush();
      items.add(item);
      columnHeight += item.height;
      if (item.baseWidth > baseWidth) {
        baseWidth = item.baseWidth;
      }
      _elementIndex++;
      return null;
    }

    while (_elementIndex < elements.length) {
      final element = elements[_elementIndex];
      switch (element) {
        case TategakiChar():
          // 連続する文字をこの列に収まる分だけ消費する
          final startIndex = _elementIndex;
          final remaining = maxHeight - usedHeight();
          final estChars = math.max(1, (remaining / charHeight).floor());

          final collected = <String>[];
          var cursor = startIndex;
          while (cursor < elements.length && collected.length < estChars) {
            final e = elements[cursor];
            if (e is! TategakiChar) {
              break;
            }
            collected.add(e.char);
            cursor++;
          }

          // \n 連結の単一 TextPainter で一括計測する
          final text = collected.join('\n');
          final painter = TextPainter(
            text: TextSpan(text: text, style: textStyle),
            textDirection: TextDirection.ltr,
          )..layout();

          // 各行（= 各文字）の高さは painter.height / 行数で求める。
          // 注: getBoxesForSelection のボックス高さは行送り（line-height）を
          // 含まないため、列の折り返し判定には使えない。
          final perLineHeight = painter.height / collected.length;
          final runWidth = painter.width;

          // 収まる文字数を決定する（列が空の場合は最低1文字を入れる）
          final columnHasContent = items.isNotEmpty || pendingText.isNotEmpty;
          var acc = 0.0;
          var fitCount = 0;
          for (var k = 0; k < collected.length; k++) {
            final overflows = acc + perLineHeight > remaining;
            if (overflows && (fitCount > 0 || columnHasContent)) {
              break;
            }
            acc += perLineHeight;
            fitCount++;
          }

          // 列が満杯で文字が余る場合のみ禁則処理を適用する
          if (fitCount < collected.length) {
            fitCount = _applyKinsoku(
              collected,
              fitCount,
              columnEmpty: !columnHasContent,
            );
          }

          // 確定した文字をバッファへ追加する
          final appendedToEmpty = pendingText.isEmpty;
          for (var k = 0; k < fitCount; k++) {
            pendingText.add(collected[k]);
            pendingHeight += perLineHeight;
          }
          if (runWidth > baseWidth) {
            baseWidth = runWidth;
          }
          _elementIndex = startIndex + fitCount;

          // 計測チャンクが丸ごと pendingText になった場合は再利用可能
          if (appendedToEmpty && fitCount == collected.length) {
            pendingPainter = painter;
          } else {
            pendingPainter = null;
          }

          // 列を確定する条件:
          // 1. 文字が余った（fitCount < collected.length）
          // 2. 残り容量が1文字分未満（これ以上入らない）
          final columnFull =
              fitCount < collected.length ||
              (maxHeight - usedHeight()) < charHeight;
          if (columnFull) {
            return finishColumn();
          }
          // すべて収まって余裕がある場合は次の要素の処理へ進む
          continue;

        case TategakiTcy(:final text):
          final tcyResult = addInlineItem(_buildTcy(text));
          if (tcyResult != null) {
            return tcyResult;
          }

        case TategakiRuby(:final base, :final ruby):
          final rubyResult = addInlineItem(_buildRuby(base, ruby));
          if (rubyResult != null) {
            return rubyResult;
          }

        case TategakiNewLine():
          // 改行: 現在の列を終了し、空の列を保留する
          flush();
          _elementIndex++;
          _pendingEmptyColumn = true;
          if (items.isNotEmpty) {
            return _makeColumn(items, baseWidth);
          }
          // 現在の列が空の場合: 空の列を保留したまま終了する
          return null;
      }
    }

    // 要素の終端に到達
    return finishColumn();
  }

  /// 禁則処理を適用して収まる文字数を調整する
  int _applyKinsoku(
    List<String> collected,
    int fitCount, {
    required bool columnEmpty,
  }) {
    var adjusted = fitCount;
    // 行末禁則: 現在の列の末尾に来てはいけない文字を次列へ送る
    while (adjusted > 0 && Kinsoku.isTailProhibited(collected[adjusted - 1])) {
      adjusted--;
    }
    // 行頭禁則: 次列の先頭に来てはいけない文字を現在の列へ押し込む
    if (adjusted > 0 &&
        adjusted < collected.length &&
        Kinsoku.isHeadProhibited(collected[adjusted])) {
      adjusted++;
    }
    // 列が完全に空で文字が余る場合は最低1文字を入れる
    // （空の列にまで禁則を適用すると列が永遠に生成できなくなるため）
    if (adjusted == 0 && columnEmpty && collected.isNotEmpty) {
      adjusted = 1;
    }
    return adjusted;
  }

  /// 列を作成する（幅はアイテムのオーバーハングを考慮して計算する）
  TategakiColumn _makeColumn(List<Paintable> items, double baseWidth) {
    var requiredWidth = baseWidth;
    for (final item in items) {
      final baseOffset = (baseWidth - item.baseWidth) / 2;
      final itemTotalWidth = baseOffset + item.width;
      if (itemTotalWidth > requiredWidth) {
        requiredWidth = itemTotalWidth;
      }
    }
    return TategakiColumn(
      items: items,
      width: requiredWidth,
      baseWidth: baseWidth,
    );
  }

  /// 縦中横の描画要素を作成する（同一テキストはキャッシュして再利用）
  PaintableTcy _buildTcy(String text) {
    final cached = _tcyCache[text];
    if (cached != null) {
      return cached;
    }
    final painter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    final item = PaintableTcy(painter);
    _tcyCache[text] = item;
    return item;
  }

  /// ルビ付きテキストの描画要素を作成する（同一の組み合わせはキャッシュ）
  PaintableRuby _buildRuby(String base, String ruby) {
    final key = (base: base, ruby: ruby);
    final cached = _rubyCache[key];
    if (cached != null) {
      return cached;
    }
    final item = _createRuby(base, ruby);
    _rubyCache[key] = item;
    return item;
  }

  /// ルビ付きテキストの描画要素を新規に作成する
  PaintableRuby _createRuby(String base, String ruby) {
    final rubyStyle = _rubyStyle;

    final basePainters = <TextPainter>[];
    var baseWidth = 0.0;

    for (final char in base.runes) {
      final mappedChar = GlyphMapper.map(String.fromCharCode(char));
      final painter = TextPainter(
        text: TextSpan(text: mappedChar, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      basePainters.add(painter);
      if (painter.width > baseWidth) {
        baseWidth = painter.width;
      }
    }

    final rubyPainters = <TextPainter>[];
    var rubyWidth = 0.0;
    var rubyHeight = 0.0;

    for (final char in ruby.runes) {
      final mappedChar = GlyphMapper.map(String.fromCharCode(char));
      final painter = TextPainter(
        text: TextSpan(text: mappedChar, style: rubyStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      rubyPainters.add(painter);
      rubyHeight += painter.height;
      if (painter.width > rubyWidth) {
        rubyWidth = painter.width;
      }
    }

    return PaintableRuby(
      basePainters: basePainters,
      rubyPainters: rubyPainters,
      baseWidth: baseWidth,
      rubyWidth: rubyWidth,
      rubyHeight: rubyHeight,
    );
  }

  /// 1文字の高さを計測する（推定用・キャッシュ）
  double get charHeight {
    final cached = _cachedCharHeight;
    if (cached != null) {
      return cached;
    }
    final painter = TextPainter(
      text: TextSpan(text: 'あ', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    _cachedCharHeight = painter.height;
    return painter.height;
  }

  /// ルビ用のスタイル（キャッシュ）
  TextStyle get _rubyStyle {
    final cached = _cachedRubyStyle;
    if (cached != null) {
      return cached;
    }
    final style = textStyle.copyWith(
      fontSize: (textStyle.fontSize ?? 14) * TategakiLayout.rubyScale,
    );
    _cachedRubyStyle = style;
    return style;
  }
}
