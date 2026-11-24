import 'package:flutter_test/flutter_test.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/utils/tategaki_converter.dart';
import 'package:tategaki/tategaki.dart';

void main() {
  group('TategakiConverter with ruby control', () {
    test('convertはisRubyEnabledがtrueのときルビを含む', () {
      final elements = <NovelContentElement>[
        const PlainText('これは'),
        const RubyText('テスト', 'てすと'),
        const PlainText('です。'),
      ];

      final result = TategakiConverter.convert(elements);

      // RubyTextがTategakiRubyとして変換されていることを確認
      final rubyElements = result.whereType<TategakiRuby>();

      expect(rubyElements, hasLength(1));
      expect(rubyElements.first.base, equals('テスト'));
      expect(rubyElements.first.ruby, equals('てすと'));
    });

    test('convertはisRubyEnabledがfalseのときルビを除外', () {
      final elements = <NovelContentElement>[
        const PlainText('これは'),
        const RubyText('テスト', 'てすと'),
        const PlainText('です。'),
      ];

      final result = TategakiConverter.convert(elements, isRubyEnabled: false);

      // RubyTextがPlainTextとして変換されていることを確認（TategakiRubyが存在しない）
      final rubyElements = result.whereType<TategakiRuby>();

      expect(rubyElements, hasLength(0));
    });

    test('convertはルビ設定に関わらずNewLine要素を保持する', () {
      final elements = <NovelContentElement>[
        const PlainText('行1'),
        const NewLine(),
        const PlainText('行2'),
      ];

      final resultWithRuby = TategakiConverter.convert(elements);
      final resultWithoutRuby = TategakiConverter.convert(
        elements,
        isRubyEnabled: false,
      );

      // NewLineの数が同じことを確認
      final newLinesWithRuby = resultWithRuby.whereType<TategakiNewLine>();
      final newLinesWithoutRuby = resultWithoutRuby
          .whereType<TategakiNewLine>();

      expect(newLinesWithRuby.length, equals(newLinesWithoutRuby.length));
      expect(newLinesWithRuby.length, equals(1));
    });

    test('convertは複数のルビ要素を正しく処理する', () {
      final elements = <NovelContentElement>[
        const RubyText('漢字', 'かんじ'),
        const PlainText('と'),
        const RubyText('平仮名', 'ひらがな'),
      ];

      // ルビ有効
      final resultWithRuby = TategakiConverter.convert(elements);
      final rubyElementsWithRuby = resultWithRuby.whereType<TategakiRuby>();
      expect(rubyElementsWithRuby, hasLength(2));

      // ルビ無効
      final resultWithoutRuby = TategakiConverter.convert(
        elements,
        isRubyEnabled: false,
      );
      final rubyElementsWithoutRuby = resultWithoutRuby
          .whereType<TategakiRuby>();
      expect(rubyElementsWithoutRuby, hasLength(0));
    });
  });
}
