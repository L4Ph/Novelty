import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/novel_search_result.dart';
import 'package:novelty/providers/author_novels_provider.dart';
import 'package:novelty/services/api_service.dart';

import 'author_novels_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('AuthorNovelsProvider', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    test('userIdで検索クエリが正しく構築される', () {
      const userId = 12345;
      const query = NovelSearchQuery(userid: [userId]);

      expect(query.userid, equals(const [userId]));
    });

    test('useridパラメータがtoMapで正しく変換される', () {
      const userId = 12345;
      const query = NovelSearchQuery(userid: [userId]);
      final map = query.toMap();

      expect(map['userid'], equals('12345'));
    });

    test('ApiServiceをモックしてProviderが正しく動作する', () async {
      const userId = 12345;
      final expectedNovels = [
        const NovelInfo(
          title: 'Test Novel',
          ncode: 'n1234',
          writer: 'Author Name',
          userId: userId,
        ),
      ];

      when(
        mockApiService.searchNovels(any),
      ).thenAnswer(
        (_) async => NovelSearchResult(
          allCount: 1,
          novels: expectedNovels,
        ),
      );

      final container = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(
        authorNovelsProvider(userId).future,
      );

      expect(result.length, equals(1));
      expect(result.first.title, equals('Test Novel'));
      expect(result.first.userId, equals(userId));

      final capturedQuery =
          verify(
                mockApiService.searchNovels(captureAny),
              ).captured.single
              as NovelSearchQuery;
      expect(capturedQuery.userid, equals(const [userId]));
    });
  });
}
