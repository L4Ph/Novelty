import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'novel_list_test.mocks.dart';

@GenerateMocks([AppDatabase, ApiService])
void main() {
  group('NovelList', () {
    late MockAppDatabase mockDatabase;
    late MockApiService mockApiService;

    setUp(() {
      mockDatabase = MockAppDatabase();
      mockApiService = MockApiService();
    });

    testWidgets('小説リストを正しく表示する', (WidgetTester tester) async {
      final novels = [
        const RankingResponse(
          ncode: 'n1234ab',
          title: 'テスト小説1',
          writer: 'テスト作者',
          story: 'テストストーリー',
          genre: 101,
          keyword: 'テスト',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
          rank: 1,
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
        const RankingResponse(
          ncode: 'n1234ab',
          title: 'テスト小説1',
          writer: 'テスト作者',
          story: 'テストストーリー',
          genre: 101,
          keyword: 'テスト',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
          rank: 1,
        ),
      ];

      final mockNovelInfo = NovelInfo(
        title: 'テスト小説1',
        ncode: 'n1234ab',
        writer: 'テスト作者',
        story: 'テストストーリー',
        genre: 101,
        keyword: 'テスト',
        novelType: 1,
        end: 0,
        generalAllNo: 10,
      );

      // モックの設定
      when(mockDatabase.getNovel('n1234ab')).thenAnswer((_) async => null);
      
      // Create a mock for ApiService and inject it directly
      final mockApiServiceInstance = MockApiService();
      when(mockApiServiceInstance.fetchNovelInfo('n1234ab'))
          .thenAnswer((_) async => mockNovelInfo);

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

      // データベースのgetNovelが呼ばれることを確認
      verify(mockDatabase.getNovel('n1234ab')).called(1);
    });

    testWidgets('すでにライブラリに登録済みの場合は警告メッセージを表示', (WidgetTester tester) async {
      final novels = [
        const RankingResponse(
          ncode: 'n1234ab',
          title: 'テスト小説1',
          writer: 'テスト作者',
          story: 'テストストーリー',
          genre: 101,
          keyword: 'テスト',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
          rank: 1,
        ),
      ];

      // 既に登録済みの小説を模擬
      final existingNovel = Novel(
        ncode: 'n1234ab',
        title: 'テスト小説1',
        writer: 'テスト作者',
      );

      when(mockDatabase.getNovel('n1234ab')).thenAnswer((_) async => existingNovel);

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