# Suggested Commands

## 依存関係のインストール

```bash
fvm flutter pub get
```

## コード生成

モデルやDIコンテナの更新後に実行します。

```bash
fvm dart run build_runner build -d
```

## 静的解析 (Linter)

コードの品質をチェックします。

```bash
fvm dart analyze
```

## テストの実行

```bash
fvm flutter test
```

## アプリケーションの実行

```bash
fvm flutter run
```
