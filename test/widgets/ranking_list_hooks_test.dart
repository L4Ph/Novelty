import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/providers/enriched_novel_provider.dart';
import 'package:novelty/widgets/ranking_list.dart';
void main() {
  group('RankingList HookConsumerWidget Tests', () {
    testWidgets('should be a HookConsumerWidget and render successfully', (WidgetTester tester) async {
      // ダミーデータの準備
      final testEnrichedNovel = EnrichedNovelData(
        novel: const RankingResponse(
          rank: 1,
          pt: 100,
          ncode: 'n1111a',
          title: 'Test Novel 1',
          writer: 'Test Writer 1',
          story: 'Story 1',
          genre: 1,
          keyword: 'keyword1',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
          allPoint: 200,
        ),
        isInLibrary: false,
      );

      // ウィジェットをテスト
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            enrichedRankingDataProvider('test').overrideWith(
              (ref) async => [testEnrichedNovel],
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(rankingType: 'test'),
            ),
          ),
        ),
      );

      // ローディング状態からデータ読み込み完了まで待機
      await tester.pumpAndSettle();

      // ウィジェットが正常に描画されることを確認
      expect(find.byType(RankingList), findsOneWidget);
      
      // HookConsumerWidgetとして機能していることを確認
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should handle empty data gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            enrichedRankingDataProvider('test').overrideWith(
              (ref) async => <EnrichedNovelData>[],
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(rankingType: 'test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 空のリストでもクラッシュしないことを確認
      expect(find.byType(RankingList), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should show error message on error', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            enrichedRankingDataProvider('test').overrideWith(
              (ref) async => throw Exception('Test error'),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: RankingList(rankingType: 'test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // エラーメッセージを確認
      expect(find.textContaining('エラーが発生しました'), findsOneWidget);
    });
  });
}