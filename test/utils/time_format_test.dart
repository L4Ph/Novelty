import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/utils/time_format.dart';

void main() {
  group('formatTimeHm', () {
    test('0埋めしたHH:mm形式を返す', () {
      expect(formatTimeHm(DateTime(2024, 1, 15, 9, 5)), '09:05');
      expect(formatTimeHm(DateTime(2024, 1, 15, 23, 59)), '23:59');
      expect(formatTimeHm(DateTime(2024, 1, 15)), '00:00');
      expect(formatTimeHm(DateTime(2024, 1, 15, 10, 30)), '10:30');
    });
  });
}
