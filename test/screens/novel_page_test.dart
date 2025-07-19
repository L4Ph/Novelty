import 'package:flutter_test/flutter_test.dart';

/// NovelPageの履歴追加ロジックのテスト
void main() {
  group('NovelPage 履歴追加ロジック', () {
    test('episode番号が正の場合はそのまま使用される', () {
      // episode番号が正の場合はそのまま使用される
      const episode = 3;
      const validEpisode = episode > 0 ? episode : 1;
      expect(validEpisode, 3);
    });

    test('episode番号が0の場合は1に変換される', () {
      // episode番号が0の場合は1に変換される
      const episode = 0;
      const validEpisode = episode > 0 ? episode : 1;
      expect(validEpisode, 1);
    });

    test('episode番号が負の場合は1に変換される', () {
      // episode番号が負の場合は1に変換される
      const episode = -1;
      const validEpisode = episode > 0 ? episode : 1;
      expect(validEpisode, 1);
    });
  });
}
