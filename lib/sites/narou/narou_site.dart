import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_source.dart';

/// 小説家になろうのサイト定義。
///
/// マスタデータ（ジャンル・ランキング種別）を提供する。
/// ジャンルの値は [lib/utils/app_constants.dart] の genreList と
/// なろうAPIの大ジャンル定義（docs/narou_api/novel_api.md）に基づく。
class NarouSite extends NovelSite {
  /// コンストラクタ。
  const NarouSite();

  @override
  NovelSource get source => NovelSource.narou;

  /// なろうのジャンルマスタ。
  ///
  /// 大ジャンルID: 1=恋愛, 2=ファンタジー, 3=文芸, 4=SF, 99=その他
  @override
  List<GenreMaster> get genres => const <GenreMaster>[
    GenreMaster(id: '101', name: '異世界〔恋愛〕', bigGenreId: '1'),
    GenreMaster(id: '102', name: '現実世界〔恋愛〕', bigGenreId: '1'),
    GenreMaster(id: '201', name: 'ハイファンタジー〔ファンタジー〕', bigGenreId: '2'),
    GenreMaster(id: '202', name: 'ローファンタジー〔ファンタジー〕', bigGenreId: '2'),
    GenreMaster(id: '301', name: '純文学〔文芸〕', bigGenreId: '3'),
    GenreMaster(id: '302', name: 'ヒューマンドラマ〔文芸〕', bigGenreId: '3'),
    GenreMaster(id: '303', name: '歴史〔文芸〕', bigGenreId: '3'),
    GenreMaster(id: '304', name: '推理〔文芸〕', bigGenreId: '3'),
    GenreMaster(id: '305', name: 'ホラー〔文芸〕', bigGenreId: '3'),
    GenreMaster(id: '306', name: 'アクション〔文芸〕', bigGenreId: '3'),
    GenreMaster(id: '307', name: 'コメディー〔文芸〕', bigGenreId: '3'),
    GenreMaster(id: '401', name: 'VRゲーム〔SF〕', bigGenreId: '4'),
    GenreMaster(id: '402', name: '宇宙〔SF〕', bigGenreId: '4'),
    GenreMaster(id: '403', name: '空想科学〔SF〕', bigGenreId: '4'),
    GenreMaster(id: '404', name: 'パニック〔SF〕', bigGenreId: '4'),
    GenreMaster(id: '9901', name: '童話〔その他〕', bigGenreId: '99'),
    GenreMaster(id: '9902', name: '詩〔その他〕', bigGenreId: '99'),
    GenreMaster(id: '9903', name: 'エッセイ〔その他〕', bigGenreId: '99'),
    GenreMaster(id: '9904', name: 'リプレイ〔その他〕', bigGenreId: '99'),
    GenreMaster(id: '9999', name: 'その他〔その他〕', bigGenreId: '99'),
  ];

  /// なろうのランキング種別マスタ。
  ///
  /// 既存UI（explore_page.dart）のタブ種別と ranking_provider.dart の
  /// order マッピングに一致させる。
  @override
  List<RankingTypeMaster> get rankingTypes => const <RankingTypeMaster>[
    RankingTypeMaster(id: 'd', label: '日間', urlPath: 'dailypoint'),
    RankingTypeMaster(id: 'w', label: '週間', urlPath: 'weeklypoint'),
    RankingTypeMaster(id: 'm', label: '月間', urlPath: 'monthlypoint'),
    RankingTypeMaster(id: 'q', label: '四半期', urlPath: 'quarterpoint'),
    RankingTypeMaster(id: 'all', label: '累計', urlPath: 'hyoka'),
  ];
}
