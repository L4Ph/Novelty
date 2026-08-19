import 'package:test/test.dart';
import 'package:wakachigaki/wakachigaki.dart';

void main() {
  group('nfcNormalize', () {
    test('濁点の結合文字を合成する', () {
      // か + U+3099 -> が
      expect(nfcNormalize('か\u3099'), 'が');
      // き + 濁点 -> ぎ
      expect(nfcNormalize('き\u3099'), 'ぎ');
    });

    test('半濁点の結合文字を合成する', () {
      // は + U+309A -> ぱ
      expect(nfcNormalize('は\u309a'), 'ぱ');
      // ひ + 半濁点 -> ぴ
      expect(nfcNormalize('ひ\u309a'), 'ぴ');
    });

    test('既に合成済みの基底はそのまま、結合文字は残す', () {
      // が + 濁点: 合成ターゲットが無いため結合文字を独立1文字として残す
      expect(nfcNormalize('が\u3099'), 'が\u3099');
      // ぱ + 半濁点
      expect(nfcNormalize('ぱ\u309a'), 'ぱ\u309a');
    });

    test('カタカナも合成する', () {
      expect(nfcNormalize('カ\u3099'), 'ガ');
      expect(nfcNormalize('ウ\u3099'), 'ヴ');
      expect(nfcNormalize('ハ\u309a'), 'パ');
    });

    test('合成対象でない結合文字は触らない', () {
      expect(nfcNormalize('あ\u3099'), 'あ\u3099');
      expect(nfcNormalize('A\u3099B'), 'A\u3099B');
    });
  });

  group('code-point 単位の分かち書き', () {
    test('サロゲートペア(絵文字/異体字)を1文字として扱う', () {
      // 𠮷 = U+20BB7 (サロゲートペア)
      expect(tokenize('𠮷野家で食べる'), ['𠮷野家', 'で', '食べる']);
      // 𐐀 = D801 DC00 (デザレット文字)
      expect(tokenize('𐐀'), ['𐐀']);
    });

    test('NFC 合成により結合文字が検索トークンに影響しない', () {
      // おか + 濁点を NFC で合成 -> おが として1要素に
      expect(tokenize('おか\u3099'), ['おが']);
      // か + 濁点 -> が
      expect(tokenize('か\u3099'), ['が']);
    });

    test('結合文字が独立して残る場合も境界判定が参照と一致する', () {
      // が + 濁点 (合成対象なし) -> 結合文字が独立して残る
      expect(tokenize('が\u3099'), ['が', '\u3099']);
    });
  });
}
