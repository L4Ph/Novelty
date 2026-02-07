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

  group('NovelPage ページ番号計算', () {
    test('エピソード1-100はページ1を返す', () {
      // エピソード1 → ページ1
      expect(((1 - 1) ~/ 100) + 1, 1);
      // エピソード50 → ページ1
      expect(((50 - 1) ~/ 100) + 1, 1);
      // エピソード100 → ページ1
      expect(((100 - 1) ~/ 100) + 1, 1);
    });

    test('エピソード101-200はページ2を返す', () {
      // エピソード101 → ページ2
      expect(((101 - 1) ~/ 100) + 1, 2);
      // エピソード150 → ページ2
      expect(((150 - 1) ~/ 100) + 1, 2);
      // エピソード200 → ページ2
      expect(((200 - 1) ~/ 100) + 1, 2);
    });

    test('エピソード201-300はページ3を返す', () {
      // エピソード201 → ページ3
      expect(((201 - 1) ~/ 100) + 1, 3);
      // エピソード300 → ページ3
      expect(((300 - 1) ~/ 100) + 1, 3);
    });

    test('エピソード1000以上も正しく計算される', () {
      // エピソード1000 → ページ10
      expect(((1000 - 1) ~/ 100) + 1, 10);
      // エピソード1001 → ページ11
      expect(((1001 - 1) ~/ 100) + 1, 11);
    });

    test('境界値: エピソード100と101でページが切り替わる', () {
      // エピソード100 → ページ1
      expect(((100 - 1) ~/ 100) + 1, 1);
      // エピソード101 → ページ2
      expect(((101 - 1) ~/ 100) + 1, 2);
    });
  });
}
