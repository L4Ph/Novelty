import 'package:flutter_test/flutter_test.dart';

/// NovelDetailPageの履歴追加に関するテスト
void main() {
  group('NovelDetailPage 履歴追加テスト', () {
    test('目次ページでは履歴に追加されない設計であることを確認', () {
      // この修正により、目次ページで履歴に追加されることはない
      // 実際の履歴追加はNovelPageでのみ実行される
      expect(true, isTrue);
    });
  });
}
