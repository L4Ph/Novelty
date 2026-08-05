# `/works/{workId}/episodes/{episodeId}/episode_sidebar` へのリクエスト（目次）

カクヨムの目次は `/works/{workId}/episodes` ではなく、
**エピソードIDが必要な `episode_sidebar` エンドポイント**から取得する
（`/works/{workId}/episodes` は 2026-08 現在 404 を返す）。

初回エピソードIDは作品ページの `__NEXT_DATA__` の
`Work.firstPublicEpisodeUnion`（`Episode:{id}` リファレンス）から取得する。

## robots.txt 上の扱い

- 取得禁止パターンに該当しないため取得可能

## 構造（`widget-toc` セクション）

```html
<section class="widget-toc">
  <header>
    <h3 class="heading-level2">目次</h3>
    <div class="widget-toc-workInfo js-chrome-visibility-fix">
      <p class="widget-toc-workStatus">
        <span>連載中</span>
        <span class="js-vertical-composition-item">全123話</span>
      </p>
    </div>
  </header>

  <div class="widget-toc-items test-toc-items">
    <ol>
      <li class="widget-toc-chapter widget-toc-level1 js-vertical-composition-item">
        <span>プロローグ</span>
      </li>
      <li class="widget-toc-episode">
        <a href="/works/16818023211929539879/episodes/16818023211929635009"
           class="widget-toc-episode-episodeTitle">
          <span class="widget-toc-episode-titleLabel js-vertical-composition-item">破滅と回帰</span>
          <time class="widget-toc-episode-datePublished" datetime="2024-01-15T12:32:34Z">2024年1月15日</time>
        </a>
      </li>
      <!-- 現在表示中のエピソードには isHighlighted が付く -->
      <li class="widget-toc-episode isHighlighted">...</li>
    </ol>
  </div>
</section>
```

## アプリでの利用（KakuyomuSite.fetchToc）

| Episode フィールド | 取得元 |
|---|---|
| `index` | 目次順の連番（1始まり） |
| `subtitle` | `span.widget-toc-episode-titleLabel` のテキスト |
| `url` | `a.widget-toc-episode-episodeTitle` の `href` を絶対URL化 |
| `update` | `time.widget-toc-episode-datePublished` のテキスト（例: `2024年1月15日`） |

- 章（`widget-toc-chapter`）はエピソード順の連番決定にのみ使用し、モデルには保持しない
- 1リクエストで全エピソードが返る（例: 123話の作品で123件）
- レポジトリ側で100件ずつページングする
