// 今日の日間ランキングのテスト
import 'dart:io';
import 'dart:convert';

Future<void> testTodayRanking() async {
  final client = HttpClient();
  
  // 今日の日付を使用
  final today = DateTime.now();
  final todayStr = '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';
  
  final url = 'https://api.syosetu.com/rank/rankget/?rtype=$todayStr-d&out=json&gzip=5';
  
  print('Testing today\'s ranking URL: $url');
  print('Current time: $today');
  
  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    
    print('Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final bytes = await response.fold<List<int>>([], (previous, element) => previous..addAll(element));
      print('Response size: ${bytes.length} bytes');
      
      try {
        final decoded = gzip.decode(bytes);
        final jsonStr = utf8.decode(decoded);
        print('Successfully decoded today\'s ranking');
        print('Decoded size: ${jsonStr.length} characters');
        
        final jsonData = json.decode(jsonStr);
        if (jsonData is List) {
          print('JSON array with ${jsonData.length} items');
        }
      } catch (e) {
        print('Error decoding/parsing today\'s ranking: $e');
      }
    } else {
      final responseBody = await response.transform(utf8.decoder).join();
      print('Error response: $responseBody');
    }
  } catch (e) {
    print('Error accessing today\'s ranking: $e');
  }
  
  client.close();
}

void main() async {
  await testTodayRanking();
}