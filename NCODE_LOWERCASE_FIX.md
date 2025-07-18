# ncodeを常に小文字で扱う修正について

## 修正の概要

この修正では、アプリケーション内でncodeを常に小文字で扱うように変更しました。これにより、URLやDBへの二重登録が防止されます。

## 修正されたファイル

### モデル層
- `lib/models/novel_info.dart`: NovelInfo.fromJsonでncodeを小文字化
- `lib/models/ranking_response.dart`: RankingResponse.fromJsonでncodeを小文字化
- `lib/models/episode.dart`: Episode.fromJsonでncodeを小文字化
- `lib/models/novel_search_query.dart`: NovelSearchQueryでncodeを小文字化

### APIサービス層
- `lib/services/api_service.dart`: APIリクエスト時とレスポンス処理時にncodeを小文字化

### ルーティング層
- `lib/router/router.dart`: ルーティングパラメータのncodeを小文字化

### リポジトリ層
- `lib/repositories/novel_repository.dart`: ファイルパス生成時のncodeを小文字化

### UI層
- `lib/widgets/novel_list_tile.dart`: 重複した小文字化処理を削除
- `lib/screens/novel_detail_page.dart`: 重複した小文字化処理を削除
- `lib/screens/history_page.dart`: 重複した小文字化処理を削除

### テスト
- `test/ncode_lowercase_test.dart`: ncodeの小文字化機能をテストする包括的なテストケース

## 修正のポイント

### 1. データの入り口で小文字化
モデルクラスの`fromJson`メソッドで確実に小文字化することで、外部APIからのデータが確実に小文字で処理されます。

```dart
factory NovelInfo.fromJson(Map<String, dynamic> json) {
  // ncodeを小文字化
  if (json['ncode'] is String) {
    json['ncode'] = (json['ncode'] as String).toLowerCase();
  }
  return _$NovelInfoFromJson(json);
}
```

### 2. APIリクエスト時の小文字化
外部APIへのリクエスト時にncodeを小文字化することで、APIの仕様に合わせた正しいリクエストが行われます。

### 3. 重複処理の削除
既に小文字化されたncodeを再度小文字化していた箇所を修正し、パフォーマンスを向上させました。

### 4. テストによる保証
小文字化処理が正常に動作することをテストで保証し、リグレッションを防止しています。

## 動作確認のポイント

1. **新しい小説の検索・表示**: 大文字のncodeを持つ小説が正常に表示されることを確認
2. **ライブラリへの追加**: 大文字のncodeを持つ小説がライブラリに正常に追加されることを確認
3. **履歴の記録**: 大文字のncodeを持つ小説の履歴が正常に記録されることを確認
4. **URL遷移**: 大文字のncodeを含むURLが正常に小文字化されて処理されることを確認
5. **ダウンロード機能**: 大文字のncodeを持つ小説が正常にダウンロードされることを確認

## テストの実行

```bash
# テストの実行
flutter test test/ncode_lowercase_test.dart

# 全てのテストの実行
flutter test
```

## 既存データへの影響

この修正は主に新しいデータの処理に影響します。既存のデータベースに大文字のncodeが保存されている場合、新しい小文字のncodeとは別のエントリとして扱われる可能性があります。必要に応じて、データベースの既存データを小文字に変換するマイグレーションを検討してください。