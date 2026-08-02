import 'dart:io';

import 'package:kakuyomu_parser/kakuyomu_parser.dart';
import 'package:test/test.dart';

void main() {
  group('parseKakuyomuEpisodeBody', () {
    test('段落テキストをパースし、末尾に改行が付与される', () {
      const html = '<p>　炎の海と土の津波が眼前を覆っていた。</p>';

      final result = parseKakuyomuEpisodeBody(html);

      expect(result, hasLength(2));
      expect(
        result[0],
        isA<PlainText>()
            .having((e) => e.text, 'text', '炎の海と土の津波が眼前を覆っていた。'),
      );
      expect(result[1], isA<NewLine>());
    });

    test('ルビ付きテキストを rubyText としてパースする', () {
      const html = '<p>その頂点に座する蛮行を、' //
          '<ruby><rb>熾天使</rb><rp>（</rp><rt>セラフ</rt><rp>）</rp></ruby>' //
          'の名に置き断罪する。</p>';

      final result = parseKakuyomuEpisodeBody(html);

      expect(result, hasLength(4));
      expect(
        result[0],
        isA<PlainText>().having((e) => e.text, 'text', 'その頂点に座する蛮行を、'),
      );
      expect(
        result[1],
        isA<RubyText>()
            .having((e) => e.base, 'base', '熾天使')
            .having((e) => e.ruby, 'ruby', 'セラフ'),
      );
      expect(
        result[2],
        isA<PlainText>().having((e) => e.text, 'text', 'の名に置き断罪する。'),
      );
      expect(result[3], isA<NewLine>());
    });

    test('blank段落は改行要素1つになる', () {
      const html = '<p class="blank"><br /></p>';

      final result = parseKakuyomuEpisodeBody(html);

      expect(result, hasLength(1));
      expect(result[0], isA<NewLine>());
    });

    test('段落内のbrは改行要素になる', () {
      const html = '<p>一行目<br />二行目</p>';

      final result = parseKakuyomuEpisodeBody(html);

      expect(
        result,
        containsAllInOrder(<Matcher>[
          isA<PlainText>().having((e) => e.text, 'text', '一行目'),
          isA<NewLine>(),
          isA<PlainText>().having((e) => e.text, 'text', '二行目'),
          isA<NewLine>(),
        ]),
      );
    });

    test('複数段落は段落ごとに改行が付与される', () {
      const html = '<p>一つ目</p><p class="blank"><br /></p><p>二つ目</p>';

      final result = parseKakuyomuEpisodeBody(html);

      expect(
        result,
        containsAllInOrder(<Matcher>[
          isA<PlainText>().having((e) => e.text, 'text', '一つ目'),
          isA<NewLine>(),
          isA<NewLine>(),
          isA<PlainText>().having((e) => e.text, 'text', '二つ目'),
          isA<NewLine>(),
        ]),
      );
    });

    test('widget-episodeBody を含む完全なページHTMLから本文を抽出できる', () {
      const html = '<html><body>'
          ' <div class="widget-episodeBody js-episode-body">'
          ' <p id="p1">本文です。</p>'
          ' <p id="p2" class="blank"><br /></p>'
          ' <p id="p3">続きです。</p>'
          ' </div></body></html>';

      final result = parseKakuyomuEpisodeBody(html);

      expect(
        result.map((e) => e.toString()).join('|'),
        contains('本文です。'),
      );
      expect(result.whereType<NewLine>(), hasLength(3));
    });

    test('実HTMLフィクスチャを正しくパースできる', () {
      final html = File('test/fixtures/episode_body.html').readAsStringSync();

      final result = parseKakuyomuEpisodeBody(html);

      // 先頭: 1段落目テキスト + 改行
      expect(
        result[0],
        isA<PlainText>()
            .having((e) => e.text, 'text', '炎の海と土の津波が眼前を覆っていた。'),
      );
      expect(result[1], isA<NewLine>());

      // 2段落目（blank）: 改行
      expect(result[3], isA<NewLine>());

      // 4段落目（p6）: ルビが含まれる
      final ruby = result.whereType<RubyText>().first;
      expect(ruby.base, '熾天使');
      expect(ruby.ruby, 'セラフ');

      // 末尾は最後の段落の改行
      expect(result.last, isA<NewLine>());
      // 空の結果ではない
      expect(result.length, greaterThan(20));
    });
  });
}
