import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wakachigaki/wakachigaki.dart';

void main() {
  group('wakachigaki feature', () {
    test('getCharType が yuhsak の規則と一致する', () {
      expect(getCharType('漢'), 'C');
      // 漢数字は NumeralKanji 優先（後勝ち）
      expect(getCharType('一'), 'S');
      expect(getCharType('あ'), 'H');
      expect(getCharType('ァ'), 'K');
      expect(getCharType('A'), 'A');
      expect(getCharType('1'), 'N');
      expect(getCharType('。'), 'O');
    });
  });

  group('wakachigaki hash', () {
    test('CRC32 が標準ベクタと一致する', () {
      // IEEE CRC-32 の既知のテストベクタ: CRC32("123456789") == 0xCBF43926
      expect(crc32(Uint8List.fromList(utf8.encode('123456789'))), 0xCBF43926);
    });

    test('CRC32 ハッシュが決定的で nBuckets 範囲に収まる', () {
      final h = hash(262144);
      final a = h('非常に');
      expect(a, isNotEmpty);
      expect(a.length <= 6, isTrue); // 16進、262144=0x40000 未満
      expect(h('非常に'), a); // 決定的
    });
  });

  group('wakachigaki tokenize', () {
    test('yuhsak README の例が再現される', () {
      // https://github.com/yuhsak/wakachigaki README の出力と一致させる
      expect(tokenize('非常に効果的な機械学習モデル'), [
        '非常',
        'に',
        '効果',
        '的',
        'な',
        '機械学習',
        'モデル',
      ]);
    });

    test('空文字は空リスト', () {
      expect(tokenize(''), isEmpty);
    });

    test('join すると原文に戻る', () {
      final text = 'ここでテキストを分かち書きします';
      expect(tokenize(text).join(''), text);
    });

    test('英語混じりも join で原文に戻る', () {
      final text = 'Noveltyは小説ビューアー';
      expect(tokenize(text).join(''), text);
    });

    test('魔法少女は一つのトークンになる', () {
      final tokens = tokenize('魔法少女は転生した');
      expect(tokens, contains('魔法少女'));
    });

    test('segment は tokenize と同一', () {
      expect(segment('非常に効果的な機械学習モデル'),
          tokenize('非常に効果的な機械学習モデル'));
    });
  });
}