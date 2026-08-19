// 文字種判定と特徴抽出
// yuhsak/wakachigaki の src/feature/regexp.ts を Dart に移植

final RegExp _kanjiReg = RegExp(
  r'^[々〇〻\u2E80-\u2FDF\u3400-\u4DBF\u4E00-\u9FFF\uF900-\uFAFF]|[\uD840-\uD87F][\uDC00-\uDFFF]+$',
);
final RegExp _numeralKanjiReg = RegExp(r'^[一二三四五六七八九十百千万億兆]+$');
final RegExp _hiraganaReg = RegExp(r'^[ぁ-ん]+$');
final RegExp _katakanaReg = RegExp(r'^[ァ-ヴーｧ-ﾝﾞﾟ]+$');
final RegExp _alphabetReg = RegExp(r'^[a-zA-Zａ-ｚＡ-Ｚ]+$');
final RegExp _numeralReg = RegExp(r'^[0-9０-９]+$');

bool isKanji(String s) => _kanjiReg.hasMatch(s);
bool isNumeralKanji(String s) => _numeralKanjiReg.hasMatch(s);
bool isHiragana(String s) => _hiraganaReg.hasMatch(s);
bool isKatakana(String s) => _katakanaReg.hasMatch(s);
bool isAlphabet(String s) => _alphabetReg.hasMatch(s);
bool isNumeral(String s) => _numeralReg.hasMatch(s);

String getCharType(String ch) {
  if (isHiragana(ch)) return 'H';
  if (isKatakana(ch)) return 'K';
  if (isKanji(ch)) return 'C';
  if (isNumeralKanji(ch)) return 'N';
  if (isAlphabet(ch)) return 'A';
  if (isNumeral(ch)) return 'N';
  if (ch.trim().isEmpty) return 'O';
  if (ch == '。' || ch == '、' || ch == '！' || ch == '？') return 'S';
  return 'O';
}
