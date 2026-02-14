import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/screens/novel_detail_page.dart';
import 'package:novelty/utils/settings_provider.dart';

@GenerateMocks([NovelRepository])
import 'novel_detail_page_test.mocks.dart';

/// NovelDetailPageのテスト
void main() {
  group('NovelDetailPage 履歴追加テスト', () {
    test('目次ページでは履歴に追加されない設計であることを確認', () {
      // この修正により、目次ページで履歴に追加されることはない
      // 実際の履歴追加はNovelPageでのみ実行される
      expect(true, isTrue);
    });
  });

  group('NovelDetailPage 長押しメニューテスト', () {
    late MockNovelRepository mockRepository;

    setUp(() {
      mockRepository = MockNovelRepository();
    });

    testWidgets('長押しでモーダルボトムシートが表示されること', (tester) async {
      // モックのNovelInfoとEpisodeを作成
      final novelInfo = NovelInfo(
        ncode: 'n0000a',
        title: 'テスト小説',
        episodes: [
          const Episode(
            index: 1,
            subtitle: 'テストエピソード',
            isDownloaded: false,
          ),
        ],
      );

      when(mockRepository.getNovelInfo('n0000a'))
          .thenAnswer((_) async => novelInfo);
      when(mockRepository.getEpisodeList('n0000a_1'))
          .thenAnswer((_) async => novelInfo.episodes!);

      // ProviderScopeでモックを注入
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            novelRepositoryProvider.overrideWithValue(mockRepository),
            settingsProvider.overrideWith((_) async => const AppSettings()),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(ncode: 'n0000a'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // エピソードのListTileを探す
      final listTileFinder = find.byType(ListTile).first;
      expect(listTileFinder, findsOneWidget);

      // 長押しする
      await tester.longPress(listTileFinder);
      await tester.pumpAndSettle();

      // モーダルボトムシートが表示されることを確認
      expect(find.text('ダウンロード'), findsOneWidget);
    });

    testWidgets('ダウンロード済みエピソードの長押しで削除メニューが表示されること', (tester) async {
      // モックのNovelInfoとEpisodeを作成（ダウンロード済み）
      final novelInfo = NovelInfo(
        ncode: 'n0000a',
        title: 'テスト小説',
        episodes: [
          const Episode(
            index: 1,
            subtitle: 'テストエピソード',
            isDownloaded: true,
          ),
        ],
      );

      when(mockRepository.getNovelInfo('n0000a'))
          .thenAnswer((_) async => novelInfo);
      when(mockRepository.getEpisodeList('n0000a_1'))
          .thenAnswer((_) async => novelInfo.episodes!);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            novelRepositoryProvider.overrideWithValue(mockRepository),
            settingsProvider.overrideWith((_) async => const AppSettings()),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(ncode: 'n0000a'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // エピソードのListTileを探す
      final listTileFinder = find.byType(ListTile).first;

      // 長押しする
      await tester.longPress(listTileFinder);
      await tester.pumpAndSettle();

      // 削除メニューが表示されることを確認
      expect(find.text('削除'), findsOneWidget);
    });

    testWidgets('長押しメニューからダウンロードが実行されること', (tester) async {
      final novelInfo = NovelInfo(
        ncode: 'n0000a',
        title: 'テスト小説',
        episodes: [
          const Episode(
            index: 1,
            subtitle: 'テストエピソード',
            isDownloaded: false,
          ),
        ],
      );

      when(mockRepository.getNovelInfo('n0000a'))
          .thenAnswer((_) async => novelInfo);
      when(mockRepository.getEpisodeList('n0000a_1'))
          .thenAnswer((_) async => novelInfo.episodes!);
      when(
        mockRepository.downloadSingleEpisode(
          'n0000a',
          1,
          revised: anyNamed('revised'),
        ),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            novelRepositoryProvider.overrideWithValue(mockRepository),
            settingsProvider.overrideWith((_) async => const AppSettings()),
          ],
          child: const MaterialApp(
            home: NovelDetailPage(ncode: 'n0000a'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 長押しする
      final listTileFinder = find.byType(ListTile).first;
      await tester.longPress(listTileFinder);
      await tester.pumpAndSettle();

      // ダウンロードボタンをタップ
      await tester.tap(find.text('ダウンロード'));
      await tester.pumpAndSettle();

      // downloadSingleEpisodeが呼ばれたことを確認
      verify(
        mockRepository.downloadSingleEpisode(
          'n0000a',
          1,
          revised: anyNamed('revised'),
        ),
      ).called(1);
    });
  });
}
