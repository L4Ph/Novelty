import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/screens/history_page.dart';
import 'package:novelty/sites/novel_source.dart';

@GenerateMocks([AppDatabase])
import 'history_page_test.mocks.dart';

void main() {
  group('HistoryPage', () {
    late MockAppDatabase mockDatabase;
    late DateTime fixedTime;

    setUp(() {
      mockDatabase = MockAppDatabase();
      fixedTime = DateTime(2024, 1, 15, 12);
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
        ProviderScope(
          retry: (_, _) => null,
          overrides: [
            appDatabaseProvider.overrideWithValue(mockDatabase),
            currentTimeProvider.overrideWithValue(fixedTime),
          ],
          child: const MaterialApp(
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
        ProviderScope(
          retry: (_, _) => null,
          overrides: [
            appDatabaseProvider.overrideWithValue(mockDatabase),
            currentTimeProvider.overrideWithValue(fixedTime),
          ],
          child: const MaterialApp(
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
        ProviderScope(
          retry: (_, _) => null,
          overrides: [
            appDatabaseProvider.overrideWithValue(mockDatabase),
            currentTimeProvider.overrideWithValue(fixedTime),
          ],
          child: const MaterialApp(
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
          ProviderScope(
            retry: (_, _) => null,
            overrides: [
              appDatabaseProvider.overrideWithValue(mockDatabase),
              currentTimeProvider.overrideWithValue(fixedTime),
            ],
            child: const MaterialApp(
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
