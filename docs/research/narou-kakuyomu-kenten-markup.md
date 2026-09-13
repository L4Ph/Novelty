# 傍点（圏点）HTMLマークアップ一次調査 — カクヨム・小説家になろう

最終更新: 2026-09-13
対象: パーサーが傍点（強調の点）を検出・復元するための、実配信 HTML の正確な把握

## 0. 調査方法・環境・要約

- 配信 HTML は `curl -sL -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120 Safari/537.36" <URL>` で取得し、Python の正規表現で該当要素を抽出して確認した（取得日 2026-09-13）。
- カクヨムの CSS は実際に配信されている `https://cdn-static.kakuyomu.jp/css/kakuyomu.css?98DELCmrB4CF` を取得し、`.emphasisDots` の宣言を確認した。
- なろうのルビ・傍点はサーバ側で `<ruby>` に変換されて配信されるため、実ページの生 HTML を直接確認した。
- JS レンダリングのサイト（エブリスタ等）は初期 HTML に本文が含まれない場合があり、記法は公式ヘルプで確認したが**実 HTML は未検証**（§3）。

**結論（要点）**

| サイト | 傍点の実体 | 正確なマークアップ | 検出セレクタの主候補 |
|---|---|---|---|
| カクヨム | `<em class="emphasisDots">` の各文字 `<span>`、点は CSS background-image | `<em class="emphasisDots"><span>字</span>…</em>` | `div.widget-episodeBody em.emphasisDots`（フォールバック `… em`） |
| 小説家になろう | 通常の `<ruby>` の `<rt>` が `・` 等の点のみ | `<ruby>親文字<rp>(</rp><rt>・・</rt><rp>)</rp></ruby>`（`<rb>` なし） | `ruby` の `rt` が点のみ（`・`/`･`/`•`/`﹅`/`﹆`） |
| エブリスタ | 記法 `《《》》`（公式） | 実 HTML 未検証 | — |
| アルファポリス | 記法 `《《》》` / `#親文字__・__#` | 実 HTML 未検証 | — |
| note | 独立記法なし（ルビで代用） | なろうと同型の `<ruby>` になる想定 | なろうと同ヒューリスティクス |

カクヨムは **`text-emphasis` を使っていない**（各文字 `<span>` に点画像を `background` で敷く擬似表示）。なろうは **ruby 要素そのもの** なので、HTML だけでは通常ルビと構造的に区別できず、`<rt>` の内容（点のみか）が唯一の手掛かりになる。

---

## 1. カクヨム

### 1.1 公式記法（一次情報）

- 公式ヘルプ「ルビや傍点を付ける（カクヨム記法を使う）」<https://kakuyomu.jp/help/entry/notation>
  - 傍点: 対象を `《《 》》` でくくる（例: `おじいさんは山へ《《柴刈り》》に出かけました。`）
  - 制約: 改行をまたぐと無効、ルビとの併用不可、エピソード本文のみ。

### 1.2 実ページでの実測（一次情報）

実在エピソード: <https://kakuyomu.jp/works/16817139555343410284/episodes/16817139555344017774>
（カクヨム上の実作品『web小説の書き方、ルール文書規則』の一話。この話の本文に実際に傍点が含まれる）

本文コンテナ: `div.widget-episode.js-episode-body-container > div.widget-episode-inner > div.widget-episodeBody.js-episode-body`
段落: `<p id="p1">…`（1段落1 `<p>`、字下げは全角スペース）

抽出した生 HTML（`div.widget-episodeBody` 内、`<p id="p136">`）:

```html
<p id="p136">　　：<em class="emphasisDots"><span>カ</span><span>ク</span><span>ヨ</span><span>ム</span><span>の</span><span>圏</span><span>点</span></em>　　専用の小さい四角</p>
```

- タグ名: `<em>`
- クラス属性: `class="emphasisDots"`（**`emphasis` ではない**）
- 入れ子: **1文字（コードポイント）ごとに地の `<span>`**。点は子要素ではなく CSS 背景画像で付く。`<span>` にクラスは無い。
- ルビとの併用は不可のため、`em.emphasisDots` の中に `<ruby>` が入ることはない（この話の本文でタグ集計: `em` は 1 個のみ、その中は `span` のみ）。

この話全体の `div.widget-episodeBody` 内タグ集計（参考）:
`p:273, br:62, ruby:178, rb:178, rp:356, rt:178, em:1, span:7`。
`em` は傍点以外に使われておらず、`<em class="emphasisDots">` ただ 1 個だった。

### 1.3 配信 CSS による裏付け（一次情報）

配信 CSS: <https://cdn-static.kakuyomu.jp/css/kakuyomu.css>（クエリ `?98DELCmrB4CF` 付きで取得）

```css
.emphasisDots{font-style:normal}
.emphasisDots>span{padding:.35em 0;background:url(/images/service/notation/emphasis-dots.png?JJXm8YZg3D69) no-repeat top center;background-size:3px 3px}
```

さらに縦書き時・黒テーマ時:

```css
#page-works-episodes-episode.writingDirection-vertical .emphasisDots>span{padding:0 .35em;background-position:center right}
#page-works-episodes-episode.colorTheme-black .emphasisDots>span{background-image:url(data:image/png;base64,…)}
```

点画像の実体: `https://cdn-static.kakuyomu.jp/images/service/notation/emphasis-dots.png`（5×5 px、`background-size:3px 3px`）。
→ カクヨムの傍点は **要素の意味ではなく CSS 背景画像**であり、`text-emphasis` ではない。プレーンテキスト抽出（`textContent`）では点文字は混入しない（各 `<span>` の文字列が連結される）。

### 1.4 第三者パーサーの実装（二次情報・照合）

いずれも上記 `emphasisDots` と一致する。

- narou.rb（`whiteleaf7/narou`, `develop` の `lib/html.rb:108-110`）<https://github.com/whiteleaf7/narou/blob/develop/lib/html.rb>
  ```ruby
  def em_to_sesame(text = @string)
    text.gsub(%r!<em class="emphasisDots">(.+?)</em>!, "［＃傍点］\\1［＃傍点終わり］")
  end
  ```
  同 API ドキュメント: <https://www.rubydoc.info/gems/narou/3.9.1/HTML>
- `minouejapan/kakuyomu-downloader-py`（`kakudlpy.py`）<https://github.com/minouejapan/kakuyomu-downloader-py/blob/main/kakudlpy.py>
  ```python
  base = base.replace('<em class="emphasisDots"><span>', AO_EMB)
  base = base.replace('</span></em>', AO_EME)
  ```
- `yama-natuki/kakuyomu-dl`（`kakuyomu-dl.pl`）<https://github.com/yama-natuki/kakuyomu-dl/blob/master/kakuyomu-dl.pl>
  ```perl
  $item =~ s|<em>(.+?)</em>|［＃傍点］$1［＃傍点終わり］|g;
  ```
  （クラスを問わず `<em>` を傍点として扱う。古い実装・寛容な実装の例）

### 1.5 注意: `class="emphasis"` はサイト出力ではない

2018年の Qiita 記事「カクヨム記法の変換処理を実装する」<https://qiita.com/sarada/items/8a1e42588973892c2ee6>
では、**その記事のライブラリ自身の出力**として
`<em class="emphasis"><span>…</span></em>` を生成している（同記事の `DOT_REGEX` 実装）。

```js
return `<em class="emphasis">${text}</em>`
```

これはカクヨム配信 HTML のクラスではない。また、2018年頃の実装が裸の `<em>` を対象にしていたことから、クラス名は時代により揺れた可能性がある。
→ パーサーは `em.emphasisDots` を第一候補にしつつ、`div.widget-episodeBody` 内の `<em>` をフォールバックとして受理するのが安全。

---

## 2. 小説家になろう

### 2.1 公式記法（一次情報）

- ルビ: 「ルビの挿入」<https://syosetu.com/helpcenter/helppage/helppageid/42>
  - `｜親文字《ルビ》` / 漢字＋仮名なら `漢字《ルビ》` / `漢字(ルビ)`。
- 傍点: 「傍点の挿入」<https://syosetu.com/helpcenter/helppage/helppageid/43>
  - 「傍点タグとして文字列が挿入されます」。独立した傍点記法はなく、ルビの `<rt>` に `・` を入れて代用する。
- 傍点の実務解説（なろう上の実作品）: <https://ncode.syosetu.com/n9885er/10/>
  - 「なろうでは ruby タグで圏点を表現しています」
  - なろう標準は中黒 `・`（U+30FB）。1文字ずつ `あ(・)い(・)…` と個別ルビにするのが推奨、まとめて `あいうえお(・・・・・)` も可。
  - ビュレット `•`(U+2022)、縦書きのゴマ点 `﹅`(U+FE45) 等も言及。

### 2.2 実ページでの実測 — 1文字ずつ（一次情報）

実在ページ: <https://ncode.syosetu.com/n9885er/10/>

抽出した生 HTML:

```html
<ruby>あ<rp>(</rp><rt>・</rt><rp>)</rp></ruby><ruby>い<rp>(</rp><rt>・</rt><rp>)</rp></ruby><ruby>う<rp>(</rp><rt>・</rt><rp>)</rp></ruby>…
```

- タグ名: `<ruby>`
- `<rb>` は**付かない**（このページで `<rb>` 出現数 0、`<rp>` 398、`<rt>` 199）
- `<rp>` の中身は環境により `(` `)`（半角）のことが多いが、同じページ内に `（` `）`（全角）や `《` `》` も混在する。たとえば作者が `《》` でルビ指定した場合は `<rp>《</rp><rt>…</rt><rp>》</rp>` になる。
- `<rt>` の中身は `・`（U+30FB）。数は親文字と 1:1。

### 2.3 実ページでの実測 — まとめて（一次情報）

同じ <https://ncode.syosetu.com/n9885er/10/> より:

```html
<ruby>あいうえおかきくけこ<rp>(</rp><rt>・・・・・・・・・・</rt><rp>)</rp></ruby>
```

- 親文字 10 文字に対し `・` も 10 個で**一致**する（観測例）。
- ただし一致は著者の書き方に依存する（点を省く・句読点を除く等）ため、**個数の一致を検出条件にしない**。

### 2.4 実ページでの実測 — 通常ルビ（対照・一次情報）

対照として、実在のなろう小説の通常ルビ（`<rb>` が無いこと・`<rp>` が全角になり得ることの確認）:

- <https://ncode.syosetu.com/n4830bu/1/>
  ```html
  <ruby>本須　麗乃<rp>（</rp><rt>もとすうらの</rt><rp>）</rp></ruby>
  ```
- <https://ncode.syosetu.com/n2267be/1/>（この話にはルビ無し: `rb=0, rp=0, rt=0`）

→ なろうの `<ruby>` は `<rb>` を含まず、`<rp>` の括弧種は一定でない。したがって**親文字は `<rb>` ではなく `<rt>` より前のテキストノードから取る**必要がある。

### 2.5 点として現れる文字（一次情報で観測）

| 文字 | コードポイント | 出現ページ |
|---|---|---|
| `・` | U+30FB（中黒・なろう標準） | n9885er/10 |
| `•` | U+2022（ビュレット） | n9885er/10 |
| `﹅` | U+FE45（ゴマ点） | n9885er/10 |
| `﹆` | U+FE46（白ゴマ点） | n9885er/10 |

`･`（U+FF65 半角中黒）も入力され得るため、`・･•﹅﹆` を「点」として扱うのが実用的。

---

## 3. 他サイト（任意・記法は一次情報 / HTML は未検証）

### 3.1 エブリスタ

- 公式ヘルプ「ルビや傍点を振ることはできますか？」<https://support.estar.jp/hc/ja/articles/360020301874>
  - 傍点は `《《 》》` でくくる。カクヨムと同じ記法。
- 実 HTML は未検証: 取得したビューアページ `https://estar.jp/novels/24987791/viewer?page=1` の初期 HTML には本文・傍点マークアップが含まれず（JS レンダリング）、`emphasis`/`kenten`/`《《` 等は 0 件だった。ブラウザ実行環境での再確認が必要。

### 3.2 アルファポリス

- 公式ヘルプは存在しない。第三者まとめ <https://yoichigarasu.com/notes/017-ruby-kihou.htm> および
  <https://note.com/ryuon_novel/n/n387d5d234f0b>、執筆支援ツール <http://lifehackdev.com/ConvenientTools/archives/332> によれば傍点は `《《単語》》`、旧記法は `#単語__・__#`。
- 実 HTML は未検証。

### 3.3 note

- 独立した傍点記法はなく、ルビで代用する旨が第三者まとめに記載（<https://note.com/ryuon_novel/n/n387d5d234f0b>）。
- note のルビ記法公式: <https://www.help-note.com/hc/ja/articles/4406430353817>
- したがって note は「なろう型（`<ruby>` の `<rt>` が点のみ）」と同じヒューリスティクスで拾える可能性が高いが、実 HTML は未検証。

### 3.4 その他の傍点記法（参考・第三者まとめ）

- ハーメルン: `《《単語》》`（<https://note.com/ryuon_novel/n/n387d5d234f0b>）
- fujossy: `:テキスト|`（<https://yoichigarasu.com/notes/017-ruby-kihou.htm>）
- pixiv: `[[emphasismark:テキスト>﹅]]`（同上）
- SS名刺メーカー: `｜テキスト《圏》`（同上）

---

## 4. 検出ヒューリスティクスと誤検出リスク

### 4.1 カクヨム

推奨:

1. `div.widget-episodeBody`（`div.widget-episodeBody.js-episode-body`）配下を走査。
2. 第一候補: `em.emphasisDots`（クラス完全一致）。
3. フォールバック: 同コンテナ内の `em`（クラス不問）。クラス名の歴史的揺れ（`emphasis` / クラス無し）に耐える。
4. 強調文字列 = 子要素のテキスト連結（各 `<span>` の文字）。

誤検出リスク:

- `<em>` は本来「強調」の意味要素。将来カクヨムが本文で別用途に `<em>` を使うと誤検出し得る。→ クラス `emphasisDots` 優先、フォールバック採用時は「子が `<span>` のみ」等の追加条件を付けると安全。
- `text-emphasis` は使われていないため、**CSS の `text-emphasis` で検出しようとしてはいけない**。
- 傍点は背景画像なので、`textContent` には点文字が混入しない（誤って点を本文へ残す心配は無い）。

### 4.2 小説家になろう

推奨:

1. 本文コンテナ（例: `div.p-novel__body`, `div.js-novel-text.p-novel__text`、段落 `p#L*`）配下の `ruby` を列挙。
2. 各 `ruby` の `<rt>` テキストから空白を除去し、**点文字集合 `・･•﹅﹆`（余裕を見て `●○` 等）だけから成るなら傍点**と判定。
3. 親文字 = `<rb>` があればそのテキスト、無ければ `<rt>`/`<rp>` より前のテキストノード（なろうは現状 `<rb>` 無し）。
4. 個数一致は要求しない。

誤検出リスク:

- なろうでは傍点と通常ルビが**同一の `<ruby>` 要素**であり、HTML 構造だけでは区別できない。唯一の信号が「`<rt>` が点のみ」であること。
- 読みが本当に `・` だけの語（記号・中黒を読ませる特殊例）や、区切りとして `・` を `<rt>` に入れたケースは誤検出し得る。極めて稀。
- 半角 `･` やビュレット `•` を点に使う著者もいるため、点集合を狭めすぎると**検出漏れ**になる。逆に集合を広げすぎ（`●` 等）ると通常ルビの記号読みを拾う可能性が上がる。実運用は `・･•﹅﹆` を既定にし、必要なら拡張。
- `<rp>` の括弧は `(` `)` `（` `）` `《` `》` と一定でないため、`<rp>` の中身を判定材料にしない。
- 点を含む通常ルビ（例: `<rt>えー・びー</rt>`）は「点のみ」条件で除外できる。逆に「点のみ」条件を「点を含む」に緩めると誤検出が増える。

### 4.3 共通（プレーンテキスト化の注意）

- なろう: `<rt>` の点をそのまま連結すると本文に `・・` が残る。傍点判定時は `<rt>` を本文から除去し、親文字へ置換する。
- カクヨム: `<em>` 内の `<span>` を連結すればよい。点は付かない。

---

## 5. 付録: 生 HTML 抜粋（加工なし）

カクヨム（`https://kakuyomu.jp/works/16817139555343410284/episodes/16817139555344017774`）:

```html
<p id="p136">　　：<em class="emphasisDots"><span>カ</span><span>ク</span><span>ヨ</span><span>ム</span><span>の</span><span>圏</span><span>点</span></em>　　専用の小さい四角</p>
```

カクヨム通常ルビ（同ページ、`<rb>` あり・`<rp>` は全角）:

```html
<ruby><rb>豚切</rb><rp>（</rp><rt>ぶったぎ</rt><rp>）</rp></ruby>
```

なろう 傍点 1文字ずつ（`https://ncode.syosetu.com/n9885er/10/`）:

```html
<ruby>あ<rp>(</rp><rt>・</rt><rp>)</rp></ruby><ruby>い<rp>(</rp><rt>・</rt><rp>)</rp></ruby>…
```

なろう 傍点 まとめて（同ページ）:

```html
<ruby>あいうえおかきくけこ<rp>(</rp><rt>・・・・・・・・・・</rt><rp>)</rp></ruby>
```

なろう 通常ルビ（`https://ncode.syosetu.com/n4830bu/1/`、`<rb>` 無し・`<rp>` は全角）:

```html
<ruby>本須　麗乃<rp>（</rp><rt>もとすうらの</rt><rp>）</rp></ruby>
```

---

## 6. 出典一覧

一次情報:

- カクヨム 公式ヘルプ「ルビや傍点を付ける」 <https://kakuyomu.jp/help/entry/notation>
- カクヨム 実エピソード <https://kakuyomu.jp/works/16817139555343410284/episodes/16817139555344017774>
- カクヨム 配信 CSS <https://cdn-static.kakuyomu.jp/css/kakuyomu.css>
- カクヨム 点画像 <https://cdn-static.kakuyomu.jp/images/service/notation/emphasis-dots.png>
- なろう 公式ヘルプ ルビの挿入 <https://syosetu.com/helpcenter/helppage/helppageid/42>
- なろう 公式ヘルプ 傍点の挿入 <https://syosetu.com/helpcenter/helppage/helppageid/43>
- なろう 実ページ（傍点解説・実作品） <https://ncode.syosetu.com/n9885er/10/>
- なろう 実ページ（通常ルビ） <https://ncode.syosetu.com/n4830bu/1/>
- エブリスタ 公式ヘルプ <https://support.estar.jp/hc/ja/articles/360020301874>

二次情報（照合）:

- narou.rb `lib/html.rb` <https://github.com/whiteleaf7/narou/blob/develop/lib/html.rb> / <https://www.rubydoc.info/gems/narou/3.9.1/HTML>
- kakuyomu-downloader-py <https://github.com/minouejapan/kakuyomu-downloader-py/blob/main/kakudlpy.py>
- kakuyomu-dl <https://github.com/yama-natuki/kakuyomu-dl/blob/master/kakuyomu-dl.pl>
- Qiita「カクヨム記法の変換処理を実装する」 <https://qiita.com/sarada/items/8a1e42588973892c2ee6>
- 夜市ガラス「小説投稿サイトのルビ記法をまとめてみた」 <https://yoichigarasu.com/notes/017-ruby-kihou.htm>
- note「各小説投稿サイトのルビと傍点の振り方」 <https://note.com/ryuon_novel/n/n387d5d234f0b>
