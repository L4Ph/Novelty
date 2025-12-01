# エピソードキャッシュシステム 設計書

## 1. 概要

一度閲覧したエピソードを自動的にキャッシュし、2回目以降の表示を高速化する機能の設計書。
また、改稿されたエピソードを検知し、適切に再取得する仕組みを提供する。

## 2. 目的

- **表示の高速化**: 一度パースしたエピソードをキャッシュし、再パースのオーバーヘッドを削減する
- **オフライン対応**: 明示的なダウンロード操作なしで、閲覧済みエピソードをオフラインでも読めるようにする
- **改稿への対応**: エピソードが改稿された場合に検知し、最新の内容を取得できるようにする
- **ユーザー体験の統一**: 明示的ダウンロードと自動キャッシュを統一されたデータ構造で管理する

## 3. 現状の課題

### 3.1. キャッシュの未活用

現在の`getEpisode`メソッドは、ダウンロード済みエピソードがなければ毎回APIからフェッチしてパースを行う。
一度閲覧したエピソードでも再度パース処理が走り、無駄なネットワーク通信とCPU負荷が発生する。

```dart
// 現状の実装
Future<List<NovelContentElement>> getEpisode(String ncode, int episode) async {
  final downloaded = await _db.getDownloadedEpisode(ncode, episode);
  if (downloaded != null) {
    return downloaded.content;
  }
  return _fetchEpisodeContent(ncode, episode);  // キャッシュせずに返している
}
```

### 3.2. 改稿検知の不在

キャッシュしたエピソードが改稿されたかどうかを判定する仕組みがない。
古いキャッシュを表示し続ける可能性がある。

### 3.3. 2つのテーブルの役割の曖昧さ

- `Episodes`: エピソードのキャッシュ（HTML形式、あまり使われていない）
- `DownloadedEpisodes`: ダウンロード済みエピソード（パース済み構造化データ）

役割が重複しており、統一されていない。

## 4. 設計方針

**「閲覧したエピソードは自動キャッシュし、改稿を検知して適切に更新する」**

### 4.1. キャッシュ戦略

| ケース | 動作 |
|--------|------|
| 目次経由でエピソードを開く | キャッシュの`revised` ≠ 目次の`revised` なら再fetch |
| 履歴から直接エピソードを開く | キャッシュあり→返す、なし→fetch&キャッシュ |
| キャッシュなし | fetch → キャッシュに保存 → 返す |

### 4.2. 改稿検知の仕組み

なろう小説の目次ページには、各エピソードの改稿日時が含まれている。

```html
<!-- 改稿されたエピソード -->
<div class="p-eplist__sublist">
  <a href="/n6753le/6/" class="p-eplist__subtitle">6.名無しの転移者さん</a>
  <div class="p-eplist__update">
    2025/10/22 12:00
    <span title="2025/10/31 01:12 改稿">（<u>改</u>）</span>
  </div>
</div>

<!-- 改稿されていないエピソード -->
<div class="p-eplist__sublist">
  <a href="/n6753le/7/" class="p-eplist__subtitle">7.魔術触媒</a>
  <div class="p-eplist__update">
    2025/10/23 12:00
  </div>
</div>
```

この情報を利用し、キャッシュ時点の`revised`と目次取得時の`revised`を比較することで、
エピソード単位で改稿を検知できる。

### 4.3. 状態判定方式

`status`カラムを使わず、`content`の中身で状態を判定する。

| content | 意味 |
|---------|------|
| `[]` (空配列) | ダウンロード失敗 |
| `[...]` (中身あり) | 成功（キャッシュ有効） |
| レコードなし | 未キャッシュ |

```dart
// 判定ロジック
if (cached == null) {
  // 未キャッシュ → fetch
} else if (cached.content.isEmpty) {
  // 失敗 → 再fetch
} else {
  // 成功 → キャッシュ返す（revised比較も）
}
```

## 5. 状態遷移図

### 5.1. キャッシュ状態

```mermaid
stateDiagram-v2
    [*] --> NotCached: 初期状態

    NotCached --> Cached: エピソードを開く<br/>(fetch & save)
    NotCached --> Failed: fetch失敗<br/>(content=[]で保存)

    Cached --> Cached: 再度開く<br/>(revised一致)

    Cached --> Stale: 目次を開く<br/>(revised不一致を検知)

    Stale --> Cached: エピソードを開く<br/>(再fetch & save)

    Failed --> Cached: リトライ成功

    Cached --> NotCached: キャッシュ削除
    Failed --> NotCached: キャッシュ削除

    state Cached {
        [*] --> Valid
        Valid: content有効
    }

    state Failed {
        [*] --> Error
        Error: content空
    }
```

### 5.2. エピソード取得の状態遷移

```mermaid
stateDiagram-v2
    [*] --> CheckCache: getEpisode呼び出し

    CheckCache --> CheckContent: キャッシュあり
    CheckCache --> Fetch: キャッシュなし

    CheckContent --> CheckRevised: content有効
    CheckContent --> Fetch: content空（失敗状態）

    CheckRevised --> CompareRevised: revisedパラメータあり
    CheckRevised --> ReturnCache: revisedパラメータなし

    CompareRevised --> ReturnCache: revised一致
    CompareRevised --> Fetch: revised不一致

    Fetch --> Parse: HTMLを取得
    Parse --> SaveSuccess: パース成功
    Parse --> SaveFailed: パース失敗

    SaveSuccess --> ReturnContent: content保存
    SaveFailed --> ReturnError: 空content保存

    ReturnCache --> [*]: コンテンツを返す
    ReturnContent --> [*]: コンテンツを返す
    ReturnError --> [*]: エラーを返す
```

## 6. シーケンス図

### 6.1. 目次経由でエピソードを開く（キャッシュヒット）

```mermaid
sequenceDiagram
    participant User as ユーザー
    participant UI as UI層
    participant Repo as NovelRepository
    participant DB as Database
    participant API as なろうAPI

    User->>UI: 目次を開く
    UI->>API: 目次をfetch
    API-->>UI: Episode[] (revisedを含む)
    UI->>UI: 目次を表示

    User->>UI: エピソード6をタップ
    UI->>Repo: getEpisode(ncode, 6, revised: "2025/10/31")
    Repo->>DB: getCachedEpisode(ncode, 6)
    DB-->>Repo: CachedEpisode (revised: "2025/10/31")
    Repo->>Repo: content有効 & revised一致を確認
    Repo-->>UI: content
    UI->>User: エピソードを表示
```

### 6.2. 目次経由でエピソードを開く（改稿検知）

```mermaid
sequenceDiagram
    participant User as ユーザー
    participant UI as UI層
    participant Repo as NovelRepository
    participant DB as Database
    participant API as なろうAPI

    User->>UI: 目次を開く
    UI->>API: 目次をfetch
    API-->>UI: Episode[] (revised: "2025/11/15" に更新)
    UI->>UI: 目次を表示（更新マーク表示）

    User->>UI: エピソード6をタップ
    UI->>Repo: getEpisode(ncode, 6, revised: "2025/11/15")
    Repo->>DB: getCachedEpisode(ncode, 6)
    DB-->>Repo: CachedEpisode (revised: "2025/10/31")
    Repo->>Repo: revised不一致を検知
    Repo->>API: fetchEpisode(ncode, 6)
    API-->>Repo: Episode (HTML)
    Repo->>Repo: パース処理
    Repo->>DB: insertCachedEpisode (revised: "2025/11/15")
    Repo-->>UI: content (最新)
    UI->>User: 最新のエピソードを表示
```

### 6.3. 履歴から直接エピソードを開く

```mermaid
sequenceDiagram
    participant User as ユーザー
    participant UI as UI層
    participant Repo as NovelRepository
    participant DB as Database
    participant API as なろうAPI

    User->>UI: 履歴画面を開く
    UI->>DB: watchHistory()
    DB-->>UI: HistoryData[]
    UI->>User: 履歴を表示

    User->>UI: 「続きを読む」をタップ
    UI->>Repo: getEpisode(ncode, 6, revised: null)
    Repo->>DB: getCachedEpisode(ncode, 6)

    alt キャッシュあり（content有効）
        DB-->>Repo: CachedEpisode
        Repo-->>UI: content
    else キャッシュなし or content空
        DB-->>Repo: null or empty content
        Repo->>API: fetchEpisode(ncode, 6)
        API-->>Repo: Episode (HTML)
        Repo->>Repo: パース処理
        Repo->>DB: insertCachedEpisode
        Repo-->>UI: content
    end

    UI->>User: エピソードを表示
```

### 6.4. 明示的ダウンロード（一括）

一括ダウンロードでは、最初に目次を取得して各エピソードの`revised`情報を取得し、
それを使ってキャッシュの更新判定を行う。

```mermaid
sequenceDiagram
    participant User as ユーザー
    participant UI as UI層
    participant Repo as NovelRepository
    participant DB as Database
    participant API as なろうAPI

    User->>UI: ダウンロードボタンをタップ
    UI->>Repo: downloadNovel(ncode, totalEpisodes)

    Repo->>API: fetchEpisodes(ncode)
    API-->>Repo: Episode[] (各エピソードのrevisedを含む)

    loop 各エピソード
        Repo->>DB: getCachedEpisode(ncode, i)
        alt キャッシュあり（content有効 & revised一致）
            DB-->>Repo: CachedEpisode
            Repo->>Repo: スキップ
        else キャッシュなし or content空 or revised不一致
            Repo->>API: fetchEpisodeContent(ncode, i)
            alt 成功
                API-->>Repo: Episode (HTML)
                Repo->>DB: insertCachedEpisode(content: [...], revised)
            else 失敗
                API-->>Repo: Error
                Repo->>DB: insertCachedEpisode(content: [])
            end
        end
        Repo->>UI: 進捗通知
    end

    Repo-->>UI: 完了
    UI->>User: 結果表示
```

## 7. データ設計

### 7.1. テーブル変更

`DownloadedEpisodes`テーブルを`CachedEpisodes`にリネームし、スキーマを変更する。

#### 変更前

```mermaid
erDiagram
    DownloadedEpisodes {
        TEXT ncode PK
        INTEGER episode PK
        TEXT content
        INTEGER downloadedAt
        INTEGER status "2=成功, 3=失敗"
        TEXT errorMessage
        INTEGER lastAttemptAt
    }
```

#### 変更後

```mermaid
erDiagram
    CachedEpisodes {
        TEXT ncode PK
        INTEGER episode PK
        TEXT content "空=失敗, 有=成功"
        INTEGER cachedAt
        TEXT revised
    }

    Novels ||--o{ CachedEpisodes : has
    History ||--o| CachedEpisodes : references
```

### 7.2. カラム詳細

| カラム | 型 | 説明 |
|--------|-----|------|
| ncode | TEXT | 小説のncode (PK) |
| episode | INTEGER | エピソード番号 (PK) |
| content | TEXT | パース済みコンテンツ (JSON)。空配列=失敗、中身あり=成功 |
| cachedAt | INTEGER | キャッシュ日時 (旧downloadedAt) |
| revised | TEXT | キャッシュ時点の改稿日時 (nullable) |

#### 削除されるカラム

| カラム | 削除理由 |
|--------|---------|
| status | contentの中身で判定するため不要 |
| errorMessage | 失敗の詳細は不要（リトライすればいい） |
| lastAttemptAt | 自動キャッシュでは不要 |

### 7.3. マイグレーション

```dart
if (from <= 10) {
  // DownloadedEpisodes → CachedEpisodes にリネーム & スキーマ変更
  // 不要なカラムを削除し、revisedカラムを追加
  await customStatement('''
    CREATE TABLE cached_episodes (
      ncode TEXT NOT NULL,
      episode INTEGER NOT NULL,
      content TEXT NOT NULL,
      cached_at INTEGER NOT NULL,
      revised TEXT,
      PRIMARY KEY(ncode, episode)
    )
  ''');

  await customStatement('''
    INSERT INTO cached_episodes (ncode, episode, content, cached_at, revised)
    SELECT ncode, episode, content, downloaded_at, NULL FROM downloaded_episodes
  ''');

  await customStatement('DROP TABLE downloaded_episodes');

  // 未使用のEpisodesテーブルを削除
  await customStatement('DROP TABLE IF EXISTS episodes');
}
```

## 8. 処理フロー

### 8.1. エピソード取得フロー

```mermaid
flowchart TD
    A[getEpisode呼び出し] --> B{キャッシュ存在?}

    B -- No --> F[APIからfetch]
    B -- Yes --> C{content有効?}

    C -- No --> F
    C -- Yes --> D{revisedパラメータあり?}

    D -- No --> G[キャッシュを返す]
    D -- Yes --> E{cached.revised == param.revised?}

    E -- Yes --> G
    E -- No --> F

    F --> H{fetch成功?}
    H -- Yes --> I[パース処理]
    H -- No --> J[空contentで保存]

    I --> K[contentを保存]
    K --> L[コンテンツを返す]
    J --> M[エラーを返す]

    G --> N[END]
    L --> N
    M --> N
```

### 8.2. ダウンロード状態判定フロー

```mermaid
flowchart TD
    A[NovelDownloadSummary計算] --> B[該当ncodeのエピソード取得]
    B --> C[successCount = content有効な数]
    C --> D[failureCount = content空の数]
    D --> E{successCount == totalEpisodes?}

    E -- Yes --> F[status = 2: 完了]
    E -- No --> G{success + failure == total<br/>かつ failure > 0?}

    G -- Yes --> H[status = 3: 一部失敗]
    G -- No --> I{success > 0 or failure > 0?}

    I -- Yes --> J[status = 1: ダウンロード中]
    I -- No --> K[status = 0: 未ダウンロード]
```

### 8.3. 目次表示と更新検知フロー

```mermaid
flowchart TD
    A[目次ページを開く] --> B[目次をfetch]
    B --> C[各エピソードのrevisedを取得]
    C --> D[DBからキャッシュ済みエピソードを取得]
    D --> E{各エピソードをループ}

    E --> F{キャッシュあり?}
    F -- Yes --> G{content有効?}
    F -- No --> H[未読マーク]

    G -- Yes --> I{revised一致?}
    G -- No --> J[失敗マーク]

    I -- Yes --> K[既読マーク]
    I -- No --> L[更新ありマーク]

    H --> M{次のエピソード}
    J --> M
    K --> M
    L --> M

    M -- あり --> E
    M -- なし --> N[目次を表示]
```

## 9. API設計

### 9.1. NovelRepository

```dart
/// エピソードを取得する（キャッシュ対応版）
///
/// [revised] が指定された場合、キャッシュの改稿日時と比較し、
/// 異なる場合は再取得する。
Future<List<NovelContentElement>> getEpisode(
  String ncode,
  int episode, {
  String? revised,
}) async {
  final cached = await _db.getCachedEpisode(ncode, episode);

  // キャッシュが存在し、content有効で、改稿日時が一致する場合はキャッシュを返す
  if (cached != null && cached.content.isNotEmpty) {
    if (revised == null || cached.revised == revised) {
      return cached.content;
    }
  }

  // fetch & cache
  try {
    final content = await _fetchEpisodeContent(ncode, episode);
    await _db.insertCachedEpisode(
      CachedEpisodesCompanion(
        ncode: Value(ncode.toNormalizedNcode()),
        episode: Value(episode),
        content: Value(content),
        cachedAt: Value(DateTime.now().millisecondsSinceEpoch),
        revised: Value(revised),
      ),
    );
    return content;
  } on Exception {
    // 失敗時は空contentで保存
    await _db.insertCachedEpisode(
      CachedEpisodesCompanion(
        ncode: Value(ncode.toNormalizedNcode()),
        episode: Value(episode),
        content: const Value([]),
        cachedAt: Value(DateTime.now().millisecondsSinceEpoch),
        revised: Value(revised),
      ),
    );
    rethrow;
  }
}
```

### 9.2. Database (集計ロジック変更)

```dart
/// 小説のダウンロード状態の集計情報を取得
Future<NovelDownloadSummary?> getNovelDownloadSummary(String ncode) async {
  final normalizedNcode = ncode.toNormalizedNcode();

  final novel = await getNovel(normalizedNcode);
  if (novel?.generalAllNo == null) return null;
  final totalEpisodes = novel!.generalAllNo!;

  final episodes = await (select(cachedEpisodes)
        ..where((e) => e.ncode.equals(normalizedNcode)))
      .get();

  // contentの中身で成功/失敗を判定
  final successCount = episodes.where((e) => e.content.isNotEmpty).length;
  final failureCount = episodes.where((e) => e.content.isEmpty).length;

  return NovelDownloadSummary(
    ncode: normalizedNcode,
    successCount: successCount,
    failureCount: failureCount,
    totalEpisodes: totalEpisodes,
  );
}
```

### 9.3. Provider

```dart
@riverpod
Future<List<NovelContentElement>> novelContent(
  Ref ref, {
  required String ncode,
  required int episode,
  String? revised,
}) async {
  final repository = ref.read(novelRepositoryProvider);
  return repository.getEpisode(ncode, episode, revised: revised);
}
```

### 9.4. UI層での使用例

```dart
// 目次からエピソードを開く場合（revisedを渡す）
onTap: () {
  context.push('/novel/$ncode/$episodeNumber?revised=${episode.revised}');
}

// または Provider経由で
final content = ref.watch(
  novelContentProvider(
    ncode: ncode,
    episode: episodeNumber,
    revised: episode.revised,
  ),
);
```

## 10. UI設計

### 10.1. ダウンロードボタンの状態

| downloadStatus | 表示 |
|----------------|------|
| 0 (未ダウンロード) | ダウンロードアイコン |
| 1 (ダウンロード中) | プログレス表示 |
| 2 (完了) | チェックマーク |
| 3 (一部失敗) | 警告アイコン + リトライ |

### 10.2. 目次での更新表示

キャッシュ済みエピソードが改稿された場合、目次に更新マークを表示する。

```dart
// エピソードリストのアイテム
ListTile(
  title: Text(episode.subtitle ?? ''),
  subtitle: Text(episode.update ?? ''),
  trailing: _buildStatusIcon(episode, cachedEpisode),
)

Widget _buildStatusIcon(Episode episode, CachedEpisode? cached) {
  if (cached == null) return const SizedBox.shrink(); // 未読
  if (cached.content.isEmpty) return const Icon(Icons.error); // 失敗
  if (cached.revised != episode.revised) return const Icon(Icons.fiber_new); // 更新あり
  return const Icon(Icons.check); // 既読
}
```

## 11. 実装タスク

- [ ] **1. データベーススキーマの変更**
  - [ ] `DownloadedEpisodes` → `CachedEpisodes` にテーブル名変更
  - [ ] `revised`カラムを追加
  - [ ] 不要なカラム（status, errorMessage, lastAttemptAt）を削除
  - [ ] カラム名変更（downloadedAt → cachedAt）
  - [ ] 未使用の`Episodes`テーブルを削除
  - [ ] マイグレーション処理を実装
  - [ ] スキーマバージョンを11に更新

- [ ] **2. Repository層の改修**
  - [ ] `getEpisode`メソッドに`revised`パラメータを追加
  - [ ] 自動キャッシュロジックを実装
  - [ ] 失敗時の空content保存を実装
  - [ ] 改稿検知ロジックを実装

- [ ] **3. Database層の改修**
  - [ ] `getNovelDownloadSummary`の判定ロジックを変更（status → content）
  - [ ] `watchNovelDownloadSummary`の判定ロジックを変更
  - [ ] その他status参照箇所の修正

- [ ] **4. Provider層の改修**
  - [ ] `novelContentProvider`に`revised`パラメータを追加
  - [ ] キャッシュ状態を監視するProviderを追加（任意）

- [ ] **5. UI層の改修**
  - [ ] 目次からエピソードを開く際に`revised`を渡す
  - [ ] 目次に更新マークを表示（任意）

- [ ] **6. テストの実装**
  - [ ] キャッシュ動作のユニットテスト
  - [ ] 改稿検知のユニットテスト
  - [ ] content空判定のテスト
  - [ ] マイグレーションのテスト

- [ ] **7. 既存機能との整合性確認**
  - [ ] 明示的ダウンロード機能が引き続き動作することを確認
  - [ ] ダウンロード済みエピソードの削除機能を確認
  - [ ] ダウンロードマネージャー画面の動作確認

- [ ] **8. コメント・ドキュメントの更新**
  - [ ] `backup_service.dart`のコメント（`Episodes`テーブルへの言及）を更新

## 12. 将来の拡張

### 12.1. キャッシュサイズ管理

- 自動キャッシュによりストレージ使用量が増加する可能性がある
- 設定画面でキャッシュサイズ上限を設定できるようにする
- LRU（Least Recently Used）方式で古いキャッシュを自動削除

### 12.2. バックグラウンド更新

- ライブラリ登録済み小説の更新を定期的にチェック
- 改稿されたエピソードをバックグラウンドで再取得

