import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/utils/html_escape_converter.dart';

void main() {
  group('HtmlEscapeConverter エッジケース', () {
    const converter = HtmlEscapeConverter();

    group('数値参照', () {
      test('十進数値参照 &#34; を " に変換できる', () {
        expect(converter.fromJson('&#34;'), '"');
      });

      test('十進数値参照 &#38; を & に変換できる', () {
        expect(converter.fromJson('&#38;'), '&');
      });

      test('十進数値参照 &#60; を < に変換できる', () {
        expect(converter.fromJson('&#60;'), '<');
      });

      test('十進数値参照 &#62; を > に変換できる', () {
        expect(converter.fromJson('&#62;'), '>');
      });

      test('十進数値参照 &#160; を ノーブレークスペース に変換できる', () {
        // &#160; はノーブレークスペース（U+00A0）
        expect(converter.fromJson('&#160;'), '\u00A0');
      });

      test('十六進数値参照 &#x22; を " に変換できる', () {
        expect(converter.fromJson('&#x22;'), '"');
      });

      test('十六進数値参照 &#x26; を & に変換できる', () {
        expect(converter.fromJson('&#x26;'), '&');
      });

      test('十六進数値参照 &#x3C; を < に変換できる', () {
        expect(converter.fromJson('&#x3C;'), '<');
      });

      test('十六進数値参照 &#x3E; を > に変換できる', () {
        expect(converter.fromJson('&#x3E;'), '>');
      });

      test('十六進数値参照（大文字X） &#X22; を " に変換できる', () {
        expect(converter.fromJson('&#X22;'), '"');
      });

      test('複数の数値参照を同時に変換できる', () {
        expect(
          converter.fromJson('&#34;タイトル&#34; &#38; サブタイトル'),
          '"タイトル" & サブタイトル',
        );
      });
    });

    group('大文字小文字混在', () {
      test('大文字 QUOT を " に変換できる', () {
        expect(converter.fromJson('&QUOT;'), '"');
      });

      test('混在 &Quot; を " に変換できる', () {
        expect(converter.fromJson('&Quot;'), '"');
      });

      test('大文字 AMP を & に変換できる', () {
        expect(converter.fromJson('&AMP;'), '&');
      });

      test('大文字小文字混在の複数エンティティ', () {
        expect(
          converter.fromJson('&QUOT;タイトル&quot; &AMP; &amp;'),
          '"タイトル" & &',
        );
      });
    });

    group('不完全なエンティティ', () {
      test('不完全なエンティティ &qu はそのまま', () {
        expect(converter.fromJson('&qu'), '&qu');
      });

      test('不完全なエンティティ & はそのまま', () {
        expect(converter.fromJson('テスト&テスト'), 'テスト&テスト');
      });

      test('不完全な数値参照 &# はそのまま', () {
        expect(converter.fromJson('テスト&#テスト'), 'テスト&#テスト');
      });

      test('不完全な数値参照 &#x はそのまま', () {
        expect(converter.fromJson('テスト&#xテスト'), 'テスト&#xテスト');
      });
    });

    group('特殊ケース', () {
      test('空文字列はそのまま返す', () {
        expect(converter.fromJson(''), '');
      });

      test('空白のみの文字列はそのまま返す', () {
        expect(converter.fromJson('   '), '   ');
      });

      test('エンティティのみの文字列', () {
        expect(converter.fromJson('&quot;&amp;&lt;'), '"&<');
      });

      test('連続する同じエンティティ', () {
        expect(converter.fromJson('&quot;&quot;&quot;'), '"""');
      });

      test('文字列の先頭にエンティティ', () {
        expect(converter.fromJson('&quot;先頭'), '"先頭');
      });

      test('文字列の末尾にエンティティ', () {
        expect(converter.fromJson('末尾&quot;'), '末尾"');
      });

      test('絵文字とUnicode混在', () {
        expect(
          converter.fromJson('🎌&quot;日本語&quot;🎌'),
          '🎌"日本語"🎌',
        );
      });

      test('特殊文字との組み合わせ', () {
        expect(
          converter.fromJson('テスト\n&quot;\t&amp;'),
          'テスト\n"\t&',
        );
      });

      test('日本語を含む文字列', () {
        expect(
          converter.fromJson('「&quot;タイトル&quot;」と&quot;作者&quot;'),
          '「"タイトル"」と"作者"',
        );
      });

      test('長い文字列でも正しく変換できる', () {
        final longString = '&quot;' * 1000;
        final result = converter.fromJson(longString);
        expect(result, '"' * 1000);
      });
    });

    group('toJson', () {
      test('文字列はそのまま返す', () {
        expect(converter.toJson('テスト'), 'テスト');
      });

      test('エンティティを含む文字列もそのまま返す', () {
        expect(converter.toJson('&quot;テスト&quot;'), '&quot;テスト&quot;');
      });

      test('nullはnullのまま返す', () {
        expect(converter.toJson(null), null);
      });
    });
  });
}
