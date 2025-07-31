import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/providers/grouped_history_provider.dart';
import 'package:novelty/screens/history_page.dart';

@GenerateMocks([AppDatabase])
import 'history_page_test.mocks.dart';

void main() {
  group('HistoryPage', () {
    late MockAppDatabase mockDatabase;
    late DateTime fixedTime;

    setUp(() {
      mockDatabase = MockAppDatabase();
      fixedTime = DateTime(2024, 1, 15, 12, 0);
    });

    testWidgets('should display grouped history items with date headers', (
      tester,
    ) async {
      final testHistoryData = [
        HistoryData(
          ncode: 'today1',
          title: '今日の小説1',
          writer: '作者1',
          lastEpisode: 5,
          viewedAt: fixedTime.millisecondsSinceEpoch,
          updatedAt: fixedTime.millisecondsSinceEpoch,
        ),
        HistoryData(
          ncode: 'today2',
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
          ncode: 'yesterday1',
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

      when(mockDatabase.watchHistory()).thenAnswer((_) => Stream.value(testHistoryData));

      await tester.pumpWidget(
        ProviderScope(
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
      expect(find.textContaining('第5章'), findsOneWidget);
      expect(find.textContaining('第3章'), findsOneWidget);
      expect(find.textContaining('第10章'), findsOneWidget);
    });

    testWidgets('should display "履歴がありません。" when no history exists', (
      tester,
    ) async {
      when(mockDatabase.watchHistory()).thenAnswer((_) => Stream.value(<HistoryData>[]));

      await tester.pumpWidget(
        ProviderScope(
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
      when(mockDatabase.watchHistory()).thenThrow(Exception('Database error'));

      await tester.pumpWidget(
        ProviderScope(
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
            ncode: 'old1',
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
        expect(find.textContaining('第15章'), findsOneWidget);
      },
    );
  });
}
