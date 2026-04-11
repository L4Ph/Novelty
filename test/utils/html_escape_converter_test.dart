import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/utils/html_escape_converter.dart';

void main() {
  group('HtmlEscapeConverter', () {
    const converter = HtmlEscapeConverter();

    group('基本的なHTMLエンティティのデコード', () {
      test('&quot;を"に変換できる', () {
        expect(converter.fromJson('&quot;'), '"');
      });

      test('&amp;を&に変換できる', () {
        expect(converter.fromJson('&amp;'), '&');
      });

      test('&lt;を<に変換できる', () {
        expect(converter.fromJson('&lt;'), '<');
      });

      test('&gt;を>に変換できる', () {
        expect(converter.fromJson('&gt;'), '>');
      });

      test('&nbsp;を半角スペースに変換できる', () {
        expect(converter.fromJson('&nbsp;'), ' ');
      });
    });

    group('複合的な変換', () {
      test('複数のエンティティが含まれる文字列を変換できる', () {
        expect(
          converter.fromJson('&quot;タイトル&quot; &amp; サブタイトル'),
          '"タイトル" & サブタイトル',
        );
      });

      test('HTMLタグ風の文字列を変換できる', () {
        expect(
          converter.fromJson('&lt;div&gt;内容&lt;/div&gt;'),
          '<div>内容</div>',
        );
      });
    });

    group('エッジケース', () {
      test('エンティティを含まない文字列はそのまま返す', () {
        expect(converter.fromJson('普通のタイトル'), '普通のタイトル');
      });

      test('空文字列はそのまま返す', () {
        expect(converter.fromJson(''), '');
      });

      test('nullはnullのまま返す', () {
        expect(converter.fromJson(null), null);
      });
    });

    group('toJson', () {
      test('文字列はそのまま返す', () {
        expect(converter.toJson('テスト'), 'テスト');
      });

      test('nullはnullのまま返す', () {
        expect(converter.toJson(null), null);
      });
    });
  });
}
