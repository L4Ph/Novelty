# 概要
このアプリケーションは、Web小説を読むためのFlutter製のアプリケーションです。

## 設計

### モデル
モデルが更新された場合、下記を実行してください。
```
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### アプリケーション
- ライブラリ
 - アプリケーション起動直後に開かれる(軸になるページ)
 - 購読した小説を表示
 - Pull to Refresh(後々実装)
 - ライブラリ内での検索を可能にする

- 履歴
 - 読んだ小説を履歴として登録する
 - 小説本文を開いたもの
 - 目次を開いた段階では対象にならない。
 - 開いた小説のncodeと話数(episodes)を保持する。

- 探す
  - デフォルトでは、なろう小説のランキングを表示する
    - 日間ランキング
    - 週間ランキング
    - 月間ランキング
    - 四半期ランキング
    - 累計ランキング

  - 上部の検索ボタンを押下することで、検索ダイアログを表示し、小説の検索を行う

累計ランキングは、ランキングAPIに存在しておらず、検索で使用している累計ポイントを元にソートし、表示する必要がある。

- もっと
  - アプリケーションの設定や、使用しているライブラリ、`このアプリケーションについて`などを表示する。
  - 設定のバックアップなど、雑多な機能を格納

### システム

# Flutterについて

## fvm
fvmを使用しています。
常にflutterのコマンドを実行する際は、先頭に`fvm`を追加して実行してください。
なにかしら変更を加えた場合は、毎回Hot reloadか、Hot restartを行って、変更を反映してください。

## Linter
### Linter
[pedantic_mono](https://github.com/mono0926/pedantic_mono) を使用しています。
`analysis_options.yaml`を変更しないでください

```
fvm dart analyze
```
を実行して、定期的にlinterエラーを確認して修正してください。

# APIドキュメント
それぞれのドキュメントは、以下にあります。

## Novelty API
- [Novelty API](./docs/novelty_api/api.md)

## なろう小説
- [なろう小説API](./docs/narou_api/novel_api.md)
- [なろう小説ランキングAPI](./docs/narou_api/ranking_api.md)

## カクヨム
(現在未実装 なろうの機能が作成後に実施)