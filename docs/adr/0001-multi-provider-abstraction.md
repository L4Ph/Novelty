# ADR-0001: 複数プロバイダ対応のためのサイト抽象レイヤー

- ステータス: 採択
- 日付: 2026-08-02
- 関連: エピック #240（カクヨム対応）

## 背景

Novelty は「小説家になろう」専用として設計され、ドメインモデル・DBスキーマ・ルーティングが
Nコード（`ncode`）の一意キーに深く依存していた。カクヨム対応（#240）にあたり、
将来のハーメルン等の追加が「パッケージとサイト実装を1つ足すだけ」で済む
プロバイダ非依存の設計が必要になった。

カクヨムには公式APIが存在せず、公開HTMLの取得・解析のみで対応する（Q2）。

## 決定

1. **`NovelSource` enum** を導入し、サイトを `dbId` / `label` / `baseUrl` で識別する。
   DB・モデル・ルーティングは `NovelSource` + `workId` の複合キーで管理する。
2. **サイト抽象レイヤー（`lib/sites/`）** を新設する。
   - `NovelSite`: マスタデータ（`genres` / `rankingTypes`）+ 読書コア（`fetchNovelInfo` / `fetchToc` / `fetchEpisode`）+ 探索（`searchNovels` / `fetchRanking`）
   - レジストリ `novelSiteRegistry: Map<NovelSource, NovelSite>`
   - 未対応メソッドは既定で `UnsupportedError` を投げる
3. **DBマイグレーション v16→v17（非破壊）**。全テーブルを `(source, work_id[, episode_id])` 複合キーに移行し、
   既存データは `source='narou'` として100%維持する。ジャンルは `INTEGER` → `TEXT`（`genreId`）に一般化。
4. **カクヨムのエピソードは目次順の連番（`episodeIndex`）で管理**し、19桁のグローバルIDは `url` として保持する。
5. **なろうの取得は従来の `ApiService` を継続利用**し、`NarouSite` はマスタデータのみ保持する
   （P1〜P3ではなろうの回帰ゼロを優先。将来のフェーズでサイト実装へ統合可能）。

## 代替案

- **ApiService をそのまま拡張**: サイト固有ロジックが1クラスに集中し、プロバイダ追加のたびに分岐が増える → 却下
- **フィーチャーフラグでカクヨムを隠す**: Q10により全開放の方針 → 却下

## 結果

- なろう機能は無変更で動作継続（回帰ゼロ）
- カクヨム追加は「パッケージ（parser）+ サイト実装 + レジストリ登録」のみ
- 将来のプロバイダ追加手順は [docs/architecture/adding_a_provider.md](../architecture/adding_a_provider.md) を参照
