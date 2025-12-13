import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_list.dart';

import 'novel_list_test.mocks.dart';

@GenerateMocks([AppDatabase, ApiService])
void main() {
  group('NovelList', () {
    late MockAppDatabase mockDatabase;

    setUp(() {
      mockDatabase = MockAppDatabase();
    });

    testWidgets('小説リストを正しく表示する', (WidgetTester tester) async {
      final novels = [
        const NovelInfo(
          ncode: 'n1234ab',
          title: 'テスト小説1',
          writer: 'テスト作者',
          story: 'テストストーリー',
          genre: 101,
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

    testWidgets('長押しでライブラリに追加処理が実行される', (WidgetTester tester) async {
      final novels = [
        const NovelInfo(
          ncode: 'n1234ab',
          title: 'テスト小説1',
          writer: 'テスト作者',
          story: 'テストストーリー',
          genre: 101,
          keyword: 'テスト',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
        ),
      ];

      // モックの設定
      when(mockDatabase.getNovel('n1234ab')).thenAnswer((_) async => null);

      // NovelList calls handleAddToLibrary, which uses novelRepository.
      // But implementation details of handleAddToLibrary might require more mocks.
      // However, if we just check getNovel call which happens in handleAddToLibrary...
      // Wait, handleAddToLibrary calls repository.addNovelToLibrary(ncode), which internally might call getNovel.
      // Or handleAddToLibrary calls isInLibrary -> which might be cached or db.

      // We also need to override novelRepositoryProvider?
      // The original test overrides appDatabaseProvider and checks mockDatabase calls.
      // If handleAddToLibrary interacts with DB, then verify is correct.

      // Note: handleAddToLibrary checks if processing, then calls repo.addNovel.
      // We should check repo.

      // However, the original test logic:
      // when(mockDatabase.getNovel('n1234ab')).thenAnswer((_) async => null);
      // ... verify(mockDatabase.getNovel('n1234ab')).called(1);
      // Wait, where does `getNovel` get called?
      // In `library_callbacks.dart`: `repository.addNovelToLibrary(item.ncode)`.
      // `NovelRepository.addNovelToLibrary` likely calls DB methods.
      // If `novel_repository` is NOT mocked, it uses real repo logic + mocked DB.
      // This seems fine.

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
      await tester.longPress(find.byType(ListTile).first);
      await tester.pump();

      // データベースへのアクセスを確認
      // Note: Implementation details of addNovelToLibrary involves checking existence first.
      verify(mockDatabase.getNovel('n1234ab')).called(1);
    });

    testWidgets('すでにライブラリに登録済みの場合は警告メッセージを表示', (WidgetTester tester) async {
      final novels = [
        const NovelInfo(
          ncode: 'n1234ab',
          title: 'テスト小説1',
          writer: 'テスト作者',
          story: 'テストストーリー',
          genre: 101,
          keyword: 'テスト',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
        ),
      ];

      // 既に登録済みの小説を模擬
      const existingNovel = Novel(
        ncode: 'n1234ab',
        title: 'テスト小説1',
        writer: 'テスト作者',
      );

      when(
        mockDatabase.getNovel('n1234ab'),
      ).thenAnswer((_) async => existingNovel);

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
      await tester.longPress(find.byType(ListTile).first);
      await tester.pump();

      // 警告メッセージが表示されることを確認
      expect(find.text('すでにライブラリに登録されています'), findsOneWidget);
    });
  });
}
