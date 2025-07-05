# 短編小説対応のための設計変更

## 概要
短編小説（novel_type = 2）に対応するため、アプリケーションの画面遷移とリクエスト先を再設計しました。

## 変更内容

### 1. ルーティング設計の変更

**変更前:**
- `/novel/:ncode/:episode` - 小説の各話表示
- `/toc/:ncode` - 目次表示

**変更後:**
- `/novel/:ncode` - 小説詳細ページ（短編の場合は本文表示、連載の場合は目次表示）
- `/novel/:ncode/:episode` - 連載小説の各話表示（短編の場合は404エラー）

### 2. 新しい画面遷移フロー

#### 短編小説（novel_type = 2）の場合
```
小説リスト → /novel/{ncode} → 本文直接表示
```

#### 連載小説（novel_type = 1）の場合
```
小説リスト → /novel/{ncode} → 目次表示 → /novel/{ncode}/{episode} → 各話表示
```

### 3. 実装された変更

#### 3.1 新しいファイル
- `lib/screens/novel_detail_page.dart` - 小説詳細ページ（短編/連載を自動判別）

#### 3.2 変更されたファイル
- `lib/router/router.dart` - 新しいルーティング構造
- `lib/screens/novel_page.dart` - 短編小説でのエピソード指定アクセス時のエラー処理
- `lib/services/api_service.dart` - 短編小説の処理改善
- `lib/widgets/novel_list_tile.dart` - 新しいルーティングに対応
- `lib/screens/library_page.dart` - 新しいルーティングに対応
- `lib/screens/history_page.dart` - 新しいルーティングに対応

#### 3.3 削除されたファイル
- `lib/screens/toc_page.dart` - `novel_detail_page.dart` に統合

### 4. API リクエスト先の変更

#### 短編小説の場合
- **小説情報取得**: `https://api.syosetu.com/novelapi/api?ncode={ncode}`
- **本文取得**: `https://ncode.syosetu.com/{ncode}/`
- **エピソード指定アクセス**: 404エラー（`/{ncode}/{episode}` は無効）

#### 連載小説の場合
- **小説情報取得**: `https://api.syosetu.com/novelapi/api?ncode={ncode}`
- **目次取得**: `https://ncode.syosetu.com/{ncode}/`
- **各話取得**: `https://ncode.syosetu.com/{ncode}/{episode}/`

### 5. エラーハンドリング

- 短編小説に対してエピソード番号でアクセスした場合、適切なエラーメッセージを表示
- ユーザーに戻るボタンを提供して適切な画面に誘導

### 6. ユーザーエクスペリエンス

- 短編小説の場合、余計な画面遷移なしで直接本文を表示
- 連載小説の場合、従来通り目次から各話を選択
- ライブラリ機能は両方の小説タイプで正常に動作

## 仕様準拠

この設計は `./docs/narou_html` 下のmarkdownファイルで定義された仕様に完全に準拠しています：

- 短編小説: `/{ncode}` で本文表示、`/{ncode}/{episodes}` で404
- 連載小説: `/{ncode}` で目次表示、`/{ncode}/{episodes}` で各話表示

## 今後の拡張性

この設計により、将来的な機能追加（ブックマーク、読書進捗管理など）も小説タイプに応じて適切に実装できる基盤が整いました。