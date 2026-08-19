// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:novel_parser_core/novel_parser_core.dart';
import 'package:test/test.dart';

void main() {
  group('HybridConverter', () {
    test('空リストは txt 空文字と空 rb になる', () {
      final elements = <NovelContentElement>[];
      final jsonStr = elements.toHybridJson();
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      expect(decoded['txt'], '');
      expect(decoded['rb'], isEmpty);
      final roundTrip = HybridConverter.fromHybridJson(jsonStr);
      expect(roundTrip, isEmpty);
    });

    test('plainText のみが正しく変換される', () {
      final elements = <NovelContentElement>[
        NovelContentElement.plainText('こんにちは'),
      ];
      final jsonStr = elements.toHybridJson();
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      expect(decoded['txt'], 'こんにちは');
      expect(decoded['rb'], isEmpty);

      final roundTrip = HybridConverter.fromHybridJson(jsonStr);
      expect(roundTrip, hasLength(1));
      expect(roundTrip[0], isA<PlainText>());
      expect((roundTrip[0] as PlainText).text, 'こんにちは');
    });

    test(r'newLine は txt 内の \n として扱われる', () {
      final elements = <NovelContentElement>[
        NovelContentElement.plainText('A'),
        NovelContentElement.newLine(),
        NovelContentElement.plainText('B'),
      ];
      final jsonStr = elements.toHybridJson();
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      expect(decoded['txt'], 'A\nB');
      expect(decoded['rb'], isEmpty);

      final roundTrip = HybridConverter.fromHybridJson(jsonStr);
      expect(roundTrip, hasLength(3));
      expect(roundTrip[0], isA<PlainText>());
      expect(roundTrip[1], isA<NewLine>());
      expect(roundTrip[2], isA<PlainText>());
    });

    test('rubyText は txt に base が入り rb に off/base/ruby が入る', () {
      final elements = <NovelContentElement>[
        NovelContentElement.plainText('かくいう俺も、'),
        NovelContentElement.rubyText('前', '・'),
        NovelContentElement.rubyText('世', '・'),
        NovelContentElement.plainText('では'),
      ];
      final jsonStr = elements.toHybridJson();
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      // txt は base を連結したもの
      expect(decoded['txt'], 'かくいう俺も、前世では');
      final rb = decoded['rb'] as List;
      expect(rb, hasLength(2));
      expect(rb[0]['off'], 7); // "かくいう俺も、" 7文字の後
      expect(rb[0]['base'], '前');
      expect(rb[0]['ruby'], '・');
      expect(rb[1]['off'], 8);
      expect(rb[1]['base'], '世');

      final roundTrip = HybridConverter.fromHybridJson(jsonStr);
      expect(roundTrip, hasLength(4));
      expect(roundTrip[1], isA<RubyText>());
      expect((roundTrip[1] as RubyText).base, '前');
    });

    test('複合例が往復できる (docs/narou_html の抜粋)', () {
      final elements = <NovelContentElement>[
        NovelContentElement.plainText('人間、どんな清廉潔白'),
        NovelContentElement.newLine(),
        NovelContentElement.plainText('かくいう俺も、'),
        NovelContentElement.rubyText('前', '・'),
        NovelContentElement.rubyText('世', '・'),
        NovelContentElement.plainText('では'),
        NovelContentElement.newLine(),
        NovelContentElement.plainText('俺は悲劇のヒロインが好きだった。'),
      ];
      final jsonStr = elements.toHybridJson();
      final roundTrip = HybridConverter.fromHybridJson(jsonStr);
      expect(roundTrip, equals(elements));
    });

    test('off/base の検証でズレを検出できる', () {
      // 不正な off を持つ JSON を手作りして fromHybridJson が base と照合することを確認
      // 正しい txt に対して off がずれている場合は base と一致しないため、
      // 実装は txt.substring(off, off+base.length) == base を検証し、不一致なら補正または例外
      final jsonStr = jsonEncode({
        'txt': 'ABCDE',
        'rb': [
          {'off': 1, 'base': 'X', 'ruby': 'えっくす'}, // txt[1] は 'B' なのに base 'X'
        ],
      });
      // 実装方針: 不一致は例外または近傍探索で補正。ここでは例外を期待するか、補正後の要素が返ることを確認
      // 現段階では例外を投げることを期待
      expect(
        () => HybridConverter.fromHybridJson(jsonStr),
        throwsA(isA<FormatException>()),
      );
    });

    test('HybridConverter.fromHybridJson は旧 verbose JSON も読める（移行用）', () {
      // 旧形式: [{"text":"A","runtimeType":"plainText"}, {"runtimeType":"newLine"}]
      final oldJson = jsonEncode([
        {'text': 'テスト', 'runtimeType': 'plainText'},
        {'runtimeType': 'newLine'},
      ]);
      final elements = HybridConverter.fromHybridJson(oldJson);
      expect(elements, hasLength(2));
      expect(elements[0], isA<PlainText>());
      expect(elements[1], isA<NewLine>());
    });
  });
}
