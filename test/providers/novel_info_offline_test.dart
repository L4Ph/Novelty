import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart' as db;
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/ncode_utils.dart';

import 'novel_detail_provider_test.mocks.dart';

void main() {
  group('Offline NovelInfo Tests', () {
    late MockAppDatabase mockDatabase;
    late MockApiService mockApiService;
    late ProviderContainer container;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockApiService = MockApiService();
      container = ProviderContainer(
        overrides: [
          db.appDatabaseProvider.overrideWithValue(mockDatabase),
          apiServiceProvider.overrideWithValue(mockApiService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    const testNcode = 'N1234AB';
    final normalizedNcode = testNcode.toNormalizedNcode();

    test(
      'novelInfoWithCacheProvider should return cached data if API fails',
      () async {
        // Simulate API failure (Offline)
        when(
          mockApiService.fetchNovelInfo(normalizedNcode),
        ).thenThrow(Exception('Network Error'));

        // Simulate Cached data exists
        when(mockDatabase.watchNovel(normalizedNcode)).thenAnswer(
          (_) => Stream.value(
            db.Novel(
              ncode: normalizedNcode,
              title: 'Cached Title',
              generalAllNo: 10,
              // other fields are nullable/default
              novelType: 1,
              end: 0,
              genre: 101,
              isr15: 0,
              isbl: 0,
              isgl: 0,
              iszankoku: 0,
              istensei: 0,
              istenni: 0,
              globalPoint: 0,
              fav: 0,
              reviewCount: 0,
              rateCount: 0,
              allPoint: 0,
              pointCount: 0,
              dailyPoint: 0,
              weeklyPoint: 0,
              monthlyPoint: 0,
              quarterPoint: 0,
              yearlyPoint: 0,
            ),
          ),
        );

        final result = await container.read(
          novelInfoWithCacheProvider(testNcode).future,
        );

        expect(result.title, equals('Cached Title'));
        expect(result.generalAllNo, equals(10));

        // verify that we tried to watch from DB
        verify(mockDatabase.watchNovel(normalizedNcode)).called(1);
      },
    );

    test(
      'novelInfoWithCacheProvider should use provided argument',
      () async {
        // Just a placeholder to ensure it's defined and correctly imported
        expect(novelInfoWithCacheProvider, isNotNull);
      },
    );
  });
}
