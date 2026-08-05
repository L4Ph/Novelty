# `/rankings/all/{period}` へのリクエスト（ランキング）

カクヨムのランキングページは従来型HTML。各作品は `div.widget-work` に含まれる。

## robots.txt 上の扱い

- 取得禁止パターンに該当しないため取得可能

## リダイレクト

- `/rankings/all/{period}` は **302リダイレクト**し、`?work_variation=long`（長編）等に振り分けられる
- アプリは `followRedirects: true` でフォローする

## 構造

```html
<div class="widget-work float-parent" itemscope itemtype="https://schema.org/CreativeWork">
  <p class="widget-work-rank">1</p>
  <!-- レビュー等（work自身のキャッチコピー + レビュー） -->
  <div class="float-left">
    <div class="widget-workCard-workColor" style="background-color: #FF5E23;"></div>
    <h3 class="widget-workCard-title">
      <a href="/works/2912051603474311296"
         class="widget-workCard-titleLabel bookWalker-work-title"
         itemprop="name">宮廷魔導師選抜試験を記念受験した田舎者</a>
      <span class="widget-workCard-author">
        ／<a class="widget-workCard-authorLabel" href="/users/johnfuruno" itemprop="author">古野ジョン</a>
      </span>
    </h3>
    <p class="widget-workCard-introduction">
      <a href="/works/2912051603474311296">キーガンは農家の息子だったが...</a>
    </p>
    <div class="widget-workCard-data">
      <p class="widget-workCard-meta">
        <a href="/works/2912051603474311296/reviews" class="widget-workCard-reviewPoints">★12,218</a>
        <span class="widget-workCard-genre">
          <a href="/genres/fantasy/recent_works" itemprop="genre">異世界ファンタジー</a>
        </span>
        <span class="widget-workCard-status">
          <span class="widget-workCard-statusLabel">連載中</span>
          <span class="widget-workCard-episodeCount">23話</span>
        </span>
        <span class="widget-workCard-characterCount">34,333文字</span>
        <span class="widget-workCard-dateUpdated" itemprop="dateModified">2026年8月1日 10:05 更新</span>
      </p>
    </div>
  </div>
</div>
```

ページャー:

```html
<div class="widget-pager">
  <p class="widget-pagerNext">
    <a href="/rankings/all/daily?work_variation=long&amp;page=2">次へ</a>
  </p>
</div>
```

## アプリでの利用（KakuyomuSite.fetchRanking）

| 項目 | 値 |
|---|---|
| URL | `/rankings/all/{period}?work_variation=long&page={page}` |
| 1ページの件数 | 約100件 |
| ページャー | `page` クエリ（2ページ目以降） |

各 `.widget-work` から:

| NovelInfo フィールド | 取得元 |
|---|---|
| `workId` | `a.widget-workCard-titleLabel` の `href` の末尾セグメント |
| `title` | `a.widget-workCard-titleLabel` のテキスト |
| `writer` | `a.widget-workCard-authorLabel` のテキスト |
| `story` | `p.widget-workCard-introduction` のテキスト |
| `genreId` | `a[itemprop=genre]` の `href` のセグメントを大文字化（例: `/genres/fantasy/...` → `FANTASY`） |
| `end` | `span.widget-workCard-statusLabel` に「連載中」を含むか（1=連載中 / 0=完結） |
| `generalAllNo` | `span.widget-workCard-episodeCount` の数字（例: `23話` → 23） |
