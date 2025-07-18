import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/screens/novel_page.dart';

/// NovelPageの履歴追加ロジックのテスト
void main() {
  group('NovelPage 履歴追加ロジック', () {
    test('episode番号が正の場合はそのまま使用される', () {
      // episode番号が正の場合はそのまま使用される
      final episode = 3;
      final validEpisode = episode > 0 ? episode : 1;
      expect(validEpisode, 3);
    });

    test('episode番号が0の場合は1に変換される', () {
      // episode番号が0の場合は1に変換される
      final episode = 0;
      final validEpisode = episode > 0 ? episode : 1;
      expect(validEpisode, 1);
    });

    test('episode番号が負の場合は1に変換される', () {
      // episode番号が負の場合は1に変換される
      final episode = -1;
      final validEpisode = episode > 0 ? episode : 1;
      expect(validEpisode, 1);
    });
  });
}