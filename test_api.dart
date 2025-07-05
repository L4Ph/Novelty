// APIテスト用スクリプト
import 'dart:io';
import 'dart:convert';

Future<void> testRankingAPI() async {
  final client = HttpClient();
  
  // 日間ランキングのテスト（前日の日付を使用）
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  final dateStr = '${yesterday.year}${yesterday.month.toString().padLeft(2, '0')}${yesterday.day.toString().padLeft(2, '0')}';
  
  final urls = [
    'https://api.syosetu.com/rank/rankget/?rtype=$dateStr-d&out=json&gzip=5',
    'https://api.syosetu.com/rank/rankget/?rtype=20250701-w&out=json&gzip=5',
    'https://api.syosetu.com/rank/rankget/?rtype=20250701-m&out=json&gzip=5',
  ];
  
  for (final url in urls) {
    print('Testing URL: $url');
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      
      print('Status: ${response.statusCode}');
      print('Headers: ${response.headers}');
      
      if (response.statusCode == 200) {
        final bytes = await response.fold<List<int>>([], (previous, element) => previous..addAll(element));
        print('Response size: ${bytes.length} bytes');
        
        // gzipデコードを試す
        try {
          final decoded = gzip.decode(bytes);
          final jsonStr = utf8.decode(decoded);
          print('Decoded size: ${jsonStr.length} characters');
          print('First 200 chars: ${jsonStr.length > 200 ? jsonStr.substring(0, 200) : jsonStr}');
          
          // JSONパースを試す
          final jsonData = json.decode(jsonStr);
          if (jsonData is List) {
            print('JSON array with ${jsonData.length} items');
            if (jsonData.isNotEmpty) {
              print('First item: ${jsonData[0]}');
            }
          } else {
            print('JSON object: $jsonData');
          }
        } catch (e) {
          print('Error decoding/parsing: $e');
        }
      } else {
        final responseBody = await response.transform(utf8.decoder).join();
        print('Error response: $responseBody');
      }
    } catch (e) {
      print('Error: $e');
    }
    print('---');
  }
  
  client.close();
}

void main() async {
  await testRankingAPI();
}