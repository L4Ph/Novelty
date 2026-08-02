import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/widgets/novel_list.dart';

import 'novel_list_test.mocks.dart';

@GenerateMocks([AppDatabase, ApiService])
void main() {
  group('NovelList', () {
    late MockAppDatabase mockDatabase;

    setUp(() {
      mockDatabase = MockAppDatabase();
    });

    testWidgets('小説リストを正しく表示する', (tester) async {
      final novels = [
        const NovelInfo(
          ncode: 'n1234ab',
          title: 'テスト小説1',
          writer: 'テスト作者',
          story: 'テストストーリー',
          genreId: '101',
          keyword: 'テスト',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(mockDatabase),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: NovelList(novels: novels),
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('テスト小説1'), findsOneWidget);
    });

    testWidgets('長押しでライブラリに追加処理が実行される', (tester) async {
      final novels = [
        const NovelInfo(
          ncode: 'n1234ab',
          title: 'テスト小説1',
          writer: 'テスト作者',
          story: 'テストストーリー',
          genreId: '101',
          keyword: 'テスト',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
        ),
      ];

      // モックの設定
      // addNovelToLibrary は、まず isInLibrary で登録済みかどうかを確認する。
      when(
        mockDatabase.isInLibrary(NovelSource.narou, 'n1234ab'),
      ).thenAnswer((_) async => false);

      // NovelList は handleAddToLibrary を呼び出し、novelRepository を使用する。
      // ただし handleAddToLibrary の実装詳細はより多くのモックを必要とする場合がある。
      // しかし、handleAddToLibrary 内で発生する DB 呼び出しを確認すれば十分。
      // handleAddToLibrary は repository.addNovelToLibrary(ncode) を呼び、
      // 内部で isInLibrary を呼び出す。
      // novelRepositoryProvider の override も必要か?
      // 元のテストは appDatabaseProvider を override して
      // mockDatabase の呼び出しを確認していた。
      // handleAddToLibrary が DB とやり取りする場合、verify が正しい。

      // handleAddToLibrary は処理中チェックを行い、その後 repo.addNovel を呼ぶ。

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(mockDatabase),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: NovelList(novels: novels),
            ),
          ),
        ),
      );

      // 最初の小説タイルを長押し
      await tester.longPress(find.byType(InkWell).first);
      await tester.pump();

      // データベースへのアクセスを確認
      // addNovelToLibrary の実装は存在確認を最初に行う。
      verify(mockDatabase.isInLibrary(NovelSource.narou, 'n1234ab')).called(1);
    });

    testWidgets('すでにライブラリに登録済みの場合は警告メッセージを表示', (tester) async {
      final novels = [
        const NovelInfo(
          ncode: 'n1234ab',
          title: 'テスト小説1',
          writer: 'テスト作者',
          story: 'テストストーリー',
          genreId: '101',
          keyword: 'テスト',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
        ),
      ];

      // 既に登録済みの小説を模擬
      when(
        mockDatabase.isInLibrary(NovelSource.narou, 'n1234ab'),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(mockDatabase),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: NovelList(novels: novels),
            ),
          ),
        ),
      );

      // 最初の小説タイルを長押し
      await tester.longPress(find.byType(InkWell).first);
      await tester.pump();

      // 警告メッセージが表示されることを確認
      expect(find.text('すでにライブラリに登録されています'), findsOneWidget);
    });
  });
}
