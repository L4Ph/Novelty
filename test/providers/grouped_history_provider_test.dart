import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/providers/grouped_history_provider.dart';
import 'package:novelty/utils/history_grouping.dart';

@GenerateMocks([AppDatabase])
import 'grouped_history_provider_test.mocks.dart';

void main() {
  group('groupedHistoryProvider', () {
    late MockAppDatabase mockDatabase;
    late ProviderContainer container;
    late DateTime fixedTime;

    setUp(() {
      mockDatabase = MockAppDatabase();
      fixedTime = DateTime(2024, 1, 15, 12, 0);
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDatabase),
          currentTimeProvider.overrideWithValue(fixedTime),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should group history items by date labels', () async {
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
        HistoryData(
          ncode: 'old1',
          title: '古い小説',
          writer: '作者4',
          lastEpisode: 15,
          viewedAt: fixedTime
              .subtract(const Duration(days: 10))
              .millisecondsSinceEpoch,
          updatedAt: fixedTime
              .subtract(const Duration(days: 10))
              .millisecondsSinceEpoch,
        ),
      ];

      when(mockDatabase.watchHistory()).thenAnswer((_) => Stream.value(testHistoryData));

      AsyncValue<List<HistoryGroup>>? result;
      container.listen<AsyncValue<List<HistoryGroup>>>(
        groupedHistoryProvider,
        (previous, next) {
          result = next;
        },
      );

      container.read(groupedHistoryProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(result, isA<AsyncData<List<HistoryGroup>>>());
      final groups = result!.asData!.value;
      expect(groups.length, 3); // 今日、1日前、古い日付の3グループ

      // 今日のグループ
      expect(groups[0].dateLabel, '今日');
      expect(groups[0].items.length, 2);
      expect(groups[0].items[0].ncode, 'today1'); // 新しい順
      expect(groups[0].items[1].ncode, 'today2');

      // 1日前のグループ
      expect(groups[1].dateLabel, '1日前');
      expect(groups[1].items.length, 1);
      expect(groups[1].items[0].ncode, 'yesterday1');

      // 古い日付のグループ（実際の日付が表示される）
      expect(groups[2].dateLabel, '2024年1月5日');
      expect(groups[2].items.length, 1);
      expect(groups[2].items[0].ncode, 'old1');

      verify(mockDatabase.watchHistory()).called(1);
    }, timeout: const Timeout(Duration(seconds: 5)));

    test('should return empty list when no history exists', () async {
      when(mockDatabase.watchHistory()).thenAnswer((_) => Stream.value(<HistoryData>[]));

      AsyncValue<List<HistoryGroup>>? result;
      container.listen<AsyncValue<List<HistoryGroup>>>(
        groupedHistoryProvider,
        (previous, next) {
          result = next;
        },
      );

      container.read(groupedHistoryProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(result, isA<AsyncData<List<HistoryGroup>>>());
      final groups = result!.asData!.value;
      expect(groups, isEmpty);
      verify(mockDatabase.watchHistory()).called(1);
    }, timeout: const Timeout(Duration(seconds: 5)));

    test('should handle database errors', () async {
      when(mockDatabase.watchHistory()).thenAnswer((_) => Stream.error(Exception('Database error')));

      AsyncValue<List<HistoryGroup>>? result;
      container.listen<AsyncValue<List<HistoryGroup>>>(
        groupedHistoryProvider,
        (previous, next) {
          result = next;
        },
      );

      container.read(groupedHistoryProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(result, isA<AsyncError<List<HistoryGroup>>>());
      expect(result!.asError!.error, isA<Exception>());
      verify(mockDatabase.watchHistory()).called(1);
    }, timeout: const Timeout(Duration(seconds: 5)));
  });
}
