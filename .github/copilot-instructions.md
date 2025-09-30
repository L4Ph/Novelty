# 言語
コミットメッセージ、Pull Requestの説明、タイトル、ドキュメント類、実装のコメント、あなたの考えはすべて日本語で記述、実施してください。

# プロジェクト概要

Noveltyは「小説家になろう」のクロスプラットフォーム小説ビューアーです。以下の技術スタックを使用しています：

- **Framework**: Flutter 3.8.1+ with Dart
- **State Management**: Riverpod (flutter_riverpod, hooks_riverpod)
- **Routing**: GoRouter
- **Database**: Drift (SQLite)
- **API Client**: Dio
- **Code Generation**: build_runner (freezed, json_annotation)
- **Testing**: flutter_test, mockito
- **Version Management**: FVM

# アーキテクチャ

プロジェクトは以下のディレクトリ構造で整理されています：

- `lib/database/` - Drift データベース関連
- `lib/models/` - データモデル (Freezed使用)
- `lib/providers/` - Riverpodプロバイダー
- `lib/repositories/` - データアクセス層
- `lib/screens/` - UI画面
- `lib/services/` - ビジネスロジック
- `lib/widgets/` - 再利用可能コンポーネント
- `lib/utils/` - ユーティリティ関数
- `docs/` - APIドキュメント

# 開発原則

## コード品質
- `very_good_analysis` パッケージのルールセット適用
- `custom_lint` プラグインによる追加チェック
- 1行の文字数制限は緩やか（80文字以上を許容）
- 生成ファイル（`*.g.dart`, `*.freezed.dart`）やモック（`**.mocks.dart`）は静的解析の対象外

## テスト駆動開発
- 新機能はテストファーストで実装
- テスト名は動作を明確に表現（日本語推奨）
- モックは`mockito`を使用し、必要なスタブを適切に設定
- コード変更後は必ずテストを実行

# 開発ワークフロー

## 必須コマンド

### 依存関係のインストール
```bash
fvm flutter pub get
```

### 静的解析（Linter）
コードの品質チェック。info レベルは必要に応じて修正：
```bash
fvm dart analyze
```

### コード生成
モデルやDIコンテナ更新後に実行：
```bash
fvm dart run build_runner build -d
```

### テスト実行
```bash
fvm flutter test
```

### アプリケーション実行
```bash
fvm flutter run
```

## Riverpod パターン

### プロバイダー作成
```dart
// StateNotifierProvider の場合
final exampleProvider = StateNotifierProvider<ExampleNotifier, ExampleState>((ref) {
  return ExampleNotifier();
});

// FutureProvider の場合  
final dataProvider = FutureProvider<Data>((ref) async {
  return await ref.read(repositoryProvider).fetchData();
});
```

### HookWidget でのプロバイダー使用
```dart
class ExampleWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exampleProvider);
    // HookWidgetの場合、useStateやuseMemoizedが使用可能
    return Container();
  }
}
```

## データモデル

### Freezed クラスの基本形
```dart
@freezed
class ExampleModel with _$ExampleModel {
  const factory ExampleModel({
    required String id,
    required String title,
    @Default([]) List<String> tags,
  }) = _ExampleModel;
  
  factory ExampleModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleModelFromJson(json);
}
```

## 重要なコーディング規約

### public_member_api_docs 対応
公開API（ライブラリの外部から使用されるクラス・メソッド）には必ずドキュメントコメントを追加：

```dart
/// ユーザー情報を管理するクラス
class UserManager {
  /// ユーザーIDから詳細情報を取得する
  Future<User> fetchUser(String userId) async {
    // 実装
  }
}
```

### 非同期処理のベストプラクティス
- 戻り値を使わないFuture呼び出しには `unawaited` を使用
- discarded_futures 警告の対応例：
```dart
import 'dart:async';

void example() {
  // NG
  someFuture();
  
  // OK
  unawaited(someFuture());
  
  // または
  someFuture().ignore();
}
```

# プロジェクト固有の情報

## データベース（Drift）

### テーブル定義の例
```dart
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### DAO パターン
```dart
@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);
  
  Future<User> findUserById(int id) =>
      (select(users)..where((u) => u.id.equals(id))).getSingle();
}
```

## APIドキュメント

### なろう小説のHTML構造
- [作品トップページ（{ncode}）](../docs/narou_html/{ncode}.md)
- [話別ページ（{ncode}/{episodes}）](../docs/narou_html/{ncode}/{episodes}.md)

### なろう小説API
- [小説情報API](../docs/narou_api/novel_api.md)
- [ランキングAPI](../docs/narou_api/ranking_api.md)

## テスト戦略

### ウィジェットテストのパターン
```dart
testWidgets('ウィジェットの動作説明', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: YourWidget(),
      ),
    ),
  );
  
  expect(find.text('期待するテキスト'), findsOneWidget);
});
```

### Mockito の使用
```dart
@GenerateMocks([Repository])
void main() {
  group('ServiceTest', () {
    late MockRepository mockRepo;
    
    setUp(() {
      mockRepo = MockRepository();
    });
    
    test('メソッドの動作説明', () {
      when(mockRepo.getData()).thenAnswer((_) async => testData);
      // テスト実装
    });
  });
}
```

# コミットとPR

## コミットメッセージ規約
- 機能追加: `✨ 新機能の説明`
- バグ修正: `🐛 修正内容の説明`
- ドキュメント: `📄 ドキュメント更新の説明`
- リファクタリング: `♻️ リファクタリング内容の説明`
- テスト: `✅ テスト内容の説明`
- 設定変更: `🔧 設定変更の説明`

## 変更前チェックリスト
1. `fvm dart analyze` でlintエラーなし
2. `fvm flutter test` で全テスト通過
3. 新機能にはテスト追加
4. 公開APIにドキュメントコメント追加
5. コード生成が必要な場合は `fvm dart run build_runner build -d` 実行済み