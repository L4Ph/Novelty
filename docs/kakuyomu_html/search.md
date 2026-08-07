# `/search?q={keyword}` へのリクエスト（検索）

カクヨムの検索ページは Next.js 製。結果は `__NEXT_DATA__` の
Apollo ステート内の `searchWorks(...)` コネクションに含まれる。

## robots.txt 上の扱い

- 取得禁止パターンに該当しないため取得可能

## 構造

```html
<script id="__NEXT_DATA__" type="application/json">
{
  "props": {
    "pageProps": {
      "__APOLLO_STATE__": {
        "ROOT_QUERY": {
          "searchWorks({\"query\":\"test\",\"offset\":0,\"first\":20})": {
            "__typename": "SearchWorkConnection",
            "nodes": [
              { "__ref": "Work:2912051604728466948" },
              ...
            ],
            "totalCount": 83,
            "pageInfo": {
              "__typename": "PageInfo",
              "hasNextPage": true,
              "hasPreviousPage": false
            }
          }
        },
        "Work:2912051604728466948": {
          "__typename": "Work",
          "id": "2912051604728466948",
          "title": "極悪令嬢を庇って死んだはずが...",
          "author": { "__ref": "UserAccount:1177354054882238876" },
          "genre": "FANTASY",
          "introduction": "...",
          ...
        }
      }
    }
  }
}
</script>
```

## アプリでの利用（KakuyomuSite.searchNovels）

| 項目 | 値 |
|---|---|
| URL | `/search?q={word}&page={N}`（`page` は2ページ目以降のみ送信。`offset` はサーバー側で破棄されるため送信しない） |
| 1ページの件数 | 20件（なろうと同一） |
| `NovelSearchResult.allCount` | `SearchWorkConnection.totalCount` |
| 各作品 | `Work:{id}` エンティティを `_workToNovelInfo` で変換 |

### 対応している絞り込み条件

カクヨム `/search` のクエリパラメータとして以下をサポートする。

| 条件 | `NovelSearchQuery` フィールド | URLパラメータ | 値 |
|---|---|---|---|
| ジャンル | `genreId` | `genre_name` | 小文字スネークケース（例: `FANTASY` → `fantasy`）。カクヨムのジャンルキーは `others` のように複数形のものがある |
| 連載状態 | `serialStatus` | `serial_status` | `running` / `completed` |
| 文字数範囲 | `totalCharacterCountRange` | `total_character_count_range` | `-20000` / `20000-100000` / `100000-` / `500000-` |

- なろう固有の詳細検索条件（種別・並び順・除外語等）はカクヨムでは未対応のため、
  UI上はカクヨム選択時に非表示にする
- タグ検索はなろう側にも相当機能がないため対象外とする
