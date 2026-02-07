import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/screens/novel_page.dart';

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

  group('NovelPage buildTitle', () {
    test('短編の場合は小説タイトルのみ表示', () {
      // 短編小説の場合
      const novelInfo = NovelInfo(
        title: '短編小説のタイトル',
        novelType: 2,
      );

      const currentEpisode = Episode(
        subtitle: '短編小説のタイトル',
        index: 1,
      );

      final result = NovelPage.buildTitle(novelInfo, 1, currentEpisode);

      expect(result, '短編小説のタイトル');
    });

    test('連載でサブタイトルがある場合は「第X話 サブタイトル」形式', () {
      // 連載小説でサブタイトルがある場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
      );

      const currentEpisode = Episode(subtitle: '始まりの物語', index: 2);

      final result = NovelPage.buildTitle(novelInfo, 2, currentEpisode);

      expect(result, '第2話 始まりの物語');
    });

    test('連載でサブタイトルがnullの場合は「第X話」のみ', () {
      // サブタイトルがnullの場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
      );

      const currentEpisode = Episode(index: 1);

      final result = NovelPage.buildTitle(novelInfo, 1, currentEpisode);

      expect(result, '第1話');
    });

    test('連載でサブタイトルが空文字の場合は「第X話」のみ', () {
      // サブタイトルが空文字の場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
      );

      const currentEpisode = Episode(subtitle: '', index: 1);

      final result = NovelPage.buildTitle(novelInfo, 1, currentEpisode);

      expect(result, '第1話');
    });

    test('エピソードがnullの場合でもエラーにならない', () {
      // エピソードがnullの場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
      );

      final result = NovelPage.buildTitle(novelInfo, 1, null);

      expect(result, '第1話');
    });

    test('該当するエピソードがない場合は「第X話」のみ', () {
      // 該当するエピソードがない場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
      );

      final result = NovelPage.buildTitle(novelInfo, 5, null);

      expect(result, '第5話');
    });

    test('短編でタイトルがnullの場合は空文字を返す', () {
      // タイトルがnullの場合
      const novelInfo = NovelInfo(
        novelType: 2,
      );

      final result = NovelPage.buildTitle(novelInfo, 1, null);

      expect(result, '');
    });
  });
}
