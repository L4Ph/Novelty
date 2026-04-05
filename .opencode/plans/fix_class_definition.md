# 作業計画: test/screens/novel_page_test.dart のクラス定義修正

## 問題の概要
`test/screens/novel_page_test.dart`の178行目から始まる`group`関数内にクラス定義（`VerticalSettings`、`HorizontalSettings`）があり、Dartでは関数内にクラスを定義できないため、`mise run codegen`が失敗しています。

## エラー内容
```
180:5: 'class' can't be used as an identifier because it's a ***word.
```

## 修正内容
1. `VerticalSettings`クラス（180-192行目）をファイルのトップレベル（import文の後）に移動
2. `HorizontalSettings`クラス（195-207行目）をファイルのトップレベルに移動
3. `group`内ではこれらのクラスを参照するだけにする

## 実装ステップ
1. **ステップ1**: `VerticalSettings`と`HorizontalSettings`のクラス定義をファイルのトップレベル（14行目付近）に追加
2. **ステップ2**: `group`内の既存のクラス定義を削除
3. **ステップ3**: `mise run codegen`を実行してビルド成功を確認
4. **ステップ4**: `mise run lint`を実行してLintエラーがないことを確認
5. **ステップ5**: コミットの承認を得て、日本語のコミットメッセージでコミット

## 影響範囲
- `test/screens/novel_page_test.dart`のみ
- 既存のテストロジックには変更なし
- クラスの位置を変更するだけ

## テスト戦略
- 既存のテストコードをそのまま使用
- codegen成功でテスト成功とみなす
