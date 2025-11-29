# tategaki パッケージ設計書

## 概要

`tategaki` は Flutter 向けの縦書き（縦組み）テキスト表示ライブラリです。
日本語小説ビューアー向けに設計されており、ルビ（振り仮名）表示にも対応しています。

---

## 目標

### 主要目標

1. **汎用性**: Novelty 以外のアプリケーションでも利用可能な独立したパッケージ
2. **シンプルな API**: 最小限の設定で縦書き表示を実現
3. **高パフォーマンス**: 大量のテキストでもスムーズに表示
4. **ルビ対応**: 日本語特有のルビ表示を完全サポート

### 非目標

- 横書きテキスト表示（本パッケージのスコープ外）
- テキスト編集機能（読み取り専用）
- 状態管理の提供（呼び出し側で管理）

---

## アーキテクチャ

### レイヤー構成

```
┌─────────────────────────────────────────────────────┐
│                   Public API                        │
│  TategakiText / TategakiSpan / TategakiStyle        │
├─────────────────────────────────────────────────────┤
│                 Layout Engine                       │
│  TategakiLayout / ColumnBuilder / MetricsCalculator │
├─────────────────────────────────────────────────────┤
│                Rendering Layer                      │
│  TategakiPainter / PaintableChar / PaintableRuby    │
├─────────────────────────────────────────────────────┤
│                   Utilities                         │
│  VerticalGlyphMapper / CharacterClassifier          │
└─────────────────────────────────────────────────────┘
```

### ディレクトリ構造

```
packages/tategaki/
├── lib/
│   ├── tategaki.dart                 # パッケージのエントリポイント
│   └── src/
│       ├── widgets/
│       │   ├── tategaki_text.dart    # メインウィジェット
│       │   └── tategaki_scroll_view.dart  # スクロール対応ラッパー
│       ├── layout/
│       │   ├── tategaki_layout.dart  # レイアウト計算
│       │   ├── column.dart           # 列データ構造
│       │   └── metrics.dart          # メトリクス
│       ├── painting/
│       │   ├── tategaki_painter.dart # CustomPainter実装
│       │   ├── paintable.dart        # 描画可能要素の基底クラス
│       │   ├── paintable_ruby.dart   # ルビ描画
│       │   └── paintable_tcy.dart    # 縦中横描画
│       ├── models/
│       │   └── tategaki_span.dart    # テキストスパンモデル
│       └── utils/
│           ├── vertical_glyph_mapper.dart  # 縦書き用字形マッピング
│           └── kinsoku.dart                # 禁則処理
├── test/
│   ├── widgets/
│   │   └── tategaki_text_test.dart
│   ├── layout/
│   │   ├── tategaki_layout_test.dart
│   │   └── kinsoku_test.dart         # 禁則処理テスト
│   └── utils/
│       └── vertical_glyph_mapper_test.dart
├── example/
│   └── lib/
│       └── main.dart
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
└── DESIGN.md
```

---

## Public API 設計

### 1. TategakiText（メインウィジェット）

```dart
/// 縦書きテキストを表示するウィジェット
class TategakiText extends StatelessWidget {
  const TategakiText({
    required this.spans,
    required this.height,
    this.style,
    this.columnSpacing = 12.0,
    this.rubyScale = 0.6,
    super.key,
  });

  /// 表示するテキストスパンのリスト
  final List<TategakiSpan> spans;

  /// 列の最大高さ（必須）
  final double height;

  /// デフォルトのテキストスタイル
  final TextStyle? style;

  /// 列間のスペース
  final double columnSpacing;

  /// ルビのフォントサイズ比率（0.0〜1.0）
  final double rubyScale;
}
```

### 2. TategakiSpan（テキストモデル）

```dart
/// 縦書きテキストの要素を表すsealed class
sealed class TategakiSpan {
  /// プレーンテキスト
  const factory TategakiSpan.text(String text) = TategakiTextSpan;

  /// ルビ付きテキスト
  const factory TategakiSpan.ruby({
    required String base,
    required String ruby,
  }) = TategakiRubySpan;

  /// 改行
  const factory TategakiSpan.newLine() = TategakiNewLine;

  /// 縦中横（数字などを横書きで挿入）
  const factory TategakiSpan.tcy(String text) = TategakiTcySpan;
}

class TategakiTextSpan implements TategakiSpan {
  const TategakiTextSpan(this.text);
  final String text;
}

class TategakiRubySpan implements TategakiSpan {
  const TategakiRubySpan({required this.base, required this.ruby});
  final String base;
  final String ruby;
}

class TategakiNewLine implements TategakiSpan {
  const TategakiNewLine();
}

/// 縦中横（Tate-Chu-Yoko）
/// 縦書きの中で横書きのテキストを挿入する
class TategakiTcySpan implements TategakiSpan {
  const TategakiTcySpan(this.text);
  final String text;  // 通常2〜4文字程度（例: "12", "!?"）
}
```

### 3. TategakiScrollView（スクロール対応）

```dart
/// 横スクロール可能な縦書きビュー
class TategakiScrollView extends StatelessWidget {
  const TategakiScrollView({
    required this.spans,
    this.style,
    this.columnSpacing = 12.0,
    this.rubyScale = 0.6,
    this.controller,
    this.physics,
    super.key,
  });

  final List<TategakiSpan> spans;
  final TextStyle? style;
  final double columnSpacing;
  final double rubyScale;
  final ScrollController? controller;
  final ScrollPhysics? physics;
}
```

---

## 内部設計

### 1. レイアウト計算

#### TategakiLayout

```dart
class TategakiLayout {
  TategakiLayout({
    required this.spans,
    required this.maxHeight,
    required this.textStyle,
    required this.rubyStyle,
    required this.columnSpacing,
  });

  /// メトリクスを計算
  TategakiMetrics calculate();
}
```

#### TategakiMetrics

```dart
class TategakiMetrics {
  const TategakiMetrics({
    required this.columns,
    required this.size,
  });

  final List<TategakiColumn> columns;
  final Size size;
}
```

#### TategakiColumn

```dart
class TategakiColumn {
  const TategakiColumn({
    required this.items,
    required this.width,
    required this.baseWidth,
  });

  final List<Paintable> items;
  final double width;      // 列の総幅（ベース + ルビ）
  final double baseWidth;  // ベーステキストの最大幅
}
```

### 2. 描画システム

#### Paintable（描画可能要素の抽象）

```dart
abstract class Paintable {
  double get height;
  double get width;
  double get baseWidth;
  double get rubyWidth;
  bool get isRuby;

  void paint(Canvas canvas, Offset offset);
}
```

#### PaintableChar（単一文字）

```dart
class PaintableChar implements Paintable {
  PaintableChar(this.painter);
  final TextPainter painter;

  // Paintable実装...
}
```

#### PaintableRuby（ルビ付きテキスト）

```dart
class PaintableRuby implements Paintable {
  PaintableRuby({
    required this.basePainters,
    required this.rubyPainters,
    required this.baseWidth,
    required this.rubyWidth,
    required this.rubyHeight,
  });

  final List<TextPainter> basePainters;
  final List<TextPainter> rubyPainters;

  // Paintable実装...
}
```

### 3. 縦書き字形マッピング

#### VerticalGlyphMapper

```dart
/// 横書き用字形を縦書き用字形に変換
class VerticalGlyphMapper {
  /// 文字を縦書き用に変換
  static String map(String char) {
    return _mapping[char] ?? char;
  }

  static const _mapping = <String, String>{
    '。': '︒',
    '、': '︑',
    'ー': '丨',
    '「': '﹁',
    '」': '﹂',
    // ... その他のマッピング
  };
}
```

### 4. 禁則処理

列の先頭・末尾に来てはいけない文字を制御します。

#### 禁則文字の定義

```dart
class Kinsoku {
  /// 行頭禁則文字（列の先頭に来てはいけない）
  static const headProhibited = {
    '。', '、', '．', '，', '：', '；', '？', '！',
    '）', '］', '｝', '」', '』', '】', '〉', '》',
    'ー', '～', '…', '‥',
  };

  /// 行末禁則文字（列の末尾に来てはいけない）
  static const tailProhibited = {
    '（', '［', '｛', '「', '『', '【', '〈', '《',
  };
}
```

#### 禁則処理のロジック

```dart
// 列末尾の処理
if (isColumnEnd && Kinsoku.tailProhibited.contains(char)) {
  // 次の列に送る（追い出し）
  endColumn();
  addToColumn(item);
}

// 列先頭の処理
if (isColumnStart && Kinsoku.headProhibited.contains(char)) {
  // 前の列に戻す（追い込み）
  // ※前の列に余裕がある場合のみ
  moveToPregiousColumn(item);
}
```

### 5. 縦中横（TCY）描画

#### PaintableTcy

```dart
class PaintableTcy implements Paintable {
  PaintableTcy(this.painter);
  final TextPainter painter;  // 横書きでレイアウト済み

  @override
  double get height => painter.width;  // 横幅が縦の高さになる

  @override
  double get width => painter.height;  // 縦幅が横の幅になる

  @override
  void paint(Canvas canvas, Offset offset) {
    // 90度回転せずに横書きのまま描画
    // 列の中央に配置
    painter.paint(canvas, offset);
  }
}
```

---

## 使用例

### 基本的な使用方法

```dart
import 'package:tategaki/tategaki.dart';

class MyNovelReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spans = [
      TategakiSpan.text('吾輩は'),
      TategakiSpan.ruby(base: '猫', ruby: 'ねこ'),
      TategakiSpan.text('である。'),
      TategakiSpan.newLine(),
      TategakiSpan.text('名前はまだ無い。'),
      TategakiSpan.newLine(),
      TategakiSpan.tcy('12'),  // 縦中横
      TategakiSpan.text('時に会おう。'),
    ];

    return TategakiScrollView(
      spans: spans,
      style: TextStyle(fontSize: 18),
    );
  }
}
```

### カスタムスタイリング

```dart
TategakiText(
  spans: spans,
  height: 600,
  style: TextStyle(
    fontSize: 20,
    fontFamily: 'NotoSerifJP',
    height: 1.8,
  ),
  columnSpacing: 16.0,
  rubyScale: 0.5,
)
```

### Directionality との統合

```dart
// RTL（右から左）で正しくスクロールさせる場合
Directionality(
  textDirection: TextDirection.rtl,
  child: TategakiScrollView(
    spans: spans,
  ),
)
```

---

## 依存関係

### Pub Workspace 構成

本パッケージは Novelty プロジェクトの [pub workspace](https://dart.dev/tools/pub/workspaces) の一部として構成されます。

**ルート pubspec.yaml（Novelty）**:
```yaml
name: novelty
environment:
  sdk: ^3.8.1
workspace:
  - packages/tategaki
  - packages/narou_parser
```

**packages/tategaki/pubspec.yaml**:
```yaml
name: tategaki
description: Flutter向け縦書きテキスト表示ライブラリ
version: 0.1.0

environment:
  sdk: ^3.8.1

# ワークスペース解決に参加（単一の共有依存関係解決を使用）
resolution: workspace

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
```

### Workspace の仕組み

1. **単一の依存関係解決**: ルートに単一の `pubspec.lock` が生成され、全パッケージで共有
2. **パッケージ間の自動解決**: workspace 内のパッケージ間の依存は自動的にローカル版が優先
3. **共有の package_config**: `.dart_tool/package_config.json` を共有し、メモリ使用量削減・分析パフォーマンス向上

### Novelty から tategaki への依存

workspace 内では、パッケージ間の依存を通常の依存として記述できます：

```yaml
# novelty/pubspec.yaml
dependencies:
  tategaki:  # workspace内のパッケージは自動的にローカル版が使用される
```

**注意**: バージョン制約を指定する場合、ローカル版がその制約を満たす必要があります。

### 設計方針: 完全なステートレス実装

本パッケージは **状態を一切持たない純粋な StatelessWidget** として実装します。

**理由**:
- 汎用性の最大化（どのプロジェクトでも利用可能）
- 依存関係ゼロ（Flutter SDK のみ）
- テストの簡素化
- 予測可能な動作

**メモ化が不要な理由**:
1. **Flutter の再構築最適化**: 親ウィジェットが変わらなければ子は再構築されない
2. **CustomPainter.shouldRepaint**: 同じデータなら再描画をスキップ
3. **const コンストラクタ**: 呼び出し側で `const` を使えば再構築自体を防止可能
4. **パフォーマンス責任の分離**: キャッシュが必要な場合は呼び出し側で実装

---

## マイグレーション計画

### Phase 1: パッケージ基盤の作成

1. `pubspec.yaml` の完成
2. 基本ディレクトリ構造の作成
3. `TategakiSpan` モデルの実装

### Phase 2: コア機能の移植

1. `VerticalGlyphMapper` の移植（`vertical_rotated.dart` から）
2. `Paintable` 系クラスの移植
3. `TategakiLayout` の実装
4. `TategakiPainter` の実装

### Phase 3: ウィジェットの実装

1. `TategakiText` の実装（`Tategaki` から移植、純粋な `StatelessWidget`）
2. `TategakiScrollView` の実装

### Phase 4: テストとドキュメント

1. ユニットテストの移植・拡充
2. ウィジェットテストの作成
3. README.md の作成
4. example アプリの作成

### Phase 5: Novelty への統合

1. ルート `pubspec.yaml` に依存追加:
   ```yaml
   dependencies:
     tategaki:  # workspace内なのでpath指定不要
   ```
2. Novelty の `tategaki.dart` を新パッケージに置き換え
3. `NovelContentElement` → `TategakiSpan` の変換レイヤー追加
4. 既存テストの更新

---

## API 互換性

### NovelContentElement との対応

| NovelContentElement | TategakiSpan |
|---------------------|--------------|
| `PlainText(text)` | `TategakiSpan.text(text)` |
| `RubyText(base, ruby)` | `TategakiSpan.ruby(base: base, ruby: ruby)` |
| `NewLine()` | `TategakiSpan.newLine()` |

### 変換ヘルパー（Novelty 側で実装）

```dart
extension NovelContentElementToTategaki on NovelContentElement {
  TategakiSpan toTategakiSpan() {
    return switch (this) {
      PlainText(:final text) => TategakiSpan.text(text),
      RubyText(:final base, :final ruby) =>
        TategakiSpan.ruby(base: base, ruby: ruby),
      NewLine() => TategakiSpan.newLine(),
    };
  }
}

extension NovelContentListToTategaki on List<NovelContentElement> {
  List<TategakiSpan> toTategakiSpans() => map((e) => e.toTategakiSpan()).toList();
}
```

---

## パフォーマンス考慮事項

### 1. ステートレス設計

`TategakiText` は純粋な `StatelessWidget` として実装します。
メモ化やキャッシュは行わず、Flutter のウィジェット再構築最適化に委ねます。

```dart
class TategakiText extends StatelessWidget {
  const TategakiText({
    required this.spans,
    required this.height,
    this.style,
    this.columnSpacing = 12.0,
    this.rubyScale = 0.6,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;
    final rubyStyle = effectiveStyle.copyWith(
      fontSize: (effectiveStyle.fontSize ?? 14) * rubyScale,
    );

    final metrics = _calculateMetrics(effectiveStyle, rubyStyle);

    if (spans.isEmpty) return const SizedBox.shrink();

    return CustomPaint(
      size: metrics.size,
      painter: TategakiPainter(metrics: metrics, spacing: columnSpacing),
    );
  }
}
```

### 2. 描画最適化

- `CustomPainter.shouldRepaint` で不要な再描画を防止
- `RepaintBoundary` の使用を推奨（呼び出し側で）

### 3. 呼び出し側でのキャッシュ（オプション）

パフォーマンスが問題になる場合、呼び出し側で対応可能：

```dart
// 例: Riverpod でメトリクスをキャッシュ
final tategakiSpansProvider = Provider<List<TategakiSpan>>((ref) {
  final content = ref.watch(novelContentProvider);
  return content.toTategakiSpans(); // 変換結果をキャッシュ
});

// 例: flutter_hooks でメモ化
final spans = useMemoized(() => content.toTategakiSpans(), [content]);
```

### 4. 大量テキスト対応

将来の拡張として以下を検討:
- 仮想化（visible 部分のみ描画）
- 列単位の遅延レンダリング

---

## テスト戦略

### ユニットテスト

1. **VerticalGlyphMapper**: 全マッピングの正確性
2. **TategakiLayout**: メトリクス計算の正確性
3. **TategakiColumn**: 列分割ロジック
4. **Kinsoku**: 禁則処理の正確性
   - 行頭禁則文字が列先頭に来ないこと
   - 行末禁則文字が列末尾に来ないこと

### ウィジェットテスト

1. **TategakiText**: 基本レンダリング
2. **TategakiScrollView**: スクロール動作
3. **ルビ表示**: 位置と配置の正確性
4. **縦中横表示**: 横書きテキストの配置

### ゴールデンテスト

- 日本語テキストの描画結果を画像で検証
- ルビ付きテキストの配置検証
- 縦中横の配置検証

---

## 将来の拡張

### 検討中の機能

1. **テキスト選択**: 縦書きでのテキスト選択対応
2. **傍点**: 強調用の傍点表示
3. **フォント切り替え**: 文字種別ごとのフォント指定
4. **横倒し（sideways）**: 英単語などを90度回転して表示
   - 現状: 英単語は1文字ずつ縦に並ぶ（H, e, l, l, o）
   - 横倒し: 単語全体を時計回りに90度回転して表示
   - なろう小説では英語がほぼ出てこないため優先度低

### API 拡張例

```dart
// 将来的な拡張
TategakiSpan.emphasis(text: '強調', style: EmphasisStyle.dot)
TategakiSpan.sideways('Hello')  // 横倒し
```

---

## バージョニング

- Semantic Versioning に従う
- 0.x.x: 初期開発フェーズ（破壊的変更あり）
- 1.0.0: 安定版リリース（Novelty での実績を経て）

---

## 開発コマンド

### Workspace 全体

```bash
# 依存関係の取得（ルートで実行）
fvm flutter pub get

# 全パッケージのテスト
fvm flutter test
```

### tategaki パッケージ単体

```bash
# パッケージディレクトリでテスト
cd packages/tategaki
fvm flutter test

# 静的解析
fvm dart analyze
```

---

## ライセンス

MIT License（Novelty プロジェクトと同一）
