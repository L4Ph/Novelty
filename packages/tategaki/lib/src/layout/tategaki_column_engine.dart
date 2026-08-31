import 'dart:math' as math;

import 'package:flutter/painting.dart';

import 'package:tategaki/src/element/tategaki_element.dart';
import 'package:tategaki/src/layout/column.dart';
import 'package:tategaki/src/layout/kinsoku.dart';
import 'package:tategaki/src/layout/tategaki_layout.dart';
import 'package:tategaki/src/painting/paintable.dart';
import 'package:tategaki/src/painting/paintable_ruby.dart';
import 'package:tategaki/src/painting/paintable_tcy.dart';
import 'package:tategaki/src/utils/glyph_mapper.dart';

/// 縦書きの列構造を遅延生成するエンジン
///
/// 列の折り返しは**純粋な算術**（文字高 × 文字数）で決定するため、レイアウト
/// 計算では TextPainter をほぼ生成しない。描画用の TextPainter は
/// [TategakiColumn.items] の初回アクセス時にのみ生成される（**遅延
/// マテリアライズ**）。これにより「未表示の列」の描画コストを排除し、
/// ページめくりモードでは表示ページの列だけが TextPainter を持つ。
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

  /// 1文字の幅（遅延計測）
  double? _cachedCharWidth;

  /// 縦中横の計測キャッシュ（同一テキストは1回だけ計測する）
  final Map<String, PaintableTcy> _tcyCache = {};

  /// ルビの計測キャッシュ（同一の組み合わせは1回だけ計測する）
  final Map<({String base, String ruby}), PaintableRuby> _rubyCache = {};

  /// 計算済みの列数
  int get computedColumnCount => _columns.length;

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

  /// 1文字の幅を計測する（列幅の推定用・キャッシュ）
  double get charWidth {
    final cached = _cachedCharWidth;
    if (cached != null) {
      return cached;
    }
    final painter = TextPainter(
      text: TextSpan(text: 'あ', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    _cachedCharWidth = painter.width;
    return painter.width;
  }

  /// ルビ用のスタイル
  TextStyle get _rubyStyle {
    return textStyle.copyWith(
      fontSize: (textStyle.fontSize ?? 14) * TategakiLayout.rubyScale,
    );
  }

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
    return TategakiColumn(
      slots: const [],
      width: 0,
      baseWidth: 0,
      textStyle: textStyle,
    );
  }

  /// 現在位置から1つの列を組み立てる
  ///
  /// 改行で現在の列が空のまま終了した場合は null を返し、
  /// 空の列を [_pendingEmptyColumn] として保留する。
  TategakiColumn? _buildColumn() {
    final slots = <TategakiColumnSlot>[];
    var usedHeight = 0.0;
    var baseWidth = 0.0;
    var pendingChars = <String>[];

    // バッファ中の文字の高さを含めた使用済み高さ
    double usedHeightWithPending() =>
        usedHeight + pendingChars.length * charHeight;

    // 連続する文字を文字ランとして確定する
    void flushChars() {
      if (pendingChars.isEmpty) {
        return;
      }
      slots.add(TategakiCharRun(pendingChars.join('\n')));
      // 確定した文字ランの高さを列の使用済み高さへ加算する
      usedHeight += pendingChars.length * charHeight;
      pendingChars = [];
    }

    TategakiColumn finishColumn() {
      flushChars();
      return _makeColumn(slots, baseWidth);
    }

    // インライン要素（縦中横・ルビ）を列に追加する
    //
    // 収まらない場合は現在の列を確定して返し、この要素は次列で処理する
    // （_elementIndex は進めない）。収まる場合は null を返す。
    TategakiColumn? addInline(Paintable item) {
      if (usedHeightWithPending() + item.height > maxHeight &&
          (slots.isNotEmpty || pendingChars.isNotEmpty)) {
        return finishColumn();
      }
      flushChars();
      slots.add(TategakiInlineItem(item));
      usedHeight += item.height;
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
          // 算術でこの列に収まる文字数を決める
          final remaining = maxHeight - usedHeightWithPending();
          var fit = math.max(0, (remaining / charHeight).floor());

          // 列が空なら最低1文字は入れる
          if (fit == 0 && slots.isEmpty && pendingChars.isEmpty) {
            fit = 1;
          }

          var collected = 0;
          while (_elementIndex < elements.length && collected < fit) {
            final e = elements[_elementIndex];
            if (e is! TategakiChar) {
              break;
            }
            pendingChars.add(e.char);
            _elementIndex++;
            collected++;
          }

          if (collected == 0) {
            // 文字が収まらない（列は既に内容がある）→ 列を確定
            return finishColumn();
          }

          final isWrapping =
              collected == fit && _elementIndex < elements.length;

          // 禁則処理
          // 行末禁則: 列の折り返し時だけ末尾の開き括弧などを次列へ送る
          var movedTailProhibited = false;
          if (isWrapping) {
            while (pendingChars.isNotEmpty &&
                Kinsoku.isTailProhibited(pendingChars.last)) {
              pendingChars.removeLast();
              _elementIndex--;
              movedTailProhibited = true;
            }
          }
          if (movedTailProhibited) {
            // 列が空になってしまう場合は最低1文字を戻す
            if (pendingChars.isEmpty && slots.isEmpty) {
              final c = elements[_elementIndex];
              if (c is TategakiChar) {
                pendingChars.add(c.char);
                _elementIndex++;
              }
            }
            if (charWidth > baseWidth) {
              baseWidth = charWidth;
            }
            return finishColumn();
          }

          // 行頭禁則: 次列の先頭になり得る句点などを現在の列へ押し込む
          final next = _elementIndex < elements.length
              ? elements[_elementIndex]
              : null;
          if (next is TategakiChar &&
              Kinsoku.isHeadProhibited(next.char) &&
              pendingChars.isNotEmpty &&
              usedHeightWithPending() + charHeight <= maxHeight) {
            pendingChars.add(next.char);
            _elementIndex++;
          }

          if (charWidth > baseWidth) {
            baseWidth = charWidth;
          }

          // 列が満杯になった場合は確定する
          if (usedHeightWithPending() >= maxHeight) {
            return finishColumn();
          }
          // 余裕がある場合は次の要素の処理へ進む
          continue;

        case TategakiTcy(:final text):
          final tcyResult = addInline(_buildTcy(text));
          if (tcyResult != null) {
            return tcyResult;
          }

        case TategakiRuby(:final base, :final ruby):
          final rubyResult = addInline(_buildRuby(base, ruby));
          if (rubyResult != null) {
            return rubyResult;
          }

        case TategakiNewLine():
          // 改行: 現在の列を終了し、空の列を保留する
          flushChars();
          _elementIndex++;
          _pendingEmptyColumn = true;
          if (slots.isNotEmpty) {
            return _makeColumn(slots, baseWidth);
          }
          // 現在の列が空の場合: 空の列を保留したまま終了する
          return null;
      }
    }

    // 要素の終端に到達
    return finishColumn();
  }

  /// 列を確定する（幅はアイテムのオーバーハングを考慮して計算する）
  TategakiColumn _makeColumn(List<TategakiColumnSlot> slots, double baseWidth) {
    var requiredWidth = baseWidth;
    for (final slot in slots) {
      switch (slot) {
        case TategakiCharRun():
          // 文字ランは charWidth を幅として使う
          if (charWidth > requiredWidth) {
            requiredWidth = charWidth;
          }
        case TategakiInlineItem(:final item):
          final baseOffset = (baseWidth - item.baseWidth) / 2;
          final itemTotalWidth = baseOffset + item.width;
          if (itemTotalWidth > requiredWidth) {
            requiredWidth = itemTotalWidth;
          }
      }
    }
    return TategakiColumn(
      slots: slots,
      width: requiredWidth,
      baseWidth: baseWidth,
      textStyle: textStyle,
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
}
