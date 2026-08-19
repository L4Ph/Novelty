// 文字種判定と特徴抽出
// yuhsak/wakachigaki の src/feature/regexp.ts / char.ts / feature.ts を Dart に移植

import 'package:wakachigaki/src/hash.dart';
import 'package:wakachigaki/src/model.dart';
import 'package:wakachigaki/src/normalize.dart';
import 'package:wakachigaki/src/ngram.dart';

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

/// 文字種コードを返す（yuhsak と同じく後勝ち）
String getCharType(String char) {
  var rep = 'O';
  if (isKanji(char)) rep = 'C';
  if (isNumeralKanji(char)) rep = 'S';
  if (isHiragana(char)) rep = 'H';
  if (isKatakana(char)) rep = 'K';
  if (isAlphabet(char)) rep = 'A';
  if (isNumeral(char)) rep = 'N';
  return rep;
}

const List<String> _markers = [
  'B', 'D', 'E', 'F', 'G', 'I', 'J', 'L', 'M', 'P', 'Q', 'R', 'T', 'U', 'V',
  'W', 'X', 'Y', 'Z',
];

/// 1文字分の N-gram 特徴
class NgramFeatureItem {
  const NgramFeatureItem({
    required this.kind,
    required this.size,
    required this.offset,
    required this.value,
  });

  final String kind; // 'type' | 'hash'
  final int size;
  final int offset;
  final String value;
}

class NgramFeature {
  const NgramFeature({required this.char, required this.features});

  final String char;
  final List<NgramFeatureItem> features;
}

/// 特徴抽出器を生成する。text を文字列に分割し、各文字の N-gram 特徴を返す。
List<NgramFeature> Function(String) featurer(
  int nBuckets,
  int size,
  int offset,
) {
  final prefix = _markers.sublist(0, offset);
  final suffix = _markers.reversed.toList().sublist(0, offset);
  final h = hash(nBuckets);

  return (text) {
    // JS の text.normalize() (NFC) + [...source] (コードポイント) 相当。
    // サロゲートペアを1文字として扱うようコードポイント単位で分割する。
    final source = nfcNormalize(text);
    final chars = _codePoints(source);
    final lowerChars = _codePoints(source.toLowerCase());
    final charsWithMarkers = [...prefix, ...lowerChars, ...suffix];
    final typesWithMarkers = [...prefix, ...chars.map(getCharType), ...suffix];
    final ngramByChars = ngram(charsWithMarkers);
    final ngramByTypes = ngram(typesWithMarkers);

    return List.generate(chars.length, (i) {
      final index = i + offset;
      final features = <NgramFeatureItem>[];
      for (var s = 1; s <= size; s++) {
        for (var o = -offset; o <= offset + 1 - s; o++) {
          final t = ngramByTypes(index)(s, o);
          final hv = h(ngramByChars(index)(s, o));
          features
            ..add(NgramFeatureItem(kind: 'type', size: s, offset: o, value: t))
            ..add(NgramFeatureItem(kind: 'hash', size: s, offset: o, value: hv));
        }
      }
      return NgramFeature(char: chars[i], features: features);
    });
  };
}

/// 文字列をコードポイント単位 (サロゲートペア対応) に分割する。
List<String> _codePoints(String s) {
  if (s.isEmpty) return const [];
  final result = <String>[];
  final runes = s.runes;
  for (final r in runes) {
    result.add(String.fromCharCode(r));
  }
  return result;
}

final List<NgramFeature> Function(String) features = featurer(
  wakachigakiNBuckets,
  wakachigakiSize,
  wakachigakiOffset,
);