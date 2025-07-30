[![DeepWiki](https://img.shields.io/badge/DeepWiki-L4Ph%2FNovelty-blue.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACwAAAAyCAYAAAAnWDnqAAAAAXNSR0IArs4c6QAAA05JREFUaEPtmUtyEzEQhtWTQyQLHNak2AB7ZnyXZMEjXMGeK/AIi+QuHrMnbChYY7MIh8g01fJoopFb0uhhEqqcbWTp06/uv1saEDv4O3n3dV60RfP947Mm9/SQc0ICFQgzfc4CYZoTPAswgSJCCUJUnAAoRHOAUOcATwbmVLWdGoH//PB8mnKqScAhsD0kYP3j/Yt5LPQe2KvcXmGvRHcDnpxfL2zOYJ1mFwrryWTz0advv1Ut4CJgf5uhDuDj5eUcAUoahrdY/56ebRWeraTjMt/00Sh3UDtjgHtQNHwcRGOC98BJEAEymycmYcWwOprTgcB6VZ5JK5TAJ+fXGLBm3FDAmn6oPPjR4rKCAoJCal2eAiQp2x0vxTPB3ALO2CRkwmDy5WohzBDwSEFKRwPbknEggCPB/imwrycgxX2NzoMCHhPkDwqYMr9tRcP5qNrMZHkVnOjRMWwLCcr8ohBVb1OMjxLwGCvjTikrsBOiA6fNyCrm8V1rP93iVPpwaE+gO0SsWmPiXB+jikdf6SizrT5qKasx5j8ABbHpFTx+vFXp9EnYQmLx02h1QTTrl6eDqxLnGjporxl3NL3agEvXdT0WmEost648sQOYAeJS9Q7bfUVoMGnjo4AZdUMQku50McDcMWcBPvr0SzbTAFDfvJqwLzgxwATnCgnp4wDl6Aa+Ax283gghmj+vj7feE2KBBRMW3FzOpLOADl0Isb5587h/U4gGvkt5v60Z1VLG8BhYjbzRwyQZemwAd6cCR5/XFWLYZRIMpX39AR0tjaGGiGzLVyhse5C9RKC6ai42ppWPKiBagOvaYk8lO7DajerabOZP46Lby5wKjw1HCRx7p9sVMOWGzb/vA1hwiWc6jm3MvQDTogQkiqIhJV0nBQBTU+3okKCFDy9WwferkHjtxib7t3xIUQtHxnIwtx4mpg26/HfwVNVDb4oI9RHmx5WGelRVlrtiw43zboCLaxv46AZeB3IlTkwouebTr1y2NjSpHz68WNFjHvupy3q8TFn3Hos2IAk4Ju5dCo8B3wP7VPr/FGaKiG+T+v+TQqIrOqMTL1VdWV1DdmcbO8KXBz6esmYWYKPwDL5b5FA1a0hwapHiom0r/cKaoqr+27/XcrS5UwSMbQAAAABJRU5ErkJggg==)](https://deepwiki.com/L4Ph/Novelty)

# Novelty

モダンで、シンプルに。そして透明性高く。  
「小説家になろう」の作品を読むために再設計された、Flutter製のクロスプラットフォーム小説ビューアーです。  

## 📖 概要  
Noveltyは、最高の読書体験を提供するために、ゼロから設計・開発された「小説家になろう」専用のクライアントアプリケーションです。  
Flutterフレームワークを採用することで、iOS、Androidはもちろん、デスクトップ（Windows, macOS, Linux）でも、ネイティブアプリのように快適で一貫した操作性を実現します。  
複雑な機能を削ぎ落とし、読書に集中できるシンプルさを追求しながら、カスタマイズ性やオフライン機能など、現代の読者に求められる機能を備えています。  

## ✨ 主な機能  
| 機能 | 説明 |
|---|---|
| 📚 ライブラリ | お気に入りの小説を登録し、更新情報を逃さず管理できます。 |
| 📈 ランキング | 日間・週間・月間・四半期・累計ランキングに対応。人気の作品を簡単に見つけられます。 |
| 🔍 小説検索 | キーワードやジャンル、文字数など、多彩な条件で読みたい小説を的確に探せます。 |
| 📖 快適なリーダー | 縦書き・横書き表示の切り替え、フォントサイズや種類の変更など、自分好みの読書環境を構築できます。 |
| 🕒 閲覧履歴 | 一度読んだ小説は自動で記録。どこまで読んだか忘れることはありません。 |
| 💾 オフライン対応 | 小説をデバイスにダウンロードすれば、通信環境がない場所でも読書を楽しめます。 |
| 🔧 データ管理 | ライブラリや履歴データをファイルにバックアップ・復元する機能を搭載。機種変更時も安心です。 |

## 🛠️ 技術スタック & アーキテクチャ  
本アプリケーションは、モダンで堅牢な技術選択に基づいています。  
 * フレームワーク: Flutter
 * 状態管理: Riverpod
 * ルーティング: GoRouter
 * データベース: Drift (SQLite)
 * APIクライアント: Dio
 * CI/CD: GitHub Actions

## 🚀 Getting Started  
開発環境をセットアップし、プロジェクトを実行する手順は以下の通りです。    

### 1. 前提条件
 * Flutter （stableチャンネル）
 * FVM (Flutter Version Management)

### 2. セットアップ

1. リポジトリをクローン
git clone https://github.com/L4Ph/Novelty.git
cd Novelty

2. FVMでプロジェクトに設定されたFlutter SDKをインストール
fvm install

3. 依存パッケージをインストール
fvm flutter pub get

4. コード生成を実行

fvm dart run build_runner build -d

### 3. アプリケーションの実行

fvm flutter run

## 📝 API & ドキュメント
本プロジェクトが利用するAPIや、HTMLの構造に関するドキュメントはリポジトリ内に含まれています。  
 * なろう小説API
   * 小説情報取得API
   * ランキング取得API
 * なろう小説HTML構造
   * 小説トップページ (/{ncode}/)
   * 小説本文ページ (/{ncode}/{episode}/)

## 🤝 コントリビューション
バグ報告、機能提案、プルリクエストなど、あらゆるコントリビューションを歓迎します。  

## 📜 ライセンス
このプロジェクトは MIT License のもとで公開されています。詳細は LICENSE ファイルをご確認ください。  