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

    test('kenten が JSON シリアライズ往復できる', () {
      final element = Kenten('重要', '﹅');
      final json = jsonEncode(element.toJson());
      final decoded = NovelContentElement.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );

      expect(decoded, isA<Kenten>());
      expect((decoded as Kenten).base, '重要');
      expect(decoded.mark, '﹅');
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

    test('serialises each variant to the persisted shape', () {
      // This is the on-disk shape. Changing it silently would make every
      // already-downloaded episode unreadable, so pin the exact keys.
      // The discriminator is the factory name, not the class name.
      expect(PlainText('a').toJson(), <String, Object?>{
        'text': 'a',
        'runtimeType': 'plainText',
      });
      expect(RubyText('山田', 'やまだ').toJson(), <String, Object?>{
        'base': '山田',
        'ruby': 'やまだ',
        'runtimeType': 'rubyText',
      });
      expect(Kenten('重要', '﹅').toJson(), <String, Object?>{
        'base': '重要',
        'mark': '﹅',
        'runtimeType': 'kenten',
      });
      expect(NewLine().toJson(), <String, Object?>{'runtimeType': 'newLine'});
    });

    test('reads a literal stored by a released version', () {
      // Not generated here: a stored string, so that a rewrite of the model
      // cannot quietly stop parsing existing rows.
      const stored =
          '[{"text":"本文","runtimeType":"plainText"},'
          '{"base":"山田","ruby":"やまだ","runtimeType":"rubyText"},'
          '{"base":"重要","mark":"﹅","runtimeType":"kenten"},'
          '{"runtimeType":"newLine"}]';

      final decoded = (jsonDecode(stored) as List<dynamic>)
          .map((e) => NovelContentElement.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(decoded, hasLength(4));
      expect(decoded[0], isA<PlainText>());
      expect((decoded[0] as PlainText).text, '本文');
      expect((decoded[1] as RubyText).ruby, 'やまだ');
      expect((decoded[2] as Kenten).mark, '﹅');
      expect(decoded[3], isA<NewLine>());
      // Round-tripping the stored value must produce the same shape again.
      expect(
        decoded.map((e) => e.toJson()).toList(),
        (jsonDecode(stored) as List<dynamic>).cast<Map<String, dynamic>>(),
      );
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
