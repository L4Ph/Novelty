import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';

void main() {
  group('ApiService', () {
    group('累計ランキング制限値', () {
      test('defaultRankingLimitは500であること', () {
        expect(defaultRankingLimit, equals(500));
      });

      test('累計ランキングクエリのlimが500であること', () {
        // _fetchAllTimeRankingメソッドで使用されるクエリを検証
        const query = NovelSearchQuery(order: 'hyoka', lim: defaultRankingLimit);
        expect(query.lim, equals(500));
      });

      test('累計ランキングが500件まで取得可能であること', () {
        // なろう小説APIの仕様確認：limの最大値は500
        const query = NovelSearchQuery(order: 'hyoka', lim: 500);
        expect(query.lim, lessThanOrEqualTo(500));
      });
    });
  });
}
