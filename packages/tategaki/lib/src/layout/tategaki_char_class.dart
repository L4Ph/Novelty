/// JLREQ の文字クラスを縦書き小説向けに集約したもの
enum TategakiCharClass {
  /// 始め括弧類（cl-01）
  openingBracket,

  /// 終わり括弧類（cl-02）
  closingBracket,

  /// 読点類（cl-07）
  comma,

  /// 句点類（cl-06）
  period,

  /// 中点類（cl-05）
  middleDot,

  /// 小書き仮名（cl-15/16 の一部）
  sutegana,

  /// 平仮名・片仮名（cl-15/16）
  kana,

  /// 漢字等（cl-19）
  kanji,

  /// 欧文用文字（cl-27）・半角英字
  latin,

  /// 連数字中の文字（cl-24）・半角アラビア数字
  digit,

  /// 和字間隔（cl-14）
  space,

  /// 区切り約物（cl-04）
  dividing,

  /// 長音記号（cl-16 の一部）
  prolongedSound,

  /// その他
  others,
}

/// 文字クラスの判定
class TategakiCharClassifier {
  TategakiCharClassifier._();

  /// 文字（1コードポイント）のクラスを返す
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
    if (code == 0x30FC || char == '丨') {
      // 長音記号（ー）とその縦書き変体
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

  /// 行頭禁則文字かどうか（JLREQ §3.1.7）
  static bool isHeadProhibited(String char) {
    return switch (of(char)) {
      TategakiCharClass.closingBracket ||
      TategakiCharClass.comma ||
      TategakiCharClass.period ||
      TategakiCharClass.middleDot ||
      TategakiCharClass.sutegana ||
      TategakiCharClass.dividing ||
      TategakiCharClass.prolongedSound => true,
      _ => false,
    };
  }

  /// 行末禁則文字かどうか（JLREQ §3.1.8）
  static bool isTailProhibited(String char) {
    return of(char) == TategakiCharClass.openingBracket;
  }

  static bool _isKana(int code) {
    if (code >= 0x3041 && code <= 0x309F) return true;
    if (code >= 0x30A1 && code <= 0x30FF) return true;
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
    if (code >= 0xFF21 && code <= 0xFF3A) return true;
    if (code >= 0xFF41 && code <= 0xFF5A) return true;
    if (code >= 0xC0 && code <= 0x24F) return true;
    return false;
  }

  static const _openingBrackets = <String>{
    '「', '（', '【', '『', '［', '｛', '〈', '《', '〔', '〖', '‘', '“',
    '(', '[', '{', '<',
    // 縦書き変体
    '︵', '﹇', '︷', '﹁', '﹃', '︻', '︿', '︽',
  };

  static const _closingBrackets = <String>{
    '」', '）', '】', '』', '］', '｝', '〉', '》', '〕', '〗', '’', '”',
    ')', ']', '}',
    // 縦書き変体
    '︶', '﹈', '︸', '﹂', '﹄', '︼', '︾', '﹀',
  };

  static const _commas = <String>{'、', '，', ',', '︑', '︐'};
  static const _periods = <String>{'。', '．', '.', '︒', '﹒'};
  static const _middleDots = <String>{
    '・', '･', '：', '；', ':', ';', '｜', '︓', '︔',
  };
  static const _dividing = <String>{'！', '？', '!', '?', '︕', '︖'};

  static const _sutegana = <String>{
    'ぁ', 'ぃ', 'ぅ', 'ぇ', 'ぉ', 'っ', 'ゃ', 'ゅ', 'ょ', 'ゎ', 'ゕ', 'ゖ',
    'ァ', 'ィ', 'ゥ', 'ェ', 'ォ', 'ッ', 'ャ', 'ュ', 'ョ', 'ヮ', 'ヵ', 'ヶ',
    'ㇰ', 'ㇱ', 'ㇲ', 'ㇳ', 'ㇴ', 'ㇵ', 'ㇶ', 'ㇷ', 'ㇸ', 'ㇹ', 'ㇺ', 'ㇻ',
    'ㇼ', 'ㇽ', 'ㇾ', 'ㇿ', 'ｧ', 'ｨ', 'ｩ', 'ｪ', 'ｫ', 'ｯ', 'ｬ', 'ｭ', 'ｮ',
  };
}
