# ADR-0004: Riverpod を捨て、内製の tiny_state で状態を持つ

- ステータス: 採択
- 日付: 2026-11-26
- 関連: #323、`packages/tiny_state`、ADR-0003（`tiny_router`）

## 背景

状態管理は Riverpod 3（`flutter_riverpod` / `riverpod_annotation` / `riverpod_generator` / `riverpod_lint` / `hooks_riverpod`）と `flutter_hooks` で組んでいた。プロバイダは50個、family の参照は40箇所、テストの `overrideWith*` は188箇所、`lib/` 80ファイル中19ファイルが Riverpod を import していた。間接依存を含めた lock は133パッケージ。

実際に使っていた機能を数えると、この規模には見合っていなかった。

- loader のうち9個は `db.watchX()` のストリームだった。drift は同一クエリのストリームを `StreamQueryStore` で共有し、最後の購読が外れたら閉じる。その上に family と参照カウントを重ねるのは、同じ仕組みの二重実装になる。
- 8個は自前のローディングフラグを持つ状態ホルダーだった（`SearchState.isLoading` / `RankingState.isLoadingMore`）。
- プロバイダ間の依存は1本だけ（`RankingNotifier` がフィルタ状態を読む）。
- `select` / `AsyncValue.guard` / observer / pause / resume は未使用。

さらに、Remix 3 の `component` パッケージ（`README.md` と `src/runtime/frame.ts`）を読むと、公開 API に store も signal も atom も無い。状態はクロージャ変数、描画は `handle.update()`、キャンセルは `queueTask` + `AbortSignal`。その Handle は Flutter の `State`（`setState` / `dispose` / `InheritedWidget`）とほぼ同型で、置き換え先として素直だった。

## 決定

1. **長寿命インスタンスはアプリルートが所有する。** `MyApp`（`StatefulWidget`）が `AppDatabase` / `ApiService` / `PreferencesRepository` / `SettingsController` / `NovelRepository` / `DatabaseMaintenanceController` / `NetworkFallbackBus` を持ち、`AppServices` に束ねて `Scope`（`InheritedWidget`）で配る。DBを差し替えるときは接続に紐づく束ごと作り直すため、閉じた接続を握ったリポジトリが画面に残らない。

2. **`packages/tiny_state` は4つだけ持つ。**
   - `Async<T>`: Loading / Data / Error の3状態（Idle は持たない。loader は必ず読み込みから始まる）
   - `Scope`: 型をキーにした `InheritedWidget`
   - `KeyedLoader<T>`: キーが変わったときだけ読み直す。前の読み込みは中断し、追い越された結果は捨てる
   - `StreamLoader<T>`: ストリームを `Async` に畳む薄い層

3. **状態ホルダーは `ChangeNotifier`。** 検索・ランキング・フィルタ・設定・保守操作は、画面かアプリルートが生成して `dispose` する。`ref.mounted` の代わりに `_disposed` フラグを1つ持つ。

4. **ストリームはリポジトリのメソッドが返す。** family プロバイダは `watchNovelInfo` / `watchEpisodeList` / `watchDownloadProgress` / `watchLastReadEpisode` のような普通のメソッドになり、画面は `StreamLoader` か `AsyncSubscription` で購読する。

5. **`ref.invalidate` に相当する仕組みは作らない。** ライブラリ一覧の3箇所の invalidate は、drift のストリームが書き込みで再emitするため不要だった。

## 帰結

- 消えたもの: Riverpod 5パッケージ + `flutter_hooks`、生成ファイル6個、`analysis_options.yaml` のプラグイン、`ProviderScope`。
- 手で書くようになったもの: DBの所有権と差し替え順序、購読の解除、読み込みの世代管理。いずれも「閉じたDBを触る」「古い結果が新しい表示を上書きする」という壊れ方をするので、テストで固定した（`test/main_test.dart`、`test/database/grouped_history_test.dart`、`test/widgets/ranking_filter_sheet_test.dart`）。
- `KeyedLoader` のキーは値等価でなければならない（record かドメインキー）。`KeyedLoader` のドキュメントに明記している。
- 自動破棄の魔法は無い。画面が持つものは画面が `dispose` する。

## 代替案

- **Riverpod のまま loader だけ自前にする**: 依存は減らない。プロバイダ定義と生成コードが残る。
- **`signals` / `provider` / `bloc` へ移す**: どれも同じ規模の概念を導入する。置き換えの理由（依存を減らし、実際に使っている機能だけを持つ）を満たさない。
- **`InheritedNotifier` だけで済ませる**: 非同期の読み込み状態とキャンセルを各画面が書くことになり、`KeyedLoader` 相当を6箇所で重複させる。
