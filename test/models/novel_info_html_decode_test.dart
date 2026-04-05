import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_info.dart';

void main() {
  group('NovelInfo HTMLエスケープデコード', () {
    test('titleにHTMLエンティティを含むJSONを正しくデコードできる', () {
      final json = {
        'title': '&quot;タイトル&quot;',
        'ncode': 'n1234',
        'writer': '作者&amp;テスト',
        'story': '&lt;あらすじ&gt;',
        'keyword': 'キーワード&quot;1&quot;,&quot;2&quot;',
      };

      final novelInfo = NovelInfo.fromJson(json);

      expect(novelInfo.title, '"タイトル"');
      expect(novelInfo.writer, '作者&テスト');
      expect(novelInfo.story, '<あらすじ>');
      expect(novelInfo.keyword, 'キーワード"1","2"');
    });

    test('エンティティを含まない文字列はそのまま', () {
      final json = {
        'title': '普通のタイトル',
        'ncode': 'n1234',
        'writer': '普通の作者',
      };

      final novelInfo = NovelInfo.fromJson(json);

      expect(novelInfo.title, '普通のタイトル');
      expect(novelInfo.writer, '普通の作者');
    });

    test('nullのフィールドはnullのまま', () {
      final json = {
        'ncode': 'n1234',
      };

      final novelInfo = NovelInfo.fromJson(json);

      expect(novelInfo.title, null);
      expect(novelInfo.writer, null);
      expect(novelInfo.story, null);
      expect(novelInfo.keyword, null);
    });
  });
}
