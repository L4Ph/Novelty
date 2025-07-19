# ライブラリ内小説検索機能 設計

## 1. 目的

ライブラリに保存された小説が増えてきた際に、ユーザーが読みたい小説を簡単に見つけられるようにするため、タイトルによる検索機能を提供する。

## 2. 要件

- ライブラリ画面のAppBarに検索アイコンを配置する。
- 検索アイコンをタップすると、SearchBarが表示され、検索クエリの入力が可能になる。
- 入力されたクエリ（小説タイトル）に基づいて、ライブラリ内の小説をインクリメンタルにフィルタリングし、結果を表示する。
- 検索にはDriftのFTS5を利用した全文検索を用いる。
- 検索対象は小説のタイトルとする。
- 検索バーはダイアログではなく、`SearchBar`ウィジェットを使用する。

## 3. 実装方針

### 3.1. Drift (SQLite) の設定

- プロジェクトルートに `build.yaml` を作成し、DriftでFTS5を有効にするための設定を記述する。
- `Novel`テーブル（`novels`）の`title`カラムを対象としたFTS5の仮想テーブルを定義する。

### 3.2. データベースの変更 (`database.dart`)

- `novels`テーブルと連携するFTS5仮想テーブル `novel_search_terms` を定義する。
- 検索用のDAO (`novelDao`) に、FTS5を使って小説を検索するメソッドを追加する。
  - `searchNovels(String query)` のようなメソッドを実装する。
- `build_runner` を実行し、データベースのコードを再生成する。

### 3.3. UIの変更 (`library_page.dart`)

- `LibraryPage`の`AppBar`に`IconButton`（検索アイコン）を追加する。
- `IconButton`をタップすると、`showSearch` を使用してカスタムの `SearchDelegate` を表示する。
- `SearchDelegate` の中で `SearchBar` を構築し、ユーザーの入力を受け付ける。
- 検索結果は `SearchDelegate` 内の `buildResults` と `buildSuggestions` で表示する。

### 3.4. 状態管理 (Provider)

- 検索クエリと検索結果を管理するため、`Riverpod` Providerを活用する。
- 検索クエリが変更されるたびに、`NovelRepository`（またはDAO）の検索メソッドを呼び出し、UIを更新する。
- `library_search_provider.dart` のような新しいファイルを作成し、検索関連のProviderを定義する。

## 4. 実装ステップ

1.  **FTS5の有効化:**
    -   `build.yaml` を作成し、FTS5モジュールを有効化する設定を記述する。
2.  **データベース定義の更新:**
    -   `database.dart` にFTS5仮想テーブルと検索用メソッドを定義する。
    -   `fvm dart run build_runner build -d` を実行してコードを生成する。
3.  **Repository/DAOの実装:**
    -   データベースの検索メソッドを呼び出すロジックを実装する。
4.  **Providerの作成:**
    -   検索状態を管理する `Riverpod` Providerを作成する。
5.  **UIの実装:**
    -   `library_page.dart` に検索UIを実装する。
    -   `SearchDelegate` を用いて検索画面を構築する。
6.  **テスト:**
    -   リポジトリの検索メソッドに関する単体テストを記述する。
    -   検索UIに関するウィジェットテスト���記述する。
