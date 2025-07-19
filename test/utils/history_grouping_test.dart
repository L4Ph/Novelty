import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/utils/history_grouping.dart';

void main() {
  group('HistoryGrouping', () {
    late DateTime today;
    
    setUp(() {
      // テストのために固定日時を使用（2024年1月15日）
      today = DateTime(2024, 1, 15);
    });

    test('should generate correct date label for today', () {
      final historyData = HistoryData(
        ncode: 'test',
        title: 'Test Novel',
        writer: 'Test Author',
        lastEpisode: 1,
        viewedAt: today.millisecondsSinceEpoch,
      );
      
      final label = HistoryGrouping.getDateLabel(historyData, today);
      expect(label, '今日');
    });

    test('should generate correct date label for 1 day ago', () {
      final oneDayAgo = today.subtract(const Duration(days: 1));
      final historyData = HistoryData(
        ncode: 'test',
        title: 'Test Novel',
        writer: 'Test Author',
        lastEpisode: 1,
        viewedAt: oneDayAgo.millisecondsSinceEpoch,
      );
      
      final label = HistoryGrouping.getDateLabel(historyData, today);
      expect(label, '1日前');
    });

    test('should generate correct date label for 6 days ago', () {
      final sixDaysAgo = today.subtract(const Duration(days: 6));
      final historyData = HistoryData(
        ncode: 'test',
        title: 'Test Novel',
        writer: 'Test Author',
        lastEpisode: 1,
        viewedAt: sixDaysAgo.millisecondsSinceEpoch,
      );
      
      final label = HistoryGrouping.getDateLabel(historyData, today);
      expect(label, '6日前');
    });

    test('should generate "1週間前" for 7 days ago', () {
      final sevenDaysAgo = today.subtract(const Duration(days: 7));
      final historyData = HistoryData(
        ncode: 'test',
        title: 'Test Novel',
        writer: 'Test Author',
        lastEpisode: 1,
        viewedAt: sevenDaysAgo.millisecondsSinceEpoch,
      );
      
      final label = HistoryGrouping.getDateLabel(historyData, today);
      expect(label, '1週間前');
    });

    test('should generate actual date for 8+ days ago', () {
      final eightDaysAgo = today.subtract(const Duration(days: 8));
      final historyData = HistoryData(
        ncode: 'test',
        title: 'Test Novel',
        writer: 'Test Author',
        lastEpisode: 1,
        viewedAt: eightDaysAgo.millisecondsSinceEpoch,
      );
      
      final label = HistoryGrouping.getDateLabel(historyData, today);
      expect(label, '2024年1月7日');
    });

    test('should group history items by date label', () {
      final historyItems = [
        HistoryData(
          ncode: 'test1',
          title: 'Test Novel 1',
          writer: 'Test Author 1',
          lastEpisode: 1,
          viewedAt: today.millisecondsSinceEpoch,
        ),
        HistoryData(
          ncode: 'test2',
          title: 'Test Novel 2',
          writer: 'Test Author 2',
          lastEpisode: 2,
          viewedAt: today.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        ),
        HistoryData(
          ncode: 'test3',
          title: 'Test Novel 3',
          writer: 'Test Author 3',
          lastEpisode: 3,
          viewedAt: today.millisecondsSinceEpoch,
        ),
      ];

      final groupedItems = HistoryGrouping.groupByDate(historyItems, today);
      
      expect(groupedItems.length, 2);
      expect(groupedItems[0].dateLabel, '今日');
      expect(groupedItems[0].items.length, 2);
      expect(groupedItems[1].dateLabel, '1日前');
      expect(groupedItems[1].items.length, 1);
    });

    test('should maintain order within groups', () {
      // 同じ日の異なる時刻を作成
      final todayMorning = DateTime(today.year, today.month, today.day, 8, 0, 0);
      final todayEvening = DateTime(today.year, today.month, today.day, 20, 0, 0);
      
      final historyItems = [
        HistoryData(
          ncode: 'test1',
          title: 'Test Novel 1',
          writer: 'Test Author 1',
          lastEpisode: 1,
          viewedAt: todayEvening.millisecondsSinceEpoch, // 夜
        ),
        HistoryData(
          ncode: 'test2',
          title: 'Test Novel 2',
          writer: 'Test Author 2',
          lastEpisode: 2,
          viewedAt: todayMorning.millisecondsSinceEpoch, // 朝
        ),
      ];

      final groupedItems = HistoryGrouping.groupByDate(historyItems, today);
      
      expect(groupedItems.length, 1);
      expect(groupedItems[0].items.length, 2);
      expect(groupedItems[0].items[0].ncode, 'test1'); // 新しい順（夜）
      expect(groupedItems[0].items[1].ncode, 'test2'); // 古い順（朝）
    });
  });
}