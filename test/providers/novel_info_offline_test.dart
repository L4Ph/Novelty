import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart' as db;
import 'package:novelty/models/novel_info.dart';
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
          appDatabaseProvider.overrideWithValue(mockDatabase),
          apiServiceProvider.overrideWithValue(mockApiService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    const testNcode = 'N1234AB';
    final normalizedNcode = testNcode.toNormalizedNcode();

    test('novelInfoProvider should return cached data if API fails', () async {
      // Simulate API failure (Offline)
      when(mockApiService.fetchNovelInfo(normalizedNcode))
          .thenThrow(Exception('Network Error'));

      // Simulate Cached data exists
      when(mockDatabase.getNovel(normalizedNcode))
          .thenAnswer((_) async => db.Novel(
                ncode: normalizedNcode,
                title: 'Cached Title',
                generalAllNo: 10,
              ));

      final result = await container.read(novelInfoProvider(testNcode).future);

      expect(result.title, equals('Cached Title'));
      expect(result.generalAllNo, equals(10));
      // verify that we tried to fetch from DB
      verify(mockDatabase.getNovel(normalizedNcode)).called(1);
    });

    test('novelInfoWithCacheProvider should return cached data if API fails', () async {
      // Simulate API failure (Offline)
      when(mockApiService.fetchNovelInfo(normalizedNcode))
          .thenThrow(Exception('Network Error'));

      // Simulate Cached data exists
      when(mockDatabase.getNovel(normalizedNcode))
          .thenAnswer((_) async => db.Novel(
                ncode: normalizedNcode,
                title: 'Cached Title',
                generalAllNo: 10,
              ));

      final result = await container.read(novelInfoWithCacheProvider(testNcode).future);

      expect(result.title, equals('Cached Title'));
      expect(result.generalAllNo, equals(10));
      // verify that we tried to fetch from DB
      verify(mockDatabase.getNovel(normalizedNcode)).called(1);
    });
  });
}
