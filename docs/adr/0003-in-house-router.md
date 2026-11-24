# ADR-0003: go_router を捨て、内製の tiny_router でルーティングする

- ステータス: 採択
- 日付: 2026-11-24
- 関連: #320（`dynamic_color` 撤去）、`packages/tiny_router`

## 背景

`lib/router/router.dart` は go_router 17 + go_router_builder で12ルート・4ブランチを宣言していた（本体300行 + 生成270行）。実際に使っていたのは `initialLocation` / `errorBuilder` / `StatefulShellRoute` / `parentNavigatorKey` / typed routes だけで、`redirect` / `refreshListenable` / `extra` / URL復元 / browser back / deep link（intent-filter 未登録）/ web（ターゲット無し）は1つも使っていなかった。つまり go_router の中心にある「URL を真実として扱う」機構が機能していない。

typed routes も中身は `String` で、`NovelDetailRoute(source: 'narou', workId: ...)` から `NovelSource.values.byName(source)` で実行時に戻していた。パス文字列の typo はコンパイルで検出できず、テストはアプリと同じパス構造のスタブルーターを組む必要があった（`history_page_test.dart`）。

プロジェクトは依存を内製する方針を取っており（`tiny_http`、`tategaki`、パーサ群、#320 の `dynamic_color` 撤去）、加えて DartNative への移行を検討している。

## 決定

1. **ルーティングの状態を「型付き Destination のスタック」にする。** URL 文字列は持たない。`lib/router/destinations.dart` の `sealed class NovelDestination` が13の画面を型付き引数付きで表し、値等価を持つ（ページのキーになるため必須）。

2. **`packages/tiny_router`（純 Dart・依存0）は1本のスタックだけを持つ。** `RouteStack<D>` に `entries` / `top` / `canPop` / `push` / `pop` / `popToRoot` / `replaceTop` / `clear` / `addListener`。初期エントリが下限（タブの root は消えない、overlay は空まで戻れる）。最前面と同じ destination の `push` は無視する（等価なページが2枚あると `Navigator` が重複キーで assert するため、二度押しの防御も兼ねる）。

3. **`packages/tiny_router` の後半が Navigator 2.0 の定型を引き受ける。** `RouteStackNavigator`（`NavigatorPopHandler` + `Navigator.pages` + 位置を含む安定キー + `onDidRemovePage` の同期）と `RouteStackDelegate`（`[root, ...stack]`）。`Page` の生成は `PageFactory` として注入する（DartNative では `Page` が非推奨エイリアスなので、移植時はここだけ差し替える）。当初は Flutter 依存を切り離した `tiny_router_flutter` に分けていたが、DartNative が Flutter 互換 API を実装しているため統合した。`lib/src/route_stack.dart` は Flutter を import しない状態を保つ（規約であって強制ではない）。

4. **タブとシェルはアプリが組む。** `lib/router/app_router.dart` がタブ4本 + overlay 1本の `RouteStack` を持ち、`AppRouter`（`push` / `pushOverlay` / `pop` / `select` / `reset`）と `RouterConfig` を提供する。パッケージは `tab` も `shell` も知らない。

5. **どちらの層に積むかは呼び出し側が決める。** `push` はタブ内（タブバーが残る）、`pushOverlay` はシェルを覆う（タブバーが隠れる）。画面の性質として Destination にフラグを持たせない — 「タブを覆う」は画面ではなく `Navigator` の構成の結果であり、UI の語彙をルーティングに持ち込むことになるため。

6. **戻るは4段階。** モーダル → アクティブタブの `Navigator`（画面の `PopScope` を尊重）→ `appRouter.pop()` → OS。タブ内 `Navigator` の転送は `NavigatorPopHandler` に任せる。`RouterConfig` は `backButtonDispatcher` を既定で作らないため、`RootBackButtonDispatcher` を明示的に渡す（渡さないとシステム Back が Router に届かず、どの画面でもアプリが終了する）。

   注意点が2つある。拒否された pop は**同じルートの全 `PopScope` に通知される**ので、`NavigatorPopHandler` の `enabled: false` だけでは非表示タブが自分を pop してしまう — コールバック内でも `handlesSystemPop` を確認する。また `onDidRemovePage` は「ページ置換」でも発火するため、通知されたページが現在の最上位と一致するときだけ `stack.pop()` する。

7. **deep link は配線しない。** Flutter の `Router` は `routeInformationProvider` / `routeInformationParser` の両方が null でも動く（アプリ状態から組み立てる用途が公式に想定されている）。将来 URL から復元したくなったら `RouteInformationParser` を足す。URL の語彙は公開契約になるため、決める時期を先送りする。

8. **loader と `push<T>` の戻り値は持たない。** データ取得は Riverpod の責務で、二重系にすると剥がせなくなる。`push` の戻り値は現状14箇所すべて未使用（`push<void>` / `unawaited`）で、実装するとスタックが「値」でなくなる（Completer をエントリに載せる必要が出る）。

9. **DBインポート適用後に `appRouter.reset()`。** スタック上の画面は入れ替え前の DB に属するため、ライブラリへ戻す。

## パッケージが意図的に知らないこと

- タブ・シェル・タブバー（アプリが 4本 + overlay を組む）
- URL・deep link
- データ取得・キャッシュ（loader）
- 状態管理（Riverpod を経由しない。`RouteStack` は自前のリスナーだけを持つ）

## 代替案

- **go_router 継続（`go_router_builder` だけ外す）**: 生成物と String パラメータは減るが、URL を真実とする構造と、使っていない機能のコストは残る → 却下
- **ファイルベースルーティング**: Dart には TS の構造的型推論が無く、型の恩恵が薄いのに生成物が増える → 却下
- **Navigator 1.0 + 薄いファサード**: タブごとのスタック保持を `IndexedStack` + ネスト `Navigator` で手組みすることになり、宣言的なページモデルより状態同期が難しい → 却下
- **TanStack Router 型（URL + 検証付き search params）**: URL を持たないので不要。ただし「型付き Destination」の考え方はここから採った → 却下
- **Destination に `build()` を持たせる（Wouter の locality）**: `Widget` 依存になり、DartNative 移植で全 Destination を書き換える → 却下
- **2層（branches / overlays）をパッケージに入れる**: タブ概念が汎用パッケージに漏れる → 却下
- **`tiny_router` / `tiny_router_flutter` の2パッケージ構成**: Flutter 依存を pure Dart のコアから切り離せるが、DartNative が Flutter 互換 API を実装しているため分ける利得が小さく、設定ファイルと CI が増えるだけだった → 統合

## 結果

- 依存が2つ減り（go_router, go_router_builder）、build_runner の生成器が1つ減り、生成物270行が消える。ルーティングは `packages/tiny_router` 1つ（コア101行 + アダプタ179行）になる。
- 呼び出し側から `context` と `ref` が消え、ナビゲーションを純粋な状態としてテストできる（`dart test` / `flutter test` でウィジェットを pump せずに済むケースが増える）。
- 失うもの: deep link、URL 復元、`redirect`、`errorBuilder`。不正な Destination は型で表現できないので errorBuilder は不要になった。
- 既知の制約: `push<T>` の戻り値を持たない、URL を持たない、状態復元（`restorationId`）は未対応。DartNative 用アダプタとマルチウィンドウ対応は未着手。
