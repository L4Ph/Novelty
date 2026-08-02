# `/works/{workId}/episodes/{episodeId}` へのリクエスト（エピソード本文）

カクヨムのエピソードページは従来型HTML（Next.jsではない）で、
本文は `div.widget-episodeBody` に含まれる。

## robots.txt 上の扱い

- `Disallow: /works/*/episodes/*/read$` は **`/read` で終わるパスのみ**禁止
- 本文ページ `/works/{workId}/episodes/{episodeId}` は取得可能
- アプリは `/read` パスを一切取得しない（KakuyomuSite がリクエスト前に検証）

## 構造（ヘッダー）

```html
<header>
  <p id="contentMain-header-title">【書籍化】魔術帝の参謀は二度目の破滅を打ち砕く</p>
  <p id="contentMain-header-author">Sty</p>
  <p class="chapterTitle level1 js-vertical-composition-item"><span>プロローグ</span></p>
  <p class="widget-episodeTitle js-vertical-composition-item">破滅と回帰</p>
</header>
```

## 構造（本文）

```html
<div class="widget-episode js-episode-body-container">
  <div class="widget-episode-inner">
    <div class="widget-episodeBody js-episode-body"
         data-viewer-history-path="..."
         data-viewer-reading-quantity-path="...">
      <p id="p1">　炎の海と土の津波が眼前を覆っていた。</p>
      <p id="p2">　そこら中に無惨に積み上がった物言わない人型から目を逸らし、僕は天を仰いだ。</p>
      <p id="p3" class="blank"><br /></p>
      <p id="p4">「愚かにも繁栄を続けた人類。その頂点に座する蛮行を、
        <ruby><rb>熾天使</rb><rp>（</rp><rt>セラフ</rt><rp>）</rp></ruby>
        の名に置き――——断罪する」</p>
    </div>
  </div>
</div>
```

## アプリでの利用

### KakuyomuSite.fetchEpisode

| Episode フィールド | 取得元 |
|---|---|
| `index` | 呼び出し元が指定（目次順連番） |
| `subtitle` | `p.widget-episodeTitle` のテキスト |
| `body` | `div.widget-episodeBody` の `innerHtml` |
| `url` | リクエストURL（目次から解決、またはレポジトリから渡される） |

### kakuyomu_parser（parseKakuyomuEpisodeBody）

| HTML | NovelContentElement |
|---|---|
| `<p>`（テキスト） | `plainText` + 段落末に `newLine` |
| `<p class="blank"><br /></p>` | `newLine` のみ |
| `<ruby><rb>X</rb><rt>Y</rt></ruby>` | `rubyText(X, Y)` |
| `<br>` | `newLine` |

- 段落先頭の全角スペース（字下げ）はなろうパーサーと同様にトリムする
- 段落ごとに末尾へ改行を付与するため、blank段落が空行1つになる
