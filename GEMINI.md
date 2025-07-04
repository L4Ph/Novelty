# 概要
このアプリケーションは、Web小説を読むためのFlutter製のアプリケーションです。

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

## Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).


# APIドキュメント
それぞれのドキュメントは、以下にあります。

## Novelty API
- [Novelty API](./docs/novelty_api/api.md)

## なろう小説
- [なろう小説API](./docs/narou_api/novel_api.md)
- [なろう小説ランキングAPI](./docs/narou_api/ranking_api.md)

## カクヨム
(現在未実装 なろうの機能が作成後に実施)