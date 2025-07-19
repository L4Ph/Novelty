import 'package:novelty/database/database.dart';

/// 履歴アイテムのグループを表すクラス
class HistoryGroup {
  /// コンストラクタ
  const HistoryGroup({
    required this.dateLabel,
    required this.items,
  });

  /// 日付ラベル（「今日」、「1日前」、「2024年1月1日」など）
  final String dateLabel;
  
  /// そのグループに属する履歴アイテムのリスト
  final List<HistoryData> items;
}

/// 履歴アイテムを日付でグルーピングするユーティリティクラス
class HistoryGrouping {
  /// 履歴アイテムの閲覧日時に基づいて適切な日付ラベルを生成する
  static String getDateLabel(HistoryData historyData, DateTime today) {
    final viewedDate = DateTime.fromMillisecondsSinceEpoch(historyData.viewedAt);
    final viewedDateOnly = DateTime(viewedDate.year, viewedDate.month, viewedDate.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    
    final difference = todayOnly.difference(viewedDateOnly).inDays;

    switch (difference) {
      case 0:
        return '今日';
      case 1:
        return '1日前';
      case 2:
        return '2日前';
      case 3:
        return '3日前';
      case 4:
        return '4日前';
      case 5:
        return '5日前';
      case 6:
        return '6日前';
      case 7:
        return '1週間前';
      default:
        // 8日以上前の場合は実際の日付を表示
        return '${viewedDateOnly.year}年${viewedDateOnly.month}月${viewedDateOnly.day}日';
    }
  }

  /// 履歴アイテムのリストを日付でグルーピングする
  static List<HistoryGroup> groupByDate(List<HistoryData> historyItems, DateTime today) {
    final groupMap = <String, List<HistoryData>>{};
    
    // 各履歴アイテムを日付ラベルでグルーピング
    for (final item in historyItems) {
      final dateLabel = getDateLabel(item, today);
      if (groupMap.containsKey(dateLabel)) {
        groupMap[dateLabel]!.add(item);
      } else {
        groupMap[dateLabel] = [item];
      }
    }
    
    // グループを作成し、各グループ内をviewedAtでソート（新しい順）
    final groups = groupMap.entries.map((entry) {
      return HistoryGroup(
        dateLabel: entry.key,
        items: entry.value..sort((a, b) => b.viewedAt.compareTo(a.viewedAt)),
      );
    }).toList();
    
    // グループを日付順でソート（新しい順）
    groups.sort((a, b) {
      final aSampleDate = DateTime.fromMillisecondsSinceEpoch(a.items.first.viewedAt);
      final bSampleDate = DateTime.fromMillisecondsSinceEpoch(b.items.first.viewedAt);
      return bSampleDate.compareTo(aSampleDate);
    });
    
    return groups;
  }
}
