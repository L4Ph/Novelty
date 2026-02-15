import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';

void main() {
  group('NovelInfo', () {
    test('コンストラクタでフィールドが正しく初期化される', () {
      final novel = NovelInfo(
        title: 'Test Novel',
        ncode: 'n1234',
        writer: 'Author',
        story: 'Story summary',
        novelType: 1,
        end: 0,
        generalAllNo: 100,
        genre: 1,
        keyword: 'fantasy',
        generalFirstup: '2024-01-01 00:00:00',
        generalLastup: '2024-01-15 12:00:00',
        globalPoint: 10000,
        dailyPoint: 100,
        weeklyPoint: 500,
        monthlyPoint: 2000,
        quarterPoint: 5000,
        yearlyPoint: 10000,
        favNovelCnt: 500,
        impressionCnt: 100,
        reviewCnt: 50,
        allPoint: 3000,
        allHyokaCnt: 200,
        sasieCnt: 10,
        kaiwaritu: 30,
        novelupdatedAt: 1705315200,
        updatedAt: 1705315200,
        episodes: const [],
        isr15: 0,
        isbl: 0,
        isgl: 0,
        iszankoku: 0,
        istensei: 0,
        istenni: 0,
      );

      expect(novel.title, equals('Test Novel'));
      expect(novel.ncode, equals('n1234'));
      expect(novel.writer, equals('Author'));
      expect(novel.novelType, equals(1));
      expect(novel.end, equals(0));
      expect(novel.generalAllNo, equals(100));
      expect(novel.globalPoint, equals(10000));
    });

    test('copyWithでフィールドを変更できる', () {
      final novel = NovelInfo(title: 'Original', ncode: 'n1234');

      final updated = novel.copyWith(title: 'Updated', globalPoint: 5000);

      expect(updated.title, equals('Updated'));
      expect(updated.ncode, equals('n1234'));
      expect(updated.globalPoint, equals(5000));
    });

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

    test('同じ値を持つインスタンスは等価', () {
      final novel1 = NovelInfo(
        title: 'Test',
        ncode: 'n1234',
        globalPoint: 1000,
      );
      final novel2 = NovelInfo(
        title: 'Test',
        ncode: 'n1234',
        globalPoint: 1000,
      );

      expect(novel1, equals(novel2));
      expect(novel1.hashCode, equals(novel2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      final novel1 = NovelInfo(title: 'Test1', ncode: 'n1234');
      final novel2 = NovelInfo(title: 'Test2', ncode: 'n1234');

      expect(novel1, isNot(equals(novel2)));
    });
  });
}
