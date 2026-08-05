# `/works/{workId}` へのリクエスト（作品ページ）

カクヨムの作品ページは Next.js（React）製のため、作品情報は
`<script id="__NEXT_DATA__" type="application/json">` 内の JSON（Apollo ステート）に含まれる。
CSSクラス名はCSS Modulesのハッシュ付きのため、**DOMパースは行わず JSON をパースする**。

## robots.txt 上の扱い

- `Disallow: /works/*/episodes/*/read$`（本文の「読む」ページのみ禁止）
- 作品ページ自体は取得可能

## 構造

```html
<script id="__NEXT_DATA__" type="application/json">
{
  "props": {
    "pageProps": {
      "__APOLLO_STATE__": {
        "ROOT_QUERY": {
          "work({\"id\":\"16818023211929539879\"})": {
            "__ref": "Work:16818023211929539879"
          }
        },
        "Work:16818023211929539879": {
          "__typename": "Work",
          "id": "16818023211929539879",
          "title": "【書籍化】魔術帝の参謀は二度目の破滅を打ち砕く",
          "author": { "__ref": "UserAccount:16817330647521627112" },
          "genre": "FANTASY",
          "serialStatus": "RUNNING",
          "publicEpisodeCount": 123,
          "catchphrase": "二度目の機会を得た青年が、幼馴染の破滅を全力で回避する話",
          "introduction": "突出した才を持った六人の帝王、六帝。\n...",
          "tagLabels": ["剣と魔法", "成り上がり", ...],
          "publishedAt": "2024-01-15T12:32:34Z",
          "lastEpisodePublishedAt": "2026-07-13T08:04:50Z",
          "firstPublicEpisodeUnion": {
            "__ref": "Episode:16818023211929635009"
          }
        },
        "UserAccount:16817330647521627112": {
          "__typename": "UserAccount",
          "id": "16817330647521627112",
          "name": "sty72",
          "activityName": "Sty"
        }
      }
    }
  }
}
</script>
```

## アプリでの利用（KakuyomuSite.fetchNovelInfo）

| NovelInfo フィールド | JSON の取得元 |
|---|---|
| `workId` | `Work.id` |
| `title` | `Work.title` |
| `writer` | `UserAccount.activityName`（fallback: `name`） |
| `story` | `Work.introduction` |
| `genreId` | `Work.genre`（例: `FANTASY`） |
| `end` | `Work.serialStatus`（`RUNNING`→1 / `COMPLETED`→0） |
| `generalAllNo` | `Work.publicEpisodeCount` |
| `keyword` | `Work.tagLabels` をスペース連結 |
| `generalFirstup` / `generalLastup` | `Work.publishedAt` / `lastEpisodePublishedAt` |

## ジャンルID一覧

`Work.genre` のキーと `KakuyomuSite.genres` の `GenreMaster.id` は一致する。

| genre | 表示名 | パス |
|---|---|---|
| `LOVE_STORY` | 恋愛 | `/genres/love_story/` |
| `ROMANCE` | ラブコメ | `/genres/romance/` |
| `FANTASY` | ファンタジー | `/genres/fantasy/` |
| `ACTION` | アクション | `/genres/action/` |
| `SF` | SF | `/genres/sf/` |
| `HISTORY` | 歴史 | `/genres/history/` |
| `MYSTERY` | ミステリー | `/genres/mystery/` |
| `HORROR` | ホラー | `/genres/horror/` |
| `DRAMA` | ドラマ | `/genres/drama/` |
| `OTHER` | その他 | `/genres/others/` |
