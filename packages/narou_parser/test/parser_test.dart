import 'package:narou_parser/narou_parser.dart';
import 'package:test/test.dart';

void main() {
  group('parseNovelContent', () {
    test('基本的なHTMLを正しくパースできるか', () {
      const html = '''
<p>
これはテストです。
<ruby><rb>山田</rb><rt>やまだ</rt></ruby>太郎。
<br>
改行も入ります。
</p>
''';
      final result = parseNovelContent(html);

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

    test('空のHTMLを渡した場合に空のリストを返すか', () {
      const html = '';
      final result = parseNovelContent(html);
      expect(result, isEmpty);
    });

    test('複雑なルビタグが混在している場合', () {
      const html = '''
<p>
<ruby><rb>漢字</rb><rt>かんじ</rt></ruby>と<ruby><rb>単語</rb><rt>たんご</rt></ruby>が混在する文章。
</p>
''';
      final result = parseNovelContent(html);

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

    test('rpタグとrbタグなしのrubyを正しくパースできるか', () {
      const html = '<p><ruby>解放<rp>(</rp><rt>リリース</rt><rp>)</rp></ruby>する。</p>';
      final result = parseNovelContent(html);

      expect(result, hasLength(3));
      expect(
        result[0],
        isA<RubyText>()
            .having((e) => e.base, 'base', '解放')
            .having((e) => e.ruby, 'ruby', 'リリース'),
      );
      expect(
        result[1],
        isA<PlainText>().having((e) => e.text, 'text', 'する。'),
      );
      expect(result[2], isA<NewLine>());
    });
  });
}
