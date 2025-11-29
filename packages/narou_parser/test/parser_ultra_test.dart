import 'package:narou_parser/narou_parser.dart';
import 'package:test/test.dart';

void main() {
  group('parseNovelContentUltra (Experimental/Scanner)', () {
    test('基本的なHTMLを正しくパースできるか', () {
      const html = '''
<p>
これはテストです。
<ruby><rb>山田</rb><rt>やまだ</rt></ruby>太郎。
<br>
改行も入ります。
</p>
''';
      final result = parseNovelContentUltra(html);

      expect(result, hasLength(6));
      expect(
        result[0],
        isA<PlainText>().having((e) => e.text, 'text', 'これはテストです。'),
      );
      expect(
        result[1],
        isA<RubyText>()
            .having((e) => e.base, 'base', '山田')
            .having((e) => e.ruby, 'ruby', 'やまだ'),
      );
      expect(
        result[2],
        isA<PlainText>().having((e) => e.text, 'text', '太郎。'),
      );
      expect(result[3], isA<NewLine>());
      expect(
        result[4],
        isA<PlainText>().having((e) => e.text, 'text', '改行も入ります。'),
      );
      expect(result[5], isA<NewLine>());
    });

    test('実体参照のデコード', () {
      const html = '<p>&lt; &gt; &amp; &quot; &nbsp;</p>';
      final result = parseNovelContentUltra(html);

      expect(result.first, isA<PlainText>());
      final text = (result.first as PlainText).text;
      expect(text, '< > & "  ');
    });

    test('複雑なルビタグが混在している場合', () {
      const html = '''
<p>
<ruby><rb>漢字</rb><rt>かんじ</rt></ruby>と<ruby><rb>単語</rb><rt>たんご</rt></ruby>が混在する文章。
</p>
''';
      final result = parseNovelContentUltra(html);

      expect(result, hasLength(5));
      expect(
        result[0],
        isA<RubyText>().having((e) => e.base, 'base', '漢字'),
      );
      expect(result[1], isA<PlainText>().having((e) => e.text, 'text', 'と'));
      expect(
        result[2],
        isA<RubyText>().having((e) => e.base, 'base', '単語'),
      );
      expect(
        result[3],
        isA<PlainText>().having((e) => e.text, 'text', 'が混在する文章。'),
      );
      expect(result[4], isA<NewLine>());
    });

    test('DOMパーサーとの互換性チェック', () {
      const html = '<p>テスト<br>です<ruby>ルビ<rt>るび</rt></ruby></p>';
      final domResult = parseNovelContent(html);
      final ultraResult = parseNovelContentUltra(html);

      expect(ultraResult.length, domResult.length);
      for (var i = 0; i < ultraResult.length; i++) {
        expect(ultraResult[i].runtimeType, domResult[i].runtimeType);
        if (ultraResult[i] is PlainText) {
          expect(
            (ultraResult[i] as PlainText).text,
            (domResult[i] as PlainText).text,
          );
        } else if (ultraResult[i] is RubyText) {
          expect(
            (ultraResult[i] as RubyText).base,
            (domResult[i] as RubyText).base,
          );
          expect(
            (ultraResult[i] as RubyText).ruby,
            (domResult[i] as RubyText).ruby,
          );
        }
      }
    });

    test('rpタグ除去の確認', () {
      const html = '<p><ruby>漢<rp>(</rp><rt>かん</rt><rp>)</rp></ruby></p>';
      final result = parseNovelContentUltra(html);
      expect(result, hasLength(2)); // RubyText + NewLine
      expect(
        result[0],
        isA<RubyText>()
            .having((e) => e.base, 'base', '漢')
            .having((e) => e.ruby, 'ruby', 'かん'),
      );
      expect(result[1], isA<NewLine>());
    });
  });
}
