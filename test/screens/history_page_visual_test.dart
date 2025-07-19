import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/providers/grouped_history_provider.dart';
import 'package:novelty/screens/history_page.dart';

@GenerateMocks([AppDatabase])
import 'history_page_visual_test.mocks.dart';

void main() {
  group('HistoryPage Visual Test', () {
    late MockAppDatabase mockDatabase;
    late DateTime fixedTime;

    setUp(() {
      mockDatabase = MockAppDatabase();
      fixedTime = DateTime(2024, 1, 15, 12, 0, 0);
    });

    testWidgets('should take screenshot of grouped history display', (
      tester,
    ) async {
      // より豊富なテストデータを作成
      final testHistoryData = [
        // 今日
        HistoryData(
          ncode: 'n1234ab',
          title: '今日読んだ素晴らしい小説',
          writer: '今日の作者',
          lastEpisode: 25,
          viewedAt: fixedTime.millisecondsSinceEpoch,
        ),
        HistoryData(
          ncode: 'n5678cd',
          title: '今日の2番目の小説',
          writer: '別の作者',
          lastEpisode: 10,
          viewedAt: fixedTime
              .subtract(const Duration(hours: 3))
              .millisecondsSinceEpoch,
        ),
        // 1日前
        HistoryData(
          ncode: 'n9999ef',
          title: '昨日読んだ面白い物語',
          writer: '昨日の作者',
          lastEpisode: 45,
          viewedAt: fixedTime
              .subtract(const Duration(days: 1))
              .millisecondsSinceEpoch,
        ),
        // 3日前
        HistoryData(
          ncode: 'n1111gh',
          title: '3日前の冒険小説',
          writer: '冒険作家',
          lastEpisode: 12,
          viewedAt: fixedTime
              .subtract(const Duration(days: 3))
              .millisecondsSinceEpoch,
        ),
        // 1週間前
        HistoryData(
          ncode: 'n2222ij',
          title: '1週間前の恋愛小説',
          writer: '恋愛作家',
          lastEpisode: 33,
          viewedAt: fixedTime
              .subtract(const Duration(days: 7))
              .millisecondsSinceEpoch,
        ),
        // 10日前（実際の日付表示）
        HistoryData(
          ncode: 'n3333kl',
          title: '古い時代の歴史小説',
          writer: '歴史作家',
          lastEpisode: 100,
          viewedAt: fixedTime
              .subtract(const Duration(days: 10))
              .millisecondsSinceEpoch,
        ),
        // 30日前（実際の日付表示）
        HistoryData(
          ncode: 'n4444mn',
          title: '1ヶ月前のファンタジー',
          writer: 'ファンタジー作家',
          lastEpisode: 200,
          viewedAt: fixedTime
              .subtract(const Duration(days: 30))
              .millisecondsSinceEpoch,
        ),
      ];

      when(mockDatabase.getHistory()).thenAnswer((_) async => testHistoryData);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(mockDatabase),
            currentTimeProvider.overrideWithValue(fixedTime),
          ],
          child: MaterialApp(
            title: 'Novelty - History Test',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            home: Scaffold(
              appBar: AppBar(
                title: const Text('履歴'),
                backgroundColor: Colors.blue.shade100,
              ),
              body: const HistoryPage(),
            ),
          ),
        ),
      );

      // Wait for async data loading
      await tester.pumpAndSettle();

      // スクリーンショットを撮影
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('history_page_grouped.png'),
      );
    });
  });
}
