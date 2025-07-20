import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/services/notification_service.dart';

void main() {
  group('NotificationService', () {
    late NotificationService notificationService;

    setUp(() {
      notificationService = NotificationService();
    });

    test('進捗パーセンテージが正しく計算されること', () {
      // Red: まず失敗するテストを書く
      // NotificationServiceに進捗計算メソッドがないので失敗する
      const progress = 25;
      const maxProgress = 100;
      const expectedPercent = 25;

      // まだ実装されていないメソッドを呼び出すテスト
      final actualPercent = notificationService.calculateProgressPercent(progress, maxProgress);
      
      expect(actualPercent, equals(expectedPercent));
    });

    test('進捗パーセンテージが端数を正しく処理すること', () {
      // Red: まだ実装されていないメソッドのテスト
      const progress = 33;
      const maxProgress = 100;
      const expectedPercent = 33;

      final actualPercent = notificationService.calculateProgressPercent(progress, maxProgress);
      
      expect(actualPercent, equals(expectedPercent));
    });

    test('進捗パーセンテージが100%を超える場合の処理', () {
      // Red: エッジケースのテスト
      const progress = 150;
      const maxProgress = 100;
      const expectedPercent = 100; // 100%を超えないよう制限

      final actualPercent = notificationService.calculateProgressPercent(progress, maxProgress);
      
      expect(actualPercent, equals(expectedPercent));
    });

    test('進捗パーセンテージがゼロ除算エラーを処理すること', () {
      // Red: エラーケースのテスト
      const progress = 10;
      const maxProgress = 0;

      // ゼロ除算の場合は0を返すべき
      final actualPercent = notificationService.calculateProgressPercent(progress, maxProgress);
      
      expect(actualPercent, equals(0));
    });
  });
}
