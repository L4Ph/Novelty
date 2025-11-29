# narou_parser パッケージ設計書

## 概要

`narou_parser` は、なろう小説の本文HTMLを `NovelContentElement` のリストに変換する純粋なDartパッケージです。

### 設計方針

- **Pure Dart**: Flutter依存なし
- **単一責務**: HTML → `List<NovelContentElement>` の変換のみ
- **無状態**: 入力と出力だけ

---

## 機能

HTMLから以下の要素を抽出：

- プレーンテキスト
- ルビテキスト（`<ruby>`, `<rb>`, `<rt>`, `<rp>` タグ）
- 改行（`<br>`, `<p>` タグ）

---

## データモデル

### NovelContentElement（ユニオン型）

```dart
@freezed
sealed class NovelContentElement with _$NovelContentElement {
  /// プレーンテキスト
  const factory NovelContentElement.plainText(String text) = PlainText;

  /// ルビ付きテキスト
  const factory NovelContentElement.rubyText({
    required String base,  // 親文字
    required String ruby,  // ルビ
  }) = RubyText;

  /// 改行
  const factory NovelContentElement.newLine() = NewLine;

  factory NovelContentElement.fromJson(Map<String, dynamic> json) =>
      _$NovelContentElementFromJson(json);
}
```

**JSON形式**:
```json
{"runtimeType": "plainText", "text": "吾輩は猫である"}
{"runtimeType": "rubyText", "base": "猫", "ruby": "ねこ"}
{"runtimeType": "newLine"}
```

---

## API

```dart
/// なろう小説の本文HTMLをパースする
///
/// [html] - 小説本文のHTML文字列
/// 戻り値: NovelContentElementのリスト
List<NovelContentElement> parseNovelContent(String html);
```

---

## ディレクトリ構造

```
packages/narou_parser/
├── lib/
│   ├── narou_parser.dart                 # エクスポート
│   └── src/
│       ├── parser.dart                   # parseNovelContent関数
│       └── models/
│           ├── novel_content_element.dart
│           ├── novel_content_element.freezed.dart
│           └── novel_content_element.g.dart
├── test/
│   ├── parser_test.dart
│   └── fixtures/
│       └── sample.html
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## 依存関係

```yaml
name: narou_parser
description: A parser for Narou novel HTML content.
version: 1.0.0

environment:
  sdk: ^3.8.0

dependencies:
  html: ^0.15.6
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.5.4
  freezed: ^3.1.0
  json_serializable: ^6.9.0
  very_good_analysis: ^8.0.0
  test: ^1.25.0
```

---

## 使用例

```dart
import 'package:narou_parser/narou_parser.dart';

void main() {
  final elements = parseNovelContent('''
    <p>吾輩は<ruby>猫<rt>ねこ</rt></ruby>である。</p>
  ''');

  for (final e in elements) {
    switch (e) {
      case PlainText(:final text):
        print('Text: $text');
      case RubyText(:final base, :final ruby):
        print('Ruby: $base ($ruby)');
      case NewLine():
        print('NewLine');
    }
  }

  // JSON変換
  final json = elements.map((e) => e.toJson()).toList();
}
```

---

## テスト

- プレーンテキストのパース
- ルビ（ruby/rb/rt/rp）のパース
- 改行（br/p）のパース
- 複合パターン
- 空HTML

---

## 責務分担

```
[Novelty本体 - ApiService]          [narou_parser]
HTMLページ全体取得
        ↓
CSSセレクタで本文抽出
(.p-novel__text:not(--preface):not(--afterword))
        ↓
    本文HTML  ──────────────→  parseNovelContent()
                                      ↓
                              List<NovelContentElement>
```

| 責務 | 担当 |
|------|------|
| HTTP通信 | Novelty本体（ApiService） |
| 前書き・後書きの除外 | Novelty本体（ApiService） |
| 本文HTMLのパース | narou_parser |

narou_parser は「本文HTMLだけ」を受け取り、パースに専念します。

---

## Novelty本体への統合

### pubspec.yaml の変更

```yaml
dependencies:
  narou_parser:
    path: packages/narou_parser
```

### 削除するファイル

パッケージに移行するため、以下のファイルを削除：

- `lib/utils/novel_parser.dart`
- `lib/models/novel_content_element.dart`
- `lib/models/novel_content_element.freezed.dart`
- `lib/models/novel_content_element.g.dart`
- `test/utils/novel_parser_test.dart`（パッケージ側に移動）

### インポートの変更

以下のファイルでインポートを変更：

| ファイル | 変更前 | 変更後 |
|---------|--------|--------|
| `lib/widgets/novel_content.dart` | `import 'package:novelty/models/novel_content_element.dart';` | `import 'package:narou_parser/narou_parser.dart';` |
| `lib/widgets/novel_content_view.dart` | `import 'package:novelty/models/novel_content_element.dart';` | `import 'package:narou_parser/narou_parser.dart';` |
| `lib/utils/tategaki_converter.dart` | `import 'package:novelty/models/novel_content_element.dart';` | `import 'package:narou_parser/narou_parser.dart';` |
| `lib/repositories/novel_repository.dart` | `import 'package:novelty/utils/novel_parser.dart';`<br>`import 'package:novelty/models/novel_content_element.dart';` | `import 'package:narou_parser/narou_parser.dart';` |
| `lib/database/database.dart` | `import 'package:novelty/models/novel_content_element.dart';` | `import 'package:narou_parser/narou_parser.dart';` |
| `test/widgets/novel_content_test.dart` | `import 'package:novelty/models/novel_content_element.dart';` | `import 'package:narou_parser/narou_parser.dart';` |
| `test/widgets/novel_content_view_test.dart` | `import 'package:novelty/models/novel_content_element.dart';` | `import 'package:narou_parser/narou_parser.dart';` |

### 関数名の変更

```dart
// 変更前
import 'package:novelty/utils/novel_parser.dart';
final elements = parseNovel(html);

// 変更後
import 'package:narou_parser/narou_parser.dart';
final elements = parseNovelContent(html);
```

### 統合後のディレクトリ構造

```
Novelty/
├── lib/
│   ├── database/
│   │   └── database.dart          # インポート変更
│   ├── repositories/
│   │   └── novel_repository.dart  # インポート変更、関数名変更
│   ├── utils/
│   │   └── tategaki_converter.dart # インポート変更
│   └── widgets/
│       ├── novel_content.dart      # インポート変更
│       └── novel_content_view.dart # インポート変更
├── packages/
│   └── narou_parser/               # 新規パッケージ
│       ├── lib/
│       │   ├── narou_parser.dart
│       │   └── src/
│       │       ├── parser.dart
│       │       └── models/
│       │           └── novel_content_element.dart
│       └── test/
│           └── parser_test.dart    # novel_parser_test.dart から移動
└── pubspec.yaml                    # 依存関係追加
```
