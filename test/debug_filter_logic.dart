// ignore_for_file: avoid_print // Debug script requires print for output

import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> main() async {
  try {
    print('DEBUG: Fetching Top 100 Daily Ranking...');

    final uri = Uri.parse(
      'https://api.syosetu.com/novelapi/api?out=json&lim=100&order=dailypoint',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      print('Error: ${response.statusCode}');
      return;
    }

    final dynamic jsonResponse = jsonDecode(response.body);
    final jsonList = jsonResponse as List<dynamic>;

    // First item is metadata count
    final firstItem = jsonList[0] as Map<String, dynamic>;
    final allCount = firstItem['allcount'] as int;
    print('Total Count: $allCount');

    var passedCount = 0;
    var failedCount = 0;

    print(
      '\nScanning for "Completed" novels or Short Stories passing the "Ongoing" filter (End == 1)...',
    );
    print('Filter Logic: Keep if (end == 1). Reject if (end != 1).');
    print('----------------------------------------------------------------');

    for (var i = 1; i < jsonList.length; i++) {
      final item = jsonList[i] as Map<String, dynamic>;
      final title = item['title'] as String;
      final novelType = item['novel_type'];
      final end = item['end'];
      final generalAllNo = item['general_all_no'];

      // Convert to int safely
      int? typeVal;
      if (novelType != null) typeVal = int.tryParse(novelType.toString());

      int? endVal;
      if (end != null) endVal = int.tryParse(end.toString());

      // Check Filter
      final kept = (endVal == 1);

      final status = kept ? '[KEPT]' : '[REJECTED]';

      // Check for suspicious "Completed" in title
      final looksCompleted = title.contains('完結');
      final looksShort = (typeVal == 2);

      if (kept) {
        passedCount++;
        if (looksCompleted) {
          print(
            '$status SUSPICIOUS (Title contains "完結"): $title (Type: $novelType, End: $end, Eps: $generalAllNo)',
          );
        } else if (looksShort) {
          print(
            '$status SUSPICIOUS (Type 2 Short Story?): $title (Type: $novelType, End: $end, Eps: $generalAllNo)',
          );
        } else {
          // Normal ongoing
        }
      } else {
        failedCount++;
        if (endVal == 1) {
          print(
            '$status ERROR: Rejected valid ongoing? $title (Type: $novelType, End: $end)',
          );
        }
      }
    }

    print('----------------------------------------------------------------');
    print('Summary:');
    print('Processed: ${jsonList.length - 1}');
    print('Kept (Ongoing): $passedCount');
    print('Rejected (Completed/Short): $failedCount');
  } on Exception catch (e, stack) {
    print('FATAL ERROR: $e');
    print(stack);
  }
}
