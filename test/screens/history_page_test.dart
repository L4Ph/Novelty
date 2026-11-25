import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:novelty/database/database.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/screens/history_page.dart';
import 'package:novelty/sites/novel_source.dart';
import '../support/test_services.dart';

@GenerateMocks([AppDatabase])
import 'history_page_test.mocks.dart';

void main() {
  group('HistoryPage', () {
    late MockAppDatabase mockDatabase;
    late DateTime fixedTime;

    setUp(() {
      mockDatabase = MockAppDatabase();
      fixedTime = DateTime(2024, 1, 15, 12);
      appRouter.reset();
    });

    testWidgets('should display grouped history items with date headers', (
      tester,
    ) async {
      final testHistoryData = [
        HistoryData(
          source: NovelSource.narou,
          workId: 'today1',
          title: '今日の小説1',
          writer: '作者1',
          lastEpisode: 5,
          viewedAt: fixedTime.millisecondsSinceEpoch,
          updatedAt: fixedTime.millisecondsSinceEpoch,
        ),
        HistoryData(
          source: NovelSource.narou,
          workId: 'today2',
          title: '今日の小説2',
          writer: '作者2',
          lastEpisode: 3,
          viewedAt: fixedTime
              .subtract(const Duration(hours: 2))
              .millisecondsSinceEpoch,
          updatedAt: fixedTime
              .subtract(const Duration(hours: 2))
              .millisecondsSinceEpoch,
        ),
        HistoryData(
          source: NovelSource.narou,
          workId: 'yesterday1',
          title: '昨日の小説',
          writer: '作者3',
          lastEpisode: 10,
          viewedAt: fixedTime
              .subtract(const Duration(days: 1))
              .millisecondsSinceEpoch,
          updatedAt: fixedTime
              .subtract(const Duration(days: 1))
              .millisecondsSinceEpoch,
        ),
      ];

      when(
        mockDatabase.watchHistory(),
      ).thenAnswer((_) => Stream.value(testHistoryData));

      await tester.pumpWidget(
        withServices(
          buildTestServices(db: mockDatabase, now: () => fixedTime),
          const MaterialApp(
            home: Scaffold(
              body: HistoryPage(),
            ),
          ),
        ),
      );

      // Wait for async data loading
      await tester.pumpAndSettle();

      // 日付ヘッダーが表示されることを確認
      expect(find.text('今日'), findsOneWidget);
      expect(find.text('1日前'), findsOneWidget);

      // 履歴アイテムが表示されることを確認
      expect(find.text('今日の小説1'), findsOneWidget);
      expect(find.text('今日の小説2'), findsOneWidget);
      expect(find.text('昨日の小説'), findsOneWidget);

      // エピソード情報が表示されることを確認
      expect(find.text('第5章 - 12:00'), findsOneWidget);
      expect(find.text('第3章 - 10:00'), findsOneWidget);
      expect(find.text('第10章 - 12:00'), findsOneWidget);
    });

    testWidgets('should display "No history found." when no history exists', (
      tester,
    ) async {
      when(
        mockDatabase.watchHistory(),
      ).thenAnswer((_) => Stream.value(<HistoryData>[]));

      await tester.pumpWidget(
        withServices(
          buildTestServices(db: mockDatabase, now: () => fixedTime),
          const MaterialApp(
            home: Scaffold(
              body: HistoryPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('履歴がありません。'), findsOneWidget);
    });

    testWidgets('should display error message when database fails', (
      tester,
    ) async {
      when(
        mockDatabase.watchHistory(),
      ).thenAnswer((_) => Stream.error(Exception('Database error')));

      await tester.pumpWidget(
        withServices(
          buildTestServices(db: mockDatabase, now: () => fixedTime),
          const MaterialApp(
            home: Scaffold(
              body: HistoryPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });

    testWidgets(
      '履歴タップで本文を開き、戻るで目次へ遷移できること',
      (tester) async {
        final testHistoryData = [
          HistoryData(
            source: NovelSource.narou,
            workId: 'today1',
            title: '今日の小説1',
            writer: '作者1',
            lastEpisode: 5,
            viewedAt: fixedTime.millisecondsSinceEpoch,
            updatedAt: fixedTime.millisecondsSinceEpoch,
          ),
        ];

        when(
          mockDatabase.watchHistory(),
        ).thenAnswer((_) => Stream.value(testHistoryData));

        await tester.pumpWidget(
          withServices(
            buildTestServices(db: mockDatabase, now: () => fixedTime),
            const MaterialApp(home: HistoryPage()),
          ),
        );

        await tester.pumpAndSettle();
        expect(appRouter.overlays.entries, isEmpty);

        // 履歴アイテムをタップ → 目次と本文が順に積まれる
        await tester.tap(find.text('今日の小説1'));
        await tester.pumpAndSettle();

        expect(appRouter.overlays.entries, [
          const NovelDetailDest(source: NovelSource.narou, workId: 'today1'),
          const NovelEpisodeDest(
            source: NovelSource.narou,
            workId: 'today1',
            episode: 5,
          ),
        ]);

        // 戻る → 目次、もう一度戻る → 空
        expect(appRouter.pop(), isTrue);
        expect(appRouter.overlays.top, isA<NovelDetailDest>());
        expect(appRouter.pop(), isTrue);
        expect(appRouter.overlays.entries, isEmpty);

        expect(find.text('今日の小説1'), findsOneWidget);
      },
    );

    testWidgets(
      'should display old date format for history older than 7 days',
      (tester) async {
        final testHistoryData = [
          HistoryData(
            source: NovelSource.narou,
            workId: 'old1',
            title: '古い小説',
            writer: '古い作者',
            lastEpisode: 15,
            viewedAt: fixedTime
                .subtract(const Duration(days: 10))
                .millisecondsSinceEpoch,
            updatedAt: fixedTime
                .subtract(const Duration(days: 10))
                .millisecondsSinceEpoch,
          ),
        ];

        when(
          mockDatabase.watchHistory(),
        ).thenAnswer((_) => Stream.value(testHistoryData));

        await tester.pumpWidget(
          withServices(
            buildTestServices(db: mockDatabase, now: () => fixedTime),
            const MaterialApp(
              home: Scaffold(
                body: HistoryPage(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 実際の日付が表示されることを確認
        expect(find.text('2024年1月5日'), findsOneWidget);
        expect(find.text('古い小説'), findsOneWidget);
      },
    );
  });
}
