import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_search_query.dart';

void main() {
  group('AuthorNovelsProvider', () {
    test('userIdで検索クエリが正しく構築される', () {
      const userId = 12345;
      final query = NovelSearchQuery(userid: const [userId]);

      expect(query.userid, equals(const [userId]));
    });

    test('useridパラメータがtoMapで正しく変換される', () {
      const userId = 12345;
      final query = NovelSearchQuery(userid: const [userId]);
      final map = query.toMap();

      expect(map['userid'], equals('12345'));
    });
  });
}
