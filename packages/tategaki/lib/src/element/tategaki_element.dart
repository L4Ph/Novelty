/// 縦書きテキストの要素を表すsealed class
sealed class TategakiElement {
  const TategakiElement();

  /// 通常の文字（1文字）
  const factory TategakiElement.char(String char) = TategakiChar;

  /// 縦中横（横書きで挿入する文字列）
  const factory TategakiElement.tcy(String text) = TategakiTcy;

  /// 改行（次の列へ）
  const factory TategakiElement.newLine() = TategakiNewLine;

  /// ルビ付きテキスト
  const factory TategakiElement.ruby({
    required String base,
    required String ruby,
  }) = TategakiRuby;
}

/// 通常の文字（1文字）
class TategakiChar extends TategakiElement {
  /// コンストラクタ
  const TategakiChar(this.char);

  /// 文字
  final String char;
}

/// 縦中横（横書きで挿入する文字列）
class TategakiTcy extends TategakiElement {
  /// コンストラクタ
  const TategakiTcy(this.text);

  /// テキスト
  final String text;
}

/// 改行（次の列へ）
class TategakiNewLine extends TategakiElement {
  /// コンストラクタ
  const TategakiNewLine();
}

/// ルビ付きテキスト
class TategakiRuby extends TategakiElement {
  /// コンストラクタ
  const TategakiRuby({required this.base, required this.ruby});

  /// ベーステキスト
  final String base;

  /// ルビテキスト
  final String ruby;
}
