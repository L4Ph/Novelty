# CONTEXT — Novelty ドメイン用語集

このファイルは、Novelty（小説ビューアー）のドメイン言語を定義する。
エージェント・開発者はこの用語集の語彙を使うこと。

## 用語

### NovelSource（サイト種別）

小説提供サイトを識別する列挙型（`lib/sites/novel_source.dart`）。
`dbId` / `label` / `baseUrl` を保持する。

| enum | dbId | label | baseUrl |
|---|---|---|---|
| `narou` | `narou` | 小説家になろう | `https://ncode.syosetu.com` |
| `kakuyomu` | `kakuyomu` | カクヨム | `https://kakuyomu.jp` |

- **避ける**: 「プロバイダ」を「サイト」と混同しない（本プロジェクトでは両方使うが、コード上の型名は `NovelSource`）。
- DBの `source` カラムは `dbId`（enum名と同一）を保存する。

### workId（サイト共通の作品ID）

`NovelSource` 内で一意な作品ID。なろうはNコード（例: `n1234ab`）、カクヨムは作品ID（例: `16818023211929539879`）。
- DBの複合主キーは `(source, work_id)`。
- なろうの `ncode` フィールドは `workId` と同一値（互換のため保持）。

### episodeIndex（エピソード番号）

カクヨムは19桁のグローバルエピソードIDを持つが、**アプリ内では目次順の連番**（1始まり）で管理する。
モデル上のフィールド名は `Episode.index` / DBは `episode_id`。
- **避ける**: カクヨムのエピソードIDをそのまま `episodeId` として扱わない（URL解決のための `url` として保持）。

### NovelSite（サイト実装）

`NovelSource` ごとの実装（`lib/sites/`）。マスタデータ（`genres` / `rankingTypes`）と
読書コア（`fetchNovelInfo` / `fetchToc` / `fetchEpisode`）、探索（`searchNovels` / `fetchRanking`）を提供する。
レジストリ `novelSiteRegistry`（`Map<NovelSource, NovelSite>`）で管理する。
Riverpodプロバイダ `novelSiteRegistryProvider` で注入可能（テスト時はオーバーライドする）。

- なろうの取得は従来の `ApiService` が担当し、サイト実装（`NarouSite`）はマスタデータのみ保持する。

### genreId（ジャンルID）

サイト共通の**文字列**ジャンルID。なろうは `"101"` 等、カクヨムは `"FANTASY"` 等。
表示名はサイト実装の `GenreMaster` から解決する。
- **避ける**: ジャンルを `int` で扱わない（P1で `genre` → `genreId: String` に一般化済み）。

### マスタデータ（Master Data）

サイト実装がコード定義で提供するジャンル（`GenreMaster`）・ランキング種別（`RankingTypeMaster`）。

## 主要な決定（ADR 参照）

- 複数プロバイダ抽象化: [ADR-0001](./docs/adr/0001-multi-provider-abstraction.md)
- カクヨムは公式APIなし・公開HTMLの取得解析のみ（robots.txt遵守）
- フェーズ分割（P1〜P4）: エピック #240
