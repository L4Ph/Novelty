// 日付処理ロジックのテスト用スクリプト
import 'dart:io';

String _twoDigits(int n) {
  if (n >= 10) {
    return '$n';
  }
  return '0$n';
}

String _getFormattedDate(String rtype) {
  final now = DateTime.now();
  switch (rtype) {
    case 'd':
      // 日間ランキングは午前4時～7時に作成されるため、
      // 現在時刻が午前4時前の場合は前日のランキングを取得
      var targetDate = now;
      if (now.hour < 4) {
        targetDate = now.subtract(const Duration(days: 1));
      }
      return '${targetDate.year}${_twoDigits(targetDate.month)}${_twoDigits(targetDate.day)}';
    case 'w':
      var date = now;
      while (date.weekday != DateTime.tuesday) {
        date = date.subtract(const Duration(days: 1));
      }
      return '${date.year}${_twoDigits(date.month)}${_twoDigits(date.day)}';
    case 'm':
      return '${now.year}${_twoDigits(now.month)}01';
    case 'q':
      final month = now.month;
      int quarterStartMonth;
      if (month >= 1 && month <= 3) {
        quarterStartMonth = 1;
      } else if (month >= 4 && month <= 6) {
        quarterStartMonth = 4;
      } else if (month >= 7 && month <= 9) {
        quarterStartMonth = 7;
      } else {
        quarterStartMonth = 10;
      }
      return '${now.year}${_twoDigits(quarterStartMonth)}01';
    case 'all':
      // 累計ランキングの場合は空文字を返す（特別な処理が必要）
      return '';
    default:
      return '';
  }
}

void main() {
  print('現在時刻: ${DateTime.now()}');
  print('');
  
  final types = ['d', 'w', 'm', 'q', 'all'];
  
  for (final type in types) {
    final date = _getFormattedDate(type);
    final typeName = {
      'd': '日間',
      'w': '週間', 
      'm': '月間',
      'q': '四半期',
      'all': '累計'
    }[type];
    
    if (date.isNotEmpty) {
      final url = 'https://api.syosetu.com/rank/rankget/?rtype=$date-$type&out=json&gzip=5';
      print('$typeName ランキング:');
      print('  日付: $date');
      print('  URL: $url');
    } else {
      print('$typeName ランキング:');
      print('  特別処理（小説APIの検索機能を使用）');
    }
    print('');
  }
}