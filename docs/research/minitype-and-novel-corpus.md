# minitype 組版エンジンと日本語ウェブ小説コーパスの一次情報調査

- 調査日: 2026-09-13
- 対象: `@minitype/minitype` v0.1.6 / `@minitype/tsx` v0.1.2 / なろう・カクヨム HTML / 青空文庫注記 / AozoraEpub3 / TxtMiru・読書尚友 / JIS X 4051:2004
- 本リポジトリ内の参照: `site/repomix-output-minitype-project-tsx.xml`、`packages/narou_parser`、`packages/kakuyomu_parser`、`packages/novel_parser_core`、`packages/tategaki`、`docs/narou_html`、`docs/kakuyomu_html`、`docs/examples`

---

## 0. 調査方法・一次ソース・限界

### 0.1 取得した一次ソース

| 対象 | 取得方法 | 版 |
| --- | --- | --- |
| エンジン本体 | `npm pack @minitype/minitype@0.1.6`（レジストリ API `https://registry.npmjs.org/@minitype/minitype`） | 0.1.6 |
| TSX ラッパ | 本リポジトリ `site/repomix-output-minitype-project-tsx.xml` | `@minitype/tsx` 0.1.2（`"@minitype/minitype": "^0.1.6"`、repomix 4324-4382 行） |
| 公式サイト | https://typeset.jp / https://typeset.jp/references/ | — |
| なろう HTML | `docs/narou_html/{ncode}.md`, `docs/narou_html/{ncode}/{episodes}.md` | — |
| カクヨム HTML | `docs/kakuyomu_html/episode.md` | — |
| 青空文庫注記 | https://www.aozora.gr.jp/annotation/ （`etc.html`, `emphasis.html`） | 2022-01-01 改訂 |
| AozoraEpub3 | `git clone https://github.com/hmdev/AozoraEpub3.git`（`/tmp/opencode/aozoraepub3`） | HEAD |
| JIS X 4051 | https://kikakurui.com/x4/X4051-2004-02.html | 2004 |

### 0.2 限界（重要）

- **エンジンのソースコードは非公開**。`https://github.com/minitype-project/minitype` は `remote: Repository not found`（404）。
- npm tarball には **`.ts` ソースも source map も含まれない**。含まれるのは `dist/*.d.ts` と **minify 済み** `dist/index.esm.js`（177,113 バイト）・`index.bun.js`・`index.browser.js`、フォント、README、`dist/llms.txt` のみ。
- ライセンスは `LicenseRef-PolyForm-Noncommercial-1.0.0`（商用不可）。
- したがって以下では、**(a) `.d.ts`（公開 API の権威）** と **(b) minify 済みバンドル内の関数本体** を突き合わせて報告する。minify により内部識別子は短縮されている（`N` = `classifyCharClass`、`jo` = 分割可否判定、`bd` = CJK 行分割、`Ho` = CJK 文字位置計算、`Ys` = TCY/正立前処理 等）。エクスポート名は `export{ Xn as TEXT_SPACE_FULL, ... }` の形で末尾（バイト位置 172,812〜）にまとめられている。
- 行番号が意味を持たない minify バンドルについては **バイトオフセット**で示す。`.d.ts` は行番号で示す。
- 数値・関数本体の断定は「バンドルから読み取れる実装」であり、公式仕様書による裏付けではない箇所がある。その旨を個別に明記する。

---

# A) minitype エンジン

## A.1 インライン／組版データモデル

### 公開インライン型（`dist/lib/inline.d.ts`）

- `InlineOrExtender`（5 行）:
  `Command | ForceBreak | Kerning | NoBreak | NoSplit | InlineGraphic | InlineMath | Hbox | Ruby | Cid | InlineExtender | string`
- `ForceBreak`（43 行）`{ type: "force-break" }` — 強制改行。両端揃え時は直前行を両端揃えにする。
- `Kerning`（50 行）`{ type: "kerning", em: number }` — 字詰め（em）。
- `NoBreak`（57 行）`{ type: "no-break" }` — **前後での行分割を禁止**。
- `NoSplit`（63 行）`{ type: "no-split" }` — **前後での行分割およびトラッキング挿入を禁止**。
- `Command`（11-40 行）— `body: InlineOrExtender[]`、`name?`, `style?`, `link?`, `footnoteLabel?`, `label?`, `id?`。脚注名は `footnoteCommandName = "fn"`。
- `Ruby`（102 行）`{ type: "ruby", base: string, ruby: string }`。
- `Cid`（108 行）`{ type: "cid", cid: number }`。
- `InlineMath`（70 行）LaTeX + サイズ、`InlineGraphic`（82 行）画像/SVG/PDF + サイズ・ブロックオフセット。
- `Hbox`（124 行）`{ type:"hbox", blockSize: HboxWidth, align?: "left"|"center"|"right"|"justify", body?: InlineOrExtender[] | fill?: string }`。
  - `HboxWidth = number | Em | Fr | "auto" | HboxPlus | HboxMax`（119 行）。`Fr` は可変幅（両端揃えで配分）。

### 実行時の中間モデル（`TempItemInfo`）

`inline.d.ts:154`:

```
TempItemInfo = TempCharInfo | TempTatechuyokoInfo | TempGraphicInfo | TempHboxInfo
```

- `TempCharInfo` — `gid`, `char`, `style`, `kerning`, `orderedCommands`, `ruby?`, **`noBreak?`**, **`noSplit?`**。
  - `noBreak` = 「**この文字の直前**での行分割禁止」、`noSplit` = 「この文字の直前でのトラッキング挿入禁止」。
- `TempCharRubyInfo`（179-185 行）— `baseCount`（親文字数）, `rubyChars: TempCharInfo[]`, `rubyOffset`, `rubyAlign`。**ルビグループの先頭親文字だけ**が保持する。
- `TempTatechuyokoInfo`（191-198 行）— `{ type:"tatechuyoko", chars: TempCharInfo[], orderedCommands }`。「縦組で複数の数字文字をひとまとめにして横向きに配置する」。
- `TempHboxInfo`（224 行）、`TempHboxFillInfo`（リーダ）。

出力側は `CharInfo`（`gid/char/inlinePosition/blockOffset/advance/size/font/effects/rotation?`）と `CharRectInfo`（インライン/ブロック方向の矩形）、`InlineGraphicInfo`。`Em`・`Fr`・`Q`・`H` は `dist/style/unit.d.ts`。`WritingMode` は `dist/style/figure.d.ts:131` の `"horizontal" | "vertical"`。

行そのものを表す単一の型は存在せず、**行分割関数の戻り値**として `{ line: TempItemInfo[]; charPositions: CharPosition[] }[]` が得られる（`dist/typesetting/typesetter-cjk.d.ts` の `splitCJKLines`、`dist/typesetting/typesetter-knuth.d.ts` の `splitKnuthLines`）。`CharPosition = { inlinePosition, blockOffset, advance, rubyWidth }`（`typesetter.d.ts`）。

### スタイル既定値（バンドル 10,389-10,487 付近）

`style/style.d.ts` と突き合わせた既定値:

| 項目 | 既定 | 出典 |
| --- | --- | --- |
| `writingMode` | `"horizontal"` | ESM `Lr="horizontal"` @10,407 |
| `text.size` | 12Q = 3mm | `$t=Dn(12)` @10,423（`Dn=e=>e*.25`） |
| `font` | `SourceHanSerifJP-Regular` | `Jn` @10,433 |
| `lineHeight` | 1.5em | `Nr=z(1.5)` |
| `align` | `"justify"` | `jr="justify"` |
| `kerning` | `false` | `Rr=!1` |
| **`tatechuyoko`** | **2** | `Ar=2` @10,482（`style.d.ts:107`） |
| **`latinUpright`** | **4** | `zr=4` @10,487（`style.d.ts:112`） |
| `rubySize` | 0.5em | `Dr=z(.5)` @10,480 |
| `rubyOffset` | 0em | `Mr=z(0)` |
| `rubyAlign` | `"jis"` | `_r="jis"` |
| `TextSpace` | `TEXT_SPACE_FULL` | `Hr=()=>Xn` |

`CharStyle`（`style/style.d.ts:97-129`）: `size/font/effects/scale/blockOffset/inlineOffset/kerning/tatechuyoko?/latinUpright?/rubySize/rubyOffset/rubyFont/rubyAlign`。

---

## A.2 改行・行の調整（ジャスティフィケーション）・禁則・トラッキング

### A.2.1 文字クラス（テーブル駆動）

`char-class.d.ts:2` の `CharClass`:

```
"openingBracket" | "closingBracket" | "comma" | "period" | "middleDot"
| "kana" | "sutegana" | "kanji" | "latin" | "math" | "space"
| "dividing" | "prolongedSound" | "lineHead" | "lineTail" | "others" | "fallback"
```

`classifyCharClass`（バンドル @13,279 で `N` として定義）の実装（ESM @13,100-13,500）:

```
$l = 「（【『［｛〈《〔〖                         // 開き括弧
Vl = 」）】』］｝〉》〕〗                         // 閉じ括弧
Xl = 、，
Yl = 。．
Zl = ・：；
ui = [closingBracket, comma, period, middleDot, sutegana, dividing, prolongedSound]
fi = [openingBracket]
Jt = [—(U+2014), ―(U+2015), …(U+2026), ‥(U+2025)]
qt = [latin]
```

判定順（`N`）:

1. `$l` → `openingBracket`
2. `Vl` → `closingBracket`
3. `Xl` → `comma` / `Yl` → `period` / `Zl` → `middleDot`
4. 小書き仮名リスト（ぁぃぅぇぉっゃゅょゎ ァィゥェォヵㇰヶ… 等）→ `sutegana`
5. `/^[ぁ-んァ-ヶ]$/` → `kana`
6. `/^\p{Script=Han}$/u` → `kanji`
7. `/^[a-zA-Z0-9\-_–~+=.,!?:;()[\]<>{}/\\@'"`#*$“”%]$/` → **`latin`（ASCII 数字を含む）**
8. `/^[０-９Ａ-Ｚａ-ｚ]$/` → **`others`（全角数字・全角英字）**
9. `/^\p{Script=Latin}$/u` → `latin`
10. `/^[ 　]$/` → `space`
11. `！？` → `dividing`
12. `ー` → `prolongedSound`
13. それ以外 → `others`

注目点:
- **ASCII 数字・英字は `latin`、全角数字・全角英字は `others`**。したがって全角 `１２３` は「ラテン扱いされず」和文寄りに扱われる。
- `math` / `lineHead` / `lineTail` / `fallback` は `CharClass` 型にはあるが、`classifyCharClass` が返すことはない（`math` はインライン数式の外部アイテム、`lineHead`/`lineTail` はアキ量テーブルの擬似キー、`fallback` はテーブル既定キー）。

### A.2.2 禁則・分割可否の述語（バンドル @13,100-15,600）

`char-class.d.ts` の公開述語とバンドル実装の対応:

| API | ESM 名 | 実装 |
| --- | --- | --- |
| `canSplit(prev,next)` | `hi` @15,246 | `!fi.includes(N(prev)) && !ui.includes(N(next)) && !(Jt.includes(prev)&&Jt.includes(next)) && !(qt.includes(N(prev))&&qt.includes(N(next)))` |
| `canInsertTracking(prev,next)` | `yi` | `!(Jt 両方) && !(latin 両方)` |
| `containsJapanese(line)` | `gi` | クラスが `kana/kanji/sutegana/openingBracket/closingBracket/comma/period/middleDot/dividing/prolongedSound` のいずれかを含む |
| `canBurasage(char)` | `bi` | `N(char) === "comma" \|\| "period"` |
| `isLineHeadForbidden(char)` | `xi` | `ui.includes(N(char))` |
| `isLineEndForbidden(char)` | `ki` | `fi.includes(N(char))` |

解釈:
- **行末禁則** = 開き括弧の直前で折らない（`fi`）。
- **行頭禁則** = `ui`（閉じ括弧・読点・句点・中点・小書き仮名・区切り約物！？・長音）を行頭に置かない。
- **分離禁止** = `—―…‥` 同士の間、および **latin 同士の間で折らない**。latin 同士の禁止が **連数字・英単語の不可分化**にあたる。
- デフォルトで「ぶら下がり」は読点・句点のみ対象（`canBurasage`）。`splitCJKLines` の `burasagariStyle` 引数で有効化。

### A.2.3 行分割アルゴリズム

2 系統ある:

1. **CJK** — `splitCJKLines`（`typesetter-cjk.d.ts`）/ 中核 `bd`（ESM @75,553）
2. **欧文（Knuth-Plass）** — `splitKnuthLines` / `getKnuthSplitIndices`（`typesetter-knuth.d.ts`）。`Box`/`Glue`/`Penalty`、`hyphenation.en-us` + `hypher`（ESM @78,800）、fitness class、demerits。空白は glue（stretch = 0.5×、shrink = 0.33×）、ペナルティ cost=50。

`containsJapanese` によりどちらを使うか決める（`char-class.d.ts:32` のコメントに「行分割アルゴリズムの選択に使用する」）。

CJK 側 `bd`（ESM @75,553）は **greedy** で、行幅 `t` を超えたとき:

1. `jo(prev, cur)`（分割許可）なら `cur` の直前で折る。
2. `burasagari` 有効かつ `cur` が読点/句点なら `l+1` で折り、**ぶら下がり**にする。
3. ギャップの縮小可能量 `T` を `Ws` で合計し、`T` だけ詰めれば収まる（`追込み`）かつ `jo(cur, next)` なら `l+1` で折る。
4. それでも不可なら `jo(e[S-1], e[S])` を満たす直前の分割点まで **`追出し`**（後退）する。

分割許可の predicate `jo`（ESM @75,500 付近）:

```
jo(prev, next) =
  next が char で next.noBreak           → false
  prev,next がともに char               → canSplit(prev.char, next.char)
  それ以外                              → !( prev が行末禁則 || next が行頭禁則 )
```

### A.2.4 行の調整（両端揃え・均等割り・トラッキング）

`calculateCJKCharPositions` / 中核 `Ho`（ESM @75,950）:

- 自然幅 `p`、Fr 合計 `d`、分離可能ギャップ数 `T` を数える。
- 両端揃え（`align==="justify"`）かつ Fr 無しで余りがあるとき、`P = (t - p) / T` を **各分離可能ギャップにトラッキングとして加算**。
- 余りがある場合の行頭余白は `hn(align,d)`: `left→0`, `center→0.5`, `right→1`（`typesetter.d.ts` の `calculateAlignRatio`。Fr があれば常に左揃え）。
- **縮小（追込み）時の優先度**は `Ws`（ESM @75,513）が返す:
  - priority 0: 行末の閉じ括弧・読点・句点・中点
  - priority 1/2: 中点
  - priority 3: 括弧・読点が絡むギャップ
  - priority 4: latin→非 latin の境界（`-1/8 em` の縮小）
- トラッキング挿入可否は `separable`（`getItemInfo`, `typesetter.d.ts` / ESM @69,281）:
  `separable = !(next が char かつ next.noSplit) && canInsertTracking(cur.char, next.char)`。
- ルビのアキは `getRubyAdvances` / `Ks`（ESM @75,900 付近）で前進量を計算し、親文字列長より長いルビは前後の親文字へ分配。

### A.2.5 文字組みアキ量テーブル（テーブル駆動）

`space.d.ts` の `TextSpace`:

```ts
type TextSpace = Partial<Record<CharClass, Partial<Record<CharClass, number>>>>
```

`getCharSpaceByClass(prevClass, nextClass, space)` が `space[prevClass][nextClass]` → 無ければ `space[prevClass].fallback` → `space.fallback[nextClass]` → `space.fallback.fallback` → 0 の順で解決（ESM `Lt` @68,400 付近）。`getCharSpaceByChar` は文字からクラスを引く。

既定 3 プリセット（`default-space.d.ts`, ESM @7,300-8,500）:

- `TEXT_SPACE_FULL`（`Xn`）— 約物全角。例:
  `closingBracket→{closingBracket:0, comma:0, period:0, fallback:0.5}`, `comma→{closingBracket:0, fallback:0.5}`, `period→{closingBracket:0, fallback:0.5}`, `middleDot→{fallback:0.25}`, `kana→{latin:0.25, math:0.25}`, `latin→{kana:.25, sutegana:.25, kanji:.25, prolongedSound:.25, lineTail:0, others:.25}`, `fallback→{openingBracket:0.5, middleDot:0.25}`。
- `TEXT_SPACE_HALF`（`Fl`）— 約物半角（`fallback` 無し、括弧系の 0 指定無し）。
- `TEXT_SPACE_HEADTAIL_HALF`（`wl`）— 行頭行末半角（`lineHead→{openingBracket:0}`、`lineTail:0` を追加）。

`typesetter.d.ts` の `ItemInfo` が `leftSpace`（`Lt` による前クラス×後クラスのアキ）、`separable`、`frValue`、`rubyWidth` を保持。

---

## A.3 縦書きサポート

- `WritingMode = "horizontal" | "vertical"`（`figure.d.ts:131`、`style/style.d.ts:13` の `DocumentStyle.writingMode`）。既定 horizontal。
- 各関数は `isVertical` 引数を持ち分岐する（`inlineWithIdsToTempCharInfo`, `getItemInfo`, `calculateBlockOffset`, `calculateCJKCharPositions` 等）。
- **向き（orientation）**: 描画 `Yo`（ESM @85,867）で、`isVertical` かつ文字クラスが `latin` のとき `rotation = 90`（横倒し）。和文は縦用 GID（`vert` feature）で正立。
- **縦中横 / text-combine-upright 相当**: `CharStyle.tatechuyoko?`（`style.d.ts:107`、既定 2）と `latinUpright?`（112 行、既定 4）。前処理は `preprocessLatin`（`vertical-preprocess.d.ts`）/ 中核 `Xo`（ESM @84,775）:
  1. `Ys(list, "tatechuyoko", ...)`（`wd`）: 隣接 char が `vd(char)` を満たし、サイズ・フォント・blockOffset・inlineOffset・kerning が同一で、`style.tatechuyoko` 値が同じ間を 1 ランにまとめる。**ラン長 ≤ しきい値**なら 1 個の `TempTatechuyokoInfo` に変換、超えるならそのまま。
     - `vd = N(e) === "latin" && /^\d+$/.test(e)` → **ASCII 数字のみ**。
  2. `Ys(list, "latinUpright", ...)`（`Ed`）: `Zs = N(e) === "latin"`（英字含む）のランを 1 ラン化。**ラン長 ≤ しきい値**なら各文字を `Ld` で全角化（コードポイント 33-126 に `+0xFEE0`）し、`["vert"]` の GID を選択して正立。超えるなら横倒しのまま。
- **縦中横の描画**（`Yo` @85,867）: グループ内の前進量合計 `f` を求め、`m = (行幅 - f) / 2` で中央寄せし、各文字を `blockOffset = -(m + h)` でブロック方向へずらして横並びにする。
- 関連テスト（配布 `.d.ts` に存在）: `dist/tests/typesetting/tatechuyoko.test.d.ts`, `dist/tests/typesetting/oikomi-oidashi.test.d.ts`, `dist/tests/typesetting/burasagari.test.d.ts`, `dist/tests/typesetting/ruby.test.d.ts`, `dist/tests/typesetting/gyodori.test.d.ts`。
- 公式 README（`dist/llms.txt`）は「禁則処理，縦組，ルビ，ハイフネーション，段組，フロート等の高度な組版」を特徴として明記。

---

## A.4 Ruby / Kenten / Num・Si / Hbox

### Ruby

- 型 `Ruby { type:"ruby", base, ruby }`（`inline.d.ts:102`）。
- 中間表現 `TempCharRubyInfo { baseCount, rubyChars, rubyOffset, rubyAlign }`（179-185 行）。
- 割り付けは描画 `Js`（ESM @87,160 付近）。`rubyAlign`:
  - `"center"` → 中央寄せ
  - `"jis"`（既定）→ 左端・中央・右端を 1-2-1 比にする（`c = a/(n*2)`, `p = a/n`）
  - `"justify"` → 両端揃え（`p = a/(n-1)`）
- ルビ幅 > 親文字幅のときは前後の親文字へ余剰を分配（`Ks`）。ルビ下端と親文字上端の間隔は `rubyOffset`。ルビ文字サイズ既定 0.5em。

### Kenten（圏点）

- `kenten(inlines, mark?)`（`plugin/built-in/kenten.d.ts`）。
- プリセット `KentenMark`: `"bullet"`（既定）, `"white-bullet"`, `"sesame"`, `"white-sesame"`, `"triangle"`, `"white-triangle"`, `"double-circle"`、または任意の 1 文字。
- 各文字の上（横組）または右（縦組）に記号を配置。

### Num / Si（`plugin/built-in/siunitx.d.ts`）

- `num(value)` — 数値または科学的記数法文字列を `InlineOrExtender[]` に整形。`"3.0e8"` 等は指数部を上付き文字で表示。
- `si(value, unit)` — LaTeX `siunitx` 相当。単位 `"kg.m/s^2"`（`.` で因子連結、`/` で分母、`^n` で指数）。`"3.0e8"` は `3.0 × 10⁸`。
- `SUP_SCALE` / `SUP_BASELINE`（`inline-extender.d.ts`）および `sup`/`sub` の既定（`scale: em(0.6)`, `sup.blockOffset: em(1/0.6*0.4)`）で上付きを実現。

### Hbox

- ブロックサイズ `HboxWidth = number | Em | Fr | "auto" | HboxPlus | HboxMax`（`inline.d.ts:119`）。`Fr` は両端揃え時の余り配分に使われる（`calculateAlignRatio` は Fr があると左揃え固定）。
- `body`（内容）または `fill`（リーダ、`hbox` の幅を文字で埋める）。`TempHboxInfo`（224 行）。リーダの配置既定は右、インライン内容は左。

---

## A.5 アラビア数字・連数字・不可分シーケンスの扱い

- ASCII 数字 `0-9` は `latin` クラス（A.2.1）。`canSplit` は **latin 同士で分割を禁じる**（`qt`）。したがって「連数字」「英単語」は不可分トークンとして扱われる。
- **縦中横は ASCII 数字の連続ランのみ**を対象（`vd`）。既定しきい値 2 なので、2 桁以下だけが縦中横、3 桁以上は横倒し（回転 90°）のまま…というのが素の挙動だが、`tatechuyoko` はスタイルで増減可能。
- **`latinUpright`（既定 4）**は英字・数字の latin ランを全角化して正立させる。したがって `C3`（2 文字）や `D1` は正立、`1200.03`（7 文字）は横倒し。`.` は `latin` 正規表現に含まれるためランに含まれるが、`vd` は `/^\d+$/` なので縦中横ランには `.` を含められない。
- 明示的に不可分にしたい場合は `NoBreak` / `NoSplit` を挿入できる（`inline-helper.d.ts` の `noBreak()`, `noSplit()`）。デフォルトでは Trailing マークが無い限り強制されず、クラス判定に依存する。

---

# B) 実小説・ビューアの慣行

## B.1 小説家になろう / カクヨム の本文 HTML とパーサ

### なろう

- 短編・連載とも本文は `<div class="p-novel__body">` 内の `<div class="js-novel-text p-novel__text">`、段落は `<p id="L1">`、空行は `<p><br></p>`（`docs/narou_html/{ncode}.md` 概ね 27-91 行、`docs/narou_html/{ncode}/{episodes}.md` 概ね 40-60 行）。
- 連載ではまえがきが `p-novel__text--preface` で分離（`{episodes}.md`）。目次・話数は `p-novel__number`、章題は `p-novel__title--rensai`。
- ルビは `<ruby>前<rp>(</rp><rt>・</rt><rp>)</rp></ruby>`（`{episodes}.md` の L2 の例）。
- パーサ: `packages/narou_parser/lib/src/parser.dart` → `parser_lookup.dart`。`<ruby>` を検出し `_processRubyContent` で `<rt>` を抽出、`<rb>`/`<rp>` を除去。`<br>` → `NewLine`、`</p>` → `NewLine`。エンティティ（`&lt; &gt; &amp; &quot; &nbsp;`）をデコード。テキストは `trim()` され、**段落先頭の全角スペース（字下げ）も除去**される。
- 注意: なろうパーサは「厳密な HTML パーサではない」（`parser_lookup.dart` コメント）。`<p>` 入れ子や想定外属性は非対応。

### カクヨム

- 本文は `div.widget-episodeBody`、段落 `<p id="p1">`、空行 `<p class="blank"><br /></p>`、ルビは `<ruby><rb>熾天使</rb><rp>（</rp><rt>セラフ</rt><rp>）</rp></ruby>`（`docs/kakuyomu_html/episode.md`）。
- パーサ: `packages/kakuyomu_parser/lib/src/parser.dart`。`.widget-episodeBody`（無ければ `body`）内の `<p>` を走査し、`blank` または空段落 → `newLine` 1 個、通常段落はインラインを再帰処理して末尾に `newLine`。`<ruby>` → `rubyText(base, rt)`、`<br>` → `newLine`。段落先頭の全角スペースは trim。

### アプリの内部モデル

`packages/novel_parser_core/lib/src/models/novel_content_element.dart`:

```dart
sealed class NovelContentElement:
  PlainText(text) | RubyText(base, ruby) | NewLine
```

- **数字・Latin・縦中横・圏点・不可分トークンを表すノードが無い**。数字や英字は `PlainText` の中に生のまま入る。縦書き時にどう組むかは `packages/tategaki` のレイアウト側で決める。
- `packages/tategaki/lib/src/parser/tategaki_parser.dart` は本文を走査し、**連続する半角数字 2〜3 桁を `TategakiTcy`** に、1 桁または 4 桁以上は 1 文字ずつ `TategakiChar` にする。`_isHalfWidthDigit` は `0x30-0x39` のみ。改行は `TategakiNewLine`。これは A.3 の minitype 既定（2 桁）や AozoraEpub3（2-3 桁）と近いが**独立実装**。
- サイト側は縦書きを制約しない。**なろう・カクヨムは横書き HTML + `<ruby>` を返す**だけで、縦組み・禁則・縦中横はビューアの責任。

## B.2 青空文庫 注記仕様（一次ソース）

`https://www.aozora.gr.jp/annotation/etc.html`・`emphasis.html`。

- **ルビ**: `青空文庫《あおぞらぶんこ》` → `<ruby><rb>青空文庫</rb><rp>（</rp><rt>あおぞらぶんこ</rt><rp>）</rp></ruby>`。漢字＋仮名、仮名＋アルファベット、平仮名＋片仮名のように文字種が混じる場合は先頭に `｜` を付けて範囲を特定。`仝々〆〇ヶ` は漢字扱い。
- **傍点（圏点）**: `［＃「○○」に傍点］` → `<em class="sesame_dot">`。種類: 白ゴマ（`white_sesame_dot`）, 丸（`black_circle`）, 白丸（`white_circle`）, 黒三角（`black_up-pointing_triangle`）, 白三角（`white_up-pointing_triangle`）, 二重丸（`bullseye`）, 蛇の目（`fisheye`）, ばつ（`saltire`）。**縦組みで行の左**に付く場合は `○○［＃「○○」の左に傍点］` → `*_after` クラス（例 `sesame_dot_after`）。開始/終了型 `［＃傍点］…［＃傍点終わり］` もある。
- **傍線**: `［＃「○○」に傍線］` → `underline_solid`、`左に傍線` → `overline_*`。
- **縦中横**: `○○［＃「○○」は縦中横］` → `<span dir="ltr">○○</span>`。実例 `米機Ｂ29［＃「29」は縦中横］の編隊は、` → `米機Ｂ<span dir="ltr">29</span>の編隊は、`。範囲指定時は `［＃縦中横］…［＃縦中横終わり］`。
- **割り注**: `［＃割り注］…［＃割り注終わり］` → `<span class="warichu">（…）</span>`。改行は `［＃改行］`。
- **横組み**: ブロックは `［＃ここから横組み］…［＃ここで横組み終わり］` → `<div class="yokogumi">`。行中は `○○［＃「○○」は横組み］` → `<span class="yokogumi">`。**半角（1 バイト）の英数字・記号からなる横組みは注記不要**（例: `What is Real Happiness?`、`Impia tortorum ...`）。
- **上付き/下付き**: `［＃「2」は上付き小文字］` → `<sup class="superscript">`、下付き → `<sub>`。行右小書き/行左小書きは縦組み用。
- **外字・外国文字**: アクセント分解した欧文は外字注記で表現し、ルビに `｜` は不要（`〔E'tude〕《エチュード》` 等）。

## B.3 AozoraEpub3 の「自動縦中横」規則（一次ソース）

出典: `https://github.com/hmdev/AozoraEpub3`、`src/com/github/hmdev/converter/AozoraEpub3Converter.java`、`src/com/github/hmdev/util/CharUtils.java`、`README.md`。

### フラグ既定値（AozoraEpub3Converter.java:34-45）

```
autoYoko       = true   // 半角2文字の数字と!?を縦中横
autoYokoNum1   = true   // 半角数字1桁を自動縦中横
autoYokoNum3   = true   // 半角数字3桁を自動縦中横
autoYokoEQ1    = true   // !/? の1文字(前後は全角)を自動縦中横
autoYokoEQ3    = true   // !/? の3文字連続を自動縦中横
autoAlpha2     = false  // 英字2文字縦中横
autoAlphaNum2  = false  // 英数字2文字縦中横
```

### 適用条件（同 :2801）

自動縦中横は **`this.vertical && !(inYoko || noTcy)`** のときだけ実行。`inYoko` は「横組み注記の中」、`noTcy` は「縦中横抑止」区間。

### 数字（同 :2805-2862）

- `autoYokoNum3` かつ後続 2 文字が数字 → **3 桁**を `［＃縦中横］…［＃縦中横終わり］` で出力。
- そうでなく `i+1` が数字 → **2 桁**。
- `autoYokoNum1` かつ前後が数字でない → **1 桁**。
- 各分岐の前に `checkTcyPrev` / `checkTcyNext` で **前後が半角か**を検査し、半角なら出力しない（`break`）。
- **4 桁以上は縦中横されない**。理由: 4 桁目の数字が存在すると `checkTcyNext(ch, i+3)` が `isHalf` の数字を検出して `false` を返し、分岐を抜けて通常出力になる。以降の位置でも同様に成立しない。これは README の「2文字の半角の数字」および「数字1桁3桁…は設定で変更」という記述と整合する。
- **日付・年号などの例外**（同 :2843-2860）:
  - `1月2日` / `1月10日` → 先頭の `1` を縦中横。
  - `年3月` / `月4日` / `第5刷` / `第6版` / `第7巻` → その 1 文字を縦中横。
  - `明治|大正|昭和|平成` + `月5日` の `5` を縦中横。

### `!` / `?`（同 :2866-2897）

- `autoYokoEQ3` かつ 3 文字連続（`!`/`?` の任意混在）→ **3 文字**。
- `autoYokoEQ1` かつ 1 文字で前後が数字でない → **1 文字**。
- 前後半角チェックあり。

### 前後半角チェック（同 :2967-3006）

```
checkTcyPrev/Next:
  タグ <...> はスキップ
  半角スペース ' ' はスキップ（無視）
  隣接文字が isHalf (0x21 <= ch <= 0x02AF) なら false
  それ以外は true
```

`CharUtils.isNum` は `'0'..'9'` のみ。`isHalf` は `0x21-0x02AF`（半角英字・数字・記号・拡張ラテン）。README（175-177 行）は「**前後に全角の文字が無い場合(間の半角スペースは無視)や、横組み注記の中では無効**」と明記。

### テスト

`test/com/github/hmdev/converter/AozoraEpub3ConverterTest.java:171-173`:
`第32［＃「32」は縦中横］図` → `第［＃縦中横］32［＃縦中横終わり］図`。

## B.4 他の縦書きビューアの documented 挙動

- **TxtMiru / TxtMiru on the Web**（縦書きテキストビューワ）
  - 機能: 禁則処理、**組文字（縦中文字）対応**、青空文庫形式のルビ表示（https://rd.vector.co.jp/download/file/win95/util/fh215781.html 、https://so-zou.jp/software/tool/document/txt-miru/）。
  - VerticalEditor の設定説明（http://www.hi-ho.ne.jp/makoto_watanabe/ve/style_basis.html）: 「**縦中横[縦書き時]** 設定を有効にすると、縦書きの際に "!?" や "!!" といった疑問符や感嘆符の連続した半角二文字を全角一文字のよう縦表示できます。チェックが入っていないと、横に寝ます」「**英字も縦中横[縦書き時]** … "in" "on" 等のアルファベットを横書きするかどうか」。
- **読書尚友**（Android / iOS の青空文庫ビューア）
  - 機能: **行頭・行末禁則、自動縦中横**（https://ebstudio.info/manual/BookViewer/00about.php 、https://ebstudio.info/manual/BookViewer_ios/00about.php）。
  - 開発ブログ（https://ebstudio.hatenablog.com/entry/2022/11/15/124147）: 明示注記の「縦中横」は完全対応していないが、「**2桁の数字は自動縦中横で表示するので、ほとんど対応**」。
- **JIS X 4051:2004**（https://kikakurui.com/x4/X4051-2004-02.html）
  - 4.3 行頭禁則処理、4.4 行末禁則処理、4.5.1 分割禁止 / 4.5.2 分離禁止、4.6 連数字の配置法、4.8 縦中横処理、4.14 圏点処理、4.16 割注処理、4.19 行の調整処理。
  - **行頭禁則和字**の例: `ヽヾゝゞ々ーぁぃぅぇぉっゃゅょゎァィゥェォッャュョヮヵヶ`。
  - **区切り約物**: `？！`。**追込み**（字間を詰めて行中の文字数を多くする）／**追出し**（字間を広げて文字数を少なくする）を禁則処理の方法として定義。
  - 「縦中横（たてちゅうよこ）: 縦書きの行中で，縦書きの字の向きのまま横書きにすること。」

## B.5 実テキストからの具体例（数字・Latin 文字列）と縦組み時の分類

出典: 本リポジトリの実データベース `novelty_backup_20260804_202130_v16.db` の `episode_contents.content`（実際のなろう作品本文）、および青空文庫注記の実例。

| # | 実例（抜粋） | 構成 | 縦組みでの望ましい扱い |
| --- | --- | --- | --- |
| 1 | `4、5歳くらいの時` | 1桁 + 読点 + 1桁 | `4`・`5` を各々1字として正立（1桁の扱い）。`、` は行頭禁則で行頭に置かない。**連数字ではない**（読点で分断） |
| 2 | `C3級` / `D1級` / `B2級` / `B3級` | 英字1 + 数字1 | 2 文字 latin ラン → 縦中横（または `latinUpright`）で正立。`級` は和文。**英数字を分離しない** |
| 3 | `第56魔法少女分隊` | 数字2桁 + 漢字 | `56` を縦中横（2 桁）。`第` は行末禁則ではないが `第`+数字は分割しないのが望ましい（AozoraEpub3 は `第N` を特別扱い） |
| 4 | `連続1000体` / `1100日` / `1000億匹` / `1000円` | 数字4桁 + 助数詞 | **4 桁は自動縦中横しない**（AozoraEpub3 と同じ）。横倒し（回転）または `latinUpright` で正立。数字→漢字の境界は分割可 |
| 5 | `Rank 99,726,438` / `SP 1200.03` / `HP  23.80` / `STR 1.0  0.0` | 英字（可変長）+ 大小の数値・小数・カンマ | `Rank`（4 文字）は正立可、`99,726,438` はカンマ区切りのため **ラン単位では 2/3/3 桁に分断される**。**トークン全体を 1 個の不可分・横倒し（または横組み）扱いにする**のが安全。`1200.03`（7 文字）は横倒し |
| 6 | `数値が 1436 になった` / `1173.03 → 1173.05` / `0074` | 4 桁、小数、先頭ゼロ、矢印 | 4 桁以上は自動縦中横しない。`0074` も 4 桁として非 TCY。`→` は分離禁止に準じる |
| 7 | 青空文庫実例 `米機Ｂ29［＃「29」は縦中横］` | 全角英字 + 数字2桁 | 明示注記で `29` のみ `dir="ltr"`（縦中横）。`Ｂ` は全角なので和字扱い |
| 8 | 青空文庫実例 `ＱＸ30トＱＺ19トハ` | 全角英字 + 数字2桁 | `30`・`19` を縦中横。全角英字は注記なしで正立 |
| 9 | 青空文庫実例 `スハフ［＃「スハフ」は横組み］ 134273` | カタカナ横組み + 6 桁数字 | 6 桁は自動縦中横せず、行中横組みで表示 |
| 10 | 青空文庫実例 `Impia tortorum ...` / `What is Real Happiness?` | 半角欧文 | 注記不要で横組み（デフォルト挙動） |

分類則のまとめ:
- 数字ラン長 `1`: 設定次第（既定は縦中横にする実装が多い）。
- `2`: 縦中横（なろう・カクヨム系ビューアの事実上の標準。minitype 既定、AozoraEpub3 既定、tategaki 実装 2-3 桁）。
- `3`: 縦中横（AozoraEpub3 既定 `autoYokoNum3`）。1 文字分の幅に 3 字を詰めるので可読性は落ちる。
- `4` 以上: 自動縦中横しない（AozoraEpub3）。横倒し、または明示的な横組み・`latinUpright`。
- 英字: 原則横倒し。短い英単語（`in`, `on`, `C3` 等）は任意で正立。既定オフ（AozoraEpub3 `autoAlpha2=false`、`autoAlphaNum2=false`）。
- カンマ・小数・矢印を含む数値は、**見かけの数字ランで分断せずトークン全体を不可分**にする。

---

# 厳格なエンジン設計への示唆

以下は、上記一次情報から Novelty の縦書きエンジンに落とすべき具体的ルール。

### 1. 文字クラス表

- `openingBracket` / `closingBracket` / `comma` / `period` / `middleDot` / `sutegana` / `kana` / `kanji` / `latin` / `digit`（ASCII）/ `fullwidthDigit` / `space` / `dividing`（！？）/ `prolongedSound`（ー）/ `others` を定義。
- minitype は ASCII 数字を `latin` に、全角数字を `others` に入れる。Novelty では **ASCII 数字は `digit` として独立**させ、全角数字は和字（正立）として扱う方が素直。
- 開き括弧: `「（【『［｛〈《〔〖`、閉じ括弧: `」）】』］｝〉》〕〗`、読点 `、，`、句点 `。．`、中点 `・：；`。

### 2. 禁則

- **行頭禁則**: 閉じ括弧、読点、句点、中点、小書き仮名、`ー`、`！？`、`…‥`、句読点の縦書き変体（`︒︑︓︔︖︕` 等）。
- **行末禁則**: 開き括弧とその縦書き変体（`︵﹇︷﹁﹃︻︿︽` 等）。
- **分離禁止**: 数字同士、英字同士、`— ― … ‥` 同士、`！？` の連続、および数値トークン内（`.` `,` `-` `/` `:` を含む）。
- 余りが出たら **追込み**（字間を縮める）→ それでも足りなければ **追出し**（直前の分割点まで戻す）。縮小優先度は「行末約物 → 中点 → 括弧 → latin 境界」の順。
- ぶら下がりは読点・句点を対象に設定可能（`burasagariStyle`）。

### 3. 縦中横（TCY）

- **ASCII 数字のみ**対象（全角数字は対象外）。
- しきい値は設定可能。既定は **2 桁**。AozoraEpub3 互換を狙うなら **1 桁 / 2 桁 / 3 桁を個別フラグ**で。
- **4 桁以上は自動 TCY しない**。グループが行幅に収まらない場合は **グループを分割せず**、グループ単位で次行へ送るか横倒しにする。
- TCY グループは n 文字で 1 em 幅、中央寄せ。グループ内の前進量合計で幅を決める。
- **前後条件**: 前後が半角文字なら TCY にしない（間の半角スペースは無視）。横組み区間・抑止区間では無効。
- 年月日の例外（`1月2日`, `年3月`, `月4日`, `第5刷/版/巻`, 年号+`月5日`）はオプションで再現可能。
- 明示注記（青空文庫 `［＃…は縦中横］`）を最優先。

### 4. 英字・Latin の正立

- 既定は横倒し（回転 90°）。
- `latinUpright` で短いラン（既定 4 文字以下）を全角化＋縦用 GID で正立。ただし **`C3` のような英数字混在**と **`1.0` のような小数**の扱いをポリシー化する（minitype は `.` を latin に含めるが TCY の `\d+` からは除外）。
- `TxtMiru` の「英字も縦中横」設定に相当するトグルを用意。

### 5. 数値トークンの不可分化

- `99,726,438` や `1200.03` のように区切り記号を含む数値は、**数字ランではなくトークン全体**を 1 単位として、折り返し・TCY 判定する。トークンが長い場合は横倒し、または横組み。
- 小数点・桁区切り・負号・パーセント・単位記号を数値トークンの一部として定義。
- 全角と半角が混在する表記（`３.14` 等）は正規化ポリシーを決める。

### 6. 字間（アキ量）

- `TextSpace` 相当をクラスペアのテーブルで持ち、`prevClass→nextClass`、無ければ `prevClass.fallback` → `fallback.nextClass` → `fallback.fallback` で解決。
- 既定は「約物全角」テーブル。閉じ括弧・読点・句点の後は 0、中点は 0.25、和欧間は 0.25、行頭/行末は 0 を基本とする。
- トラッキング挿入は「latin 同士の間」「`—―…‥` 同士の間」「`noSplit` 指定の直前」では行わない。

### 7. ルビ

- 親文字（`baseCount`）とルビ文字列を保持し、割り付けは `jis`（1-2-1）/ `center` / `justify` を実装。既定 `jis`。
- ルビサイズ 0.5em、`rubyOffset` で親文字との間隔。ルビが親文字より長い場合は余剰を前後の親文字へ分配。
- 傍点ルビ（青空文庫の `［＃「○○」に傍点］` を `<ruby><rt>・</rt></ruby>` 的に表現するケース）と通常ルビを区別できるようにする。

### 8. 圏点・傍線

- プリセット: ゴマ・白ゴマ・丸・白丸・黒三角・白三角・二重丸・蛇の目・ばつ。
- 横組みは文字の上、縦組みは文字の右（青空文庫の「左に傍点」は縦組みの左 = 次の行側なので、行方向に注意）。

### 9. パーサ／中間モデルの拡張

- 現行 `NovelContentElement` は `PlainText` / `RubyText` / `NewLine` のみで、数字・Latin・TCY・不可分・圏点を表現できない。**TCY / NoBreak / NoSplit / Kenten / Warichu / Superscript を追加**するか、レンダラ側で `PlainText` をトークナイズする段を設ける。
- なろう・カクヨムは数字・英字を生テキストで返すため、**レンダリング時トークナイズ**が必須（minitype は組版時、AozoraEpub3 は変換時）。`packages/tategaki/lib/src/parser/tategaki_parser.dart` の「半角数字 2-3 桁 → TCY」が現行の最小実装。
- 青空文庫互換を狙う場合は注記パーサを別途用意し、`［＃「N」は縦中横］`・`［＃「X」に傍点］`・`［＃ここから横組み］` を構造化する。

### 10. 縦書き方向の描画

- 和文は縦用 GID（OpenType `vert`）。約物は縦書き変体への字形変換（`。`→`︒`、`、`→`︑`、括弧類）を行い、禁則表にも変体を含める（`packages/tategaki/lib/src/layout/kinsoku.dart` は既に変体を含む）。
- Latin は既定 90° 回転。TCY グループはブロック方向にオフセットして 1 em 内に横並び。
- 行送り・字詰め・段組は `blockOffset` / `inlinePosition` を分離した座標系で扱う（minitype の `CharPosition` と同様）。

### 11. 検証すべきテストケース

- `4、5歳` / `C3級` / `第56` / `1000体` / `99,726,438` / `1200.03` / `1436` / `0074` / `米機Ｂ29` / `ＱＸ30` / `!!` / `!?` / `1月2日` / `年3月` / `第5刷`。
- 禁則: `あ「い」う`、`あ（い`、`あー`、`あ…あ`、`あ！！`。
- 各行末で括弧・読点が行頭に来ないこと、4 桁数字が TCY されないこと、数値トークンが分断されないこと。

---

## 付録: 主要ファイル・URL

- `@minitype/minitype` v0.1.6 tarball: `https://registry.npmjs.org/@minitype/minitype/-/minitype-0.1.6.tgz`（`npm pack @minitype/minitype@0.1.6`）
- 公式: https://typeset.jp / https://typeset.jp/references/ / `dist/llms.txt`
- 配布 `.d.ts`: `dist/lib/inline.d.ts`, `dist/typesetting/{char-class,space,typesetter,typesetter-cjk,typesetter-knuth,vertical-preprocess,default-space}.d.ts`, `dist/plugin/built-in/{kenten,siunitx,inline-extender}.d.ts`, `dist/style/{style,figure,unit}.d.ts`, `dist/index.d.ts`
- TSX ラッパ: `site/repomix-output-minitype-project-tsx.xml`（`@minitype/tsx` 0.1.2、`site/package.json`）
- 青空文庫注記: https://www.aozora.gr.jp/annotation/ / `etc.html` / `emphasis.html`
- AozoraEpub3: https://github.com/hmdev/AozoraEpub3 (`src/com/github/hmdev/converter/AozoraEpub3Converter.java`, `src/com/github/hmdev/util/CharUtils.java`, `README.md`)
- TxtMiru: https://so-zou.jp/software/tool/document/txt-miru/ / https://rd.vector.co.jp/download/file/win95/util/fh215781.html / http://www.hi-ho.ne.jp/makoto_watanabe/ve/style_basis.html
- 読書尚友: https://ebstudio.info/manual/BookViewer/00about.php / https://ebstudio.info/manual/BookViewer_ios/00about.php / https://ebstudio.hatenablog.com/entry/2022/11/15/124147
- JIS X 4051:2004: https://kikakurui.com/x4/X4051-2004-02.html
- なろう HTML: `docs/narou_html/{ncode}.md`, `docs/narou_html/{ncode}/{episodes}.md`
- カクヨム HTML: `docs/kakuyomu_html/episode.md`
- パーサ: `packages/narou_parser/lib/src/parser_lookup.dart`, `packages/kakuyomu_parser/lib/src/parser.dart`, `packages/novel_parser_core/lib/src/models/novel_content_element.dart`
- 縦組み試作: `packages/tategaki/lib/src/parser/tategaki_parser.dart`, `packages/tategaki/lib/src/layout/kinsoku.dart`
