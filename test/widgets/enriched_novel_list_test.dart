import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/domain/novel_enrichment.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/enriched_novel_list.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

import 'enriched_novel_list_test.mocks.dart';

@GenerateMocks([AppDatabase, ApiService])
void main() {
  late MockAppDatabase mockDb;
  late MockApiService mockApiService;

  // テスト用のダミーデータ
  const testNovel = NovelInfo(
    ncode: 'n1111a',
    title: 'Test Novel 1',
    writer: 'Test Writer 1',
    story: 'Story 1',
    genre: 1,
    keyword: 'keyword1',
    novelType: 1,
    end: 0,
    generalAllNo: 10,
    allPoint: 200,
  );

  const testEnrichedNovel = EnrichedNovelData(
    novel: testNovel,
    isInLibrary: false,
  );

  const testFullNovelInfo = NovelInfo(
    title: 'Test Novel 1',
    ncode: 'n1111a',
    writer: 'Test Writer 1',
    story: 'Story 1',
    genre: 1,
    keyword: 'keyword1',
    generalFirstup: '2025-01-01 00:00:00',
    generalLastup: '2025-01-01 00:00:00',
    novelType: 1,
    end: 0,
    generalAllNo: 10,
    isr15: 0,
    isbl: 0,
    isgl: 0,
    iszankoku: 0,
    istensei: 0,
    istenni: 0,
    globalPoint: 100,
    dailyPoint: 10,
    weeklyPoint: 20,
    monthlyPoint: 30,
    quarterPoint: 40,
    yearlyPoint: 50,
    favNovelCnt: 5,
    impressionCnt: 3,
    reviewCnt: 2,
    allPoint: 200,
    allHyokaCnt: 20,
    sasieCnt: 1,
    kaiwaritu: 50,
    novelupdatedAt: 1722726000,
    updatedAt: 1722726000,
    episodes: [],
  );

  setUp(() {
    mockDb = MockAppDatabase();
    mockApiService = MockApiService();
  });

  Widget createTestWidget(List<EnrichedNovelData> novels) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(mockDb),
        apiServiceProvider.overrideWithValue(mockApiService),
        // InvalidateされるProviderたちをダミーでオーバーライド
        libraryNovelsProvider.overrideWith((ref) => Stream.value([])),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EnrichedNovelList(enrichedNovels: novels),
        ),
      ),
    );
  }

  group('EnrichedNovelList', () {
    testWidgets('should add novel to library on long press', (
      WidgetTester tester,
    ) async {
      // --- Arrange ---
      when(mockDb.isInLibrary(any)).thenAnswer((_) async => false);
      when(
        mockApiService.fetchNovelInfo(any),
      ).thenAnswer((_) async => testFullNovelInfo);
      when(mockDb.insertNovel(any)).thenAnswer((_) async => 1);
      when(mockDb.addToLibrary(any)).thenAnswer((_) async => 1);

      await tester.pumpWidget(createTestWidget([testEnrichedNovel]));

      // --- Act ---
      await tester.longPress(find.byType(NovelListTile));
      await tester.pumpAndSettle();

      // --- Assert ---
      verify(
        mockApiService.fetchNovelInfo(testNovel.ncode),
      ).called(1);

      // `cachedAt`が動的なため、argThatで他のフィールドを検証
      verify(
        mockDb.insertNovel(
          argThat(
            isA<NovelsCompanion>()
                .having(
                  (c) => c.ncode.value,
                  'ncode',
                  testFullNovelInfo.ncode,
                )
                .having(
                  (c) => c.title.value,
                  'title',
                  testFullNovelInfo.title,
                ),
          ),
        ),
      ).called(1);

      verify(
        mockDb.addToLibrary(testNovel.ncode),
      ).called(1);

      expect(find.text('ライブラリに追加しました'), findsOneWidget);
    });
  });
}
