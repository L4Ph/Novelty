# Novelty

「小説家になろう」「カクヨム」を読むためにゼロから設計した、Flutter製のクロスプラットフォーム小説ビューアーです。

オフラインファーストで、縦書き表示・高度な検索・ランキング・バックアップに対応しています。

## 主な機能

- **縦書き／横書き**: 日本語小説に最適化した縦書き表示。フォント・行間・文字サイズを調整できます
- **オフライン閲覧**: 一度ダウンロードした作品は、通信環境がなくても読めます
- **作品探索**: なろう・カクヨムのランキング切り替えと、条件を指定した検索
- **データ管理**: ライブラリや閲覧履歴のバックアップと復元

## 対応サイト

小説家になろう / カクヨム（`NovelSource` による抽象化で、サイト追加に対応しています）

## 入手

- [GitHub Releases](https://github.com/L4Ph/Novelty/releases) からダウンロード
- [Google Play ベータ](https://play.google.com/apps/testing/moe.l4ph.novelty)（Google グループへの参加が必要）

## 開発

```bash
mise run get      # 依存関係の取得
mise run codegen  # コード生成
mise run run      # アプリ起動
```

## ライセンス

- アプリ本体: [PolyForm Noncommercial 1.0.0](./LICENSE)
- `packages/` 以下: [MIT License](./packages/LICENSE)

## 不具合報告・要望

[Issue](https://github.com/L4Ph/Novelty/issues) にて受け付けています（プルリクエストは受け付けていません）。

---

「小説家になろう」は株式会社ヒナプロジェクトの登録商標です。

「カクヨム」は株式会社KADOKAWAのサービスです。

本アプリは各社とは無関係の非公式クライアントアプリです。
