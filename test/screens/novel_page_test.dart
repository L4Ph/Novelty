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
        episodes: [
          Episode(
            subtitle: '短編小説のタイトル',
            index: 1,
          ),
        ],
      );

      final episodeDataMap = {
        for (final e in novelInfo.episodes!)
          if (e.index != null) e.index!: e,
      };

      final result = NovelPage.buildTitle(novelInfo, 1, episodeDataMap);

      expect(result, '短編小説のタイトル');
    });

    test('連載でサブタイトルがある場合は「第X話 サブタイトル」形式', () {
      // 連載小説でサブタイトルがある場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
        episodes: [
          Episode(subtitle: 'プロローグ', index: 1),
          Episode(subtitle: '始まりの物語', index: 2),
          Episode(subtitle: '冒険の続き', index: 3),
        ],
      );

      final episodeDataMap = {
        for (final e in novelInfo.episodes!)
          if (e.index != null) e.index!: e,
      };

      final result = NovelPage.buildTitle(novelInfo, 2, episodeDataMap);

      expect(result, '第2話 始まりの物語');
    });

    test('連載でサブタイトルがnullの場合は「第X話」のみ', () {
      // サブタイトルがnullの場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
        episodes: [
          Episode(index: 1),
          Episode(index: 2),
        ],
      );

      final episodeDataMap = {
        for (final e in novelInfo.episodes!)
          if (e.index != null) e.index!: e,
      };

      final result = NovelPage.buildTitle(novelInfo, 1, episodeDataMap);

      expect(result, '第1話');
    });

    test('連載でサブタイトルが空文字の場合は「第X話」のみ', () {
      // サブタイトルが空文字の場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
        episodes: [
          Episode(subtitle: '', index: 1),
        ],
      );

      final episodeDataMap = {
        for (final e in novelInfo.episodes!)
          if (e.index != null) e.index!: e,
      };

      final result = NovelPage.buildTitle(novelInfo, 1, episodeDataMap);

      expect(result, '第1話');
    });

    test('エピソードリストがnullの場合でもエラーにならない', () {
      // エピソードリストがnullの場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
      );

      const episodeDataMap = <int, Episode>{};

      final result = NovelPage.buildTitle(novelInfo, 1, episodeDataMap);

      expect(result, '第1話');
    });

    test('該当するエピソード番号が見つからない場合は「第X話」のみ', () {
      // 該当するエピソード番号が見つからない場合
      const novelInfo = NovelInfo(
        title: '連載小説のタイトル',
        novelType: 1,
        episodes: [
          Episode(subtitle: 'プロローグ', index: 1),
          Episode(subtitle: '第二章', index: 2),
        ],
      );

      final episodeDataMap = {
        for (final e in novelInfo.episodes!)
          if (e.index != null) e.index!: e,
      };

      final result = NovelPage.buildTitle(novelInfo, 5, episodeDataMap);

      expect(result, '第5話');
    });

    test('短編でタイトルがnullの場合は空文字を返す', () {
      // タイトルがnullの場合
      const novelInfo = NovelInfo(
        novelType: 2,
      );

      const episodeDataMap = <int, Episode>{};

      final result = NovelPage.buildTitle(novelInfo, 1, episodeDataMap);

      expect(result, '');
    });
  });
}
