/// 縦書きテキストの要素を表すsealed class
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
}

/// 縦中横（横書きで挿入する文字列）
class TategakiTcy extends TategakiElement {
  /// コンストラクタ
  const TategakiTcy(this.text);

  /// テキスト
  final String text;
}

/// 回転させる文字列（縦向きに組む数字・欧文）
class TategakiRotated extends TategakiElement {
  /// コンストラクタ
  const TategakiRotated(this.text);

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

/// 傍点（圏点）付きテキスト
class TategakiKenten extends TategakiElement {
  /// コンストラクタ
  const TategakiKenten({required this.base, required this.mark});

  /// ベーステキスト
  final String base;

  /// 点の種類（1文字）
  final String mark;
}
