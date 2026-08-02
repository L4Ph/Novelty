import 'dart:convert';

import 'package:novel_parser_core/novel_parser_core.dart';
import 'package:test/test.dart';

void main() {
  group('NovelContentElement', () {
    test('plainText が JSON シリアライズ往復できる', () {
      final element = PlainText('これはテストです。');
      final json = jsonEncode(element.toJson());
      final decoded = NovelContentElement.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );

      expect(decoded, isA<PlainText>());
      expect((decoded as PlainText).text, 'これはテストです。');
    });

    test('rubyText が JSON シリアライズ往復できる', () {
      final element = RubyText('山田', 'やまだ');
      final json = jsonEncode(element.toJson());
      final decoded = NovelContentElement.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );

      expect(decoded, isA<RubyText>());
      expect((decoded as RubyText).base, '山田');
      expect(decoded.ruby, 'やまだ');
    });

    test('newLine が JSON シリアライズ往復できる', () {
      final element = NewLine();
      final json = jsonEncode(element.toJson());
      final decoded = NovelContentElement.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );

      expect(decoded, isA<NewLine>());
    });

    test('ファクトリから生成した要素も JSON シリアライズ往復できる', () {
      final element = NovelContentElement.plainText('テスト');
      final json = jsonEncode(element.toJson());
      final decoded = NovelContentElement.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );

      expect(decoded, isA<PlainText>());
      expect((decoded as PlainText).text, 'テスト');
    });

    test('リストを JSON 文字列に変換して戻せる', () {
      final elements = <NovelContentElement>[
        NovelContentElement.plainText('テスト'),
        NovelContentElement.newLine(),
      ];
      final jsonString = elements.toJsonString();
      final decoded = (jsonDecode(jsonString) as List<dynamic>)
          .map((e) => NovelContentElement.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(decoded, hasLength(2));
      expect(decoded[0], isA<PlainText>());
      expect(decoded[1], isA<NewLine>());
    });
  });
}
