/// 小説のジャンル
const List<Map<String, dynamic>> genreList = [
  {'id': 101, 'name': '異世界〔恋愛〕'},
  {'id': 102, 'name': '現実世界〔恋愛〕'},
  {'id': 201, 'name': 'ハイファンタジー〔ファンタジー〕'},
  {'id': 202, 'name': 'ローファンタジー〔ファンタジー〕'},
  {'id': 301, 'name': '純文学〔文芸〕'},
  {'id': 302, 'name': 'ヒューマンドラマ〔文芸〕'},
  {'id': 303, 'name': '歴史〔文芸〕'},
  {'id': 304, 'name': '推理〔文芸〕'},
  {'id': 305, 'name': 'ホラー〔文芸〕'},
  {'id': 306, 'name': 'アクション〔文芸〕'},
  {'id': 307, 'name': 'コメディー〔文芸〕'},
  {'id': 401, 'name': 'VRゲーム〔SF〕'},
  {'id': 402, 'name': '宇宙〔SF〕'},
  {'id': 403, 'name': '空想科学〔SF〕'},
  {'id': 404, 'name': 'パニック〔SF〕'},
  {'id': 9901, 'name': '童話〔その他〕'},
  {'id': 9902, 'name': '詩〔その他〕'},
  {'id': 9903, 'name': 'エッセイ〔その他〕'},
  {'id': 9904, 'name': 'リプレイ〔その他〕'},
  {'id': 9999, 'name': 'その他〔その他〕'},
];

/// 小説のタイプ
const novelTypes = <String, String>{
  't': '短編',
  'r': '連載中',
  'er': '完結済連載作品',
  're': 'すべての連載作品',
  'ter': '短編と完結済連載作品',
};

/// 小説の並び替えオプション
const novelOrders = <String, String>{
  'new': '新着更新順',
  'favnovelcnt': 'ブックマーク数の多い順',
  'reviewcnt': 'レビュー数の多い順',
  'hyoka': '総合ポイントの高い順',
  'hyokaasc': '総合ポイントの低い順',
  'dailypoint': '日間ポイントの高い順',
  'weeklypoint': '週間ポイントの高い順',
  'monthlypoint': '月間ポイントの高い順',
  'quarterpoint': '四半期ポイントの高い順',
  'yearlypoint': '年間ポイントの高い順',
  'impressioncnt': '感想の多い順',
  'hyokacnt': '評価者数の多い順',
  'hyokacntasc': '評価者数の少ない順',
  'weekly': '週間ユニークユーザの多い順',
  'lengthdesc': '作品本文の文字数が多い順',
  'lengthasc': '作品本文の文字数が少ない順',
  'generalfirstup': '初回掲載順',
  'ncodeasc': 'Nコード昇順',
  'ncodedesc': 'Nコード降順',
  'old': '更新が古い順',
};
