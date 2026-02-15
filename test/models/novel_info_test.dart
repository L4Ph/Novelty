import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_info.dart';

void main() {
  group('NovelInfo', () {
    test('fromJsonでJSONからインスタンスを生成できる', () {
      final json = {
        'title': 'Test Novel',
        'ncode': 'N1234AB',
        'writer': 'Author',
        'novel_type': '1',
        'end': '0',
        'general_all_no': '100',
        'genre': '1',
        'global_point': '10000',
      };

      final novel = NovelInfo.fromJson(json);

      expect(novel.title, equals('Test Novel'));
      expect(novel.ncode, equals('n1234ab'));
      expect(novel.novelType, equals(1));
      expect(novel.globalPoint, equals(10000));
    });

    test('toJsonでJSONに変換できる', () {
      final novel = NovelInfo(
        title: 'Test Novel',
        ncode: 'n1234',
        novelType: 1,
      );

      final json = novel.toJson();

      expect(json['title'], equals('Test Novel'));
      expect(json['ncode'], equals('n1234'));
    });

    test('toDbCompanionが正しく動作する', () {
      final novel = NovelInfo(
        ncode: 'n1234',
        title: 'Test Novel',
        writer: 'Author',
        novelType: 1,
        end: 0,
        genre: 1,
        generalAllNo: 100,
      );

      final companion = novel.toDbCompanion();

      expect(companion.ncode.value, equals('n1234'));
      expect(companion.title.value, equals('Test Novel'));
    });
  });
}
