import 'package:flutter/foundation.dart';

/// 縦書きテキストの要素を表すsealed class
@immutable
sealed class TategakiElement {
  const TategakiElement();

  /// 通常の文字（1文字・正立）
  const factory TategakiElement.char(String char) = TategakiChar;

  /// 縦中横（横書きで挿入する文字列。既定は2桁の半角数字）
  const factory TategakiElement.tcy(String text) = TategakiTcy;

  /// 回転させる文字列（3桁以上の数字トークン・2文字以上の欧文など）
  const factory TategakiElement.rotated(String text) = TategakiRotated;

  /// 改行（次の列へ）
  const factory TategakiElement.newLine() = TategakiNewLine;

  /// ルビ付きテキスト
  const factory TategakiElement.ruby({
    required String base,
    required String ruby,
    TategakiRubyAlign align,
  }) = TategakiRuby;

  /// 傍点（圏点）付きテキスト
  const factory TategakiElement.kenten({
    required String base,
    required String mark,
  }) = TategakiKenten;
}

/// 通常の文字（1文字・正立）
class TategakiChar extends TategakiElement {
  /// コンストラクタ
  const TategakiChar(this.char);

  /// 文字
  final String char;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TategakiChar &&
          runtimeType == other.runtimeType &&
          char == other.char;

  @override
  int get hashCode => Object.hash(TategakiChar, char);

  @override
  String toString() => 'TategakiChar($char)';
}

/// 縦中横（横書きで挿入する文字列）
class TategakiTcy extends TategakiElement {
  /// コンストラクタ
  const TategakiTcy(this.text);

  /// テキスト
  final String text;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TategakiTcy &&
          runtimeType == other.runtimeType &&
          text == other.text;

  @override
  int get hashCode => Object.hash(TategakiTcy, text);

  @override
  String toString() => 'TategakiTcy($text)';
}

/// 回転させる文字列（縦向きに組む数字・欧文）
class TategakiRotated extends TategakiElement {
  /// コンストラクタ
  const TategakiRotated(this.text);

  /// テキスト
  final String text;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TategakiRotated &&
          runtimeType == other.runtimeType &&
          text == other.text;

  @override
  int get hashCode => Object.hash(TategakiRotated, text);

  @override
  String toString() => 'TategakiRotated($text)';
}

/// 改行（次の列へ）
class TategakiNewLine extends TategakiElement {
  /// コンストラクタ
  const TategakiNewLine();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TategakiNewLine && runtimeType == other.runtimeType;

  @override
  int get hashCode => Object.hash(TategakiNewLine, 0);

  @override
  String toString() => 'TategakiNewLine()';
}

/// ルビの割り付け方式
enum TategakiRubyAlign {
  /// 親文字数・ルビ文字数から自動判定する
  auto,

  /// JIS X 4051 の 2:1 配分（グループルビ）
  jis,

  /// 中央寄せ
  center,

  /// 両端揃え
  justify,
}

/// ルビ付きテキスト
class TategakiRuby extends TategakiElement {
  /// コンストラクタ
  const TategakiRuby({
    required this.base,
    required this.ruby,
    this.align = TategakiRubyAlign.auto,
  });

  /// ベーステキスト
  final String base;

  /// ルビテキスト
  final String ruby;

  /// 割り付け方式
  final TategakiRubyAlign align;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TategakiRuby &&
          runtimeType == other.runtimeType &&
          base == other.base &&
          ruby == other.ruby &&
          align == other.align;

  @override
  int get hashCode => Object.hash(TategakiRuby, base, ruby, align);

  @override
  String toString() => 'TategakiRuby(base: $base, ruby: $ruby, align: $align)';
}

/// 傍点（圏点）付きテキスト
class TategakiKenten extends TategakiElement {
  /// コンストラクタ
  const TategakiKenten({required this.base, required this.mark});

  /// ベーステキスト
  final String base;

  /// 点の種類（1文字）
  final String mark;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TategakiKenten &&
          runtimeType == other.runtimeType &&
          base == other.base &&
          mark == other.mark;

  @override
  int get hashCode => Object.hash(TategakiKenten, base, mark);

  @override
  String toString() => 'TategakiKenten(base: $base, mark: $mark)';
}
