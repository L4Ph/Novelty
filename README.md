[![DeepWiki](https://img.shields.io/badge/DeepWiki-L4Ph%2FNovelty-blue.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACwAAAAyCAYAAAAnWDnqAAAAAXNSR0IArs4c6QAAA05JREFUaEPtmUtyEzEQhtWTQyQLHNak2AB7ZnyXZMEjXMGeK/AIi+QuHrMnbChYY7MIh8g01fJoopFb0uhhEqqcbWTp06/uv1saEDv4O3n3dV60RfP947Mm9/SQc0ICFQgzfc4CYZoTPAswgSJCCUJUnAAoRHOAUOcATwbmVLWdGoH//PB8mnKqScAhsD0kYP3j/Yt5LPQe2KvcXmGvRHcDnpxfL2zOYJ1mFwrryWTz0advv1Ut4CJgf5uhDuDj5eUcAUoahrdY/56ebRWeraTjMt/00Sh3UDtjgHtQNHwcRGOC98BJEAEymycmYcWwOprTgcB6VZ5JK5TAJ+fXGLBm3FDAmn6oPPjR4rKCAoJCal2eAiQp2x0vxTPB3ALO2CRkwmDy5WohzBDwSEFKRwPbknEggCPB/imwrycgxX2NzoMCHhPkDwqYMr9tRcP5qNrMZHkVnOjRMWwLCcr8ohBVb1OMjxLwGCvjTikrsBOiA6fNyCrm8V1rP93iVPpwaE+gO0SsWmPiXB+jikdf6SizrT5qKasx5j8ABbHpFTx+vFXp9EnYQmLx02h1QTTrl6eDqxLnGjporxl3NL3agEvXdT0WmEost648sQOYAeJS9Q7bfUVoMGnjo4AZdUMQku50McDcMWcBPvr0SzbTAFDfvJqwLzgxwATnCgnp4wDl6Aa+Ax283gghmj+vj7feE2KBBRMW3FzOpLOADl0Isb5587h/U4gGvkt5v60Z1VLG8BhYjbzRwyQZemwAd6cCR5/XFWLYZRIMpX39AR0tjaGGiGzLVyhse5C9RKC6ai42ppWPKiBagOvaYk8lO7DajerabOZP46Lby5wKjw1HCRx7p9sVMOWGzb/vA1hwiWc6jm3MvQDTogQkiqIhJV0nBQBTU+3okKCFDy9WwferkHjtxib7t3xIUQtHxnIwtx4mpg26/HfwVNVDb4oI9RHmx5WGelRVlrtiw43zboCLaxv46AZeB3IlTkwouebTr1y2NjSpHz68WNFjHvupy3q8TFn3Hos2IAk4Ju5dCo8B3wP7VPr/FGaKiG+T+v+TQqIrOqMTL1VdWV1DdmcbO8KXBz6esmYWYKPwDL5b5FA1a0hwapHiom0r/cKaoqr+27/XcrS5UwSMbQAAAABJRU5ErkJggg==)](https://deepwiki.com/L4Ph/Novelty)

# Novelty

**モダンで、シンプルに。そして透明性高く。**

「小説家になろう」の作品を読むためにゼロから再設計された、Flutter製のクロスプラットフォーム小説ビューアーです。

## 概要

Noveltyは、最高の読書体験を提供するために開発された「小説家になろう」専用のクライアントアプリケーションです。
**オフラインファースト**の設計思想に基づき、ネットワーク接続が不安定な環境や圏外でも、保存されたライブラリからストレスなく読書を継続できます。

複雑な要求や機能を削ぎ落とし、読書に集中できるシンプルさを追求しながら、現代の読書スタイルに求められる必須機能を備えています。

## 主な機能

### 読書体験の追求
*   **縦書き・横書きの完全対応**: 日本語の小説に最適な縦書き表示をサポートしています。好みに合わせて横書きへの切り替えも瞬時に行えます。
*   **詳細なカスタマイズ**: フォントサイズ、フォントの種類、行間などを自由に調整し、自分だけの最適な読書環境を構築できます。

### 快適な作品探索
*   **ランキング機能**: 日間・週間・月間・四半期・累計など、多彩なランキングから人気の作品を簡単に見つけられます。
*   **高度な検索**: キーワード、ジャンル、文字数、完結区分など、詳細な条件を指定して作品を検索可能です。

### ライブラリとデータ管理
*   **オフライン閲覧**: 徹底したオフラインファースト設計により、作品を一度ダウンロードすれば、通信環境に依存せずいつでもどこでも読書を楽しめます。
*   **閲覧履歴の自動同期**: 読書の進捗は自動的に記録され、どこまで読んだかを忘れることはありません。
*   **バックアップと復元**: ライブラリや履歴データをファイルとしてエクスポート・インポートする機能を搭載しており、機種変更時も安心です。

### プライバシーとセキュリティ
*   **最小限の権限**: ユーザーのプライバシーを最大限尊重するため、**アプリケーションデータのバックアップおよび復元に必要なファイルアクセス権限以外、一切のデバイス権限（カメラ、位置情報、連絡先、マイクなど）を要求しません。**

## 技術スタック

本アプリケーションは、モダンで堅牢な技術選択に基づき開発されています。

*   **Framework**: Flutter
*   **Language**: Dart
*   **State Management**: Riverpod
*   **Routing**: GoRouter
*   **Database**: Drift (SQLite)
*   **API Client**: Dio
*   **CI/CD**: GitHub Actions

## 開発環境のセットアップ

### 前提条件
*   Flutter (stable channel)
*   FVM (Flutter Version Management)

### インストール手順

1.  **リポジトリのクローン**
    ```bash
    git clone https://github.com/L4Ph/Novelty.git
    cd Novelty
    ```

2.  **Flutter SDKのインストール (FVM使用)**
    ```bash
    fvm install
    ```

3.  **依存関係のインストール**
    ```bash
    fvm flutter pub get
    ```

4.  **コード生成の実行**
    ```bash
    fvm dart run build_runner build -d
    ```

### アプリケーションの実行

```bash
fvm flutter run
```

## APIとドキュメント

本プロジェクトが利用するAPIや、データ構造に関するドキュメントはリポジトリ内に含まれています。

*   なろう小説API (小説情報・ランキング)
*   なろう小説HTML構造 (トップページ・本文ページ)

## コントリビューション

バグ報告、機能提案、プルリクエストなど、あらゆるコントリビューションを歓迎します。

## ライセンス

*   **アプリケーション本体**: [PolyForm Noncommercial 1.0.0](./LICENSE)
    *   非商用利用に限り、自由な再配布、改変を許可します。
*   **packagesディレクトリ**: [MIT License](./packages/LICENSE)
    *   商用利用を含む自由な利用が可能です。

---

*「小説家になろう」は株式会社ヒナプロジェクトの登録商標です。本アプリは非公式のクライアントアプリです。*
