# tategaki パッケージ設計書

## 概要

`tategaki` は Flutter 向けの縦書きテキスト表示ライブラリです。
構造化されたテキスト要素を受け取り、適切な縦書きとして表示します。

---

## 設計思想

### パーサーとウィジェットの分離

```
┌─────────────────┐     ┌─────────────────┐
│  TategakiParser │     │   外部パーサー   │
│  (文字列→要素)  │     │  (HTML→要素など) │
└────────┬────────┘     └────────┬────────┘
         │                       │
         └───────────┬───────────┘
                     ▼
         ┌─────────────────────┐
         │  List<TategakiElement>  │
         └───────────┬─────────┘
                     ▼
         ┌─────────────────────┐
         │    TategakiText     │
         │  (StatelessWidget)  │
         └─────────────────────┘
```

### 責務の分離

| コンポーネント | 責務 |
|----------------|------|
| `TategakiElement` | 縦書き要素のデータモデル |
| `TategakiParser` | 文字列 → 要素リスト変換（縦中横検出含む） |
| `TategakiText` | 要素リスト → 縦書き描画 |

---

## Public API

### TategakiElement

```dart
/// 縦書きテキストの要素
sealed class TategakiElement {
  /// 通常の文字（1文字、字形変換済み）
  const factory TategakiElement.char(String char) = TategakiChar;

  /// 縦中横（横書きで挿入する文字列。既定は2桁の半角数字）
  const factory TategakiElement.tcy(String text) = TategakiTcy;

  /// 回転させる文字列（3桁以上の数字トークン・2文字以上の欧文）
  const factory TategakiElement.rotated(String text) = TategakiRotated;

  /// 改行（次の列へ）
  const factory TategakiElement.newLine() = TategakiNewLine;

  /// ルビ付きテキスト
  const factory TategakiElement.ruby({
    required String base,
    required String ruby,
  }) = TategakiRuby;

  /// 傍点（圏点）付きテキスト
  const factory TategakiElement.kenten({
    required String base,
    required String mark,
  }) = TategakiKenten;
}
```

### TategakiParser

```dart
/// 文字列を縦書き要素に変換するパーサー
class TategakiParser {
  /// 文字列をパースして要素リストに変換
  ///
  /// - 改行（\n）を検出して TategakiNewLine に
  /// - 半角数字トークン（小数点・位取りコンマを含む）を向きのラダーで
  ///   TategakiChar / TategakiTcy / TategakiRotated に
  /// - 半角英字ランを TategakiChar（1文字） / TategakiRotated（2文字以上）に
  /// - 残りの文字を1文字ずつ TategakiChar に（字形変換適用）
  static List<TategakiElement> parse(String text);
}
```

### TategakiText

```dart
/// 縦書きテキストを表示するウィジェット
class TategakiText extends StatelessWidget {
  const TategakiText(
    this.elements, {
    required this.height,
    super.key,
  });

  /// 表示する要素のリスト
  final List<TategakiElement> elements;

  /// 列の高さ（必須）
  final double height;
}
```

---

## 使用例

### シンプルな使い方（パーサー経由）

```dart
import 'package:tategaki/tategaki.dart';

// 文字列をパースして表示
final elements = TategakiParser.parse('吾輩は猫である。12時に会おう。');

TategakiText(
  elements,
  height: 600,
)
```

### 構造化データを直接渡す（Novelty向け）

```dart
// 外部でパースした結果を渡す
final elements = [
  TategakiElement.char('吾'),
  TategakiElement.char('輩'),
  TategakiElement.char('は'),
  TategakiElement.ruby(base: '猫', ruby: 'ねこ'),
  TategakiElement.char('で'),
  TategakiElement.char('あ'),
  TategakiElement.char('る'),
  TategakiElement.char('︒'),
];

TategakiText(
  elements,
  height: 600,
)
```

### スタイル指定

```dart
DefaultTextStyle(
  style: TextStyle(
    fontSize: 18,
    fontFamily: 'NotoSerifJP',
  ),
  child: TategakiText(elements, height: 600),
)
```

### スクロール対応

```dart
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  reverse: true,  // 右から左へスクロール
  child: TategakiText(elements, height: 600),
)
```

---

## 内部処理

### 1. 縦書き字形変換（パーサーで適用）

```
。 → ︒
、 → ︑
ー → 丨
「 → ﹁
」 → ﹂
（ → ︵
） → ︶
```

### 2. 縦中横（パーサーで検出）

```
入力: "12時に会おう"
出力: [Tcy("12"), Char("時"), Char("に"), ...]
```

**検出ルール**:
- 半角数字1桁 → `TategakiChar`（正立）
- 半角数字2桁（区切りなし）→ `TategakiTcy`
- 半角数字3桁以上、または小数点・位取りコンマを含む → トークン全体が `TategakiRotated`
- 半角英字1文字 → `TategakiChar`、2文字以上 → `TategakiRotated`

### 3. 禁則・アキ・行調整（レイアウト時に適用）

- 文字クラス（`TategakiCharClassifier`）は JLREQ の文字クラスを集約し、
  行頭禁則・行末禁則を判定する。字形変換後の縦書き変体（`︒` `︑` `﹁` 等）も含む。
- アキ量（`TategakiAki`）は文字クラスペアごとの空き量を em で返す
  （読点・句点の後ろ 0.5em、中点の前後 0.25em、和欧間 0.25em、括弧はベタ）。
- 行調整（`TategakiColumnEngine._adjust`）は、段落末以外の行で
  余りを分離可能なギャップへ均等配分（トラッキング）し、不足時はアキを詰める。
- 字送り（インライン方向）は `fontSize`（em）、行送り（列幅）は
  `fontSize × lineHeight` とする。

---

## アーキテクチャ

```
┌─────────────────────────────────────┐
│            TategakiText             │
│         (StatelessWidget)           │
├─────────────────────────────────────┤
│           TategakiLayout            │
│   要素リスト → 列レイアウト計算      │
│         （禁則処理を含む）           │
├─────────────────────────────────────┤
│           TategakiPainter           │
│          (CustomPainter)            │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│           TategakiParser            │
│   文字列 → List<TategakiElement>    │
│  （字形変換・縦中横検出を含む）      │
└─────────────────────────────────────┘
```

### ディレクトリ構造

```
packages/tategaki/
├── lib/
│   ├── tategaki.dart                 # エントリポイント（export）
│   └── src/
│       ├── tategaki_text.dart        # メインウィジェット
│       ├── element/
│       │   └── tategaki_element.dart # 要素モデル
│       ├── parser/
│       │   └── tategaki_parser.dart  # 文字列パーサー
│       ├── layout/
│       │   ├── tategaki_layout.dart  # レイアウト計算
│       │   ├── tategaki_column_engine.dart # 列分割・行調整
│       │   ├── column.dart           # 列データ・配置済みアイテム
│       │   ├── tategaki_measurer.dart # 要素の計測・描画要素生成
│       │   ├── tategaki_char_class.dart # JLREQ 文字クラス
│       │   ├── tategaki_aki.dart     # アキ量テーブル
│       │   ├── vertical_orientation.dart # UAX #50 向き解決
│       │   └── vertical_orientation_data.dart # 生成済み範囲表
│       ├── painting/
│       │   ├── tategaki_painter.dart # CustomPainter
│       │   ├── paintable.dart        # 描画要素の基底
│       │   ├── paintable_rotated.dart # 回転描画
│       │   ├── paintable_ruby.dart   # ルビ描画
│       │   ├── paintable_kenten.dart # 傍点描画
│       │   └── paintable_tcy.dart    # 縦中横描画
│       └── utils/
│           └── glyph_mapper.dart     # 字形マッピング
├── data/
│   └── VerticalOrientation.txt       # Unicode UAX #50 データ
├── tool/
│   └── gen_vertical_orientation.dart # 範囲表の生成スクリプト
├── test/
│   ├── element/
│   │   └── tategaki_element_test.dart
│   ├── parser/
│   │   └── tategaki_parser_test.dart
│   ├── layout/
│   │   ├── tategaki_layout_test.dart
│   │   └── kinsoku_test.dart
│   └── tategaki_text_test.dart
├── pubspec.yaml
└── README.md
```

---

## Novelty との統合

### 変換レイヤー（Novelty側で実装）

```dart
extension NovelContentElementToTategaki on NovelContentElement {
  TategakiElement toTategakiElement() {
    return switch (this) {
      PlainText(:final text) => _convertPlainText(text),
      RubyText(:final base, :final ruby) =>
        TategakiElement.ruby(base: base, ruby: ruby),
      NewLine() => TategakiElement.newLine(),
    };
  }
}

List<TategakiElement> _convertPlainText(String text) {
  // TategakiParser を使うか、独自に変換
  return TategakiParser.parse(text);
}
```

### 使用例（Novelty）

```dart
// Before
Tategaki(
  contentData,  // List<NovelContentElement>
  style: textStyle,
  maxHeight: constraints.maxHeight,
)

// After
TategakiText(
  contentData.expand((e) => e.toTategakiElements()).toList(),
  height: constraints.maxHeight,
)
```

---

## 依存関係

### pubspec.yaml

```yaml
name: tategaki
description: Flutter向け縦書きテキスト表示ライブラリ
version: 0.1.0

environment:
  sdk: ^3.8.1

resolution: workspace

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
```

---

## マイグレーション計画

### Phase 1: 基盤作成

1. ディレクトリ構造の作成
2. `TategakiElement` の実装
3. `GlyphMapper` の移植
4. `TategakiParser` の実装（縦中横検出含む）

### Phase 2: レイアウト・描画

1. `Paintable` 系クラスの実装
2. `Kinsoku` の実装
3. `TategakiLayout` の実装
4. `TategakiPainter` の実装

### Phase 3: ウィジェット

1. `TategakiText` の実装
2. テストの作成

### Phase 4: Novelty 統合

1. `NovelContentElement` → `TategakiElement` 変換の実装
2. 既存の `Tategaki` ウィジェットを `TategakiText` に置き換え
3. 既存テストの更新

---

## テスト戦略

### ユニットテスト

1. **TategakiElement**: 各要素の生成
2. **GlyphMapper**: 全マッピングの正確性
3. **TategakiParser**:
   - 通常文字のパース
   - 改行の処理
   - 縦中横の検出（2桁、3桁、4桁以上）
4. **Kinsoku**: 禁則処理の正確性

### ウィジェットテスト

1. **TategakiText**: 基本レンダリング
2. 空リストの処理
3. ルビ付きテキストの表示
4. 縦中横の表示

---

## 将来の拡張

### ルビ記法のパース（Phase 2）

```dart
// 青空文庫形式を自動パース
final elements = TategakiParser.parse(
  '吾輩は｜猫《ねこ》である。',
);
// → [..., Ruby(base: '猫', ruby: 'ねこ'), ...]
```

---

## 開発コマンド

```bash
cd packages/tategaki

# テスト
flutter test

# 静的解析
dart analyze
```
