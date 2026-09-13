/// 文字クラス（JLREQ の文字クラスを縦書き小説向けに集約したもの）
enum TategakiCharClass {
  /// 始め括弧類
  openingBracket,

  /// 終わり括弧類
  closingBracket,

  /// 読点類
  comma,

  /// 句点類
  period,

  /// 中点類
  middleDot,

  /// 小書き仮名
  sutegana,

  /// 平仮名・片仮名
  kana,

  /// 漢字
  kanji,

  /// 半角・全角の欧文
  latin,

  /// 半角アラビア数字
  digit,

  /// 空白
  space,

  /// 区切り約物（！？）
  dividing,

  /// 長音記号
  prolongedSound,

  /// その他
  others,
}

/// 文字クラスの判定
class CharClassifier {
  CharClassifier._();

  /// 文字のクラスを返す
  static TategakiCharClass of(String char) {
    if (char.isEmpty) {
      return TategakiCharClass.others;
    }
    final code = char.runes.first;

    if (_openingBrackets.contains(char)) {
      return TategakiCharClass.openingBracket;
    }
    if (_closingBrackets.contains(char)) {
      return TategakiCharClass.closingBracket;
    }
    if (_commas.contains(char)) {
      return TategakiCharClass.comma;
    }
    if (_periods.contains(char)) {
      return TategakiCharClass.period;
    }
    if (_middleDots.contains(char)) {
      return TategakiCharClass.middleDot;
    }
    if (_sutegana.contains(char)) {
      return TategakiCharClass.sutegana;
    }
    if (code == 0x30FC) {
      return TategakiCharClass.prolongedSound;
    }
    if (_dividing.contains(char)) {
      return TategakiCharClass.dividing;
    }
    if (code >= 0x30 && code <= 0x39) {
      return TategakiCharClass.digit;
    }
    if (_isKana(code)) {
      return TategakiCharClass.kana;
    }
    if (_isKanji(code)) {
      return TategakiCharClass.kanji;
    }
    if (_isLatin(code)) {
      return TategakiCharClass.latin;
    }
    if (code == 0x20 || code == 0x3000) {
      return TategakiCharClass.space;
    }
    return TategakiCharClass.others;
  }

  /// 行頭禁則文字かどうか
  static bool isHeadProhibited(String char) {
    final cls = of(char);
    return cls == TategakiCharClass.closingBracket ||
        cls == TategakiCharClass.comma ||
        cls == TategakiCharClass.period ||
        cls == TategakiCharClass.middleDot ||
        cls == TategakiCharClass.sutegana ||
        cls == TategakiCharClass.dividing ||
        cls == TategakiCharClass.prolongedSound;
  }

  /// 行末禁則文字かどうか
  static bool isTailProhibited(String char) {
    return of(char) == TategakiCharClass.openingBracket;
  }

  static bool _isKana(int code) {
    // 平仮名・片仮名（小書きは sutegana で先に判定済み）
    if (code >= 0x3041 && code <= 0x309F) return true;
    if (code >= 0x30A1 && code <= 0x30FF) return true;
    // 半角カナ
    if (code >= 0xFF66 && code <= 0xFF9F) return true;
    return false;
  }

  static bool _isKanji(int code) {
    return (code >= 0x3400 && code <= 0x4DBF) ||
        (code >= 0x4E00 && code <= 0x9FFF) ||
        (code >= 0xF900 && code <= 0xFAFF);
  }

  static bool _isLatin(int code) {
    if (code >= 0x41 && code <= 0x5A) return true;
    if (code >= 0x61 && code <= 0x7A) return true;
    // 全角英字
    if (code >= 0xFF21 && code <= 0xFF3A) return true;
    if (code >= 0xFF41 && code <= 0xFF5A) return true;
    // ラテン補助
    if (code >= 0xC0 && code <= 0x24F) return true;
    return false;
  }

  static const _openingBrackets = <String>{
    '「', '（', '【', '『', '［', '｛', '〈', '《', '〔', '〖', '‘', '“',
    '(', '[', '{', '<',
  };

  static const _closingBrackets = <String>{
    '」', '）', '】', '』', '］', '｝', '〉', '》', '〕', '〗', '’', '”',
    ')', ']', '}',
  };

  static const _commas = <String>{'、', '，', ','};
  static const _periods = <String>{'。', '．', '.'};
  static const _middleDots = <String>{'・', '･', '：', '；', ':', ';'};
  static const _dividing = <String>{'！', '？', '!', '?'};

  static const _sutegana = <String>{
    'ぁ', 'ぃ', 'ぅ', 'ぇ', 'ぉ', 'っ', 'ゃ', 'ゅ', 'ょ', 'ゎ', 'ゕ', 'ゖ',
    'ァ', 'ィ', 'ゥ', 'ェ', 'ォ', 'ッ', 'ャ', 'ュ', 'ョ', 'ヮ', 'ヵ', 'ヶ',
    'ㇰ', 'ㇱ', 'ㇲ', 'ㇳ', 'ㇴ', 'ㇵ', 'ㇶ', 'ㇷ', 'ㇸ', 'ㇹ', 'ㇺ', 'ㇻ',
    'ㇼ', 'ㇽ', 'ㇾ', 'ㇿ', 'ｧ', 'ｨ', 'ｩ', 'ｪ', 'ｫ', 'ｯ', 'ｬ', 'ｭ', 'ｮ',
  };

  static const _openingBracketVariants = <String>{
    '︵', '﹇', '︷', '﹁', '﹃', '︻', '︿', '︽',
  };

  static const _closingBracketVariants = <String>{
    '︶', '﹈', '︸', '﹂', '﹄', '︼', '︾', '﹀',
  };

  static const _commaVariants = <String>{'︑', '︐'};
  static const _periodVariants = <String>{'︒', '﹒'};
  static const _middleDotVariants = <String>{'｜', '︓', '︔'};
  static const _dividingVariants = <String>{'︕', '︖'};
  static const _prolongedVariants = <String>{'丨'};

  /// 縦書き変体（Unicode の縦書き形）も含めてクラスを返す。
  ///
  /// 字形変換後に呼ばれることを想定する。
  static TategakiCharClass ofVariant(String char) {
    if (_openingBracketVariants.contains(char)) {
      return TategakiCharClass.openingBracket;
    }
    if (_closingBracketVariants.contains(char)) {
      return TategakiCharClass.closingBracket;
    }
    if (_commaVariants.contains(char)) {
      return TategakiCharClass.comma;
    }
    if (_periodVariants.contains(char)) {
      return TategakiCharClass.period;
    }
    if (_middleDotVariants.contains(char)) {
      return TategakiCharClass.middleDot;
    }
    if (_dividingVariants.contains(char)) {
      return TategakiCharClass.dividing;
    }
    if (_prolongedVariants.contains(char)) {
      return TategakiCharClass.prolongedSound;
    }
    return of(char);
  }
}
