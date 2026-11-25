import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/novel_search_result.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/ranking_list.dart';

import '../support/test_services.dart';
import 'ranking_list_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService api;

  setUp(() => api = MockApiService());

  /// Pumps a ranking list bound to [filter].
  Future<RankingFilterController> pumpRankingList(
    WidgetTester tester, {
    required Key key,
    RankingFilterState filter = const RankingFilterState(),
  }) async {
    final controller = RankingFilterController(
      source: filter.source,
    )..setShowOnlyOngoing(value: filter.showOnlyOngoing);
    if (filter.selectedGenreId != null) {
      controller.setSelectedGenreId(filter.selectedGenreId);
    }
    addTearDown(controller.dispose);

    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(
      withServices(
        buildTestServices(db: db, api: api),
        MaterialApp(
          home: Scaffold(
            body: RankingList(
              source: filter.source,
              rankingType: 'd',
              filter: controller,
              key: key,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return controller;
  }

  group('RankingList Widget Tests', () {
    testWidgets('should display ranking list items', (tester) async {
      final mockNovels = List.generate(
        5,
        (index) => NovelInfo(
          ncode: 'n$index',
          title: 'Novel $index',
          writer: 'Writer $index',
          story: 'Story $index',
          genreId: '101',
          novelType: 1,
          end: 1,
          allPoint: 1000 - index,
        ),
      );

      when(api.searchNovels(any)).thenAnswer(
        (_) async => NovelSearchResult(novels: mockNovels, allCount: 5),
      );

      await pumpRankingList(tester, key: const PageStorageKey('test'));

      expect(find.text('Novel 0'), findsOneWidget);
      expect(find.text('Novel 4'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should update query when filter changes', (tester) async {
      final mockNovels = [
        const NovelInfo(
          ncode: 'n1',
          title: 'Filtered Novel',
          writer: 'Writer',
          genreId: '201', // ファンタジー
        ),
      ];

      when(api.searchNovels(any)).thenAnswer(
        (_) async => NovelSearchResult(novels: mockNovels, allCount: 1),
      );

      await pumpRankingList(
        tester,
        key: const PageStorageKey('test_filter'),
        filter: const RankingFilterState(
          selectedGenreId: '201',
        ),
      );

      // searchNovels がジャンルを含むクエリで呼ばれたことを確認
      final captured = verify(api.searchNovels(captureAny)).captured;
      final query = captured.last as NovelSearchQuery;
      expect(query.genreId, equals(['201']));

      expect(find.text('Filtered Novel'), findsOneWidget);
    });

    testWidgets('should filter ongoing novels locally', (tester) async {
      final mockNovels = [
        const NovelInfo(
          ncode: 'n1',
          title: 'Ongoing Novel',
          writer: 'Writer',
          novelType: 1, // 連載中
          end: 1, // 連載中
        ),
        const NovelInfo(
          ncode: 'n2',
          title: 'Short Story',
          writer: 'Writer',
          novelType: 2, // 短編
          end: 0, // 短編または完結
        ),
      ];

      when(api.searchNovels(any)).thenAnswer(
        (_) async => NovelSearchResult(novels: mockNovels, allCount: 2),
      );

      await pumpRankingList(
        tester,
        key: const PageStorageKey('test_ongoing_local'),
        filter: const RankingFilterState(
          showOnlyOngoing: true,
        ),
      );

      // クエリに type='r' が含まれないことを確認（削除したため）
      final captured = verify(api.searchNovels(captureAny)).captured;
      final query = captured.last as NovelSearchQuery;
      expect(query.type, isNull);

      // フィルタリング検証: 連載中の小説のみ表示されること
      expect(find.text('Ongoing Novel'), findsOneWidget);
      expect(find.text('Short Story'), findsNothing);
    });

    testWidgets('should refresh list when filter changes dynamically', (
      tester,
    ) async {
      final mockNovels = [
        const NovelInfo(
          ncode: 'n1',
          title: 'Initial Novel',
          writer: 'Writer',
          novelType: 1,
          end: 1,
        ),
      ];
      final filteredNovels = [
        const NovelInfo(
          ncode: 'n2',
          title: 'Filtered Novel',
          writer: 'Writer',
          novelType: 1,
          end: 1,
        ),
      ];

      when(api.searchNovels(any)).thenAnswer(
        (_) async => NovelSearchResult(novels: mockNovels, allCount: 1),
      );

      final filter = await pumpRankingList(
        tester,
        key: const PageStorageKey('test_dynamic'),
      );
      expect(find.text('Initial Novel'), findsOneWidget);

      // 新しいクエリ用にモックの応答を更新してから、フィルタを変更する
      when(api.searchNovels(any)).thenAnswer(
        (_) async => NovelSearchResult(novels: filteredNovels, allCount: 1),
      );
      filter.setShowOnlyOngoing(value: true);

      await tester.pumpAndSettle();

      // 絞り込み後の小説が表示されるはず
      // リアクティブ性が無い場合、'Initial Novel' が表示されたままになり失敗する
      expect(find.text('Filtered Novel'), findsOneWidget);
    });
  });
}
