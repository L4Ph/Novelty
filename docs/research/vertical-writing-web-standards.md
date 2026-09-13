# 日本語縦書きエンジンのための Web 標準・ブラウザ実装 一次情報調査

最終更新: 2026-09-13

本レポートは、Flutter 上に独自の日本語縦書き（縦組）エンジンを実装するための判断材料として、W3C 仕様・Unicode 標準・ブラウザ実装を**一次情報**から調査したものである。各主張には出典（URL と節番号）を付す。特に明記しない限り、仕様記述は**規範的（normative）**、ブラウザ実装・バグ・互換表は**実装詳細（informative）**である。

- 「規範」= 仕様が要求する振る舞い。
- 「実装」= 実際の Blink / WebKit / Gecko の挙動。仕様と一致しないことがある。

---

## 1. CSS Writing Modes Level 3 / 4

一次情報: W3C, *CSS Writing Modes Level 4*, W3C Candidate Recommendation 30 July 2019, <https://www.w3.org/TR/css-writing-modes-4/>（以下 CSS-WM-4）。Level 3 も本質的に同じプロパティ集合を持つ。

### 1.1 `writing-mode`（§3.2）

| 値 | ブロックフロー方向 | 書字方向モード | 組版モード |
|---|---|---|---|
| `horizontal-tb` | 下→上（横書き） | horizontal | horizontal |
| `vertical-rl` | 右→左（縦書き・日本語で一般的） | vertical | vertical |
| `vertical-lr` | 左→右（モンゴル文字など） | vertical | vertical |
| `sideways-rl` | 右→左 | vertical | horizontal |
| `sideways-lr` | 左→右 | vertical | horizontal |

仕様（CSS-WM-4 §3.2）:

- 初期値 `horizontal-tb`、継承あり、すべての要素に適用（table row/column group 等を除く）。
- `vertical-rl` / `vertical-lr` は「書字方向モード（writing mode）も組版モード（typographic mode）も vertical」。
- `sideways-rl` / `sideways-lr` は「書字方向モードは vertical、組版モードは horizontal」。つまり行内のグリフは常に 90°回転され、`text-orientation` の影響を受けない（後述の縦組用の字形選択を行わない）。
- replaced element（画像・iframe 等）の内容は writing-mode で回転しない（CSS-WM-4 §3.2）。

日本語縦組に使うのは原則 `vertical-rl`。English の spine/表ヘッダのように**横向きテキストを縦に置く**用途は `sideways-*` を使うべきで、`vertical-*` の代用にしてはならない（W3C i18n, *Styling vertical CJK text*, <https://www.w3.org/International/articles/vertical-text/index.en.html>「Sideways values of writing-mode」）。

### 1.2 `text-orientation`（§5.1）

値: `mixed | upright | sideways`。初期値 `mixed`、継承あり。**horizontal な組版モードでは効果がない**（CSS-WM-4 §5.1）。

- `mixed`（既定）: horizontal-only なスクリプトの文字を**横倒し（90°時計回り）**、vertical なスクリプトの文字を**本来の縦向き**で組む（CSS-WM-4 §5.1）。
- `upright`: horizontal-only な文字も**正立**させる。加えて、使用値の `direction` を `ltr` にし、bidi 上すべての文字を strong LTR として扱う（CSS-WM-4 §5.1）。これは RTL 文字（アラビア語等）を正立させるときに重要。
- `sideways`: すべての文字を、横組を 90°時計回りに回転したように組む（CSS-WM-4 §5.1）。

**どの文字が回転するかは UTR #50 / UAX #50 の `Vertical_Orientation` プロパティで決まる**（CSS-WM-4 §5.1.2）:

> When text-orientation is mixed, the UA must determine the orientation of each typographic character unit by its Vertical_Orientation property: typesetting it upright if its orientation property is U, Tu, or Tr; or typesetting it sideways (90° clockwise from horizontal) if its orientation property is R.

- したがって既定（`mixed`）では、**ASCII 数字・ラテン文字は R なので横倒し**、**漢字・かなは U（または Tu/Tr）なので正立**。
- OpenType の `vrt2` は CSS では使われず、UA が UTR50 に従って正立/横倒しを決める（CSS-WM-4 §5.1.2）。
- `upright` では OpenType `vert` 相当の縦書き用字形を使う。ただしフォントに無い場合は UA が合成してよい（CSS-WM-4 §5.1.1）。
- 縦組の baseline: `text-orientation` が `mixed` / `upright` のときは **central baseline が dominant**（CSS-WM-4 §4.2）。

### 1.3 `text-combine-upright`（§9.1）

**縦中横（tate-chu-yoko）の仕様上の基盤。**

| 項目 | 内容 |
|---|---|
| 値 | `none | all | [ digits <integer>? ]`（CSS-WM-4 §9.1） |
| 初期値 | `none`、**継承あり** |
| 適用対象 | non-replaced inline elements |
| computed value | specified keyword + integer（digits の場合） |

- `all`: ボックス内の**連続する組版文字単位をすべて**、縦1文字分のスペースに横組する（CSS-WM-4 §9.1）。
- `digits <integer>?`: **連続する ASCII 数字（U+0030–U+0039）の極大列**のうち、指定整数以下の長さのものを縦1文字分に横組する。整数省略時は **2**。**有効範囲は 2–4**、それ以外は無効（CSS-WM-4 §9.1）。
  - ここが重要: 「n 桁ずつ区切って結合」ではなく、**極大列そのものの長さが n 以下なら結合、超えるなら何もしない**。たとえば `digits 2` に `123` を適用すると、極大列は `123`（3 > 2）なので**結合しない**（WPT `text-combine-upright-value-digits2-003.html` がこの挙動をテスト）。
  - `digits` は ASCII 数字のみ。小数点 `.`、位取り `,`、空白は**結合対象外で列を分断する**。仕様の例（CSS-WM-4 §9.1）では `10,000` に `digits 2` を当てると `10` は結合、`,000` は結合されない。
- 結合できるのは**プレーンテキストのみ**で、ボックス境界で中断されない連続文字に限る。継承するので、祖先の同一 `text-combine-upright` 値を持つ別ボックスをまたぐ結合列は、たとえ要素境界で分割されていても結合しない（CSS-WM-4 §9.1.1）。この look-ahead / look-behind 規則は仕様上 **at-risk** と明記されている（CSS-WM-4 Status of this document）。
- レイアウト規則（§9.1.2）: 結合テキストは bidi 的に isolate され、`line-height: 1em` の horizontal inline-block と同様に横組される。実効サイズは **1em 平方**で、はみ出す分はレイアウト測定から除外される。グリフは 1em 平方の中央に配置される。baseline は親インラインボックスの text-over/text-under baseline の中間に来るように選ばれる。bidi 上は `text-orientation: upright` の1文字として扱われる。行分割・decoration・spacing では **U+FFFC (OBJECT REPLACEMENT CHARACTER) 1グリフ**として扱われる。
- 圧縮規則（§9.1.3）: 結合後の advance width が 1em を超える場合、UA は**必ず 1em に収める**。OpenType 実装は `hwid` / `twid` / `qwid`（`fwid`/`pwid` は不可）を使う。無ければ半角・3分・4分幅グリフ、幾何スケーリング等で圧縮してよい。全角文字を含む場合は、まず `text-transform: full-width` の逆変換で非全角に戻してから圧縮する（§9.1.3.1）。

> **注**: `text-combine-upright` の計算値に整数を含むため、`digits` は値として存在する。しかし後述のとおり主要ブラウザは `digits` を実装していない。

### 1.4 `direction` と `unicode-bidi`（§2.1, §2.2）

- `direction`: `ltr | rtl`、初期値 `ltr`、継承あり。行内のベース方向、テーブル列の順序、水平オーバーフロー方向、既定の text-align を決める（CSS-WM-4 §2.1）。
- `text-orientation: upright` は**使用値の `direction` を `ltr` に強制**する（§5.1）。縦組で RTL を正立させるときは、仕様の注記どおり `unicode-bidi: bidi-override; direction: ltr` を明示する必要が生じうる（§5.1 の note）。ただし同 note は「現時点で主要実装は upright 時の RTL 自動 LTR 化をサポートしていない」と述べている（実装ギャップ）。

---

## 2. CSS Text Level 3 / 4

### 2.1 `line-break`（CSS Text 3 §5.2）

一次情報: W3C, *CSS Text Module Level 3*, <https://www.w3.org/TR/css-text-3/#line-break-property>。値: `auto | loose | normal | strict | anywhere`。継承あり。

仕様が**規範的に**定める差分（CSS Text 3 §5.2）:

- `normal` / `loose`（中国語・日本語のとき）: CJK ハイフン様 `〜 U+301C`, `゠ U+30A0` の前で分割可。
- `loose`（直前が Unicode line breaking class **ID** のとき、`word-break: break-all` で ID 扱いのときを含む）: `‐ U+2010`, `– U+2013` の前で分割可。
- `normal` / `strict` では禁止、`loose` で許容:
  - 小書き仮名・長音記号（line breaking class **CJ**）の前
  - 反復記号 `々 U+3005`, `〻 U+303B`, `ゝ U+309D`, `ゞ U+309E`, `ヽ U+30FD`, `ヾ U+30FE`
  - 分離不能文字（`‥ U+2025`, `… U+2026` 等、class **IN**）の間
- `loose`（中国語・日本語のとき）: 中黒・コロン・セミコロン等（`・ U+30FB`, `： U+FF1A`, `； U+FF1B`, `･ U+FF65`, `‼ U+203C`, `⁇ U+2047`, `⁈ U+2048`, `⁉ U+2049`, `！ U+FF01`, `？ U+FF1F`）の前で分割可。
- `loose`: class **PO**（East Asian Width が A/F/W）の前で分割可、class **PR**（同）の後ろで分割可。
- `anywhere`: すべての組版文字単位間で soft wrap opportunity を許す。GL/WJ/ZWJ class や `word-break` による禁止も無視。優先順位付けなし、ハイフネーションなし（§5.2）。

**JIS X 4051 / JLREQ との関係についての規範的立場**: 仕様は「`loose`/`normal`/`strict` の正確な規則集合は UA が決め、言語慣習に従うべき」とし、必須要件は上記 CJK 差分のみ（CSS Text 3 §5.2）。仕様は実装の出発点として UAX #14 を挙げつつ、JLREQ・JIS X 4051・CLREQ を参照情報として示すのみで、**JIS X 4051 の禁則レベルへの規範的マッピングはしていない**（CSS Text 3 §5.2, line breaking の節;参照文献 [JIS4051], [JLREQ]）。CSS Text Level 4 も同様（<https://www.w3.org/TR/css-text-4/#line-break-property>）。

### 2.2 `word-break`（CSS Text 3 §5.1）

値: `normal | keep-all | break-all | break-word`。継承あり。`normal`/`break-all`/`keep-all` の挙動を定義し、`break-word` は `overflow-wrap: anywhere` と同義の legacy 値（§5.1、§5.4）。CJK では `keep-all` が「CJK 文字を非 CJK のようにふるまわせる（単語内で分割しない）」、`break-all` が「CJK 以外も文字単位で分割」に対応する（§5.1）。

### 2.3 `overflow-wrap`（CSS Text 3 §5.4）

値: `normal | break-word | anywhere`。継承あり。`break-word` は `anywhere` とほぼ同じだが、min-content intrinsic size の計算で soft wrap opportunity を考慮しない点が異なる（§5.4）。`word-wrap` は legacy alias（§5.4）。

### 2.4 `text-align`（CSS Text 3 §6.1）

値: `start | end | left | right | center | justify | match-parent | justify-all`。初期値 `start`、継承あり、block containers に適用。`start`/`end` は**論理方向**で、縦組では行の天地に対応する。`justify` は `text-justify` に従い行を正確に埋め、最終行は（`text-align-last` 指定がなければ）start そろえ（§6.1, §6.4）。`justify-all` は最終行も justify する（§6.1）。

### 2.5 `text-justify`（CSS Text 3 §6.4）

値: `auto | none | inter-word | inter-character`。`inter-character` は「隣接する組版文字単位間のスペースを調整する。日本語などの東アジアで使われる」と明記されている（§6.4）。`distribute` は `inter-character` の legacy alias として必須サポート（§6.4）。`auto` の既定は UA 裁量で、JLREQ に従う日本語向けの正当化も例示されるが、完全なアルゴリズムは Level 3 では定義しない（§6.4, §6.4.1）。伸長/圧縮は `letter-spacing` / `word-spacing` と加算的に適用される（§6.4.1）。

### 2.6 `hanging-punctuation`（CSS Text 3 §8.2.1）

値: `none | [ first || [ force-end | allow-end ] || last ]`。継承あり。1行の各端で**最大1文字**だけぶら下げ可能（§8.2.1）。`first` は Ps/Pf/Pi と ASCII 引用符、`U+3000`。`last` は Pe/Pf/Pi と ASCII 引用符。`force-end` / `allow-end` は停止符・読点類（`、。`、`，．`、`．`、small forms 等）を対象とする（§8.2.1）。実装サポートは限定的で、JLREQ §3.8.2 は「ぶら下げ組は JIS X 4051 の規定ではなく解説で説明されている」と位置づける。

### 2.7 `text-spacing-trim`（CSS Text 4 §8.5）

一次情報: W3C, *CSS Text Module Level 4*, <https://www.w3.org/TR/css-text-4/#text-spacing-trim-property>。値: `<spacing-trim> | auto`、`<spacing-trim> = space-all | normal | space-first | trim-start | trim-both | trim-all`（§8.5）。

- 全角の始め括弧類・終わり括弧類・中点類を、行頭/行末/隣接関係に応じて**半角（flush）または全角（spaced）**に設定し、約物連続時の空きを詰める（§8.5）。
- `normal`: 行頭の始め括弧は全角、行末の終わり括弧は「justification 前に収まらない場合のみ半角」、約物間は詰める。`trim-both`: 行頭・行末とも半角。`trim-start`: 行頭のみ半角。`trim-all`: 位置・隣接によらず半角。`space-first`: 最初の行と強制改行後の行のみ始め括弧を全角（既存 ePub 互換のため）（§8.5）。
- 隣接約物の半角化にはフォントの OpenType `halt` / `chws` が必要で、無ければ無効（MDN, *text-spacing-trim*, <https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/text-spacing-trim>）。

### 2.8 `text-autospace`（CSS Text 4 §8.4）

値: `normal | <autospace> | auto`、`<autospace> = no-autospace | [ ideograph-alpha || ideograph-numeric || punctuation ] || [ insert | replace ]`（§8.4）。

- 和文（ideograph）と欧文（non-ideographic letters/numerals）の境界などに**自動でアキを挿入**する。挿入量は **CJK advance の 1/8 = 0.125ic**（§8.4.1）。
- 挿入規則は日本語組版の慣習（JLREQ）に相当する。`text-spacing-trim`（約物の詰め）と `text-autospace`（和欧間の空け）は補完関係。
- ideograph の定義は `U+3041–U+30FF`（句読点を除く）・CJK Strokes・Katakana Phonetic Extensions・Han extended script（§8.4.1）。non-ideographic letters/numerals からは「East Asian Wide/Fullwidth のもの」「縦組で upright になるもの（`text-orientation`/`text-combine-upright`）」を除外する（§8.4.1）。

---

## 3. Unicode

### 3.1 UAX #14 Line Breaking Algorithm

一次情報: Unicode, *UAX #14: Unicode Line Breaking Algorithm*, <https://www.unicode.org/reports/tr14/>。

CJK と数字に関係する主なクラス（§5 Table 1）:

| クラス | 名称 | 意味 |
|---|---|---|
| `NU` | Numeric | 数字。行分割上「数値式」を形成 |
| `IS` | Infix Numeric Separator | `.` `,`。数値の後ろと、数値の前で分割を防ぐ |
| `CL` | Close Punctuation | `}` 等。直前で分割禁止 |
| `CP` | Close Parenthesis | `)` `]`。直前で分割禁止 |
| `EX` | Exclamation/Interrogation | `!` `?` 等。直前で分割禁止 |
| `IN` | Inseparable | リーダー類。ペア間は間接分割のみ |
| `NS` | Nonstarter | `‼` `‽` 等。直前で間接分割のみ |
| `OP` | Open Punctuation | `(` `[` `{` 等。直後で分割禁止 |
| `QU` | Quotation | 引用符 |
| `PO` | Postfix Numeric | `%` `¢`。数値式の直後で分割禁止 |
| `PR` | Prefix Numeric | `$` `£` `¥`。数値式の直前で分割禁止 |
| `ID` | Ideographic | 漢字等。数値文脈を除き前後で分割可 |
| `CJ` | Conditional Japanese Starter | 小書き仮名。strict/normal では NS、loose では ID 相当 |
| `AL` | Alphabetic | 欧字・記号 |

関連規則（原文で確認）:

- **LB13**: `× CL`, `× CP`, `× EX`, `× SY` — これらの直前で分割しない。
- **LB21**: `× BA`, `× HH`, `× HY`, `× NS` — ハイフン・非 starter の直前で分割しない。
- **LB22**: `× IN` — 三点・二点リーダーの直前で分割しない。
- **LB25 (Do not break numbers)**: `NU (SY | IS)*` を核に、`CL`/`CP`/`PO`/`PR`/`NU`/`OP`/`IS`/`HY` の組み合わせで数値を分割しない。仕様は `( PR | PO ) ? ( OP | HY ) ? IS ? NU ( NU | SY | IS ) *` の形の数値を**分割しないこと**を推奨している（LB24 の直後の記述）。
- CJK の禁則（JLREQ の行頭禁則・行末禁則）は UAX #14 の `CL`/`CP`/`EX`/`NS`/`OP`/`QU` と、CSS `line-break` の追加規則で近似される。

> **重要**: UAX #14 は**ベースライン**であり、JLREQ のような言語固有の禁則は「tailoring（調整）」として別途適用される（UAX #14 §8 ほか、CSS Text 3 §5.2 の注記）。UTF-8 の日本語本文を正しく禁則処理するには、自前で JLREQ §3.1.7/§3.1.8 の行頭・行末禁則クラスを実装する必要がある。

### 3.2 UAX #29 Grapheme Clusters

一次情報: Unicode, *UAX #29: Unicode Text Segmentation*, <https://www.unicode.org/reports/tr29/#Grapheme_Cluster_Boundaries>。

- 「default grapheme cluster」は「extended grapheme cluster」とも呼ばれる（UAX #29 §3, §4.2）。結合文字・絵文字 ZWJ シーケンス・領域表示子などを1単位として扱う。
- **縦書きの文字方向は文字ではなく grapheme cluster 単位で適用すべき**（UTR #50 §3.2.1）。extended / legacy いずれの定義でもよいが、ベース文字の最初の文字の orientation を使い、**囲み結合記号（general category Me）を含むクラスタは全体を U（正立）**とする（UTR #50 §3.2.1）。

### 3.3 UAX #50 / UTR #50 `Vertical_Orientation`

一次情報: Unicode, *UAX #50: Unicode Vertical Text Layout*, <https://www.unicode.org/reports/tr50/>（Version Unicode 17.0.0, 2025-07-24）。データファイル: <https://www.unicode.org/Public/UNIDATA/VerticalOrientation.txt>。

値（§3.1）:

| 値 | 意味 |
|---|---|
| `U` | code chart と同じ向きで**正立** |
| `R` | code chart から**90°時計回りに横倒し** |
| `Tu` | 正立だが code chart と異なる縦書き用グリフを要することが多い。フォールバックは U |
| `Tr` | Tu と同様だが、フォールバックは 90°時計回り（R） |

性質（§3.2, §3.2.1, §3.2.4）:

- 本プロパティは **informative**（§2）。文書が明示指定しない場合の安定した既定値を与える。
- コードチャートの向きは Unicode 7.0 以降「横書き時の向き」に統一された（§3.3）。
- ASCII の引用符・全角引用符（U+2018/2019/201C/201D）は、全角グリフで表示される場合に縦書きで別グリフを使う（§3.2.4）。Revision 33 でこれらは `R` から `Tr` に変更された（Modifications, Revision 33）。

**データファイルで確認した重要なクラス分け**（`VerticalOrientation.txt`, Unicode 17.0.0）:

| 範囲 | 値 | 例 |
|---|---|---|
| `U+0020` SPACE | `R` | 半角スペース |
| `U+0021..0023` | `R` | `!` `"` `#` |
| `U+0028` | `R` | `(` |
| `U+002C` | `R` | `,` |
| `U+002D` | `R` | `-` |
| `U+002E..002F` | `R` | `.` `/` |
| **`U+0030..0039`** | **`R`** | **ASCII 数字（横倒し）** |
| `U+003A..003B` | `R` | `:` `;` |
| **`U+0041..005A`** | **`R`** | **ASCII 大文字（横倒し）** |
| `U+005B`, `U+007B` | `R` | `[` `{` |
| **`U+0061..007A`** | **`R`** | **ASCII 小文字（横倒し）** |
| `U+3000` IDEOGRAPHIC SPACE | `U` | 全角スペース（正立） |
| `U+3001..3002` | `Tu` | `、` `。`（縦書き用字形） |
| `U+3008`, `U+300C`, `U+300D`, `U+3010` 等 | `Tr` | 各種括弧（縦書き用字形、フォールバック R） |
| `U+30A0` DOUBLE HYPHEN | `Tr` | |
| `U+30FB` KATAKANA MIDDLE DOT | `U` | 中黒（正立） |
| `U+30FC` PROLONGED SOUND MARK | `Tr` | 長音記号 |
| **`U+FF01`** | `Tu` | 全角 `！` |
| `U+FF02..FF07` | `U` | 全角 `”` `＃` `＄` `％` `＆` `’` |
| `U+FF08`, `U+FF09` | `Tr` | 全角 `（` `）` |
| `U+FF0C`, `U+FF0E` | `Tu` | 全角 `，` `．` |
| `U+FF0D`, `U+FF1C..FF1E` | `R` | 全角 `－` `<` `=` `>` |
| `U+FF0F` | `U` | 全角 `/` |
| **`U+FF10..FF19`** | **`U`** | **全角数字（正立）** |
| `U+FF1A..FF1B` | `Tr` | 全角 `：` `；` |
| `U+FF1F` | `Tu` | 全角 `？` |
| `U+FF20` | `U` | 全角 `＠` |
| **`U+FF21..FF3A`** | **`U`** | **全角ラテン大文字（正立）** |
| `U+FF3B`, `U+FF5B` | `Tr` | 全角 `［` `｛` |
| **`U+FF41..FF5A`** | **`U`** | **全角ラテン小文字（正立）** |

まとめ（**決定的事実**）:

- **ASCII の数字・ラテン文字は既定（`mixed`）で横倒し（R）**。日本語縦組でこれらを正立・縦中横にしたい場合は、明示的に `text-orientation: upright`、`text-transform: full-width`、全角コードポイント、または `text-combine-upright` を使う必要がある。
- **全角形（FF10–FF19, FF21–FF3A, FF41–FF5A）は正立（U）**。したがって「全角に変換すれば正立する」という W3C i18n の指針と整合する。
- 日本語の約物 `、。` は `Tu`、括弧類は `Tr`。つまり**正立だが縦書き用の代替グリフ**を使う必要がある（OpenType `vert`）。
- 中黒 `U+30FB` は `U`、長音 `U+30FC` は `Tr`。

---

## 4. JLREQ（W3C Japanese Layout Requirements）

一次情報: W3C, *Requirements for Japanese Text Layout*, <https://www.w3.org/TR/jlreq/>（本レポートでは同ページの日英併記テキストを参照。節番号は英語版・日本語版で共通）。

### 4.1 縦組におけるアラビア数字の3つの配置方法（§3.2.3, §2.3.2）

JLREQ §3.2.3 は、縦組で欧字・アラビア数字を配置する方法を3つ挙げる:

1. **和文文字と同じく正立で1字1字配置**（Figure 94）。文中の欧字/数字が1字の場合に使う。通常は**全角モノスペース**書体。プロポーショナル書体を全角スペース内に正立配置する方法もある（§3.2.4）。
2. **90°時計回りに回転して配置**（Figure 95）。欧字が一般の単語・文の場合。横組同様に**プロポーショナル書体**（数字は半角）を使う。
3. **縦中横（tate-chu-yoko）で配置**（Figure 96）。**2桁のアラビア数字**や、行幅と同程度〜やや超える程度の2〜3文字の欧字列で使う。プロポーショナル書体（数字は半角）。

補足（Note, §3.2.3）: 頭字語 `GNP` や `Web` のような語は原則 1字ずつ正立配置だが、90°回転する例もある。また、縦組の数字は伝統的に漢数字を使うのが原則だったが、新聞等でアラビア数字が増え、縦中横の利用が増大している。

### 4.2 縦中横（tate-chu-yoko）の処理（§3.2.5）

- 縦中横にする文字列は**まず左から右へベタ組**し、その**文字列全体を行の中央**に配置する（§3.2.5）。
- 前後に平仮名・片仮名・漢字等が来る場合、字間は**ベタ組**。
- 読点類（cl-07）・終わり括弧類（cl-02）の後ろ、または始め括弧類（cl-01）の前では、原則**二分アキ**。
- 行中で句点類（cl-06）の後ろに縦中横が来る場合も**二分アキ**。ただし句点が行末ならその後ろも二分アキ。
- 句点・読点・終わり括弧の前、始め括弧の後ろに縦中横が来る場合は**ベタ組**。
- 隣接文字クラスとの詳細な空き量は §B（文字間の空き量）の表に従う。

### 4.3 分割禁止（unbreakable sequences, §3.1.10）

「これらの文字・記号が連続する場合は、その字間で2行に分割しない」。主なもの:

- **連続するアラビア数字の字間**（Figure 82–84）。アラビア数字は「位置で桁を示す」ため分割不可。**漢数字は分割可**（位取りの読点・概数読点・小数点の中点の前は不可、後ろは可）。
- **小数点 `FULL STOP .`、位取りの `COMMA ,` または空白の前後も含めて分割禁止**（§3.1.10 Note, Figure 84）。ここが重要: JLREQ は「数字＋小数点/位取り/空白」を**ひとかたまり**として扱う。
- **前置省略記号（cl-12）**（`¥`, `$`, `¢` 等）と後続の数字との間。
- **後置省略記号（cl-13）**（`%`, `‰` 等）と先行する数字との間（ただし `%` は独立性が高く分割を認める考え方もある。`50パーセント` の `0` と `パ` の間は分割可、§3.1.10 Note）。
- **欧文単語内の、ハイフネーション可能箇所以外の字間**、および単位記号（`km`, `kg`, `mm` 等）内の字間。
- 連続する全角ダッシュ（2倍ダッシュ `——`）、連続する三点リーダ/二点リーダ（`……`, `‥‥`）。
- 行頭禁則（§3.1.7）・行末禁則（§3.1.8）も分割禁止として解釈できる（§3.1.10 Note）。

**CSS `line-break` との不一致**: CSS の既定 `line-break: auto`/`normal` は UAX #14 ベースで、`10,000` のような「数字＋カンマ＋数字」を `IS`/`NU` で結合しうるが、JLREQ の分割禁止セット（読点・中点・前置/後置省略記号・位取り空白を含む）とは範囲が異なる。独自エンジンでは JLREQ §C（文字間での分割の可否）の表を実装するのが安全。

### 4.4 行の調整処理（line adjustment / justification, §3.8）

- 段落末尾の最終行を除き、**すべての行の行長をそろえる**のが日本語組版の原則。欧文の "ragged right" 等に相当する概念はない（§3.8.1 Note）。
- 調整方法は2つ（§3.8.2）:
  1. **詰める処理（追込み）**: 読点類・終わり括弧類の後ろ、始め括弧類の前の二分アキ、欧文間隔（cl-26）などを規定範囲内で詰める。
  2. **空ける処理（追出し）**: 欧文間隔や、空ける処理を避けない箇所の字間を広げる。
- **詰める処理を優先し、それで処理できない場合に空ける処理**を行う（§3.8.2）。
- 優先順位（§3.8.3）: 欧文間隔を最小四分アキまで均等に詰める → 行末の終わり括弧・読点・句点の後ろの二分アキをベタに → 行末の中点の前後四分アキをベタに → …。詳細は §D/§E の表。
- **空けてはいけない箇所**（分離禁止, §3.1.11）: §3.1.10 の分割禁止箇所、始め括弧の後ろ/終わり括弧の前、句点/読点の前後、中点の前後、区切り約物の前後、ハイフン類の前後、和字間隔の前後、熟語ルビ付き親文字の字間。
- ぶら下げ組は JIS X 4051 では規定されず「解説」で説明される方法（§3.8.2 Note）。

### 4.5 ルビ（ruby, §3.3）

- **モノルビ**（§3.3.5）: ルビ文字列はベタ組。親文字1字とルビ1字のとき、縦組では天地中央をそろえる**中付き**、または上端をそろえる**肩付き**。親文字1字にルビ3字以上なら、中付き/肩付きの別に応じた配置。モノルビは親文字とルビを**一体**として扱い、内部改行禁止。
- **グループルビ**（§3.3.6）: 親文字列長＝ルビ列長なら両者をベタ組にし中心をそろえる。ルビが短い場合は、ルビ文字間の空き量を2、先頭・末尾の空き量を1の比率で空ける（JIS X 4051 の方法, Figure 124）、または先頭・末尾をそろえてルビ文字間のみ空ける（Figure 125）。
- **熟語ルビ**（§3.3.7）: 熟語を構成する各漢字のルビがそれぞれ2字以下なら、各親文字とルビを対応させモノルビとして配置。**1字でも3字以上のルビがある場合は熟語全体にルビを付す**（グループルビ同様の方法、または熟語の構成と隣接文字種を考慮する方法）。熟語ルビは親文字の区切りで2行に分割してよく、付き親文字の字間は**行の調整処理で空ける対象としない**。
- **はみ出し処理**（§3.3.8）: ルビが長い場合、隣接する漢字にはルビを掛けてはならない。平仮名・片仮名・長音記号・小書き仮名にはルビ文字サイズの全角まで掛けてよい。

---

## 5. ブラウザ / エンジンの実装状況

### 5.1 `text-combine-upright`: `all` は実装、`digits` は未実装

**規範**は `all` と `digits <integer>?` の双方を定義する（CSS-WM-4 §9.1）。しかし**実装**は `all` のみである。

- **Blink（Chrome/Edge）**: `third_party/blink/renderer/core/css/css_properties.json5` の `text-combine-upright` は

  ```json5
  name: "text-combine-upright",
  inherited: true,
  keywords: ["none", "all"],
  ```

  と、**`digits` を keyword に持たない**（したがって `digits` は解析できない）。一次情報: <https://raw.githubusercontent.com/chromium/chromium/main/third_party/blink/renderer/core/css/css_properties.json5>（`text-combine-upright`）。`-webkit-text-combine` は `none` / `horizontal` のサロゲートプロパティとして登録されている（同ファイル, `surrogate_for: "text-combine-upright"`）。
- **Blink の `all` 実装**: `LayoutTextCombine`（<https://raw.githubusercontent.com/chromium/chromium/main/third_party/blink/renderer/core/layout/layout_text_combine.h>）。ヘッダのコメントは "The layout object for the element having `text-combine-upright:all` in vertical writing mode" と明記。子は `LayoutText` かつ `StyleRef().HasTextCombine()` のときに限る。1em に収めるため、幅を `scale_x_` でスケールするか、`compressed_font_`（幅バリアント `hwid`/`twid`）を使う（同 `.cc`, `SetScaleX`, `SetCompressedFont`）。**自動的な数字列検出・グループ化は行わない**。
- **WebKit（Safari）**: `RenderCombineText`（<https://raw.githubusercontent.com/WebKit/WebKit/main/Source/WebCore/rendering/RenderCombineText.h>）が要素のテキスト全体を横組し、1em に収まるよう**フォントサイズを縮小**する（最小スケール 0.4、`.cpp` の `combineTextIfNeeded`）。`digits` の構文は未実装: WebKit Bug 234706 "Implement digits syntax for text-combine-upright" は **NEW** のまま（<https://bugs.webkit.org/show_bug.cgi?id=234706>）。歴史的経緯は Bug 150821（`text-combine-upright: all` は実装済み、旧 `-webkit-text-combine` は legacy）（<https://bugs.webkit.org/show_bug.cgi?id=150821>）。Safari は長く `-webkit-text-combine: horizontal` を使う必要があり、Apple のガイドも縦中横には `-webkit-text-combine` を使うよう明記している（<https://help.apple.com/itc/booksassetguide/en.lproj/itc7e9ec52f7.html> "Text Directions"）。
- **Chromium Bug 40674447** "Implement text-combine-upright: digits `<integer>`?" は 2020 年起票の Feature Request P3 で未解決（<https://issues.chromium.org/issues/40674447>）。
- **Gecko（Firefox）**: `all` は Firefox 48 から対応（<https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Releases/48>）。`digits` の computed value WPT は FAIL と報告されている（Bugzilla 2002512 の WPT 同期記録, <https://bugzilla.mozilla.org/show_bug.cgi?id=2002512>）。

> **結論（`digits` の指定 vs 実装）**: 仕様は「ASCII 数字の極大列が n 桁以下ならその列全体を1文字分に横組する」と定義するが、**Blink/Gecko/WebKit はいずれも `digits` 値を解釈しない**。実務上は著者が数字列（および任意の短い欧字列）を `<span>` でマークアップし、`text-combine-upright: all` を当てる。W3C の現行記事も Blink/Gecko/WebKit すべてで `digits` を「❌」としている（W3C i18n, *Styling vertical CJK text*；W3C *Japanese Gap Analysis* #169, <https://www.w3.org/TR/jpan-gap/#x169-tate-chu-yoko-lacks-support-for-digits-value>）。
>
> したがって **`digits 2` の「2桁ずつグループ化」をブラウザに期待することはできない**。グループ化（`123456` を `12` `34` `56` にする等）をしたい場合は、アプリ側で ASCII 数字列を検出して分割し、各区間を `all` で横組する必要がある。これは仕様の `digits`（極大列長 ≤ n のときのみ結合）よりも踏み込んだ挙動であることに注意。

### 5.2 `text-orientation: mixed` と UTR50

- Blink は ICU の `UCHAR_VERTICAL_ORIENTATION` を参照し、`U_VO_ROTATED` でなければ正立とする:
  `third_party/blink/renderer/platform/text/character.cc` の `Character::IsUprightInMixedVertical`（<https://raw.githubusercontent.com/chromium/chromium/main/third_party/blink/renderer/platform/text/character.cc>）。コメントでも仕様節 `#vertical-orientations` を参照している。これは仕様（CSS-WM-4 §5.1.2）の U/Tu/Tr=正立、R=横倒しと一致する。
- W3C i18n の現行テストでは、`text-orientation: upright`（正立）は主要エンジンで動作し、`text-orientation` の upright サポートギャップは「Fixed」とされている（W3C *Japanese Gap Analysis* #168, <https://www.w3.org/TR/jpan-gap/#x168-upright-text-orientation-not-supported>）。ただし非ラテン系（アラビア語・デーヴァナーガリー）の upright は依然不十分（同記事、および *Styling vertical CJK text*）。

### 5.3 禁則・line-break の実装

- Blink は ICU の行分割に加え、独自の strictness tailoring を持つ。`third_party/blink/renderer/platform/text/text_break_iterator.cc` に `LineBreakStrictness::kLoose` / `kNormal` / `kStrict` があり、たとえば「LB21 の BA クラス直前の分割を `line-break: loose` のときだけ許す」等を実装する（<https://raw.githubusercontent.com/chromium/chromium/main/third_party/blink/renderer/platform/text/text_break_iterator.cc>）。これは CSS Text 3 §5.2 の CJK 差分を実装したものだが、**JIS X 4051 の全禁則を実装しているわけではない**。
- CSS 仕様自体が「`line-break` の `loose`/`normal`/`strict` の正確な集合は UA 裁量」としており（CSS Text 3 §5.2）、エンジン間・版間での差が残る。日本語の書籍品質の禁則・行調整が必要なら、JLREQ §3.1.7/§3.1.8/§3.1.11/§3.8 を自前実装するのが確実。

### 5.4 参考: 実装サポートの現状（informative）

- `text-spacing-trim`: Chrome/Edge 123+ で対応、Firefox/Safari は未対応（caniuse, <https://caniuse.com/wf-text-spacing-trim>）。MDN によれば `trim-both`/`trim-all`/`auto` はどのブラウザも未実装（<https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/text-spacing-trim>）。
- `text-autospace`: 2025-11 に Baseline newly available。Chrome/Edge 140+, Firefox 145+, Safari 18.4+ で対応（MDN, <https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/text-autospace>; caniuse 同）。ただし W3C i18n の相互運用テストでは、`ideograph-alpha ideograph-numeric` の明示指定が Chrome で効かない等、**相互運用性は未熟**と報告されている（W3C, *Managing inline spaces in Chinese & Japanese*, <https://www.w3.org/International/articles/styling/inline-space>）。

---

## 6. EPUB / CSS 縦書きの実践

一次情報:

- W3C, *EPUB 3.3*, <https://www.w3.org/TR/epub-33/>（Appendix E.1 "Prefixed properties"）。
- W3C, *EPUB Reading Systems 3.4*, <https://www.w3.org/TR/epub-rs-34/>（§7.1 XHTML content documents）。
- EPUB Content Documents 3.2, §4.4.1 "CSS Writing Modes", <https://www.w3.org/publishing/epub32/epub-contentdocs.html>。

### 6.1 `-epub-writing-mode`

- EPUB 3.3 Appendix E.1.2 は `-epub-writing-mode` を「`writing-mode` の接頭辞付き版。構文・挙動は同じ」と定義し、値は `horizontal-tb | vertical-rl | vertical-lr`（EPUB 3.3 §E.1.2）。`sideways-*` は含まれない。
- EPUB Content Documents 3.2 §4.4.1 は `-epub-writing-mode` の各値を `writing-mode` にマッピングする表を示す（`horizontal-tb`/`vertical-rl`/`vertical-lr`）。
- EPUB Reading Systems 3.4 §7.1 は「リーディングシステムは EPUB 3.3 で定義される接頭辞付きプロパティを **SHOULD** サポートする」とする（<https://www.w3.org/TR/epub-rs-34/#sec-xhtml>）。
- Apple Books は `html { -epub-writing-mode: vertical-rl; }` を使い、各 content document は単一の writing-mode のみサポートする（<https://help.apple.com/itc/booksassetguide/en.lproj/itc7e9ec52f7.html>）。

### 6.2 `-epub-text-combine` / `-epub-text-combine-horizontal`

- EPUB 3.3 Appendix E.1.3 は `-epub-text-combine-horizontal`（値 `none | all`）と、非推奨の `-epub-text-combine`（値 `none | horizontal | horizontal <number>`）を定義し、対応関係を示す:

  | 接頭辞付き | CSS 相当 |
  |---|---|
  | `-epub-text-combine-horizontal: none` | `text-combine-upright: none` |
  | `-epub-text-combine-horizontal: all` | `text-combine-upright: all` |
  | `-epub-text-combine: none` | `text-combine-upright: none` |
  | `-epub-text-combine: horizontal` | `text-combine-upright: all` |
  | `-epub-text-combine: horizontal <number>` | `text-combine-upright: digits <number>` |

  （EPUB 3.3 §E.1.3; EPUB Content Documents 3.2 §4.4.1 も同じマッピング）
- **重要な実務的帰結**: 旧 EPUB コンテンツは `-epub-text-combine: horizontal <number>` で数字の桁数制御を表現していた。これを unprefixed に写すと `text-combine-upright: digits <number>` になるが、**現行主要ブラウザは `digits` を実装していない**ため、変換しても期待どおりに動かない（§5.1）。
- Apple Books は縦中横に `-webkit-text-combine: horizontal` を要求し、`writing-mode` では作れないと明記している（Apple Books Asset Guide "Tatechuyoko"）。これは WebKit が `-webkit-text-combine`（none/horizontal のみ）をサポートし、`text-combine-upright` の扱いが限定的であることに対応する。第三者ライブラリ（例: `Love-Rox/tate-chu-yoko`）も `-webkit-text-combine: horizontal` と `text-combine-upright: all` を併記する運用を採る（<https://github.com/Love-Rox/tate-chu-yoko>）。
- Readium CSS の EPUB 互換ドキュメントは、`-epub-*` は互換のために polyfill しつつ、**新規コンテンツは unprefixed を使うべき**としている（<https://readium.org/css/docs/CSS21-epub_compat.html>）。

### 6.3 EPUB における既知のギャップ

- EPUB 3.3 は `dir` 属性を **under-implemented** と明示する（EPUB 3.3 §5.3.1, §A.1）。縦書き・双方向の実装成熟度はリーディングシステム依存。
- `digits` 相当の旧 `-epub-text-combine: horizontal <number>` を、現行の unprefixed 対応に移行してもブラウザ未実装という断絶がある（§6.2, §5.1）。
- リーディングシステムは「SHOULD」で接頭辞プロパティをサポートするが（EPUB RS 3.4 §7.1）、実際の CSS エンジン能力（Blink/WebKit/Gecko）に依存するため、縦中横の桁数制御・禁則・ルビ品質は RS ごとに差が出る。

---

## 参考文献（一次情報）

- W3C, *CSS Writing Modes Level 4*, CR 2019-07-30. <https://www.w3.org/TR/css-writing-modes-4/> — §2.1 direction, §2.2 unicode-bidi, §3.2 writing-mode, §4.2 baselines, §5.1 text-orientation, §5.1.2 mixed vertical orientations, §9.1 text-combine-upright.
- W3C, *CSS Text Module Level 3*. <https://www.w3.org/TR/css-text-3/> — §5.1 word-break, §5.2 line-break, §5.4 overflow-wrap, §6.1 text-align, §6.4 text-justify, §8.2.1 hanging-punctuation.
- W3C, *CSS Text Module Level 4*. <https://www.w3.org/TR/css-text-4/> — §8.4 text-autospace, §8.4.1 inter-script spacing, §8.5 text-spacing-trim.
- Unicode, *UAX #14: Unicode Line Breaking Algorithm*. <https://www.unicode.org/reports/tr14/> — §5 Table 1, LB13, LB21, LB22, LB24, LB25, §8 Customization.
- Unicode, *UAX #29: Unicode Text Segmentation*. <https://www.unicode.org/reports/tr29/#Grapheme_Cluster_Boundaries>.
- Unicode, *UAX #50: Unicode Vertical Text Layout* (Version 17.0.0). <https://www.unicode.org/reports/tr50/> — §3.1, §3.2.1, §3.2.4, Modifications Rev.33.
- Unicode, *VerticalOrientation.txt* (UCD). <https://www.unicode.org/Public/UNIDATA/VerticalOrientation.txt>.
- W3C, *Requirements for Japanese Text Layout (JLREQ)*. <https://www.w3.org/TR/jlreq/> — §3.1.7/3.1.8, §3.1.10, §3.1.11, §3.2.3–3.2.5, §3.3.5–3.3.8, §3.8.1–3.8.3.
- W3C, *Japanese Gap Analysis*. <https://www.w3.org/TR/jpan-gap/> — #168, #169.
- W3C i18n, *Styling vertical Chinese, Japanese, Korean and Mongolian text*. <https://www.w3.org/International/articles/vertical-text/index.en.html>.
- W3C i18n, *Managing inline spaces in Chinese & Japanese*. <https://www.w3.org/International/articles/styling/inline-space>.
- Blink, `css_properties.json5`（text-combine-upright の keyword 一覧）.<https://raw.githubusercontent.com/chromium/chromium/main/third_party/blink/renderer/core/css/css_properties.json5>.
- Blink, `layout_text_combine.h/.cc`（text-combine-upright:all の実装）.<https://raw.githubusercontent.com/chromium/chromium/main/third_party/blink/renderer/core/layout/layout_text_combine.h>.
- Blink, `character.cc`（UTR50 に基づく `IsUprightInMixedVertical`）.<https://raw.githubusercontent.com/chromium/chromium/main/third_party/blink/renderer/platform/text/character.cc>.
- Blink, `text_break_iterator.cc`（line-break strictness 実装）.<https://raw.githubusercontent.com/chromium/chromium/main/third_party/blink/renderer/platform/text/text_break_iterator.cc>.
- WebKit, `RenderCombineText.h/.cpp`（text-combine-upright:all の実装）.<https://raw.githubusercontent.com/WebKit/WebKit/main/Source/WebCore/rendering/RenderCombineText.h>.
- WebKit Bug 150821（text-combine-upright 実装）, <https://bugs.webkit.org/show_bug.cgi?id=150821>；Bug 234706（digits 未実装・NEW）, <https://bugs.webkit.org/show_bug.cgi?id=234706>.
- Chromium Issue 40674447（digits 未実装・Feature Request P3）, <https://issues.chromium.org/issues/40674447>.
- Mozilla Bug 2002512（digits の WPT FAIL 記録）, <https://bugzilla.mozilla.org/show_bug.cgi?id=2002512>.
- MDN, *text-combine-upright*, <https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/text-combine-upright>；*text-spacing-trim*；*text-autospace*.
- W3C, *EPUB 3.3*. <https://www.w3.org/TR/epub-33/> — §5.3.1, §A.1, §E.1.2, §E.1.3.
- W3C, *EPUB Reading Systems 3.4*. <https://www.w3.org/TR/epub-rs-34/> — §7.1.
- EPUB Content Documents 3.2, §4.4.1 CSS Writing Modes. <https://www.w3.org/publishing/epub32/epub-contentdocs.html>.
- Apple Books Asset Guide, *Text Directions / Tatechuyoko*. <https://help.apple.com/itc/booksassetguide/en.lproj/itc7e9ec52f7.html>.
- Readium CSS, *EPUB Compatibility*. <https://readium.org/css/docs/CSS21-epub_compat.html>.

---

## 7. Flutter 実装への示唆

Flutter には `writing-mode` / `text-orientation` / `text-combine-upright` に相当するネイティブ機能が無い。以下は**標準仕様の意味論を自前で再現する**ために必要な項目である（各項目に根拠節を付す）。

### 7.1 縦書きレイアウト基盤（自前）

1. **行の進行は右→左（`vertical-rl`）**。ブロックは右から左へ、行内は上から下へ。`dart:ui` の `TextPainter` は横書き前提のため、TextPainter を行単位で組み、行を右から左に配置するか、各行のキャンバスを 90°回転して描画するかを選ぶ必要がある（CSS-WM-4 §3.2）。
2. **ベースラインは central baseline を使う**（`text-orientation: mixed`/`upright` 相当）（CSS-WM-4 §4.2, §4.4）。Flutter の `TextBaseline.ideographic` が近いが、行内の字面中心合わせは自前補正が必要。
3. **`sideways-*` 相当は「横書き行を 90°回転」**として別レイヤで実装する（組版モード horizontal）。`vertical-*` と混同しない（CSS-WM-4 §3.2）。

### 7.2 グリフ方向（UTR50 の自前実装）

4. **`text-orientation: mixed` の既定挙動を再現**: 各 grapheme cluster の最初の文字の `Vertical_Orientation`（U/R/Tu/Tr）を表引きし、**U/Tu/Tr は正立、R は 90°時計回りに回転**する（CSS-WM-4 §5.1.2; UTR #50 §3.1）。囲み結合記号（Me）を含むクラスタは全体 U（UTR #50 §3.2.1）。
5. **`VerticalOrientation.txt` を同梱**して表を生成する（<https://www.unicode.org/Public/UNIDATA/VerticalOrientation.txt>）。少なくとも次の既定を検証する:
   - ASCII 数字・ラテン文字は **R（回転）**（`U+0030–0039`, `U+0041–005A`, `U+0061–007A`）。
   - 全角数字・全角ラテン文字は **U（正立）**（`U+FF10–FF19`, `U+FF21–FF3A`, `U+FF41–FF5A`）。
   - `、` `。` は **Tu**、括弧類は **Tr**、`・` は **U**、長音 `ー` は **Tr**。
6. **Tu/Tr は縦書き用代替グリフ**（OpenType `vert`）を使う。Flutter の `FontFeature` で `vert` を有効化できるが、フォントに `vert` グリフが無い場合は正立フォールバック（Tu）または回転フォールバック（Tr）を選ぶ（CSS-WM-4 §5.1.1; UTR #50 §3.1）。
7. **`text-orientation: upright` 相当**: 全 horizontal-only 文字を正立させ、さらに全角化（`text-transform: full-width` 相当）と組み合わせるのが実務的。ASCII 数字を正立させたいだけなら、全角コードポイント/全角グリフ変換が最も簡単（W3C i18n 記事）。

### 7.3 縦中横（最重要・完全自前）

8. **`text-combine-upright` は一切無い**ため、縦中横は完全に自前実装する。対象文字列を横方向にベタ組・測定し、**1em 平方に収まるよう圧縮**し、**行の中央に正立配置**し、bidi・decoration・spacing 上は 1 グリフ（U+FFFC 相当）として扱う（CSS-WM-4 §9.1.2）。
9. **圧縮手段**: (a) 幅バリアント `hwid`/`twid`/`qwid` を `FontFeature` で有効化、(b) 無ければ半角/3分/4分グリフ、(c) 幾何スケーリング（`Transform.scale`）の順でフォールバック（CSS-WM-4 §9.1.3）。Blink は `LayoutTextCombine` で scale と compressed font を併用し、WebKit はフォントサイズを 0.4 まで縮小する実装（§5.1）。
10. **`digits` の自前実装**: ブラウザ同様「`all` 相当（明示マーク）のみ」でもよいが、日本語 Web 小説の表示としてはアプリ側で **ASCII 数字の極大列を検出**し、n 桁以下なら横組するのが望ましい。ただし仕様の `digits` は「極大列長 ≤ n なら結合、超えるなら未結合」であり、**n 桁ずつ分割する挙動ではない**（CSS-WM-4 §9.1）。仕様に忠実にするか、より実用的な「n 桁ずつグループ化」を採用するかは製品判断。前者の場合は `123456` は 1 文字分に圧縮されて潰れるため、実用上は後者（最大 2–4 桁で分割して各グループを横組）を推奨する（W3C i18n 記事も 2–4 桁を横組する運用を示す）。
11. **`text-transform: full-width` との相互作用**: 結合対象外の数字を全角化して正立させる処理を、結合処理より後に適用する（CSS-WM-4 §9.1.3.1）。Web 小説（小説家になろう）は半角数字・半角カナを多用するため、全角/半角の正規化ポリシーを明確にする。

### 7.4 禁則・分割禁止（JLREQ ベースの自前実装）

12. **JLREQ §3.1.10 の分割禁止**を実装する: 連続アラビア数字、小数点 `.`、位取り `,`・空白を**含む**数値列、`¥`/`$` 等の前置省略記号＋数字、`%`/`‰` 等の後置省略記号＋数字、英単語内・単位記号内、2倍ダッシュ、2倍リーダー。特に **`1,234,567.89` 全体を分割不可**として扱う（UAX #14 の LB25 だけでは位取り空白や JLREQ 固有の扱いを完全には覆えない）。
13. **行頭禁則（JLREQ §3.1.7）・行末禁則（§3.1.8）**を実装する。行頭禁則: 終わり括弧類・句点類・読点類・中点類・区切り約物・ハイフン類・小書き仮名・長音・反復記号など。行末禁則: 始め括弧類など。CSS `line-break: strict/normal/loose`（CSS Text 3 §5.2）の CJK 差分を参考に、既定は「normal 相当」にする。
14. **行末処理と追込み/追出し**（JLREQ §3.8.2–3.8.3）: まず詰める処理（行末の二分アキ・中点四分アキ・欧文間隔）を優先し、不足時に空ける処理（和字間・欧文間隔）を行う。空けてはいけない箇所（§3.1.11）を厳守する。Ruby 付き親文字の字間は空けない（§3.1.11）。
15. **ルビ**（JLREQ §3.3）: モノルビ（中付き/肩付き、親文字1字に3字以上の場合のあふれ優先順位）・グループルビ（2:1 比率）・熟語ルビ（親文字単位で分割可）を実装する。Flutter の `TextSpan` + カスタム `RenderBox` で、親文字幅とルビ幅から配置を計算する必要がある。ルビのはみ出し規則（§3.3.8: 漢字には掛けない、仮名には全角まで掛けてよい）も実装する。

### 7.5 和欧混植・約物間隔（自主実装）

16. **`text-autospace` 相当**（和欧間 1/8ic）を、CJK/非 CJK 境界検出で実装する（CSS Text 4 §8.4.1）。ただし和文の読点後など JLREQ 固有の空き量は §B の表に従う。
17. **`text-spacing-trim` 相当**（全角括弧・中点の半角化/隣接詰め）を実装する。フォントの `halt`/`chws` を使わない場合は、字面の左右空き量を計算して詰める（CSS Text 4 §8.5; MDN `text-spacing-trim`）。
18. **`hanging-punctuation` 相当**（ぶら下げ、句点・読点を版面外に出す）は JLREQ §3.8.2 の「ぶら下げ組」に対応。ただし Web 小説の電子表示では必須ではないため、任意機能とする。

### 7.6 実装優先度の提案

- **必須**: 行の右→左進行、UTR50 表による正立/回転、`、。`・括弧の縦書き用字形（`vert`）、縦中横（桁数指定・グループ化）、連数字の分割禁止、行頭/行末禁則、ルビ。
- **推奨**: 行調整（追込み優先・追出し）、和欧間アキ、全角/半角の正規化、`text-transform: full-width` 相当。
- **任意**: ぶら下げ組、`sideways-*` 相当、熟語ルビの高度な最適化。
