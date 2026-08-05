# プロバイダ追加ガイド（ハーメルン等）

新しい小説サイトをNoveltyに追加する手順。カクヨム対応（#240）の設計に基づき、
「パッケージとサイト実装を1つ足すだけ」で追加できる。

## 前提

- サイトが公開HTMLまたは公式APIを提供していること
- robots.txt を遵守し、レート制限を設けること
- エピソードは目次順の連番（`episodeIndex`）で管理し、サイト固有IDは `url` に保持すること

## 手順

### 1. `NovelSource` に enum を追加

`lib/sites/novel_source.dart`:

```dart
enum NovelSource {
  narou('narou', '小説家になろう', 'https://ncode.syosetu.com'),
  kakuyomu('kakuyomu', 'カクヨム', 'https://kakuyomu.jp'),
  hameln('hameln', 'ハーメルン', 'https://syosetu.org'), // 例
  ;
  ...
}
```

### 2. パーサーパッケージを新設（本文がHTMLの場合）

`packages/<site>_parser/` を作成し、`novel_parser_core` の `NovelContentElement` を返す
パース関数を実装する。ルート `pubspec.yaml` の `workspace:` と `dependencies:` に追加。

### 3. サイト実装を新設

`lib/sites/<site>/<site>_site.dart` に `NovelSite` を実装する。

| メソッド | 必須度 | 内容 |
|---|---|---|
| `source` / `genres` / `rankingTypes` | 必須 | マスタデータ |
| `fetchNovelInfo` / `fetchToc` / `fetchEpisode` | 必須 | 読書コア |
| `searchNovels` / `fetchRanking` | 任意 | 未対応なら既定の `UnsupportedError` のまま |

アクセス方針（robots.txt検証・レート制限）は `KakuyomuSite` を参考に実装する。

### 4. レジストリに登録

`lib/sites/novel_site_registry.dart`:

```dart
final Map<NovelSource, NovelSite> novelSiteRegistry = {
  NovelSource.narou: const NarouSite(),
  NovelSource.kakuyomu: KakuyomuSite(),
  NovelSource.hameln: HamelnSite(),
};
```

### 5. UIの対応

- **探索画面**: `ExplorePage` のプロバイダ切替（SegmentedButton）に追加。
  タブはサイトの `rankingTypes` から自動生成される。
- **ライブラリ**: `LibraryPage` のプロバイダ絞り込みチップに追加（`NovelSource.values` から自動生成）。
- **検索モーダル**: プロバイダ切替に追加。なろう固有の詳細条件は `source == narou` のときのみ表示。

### 6. テスト

- パーサー: HTMLフィクスチャによる単体テスト
- サイト実装: フィクスチャ + モックHTTP（Dioアダプタ）によるテスト
- レポジトリ統合: 追加→目次→本文のフロー
- `flutter analyze` 0件（info含む）・全テスト緑

### 7. ドキュメント

- `docs/<site>_html/` にHTML構造を記録（`docs/kakuyomu_html/` を参考に）
- `CONTEXT.md` の用語表に追記

## チェックリスト

- [ ] robots.txt の取得禁止パスを確認し、取得URLが許可範囲か
- [ ] レート制限（リクエスト間隔）を設けたか
- [ ] キャッシュファースト（差分取得）が機能するか
- [ ] 既存サイト（なろう・カクヨム）の回帰がゼロか
- [ ] lint 0（info含む）・全テスト緑
