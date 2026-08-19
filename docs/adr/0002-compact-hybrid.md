# ADR-0002: Hybrid JSON による本文キャッシュの軽量化と FTS 廃止

- ステータス: 採択
- 日付: 2026-08-20
- 関連: DB肥大化対応（v18）、検索基盤の再設計

## 背景

`episode_contents` の `content` は `List<NovelContentElement>` を `json.encode` した verbose JSON（`{"text":"...","runtimeType":"plainText"}`）で保存され、純テキスト比で約3.5倍、DB全体 875MB のうち `episode_contents` 236MB + `episodes_search` FTS 456MB で79%を占有していた。バックアップ/リストアの転送量と端末容量が深刻化し、同時に `episodes_search` の全文検索も bigram によるノイズと容量の両面で見直しが必要になった。

Grillingでは「本文をどう持つか」「索引は要るのか」「`plain` の定義は何か」「`off` のズレをどう防ぐか」「`wakachigaki` をどこで使うか」を1問1答で分岐を潰し、最終的に本文概念を1列で保ちつつ検索はクエリ側の分かち書き + 全文スキャンで代替する方針に収束した。

## 決定

1. **Hybrid JSON `{"txt":"...","rb":[{"off":int,"base":String,"ruby":String}]}` を `episode_contents.content` の永続化形式とする。** `txt` は `PlainText.text` + `RubyText.base` + `"\n"` を連結した読み上げテキスト（検索対象）、`rb` はルビの注釈をオフセットで保持する。`newLine` は `txt` 内の `"\n"` として表現し、`rb` とは非対称に扱う。`off`/`base` の不整合は `txt.substring(off, off+base.length) == base` で検証し、ズレたら `FormatException`。`len` は `base.length` で導出するため持たない。旧 `runtimeType` 形式も `HybridConverter.fromHybridJson` で読込可能とし、マイグレーションの互換性を担保する。

2. **DBマイグレーション v17→v18 で一括変換。** `currentSchemaVersion = 18` とし、`_migrateToV18` で `episode_contents` 11,077件を `HybridConverter` で再エンコードする。`content` が `'[]'` または `'{"txt":"","rb":[]}'` は空（失敗）として集計し、`success_count`/`failure_count` の SQL も両方を考慮する。`episodes_search` および shadow テーブルは `DROP` し、`_createFtsTables`/`_populateFtsTables` は `novels_search` のみに縮退する。新規インストールでは `episodes_search` を作成しない。

   - `wakachigaki` の `tokenize` は参照実装（`yuhsak/wakachigaki` TS / `wakachigaki-py`）と出力が完全一致することを、README 例・サロゲートペア・NFC 結合文字を含む複数ケースで検証している（`dart test packages/wakachigaki`）。

3. **`wakachigaki` をクリーンルームで自前移植し、クエリ側だけに使う。** `packages/wakachigaki` を `workspace` に新設し、 `yuhsak/wakachigaki`（MIT）のアルゴリズムを仕様として自前実装する。`Adora-Inc/japanese_word_tokenizer` は参照に留め、コードのコピーは行わず来歴も残さない。モデルは `tool/codegen.dart`（Dart）が `yuhsak/wakachigaki` の `src/model/model.ts` を `fetch` して `packages/wakachigaki/lib/src/model.dart` の `const` に生成する。リポジトリには `model.json` を残さず、`yuhsak` のみを `tool/codegen.dart` と `lib/generated/wakachigaki_model.dart` のヘッダでクレジットする。FT（追加学習）は第一弾では見送り、汎用モデルで検証してから `tool/wakachigaki/` に Python を隔離して追加する二段階とする。

4. **検索は索引なしの全文スキャンに置換。** `searchEpisodes` は `SELECT content FROM episode_contents` → `HybridConverter.fromSql` → `txt.contains` を `wakachigaki.tokenize(query).every(plain.contains)` で絞り込む。`episodes_search` への `JOIN` と `MATCH` を廃止し、`_updateEpisodeSearchIndex` は `no-op` 化する。`novels_search`（title/writer/story のみ）は `2MB` と小さいため維持する。`Isolate` での一括デコードは将来のチューニング余地として残し、第一弾ではメインスレッドで70msを許容する。

5. **`plain` 列の物理化や子テーブル `episode_rubies`、 `SharedPreferencesWithCache` への本文格納は見送る。** 本文概念は `content` 1列で保持し、将来 `Kenten` 等が増えても `Hybrid` の `rb` に `type` を追加する形で拡張する。デバイス幅での折り返し（ソフト改行）はデータに持たず、レンダリング側で処理する。

## 代替案

- **タプル JSON `["pt","..."]`**: 48%と Hybrid より小さいが `txt` 連結のために毎回要素走査が必要で検索が230msと遅い → 却下
- **DSLテキスト `｜前《・》`**: 30%と最小だが Dart の `json.decode` が使えずパーサ自作が必要 → 却下
- **転置インデックス `search_tokens` 正規化テーブル**: 550万行と row 無限増殖しマイグレーションが重い → 却下
- **2列分離 `plain` + `ruby`**: 本文概念が分裂し `UPDATE` が2列に跨る → Hybrid JSON 1列の方が取り回しが良いため却下
- **Isar/Hive への索引分離**: 依存追加でバックアップ対象が増える → 却下
- **FTS5の `content=''` 外部コンテンツ化**: 容量は減るが `wakachigaki` のカスタムトークナイザを C で書く必要 → 却下

## 結果

- `episode_contents` 236MB → 約123MB（-48%）、`episodes_search` 456MB → 0MBで DB全体 875MB → 約307MB（-65%）。バックアップ/リストアの転送量と端末容量が半減する。
- `ContentConverter` は `HybridConverter` に委譲し、旧 `runtimeType` も読めるため既存DBからのマイグレーションは非破壊。
- 検索は `wakachigaki` の分かち書き精度をクエリ側で享受しつつ、索引なしでも11k件で70msと体感許容範囲。FTが不要になり `tool/` に Python を持ち込まずに済む。
- 将来の拡張は `Hybrid` の `rb` に `type` を足すか `tool/wakachigaki` で FT する形で二段階にできる。
