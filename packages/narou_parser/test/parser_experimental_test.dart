import 'package:narou_parser/experimental.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:test/test.dart';

void main() {
  group('parseNovelContentFast (Experimental)', () {
    test('基本的なHTMLを正しくパースできるか', () {
      const html = '''
<p>
これはテストです。
<ruby><rb>山田</rb><rt>やまだ</rt></ruby>太郎。
<br>
改行も入ります。
</p>
''';
      final result = parseNovelContentFast(html);

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
      final result = parseNovelContentFast(html);

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
      final result = parseNovelContentFast(html);

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
      final fastResult = parseNovelContentFast(html);

      expect(fastResult.length, domResult.length);
      for (var i = 0; i < fastResult.length; i++) {
        expect(fastResult[i].runtimeType, domResult[i].runtimeType);
        if (fastResult[i] is PlainText) {
          expect(
            (fastResult[i] as PlainText).text,
            (domResult[i] as PlainText).text,
          );
        } else if (fastResult[i] is RubyText) {
          expect(
            (fastResult[i] as RubyText).base,
            (domResult[i] as RubyText).base,
          );
          expect(
            (fastResult[i] as RubyText).ruby,
            (domResult[i] as RubyText).ruby,
          );
        }
      }
    });
  });
}
