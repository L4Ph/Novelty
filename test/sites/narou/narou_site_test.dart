import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/sites/narou/narou_site.dart';
import 'package:novelty/sites/novel_source.dart';

void main() {
  group('NarouSite', () {
    const site = NarouSite();

    test('source は NovelSource.narou', () {
      expect(site.source, NovelSource.narou);
    });

    test('ジャンルが genreList の全20件を正しい大ジャンルIDで保持する', () {
      // 期待値は lib/utils/app_constants.dart の genreList と、
      // docs/narou_api/novel_api.md の biggenre 定義
      // （1=恋愛, 2=ファンタジー, 3=文芸, 4=SF, 99=その他）から導出
      const expectedGenres = <({String id, String name, String bigGenreId})>[
        (id: '101', name: '異世界〔恋愛〕', bigGenreId: '1'),
        (id: '102', name: '現実世界〔恋愛〕', bigGenreId: '1'),
        (id: '201', name: 'ハイファンタジー〔ファンタジー〕', bigGenreId: '2'),
        (id: '202', name: 'ローファンタジー〔ファンタジー〕', bigGenreId: '2'),
        (id: '301', name: '純文学〔文芸〕', bigGenreId: '3'),
        (id: '302', name: 'ヒューマンドラマ〔文芸〕', bigGenreId: '3'),
        (id: '303', name: '歴史〔文芸〕', bigGenreId: '3'),
        (id: '304', name: '推理〔文芸〕', bigGenreId: '3'),
        (id: '305', name: 'ホラー〔文芸〕', bigGenreId: '3'),
        (id: '306', name: 'アクション〔文芸〕', bigGenreId: '3'),
        (id: '307', name: 'コメディー〔文芸〕', bigGenreId: '3'),
        (id: '401', name: 'VRゲーム〔SF〕', bigGenreId: '4'),
        (id: '402', name: '宇宙〔SF〕', bigGenreId: '4'),
        (id: '403', name: '空想科学〔SF〕', bigGenreId: '4'),
        (id: '404', name: 'パニック〔SF〕', bigGenreId: '4'),
        (id: '9901', name: '童話〔その他〕', bigGenreId: '99'),
        (id: '9902', name: '詩〔その他〕', bigGenreId: '99'),
        (id: '9903', name: 'エッセイ〔その他〕', bigGenreId: '99'),
        (id: '9904', name: 'リプレイ〔その他〕', bigGenreId: '99'),
        (id: '9999', name: 'その他〔その他〕', bigGenreId: '99'),
      ];

      expect(site.genres, hasLength(expectedGenres.length));

      final genreById = {for (final genre in site.genres) genre.id: genre};
      for (final expected in expectedGenres) {
        final genre = genreById[expected.id];
        expect(genre, isNotNull, reason: 'id=${expected.id} が存在すること');
        expect(genre!.name, expected.name);
        expect(genre.bigGenreId, expected.bigGenreId);
      }
    });

    test('なろうの全ジャンルは小ジャンル（isBigGenre: false）', () {
      expect(site.genres, isNotEmpty);

      for (final genre in site.genres) {
        expect(genre.isBigGenre, isFalse);
      }
    });

    test('ランキング種別が既存の5種別と一致する', () {
      // 期待値は explore_page.dart のタブ（日間・週間・月間・四半期・累計）、
      // ranking_provider.dart の order マッピング、
      // docs/narou_api/novel_api.md の order パラメータから導出
      const expectedRankingTypes =
          <({String id, String label, String urlPath})>[
            (id: 'd', label: '日間', urlPath: 'dailypoint'),
            (id: 'w', label: '週間', urlPath: 'weeklypoint'),
            (id: 'm', label: '月間', urlPath: 'monthlypoint'),
            (id: 'q', label: '四半期', urlPath: 'quarterpoint'),
            (id: 'all', label: '累計', urlPath: 'hyoka'),
          ];

      expect(site.rankingTypes, isNotEmpty);

      final rankingTypeById = {
        for (final type in site.rankingTypes) type.id: type,
      };
      for (final expected in expectedRankingTypes) {
        final type = rankingTypeById[expected.id];
        expect(type, isNotNull, reason: 'id=${expected.id} が存在すること');
        expect(type!.label, expected.label);
        expect(type.urlPath, expected.urlPath);
      }
    });

    test('ランキング種別の id は重複しない', () {
      final ids = site.rankingTypes.map((type) => type.id).toSet();

      expect(ids, hasLength(site.rankingTypes.length));
    });
  });
}
