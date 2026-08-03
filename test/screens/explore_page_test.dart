import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/domain/search_state.dart';
import 'package:novelty/screens/explore_page.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExplorePage', () {
    testWidgets('オフラインモード中はオフライン用の画面が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(true),
            searchStateProvider.overrideWithValue(const SearchState()),
            rankingFilterStateProvider(
              NovelSource.narou,
              'd',
            ).overrideWithValue(const RankingFilterState()),
          ],
          child: const MaterialApp(
            home: ExplorePage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('オフラインモード中は検索・ランキングを利用できません'),
        findsOneWidget,
      );
      expect(find.text('ライブラリに戻る'), findsOneWidget);
    });

    testWidgets('オフラインモード中に検索アイコンをタップすると説明が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(true),
            searchStateProvider.overrideWithValue(const SearchState()),
            rankingFilterStateProvider(
              NovelSource.narou,
              'd',
            ).overrideWithValue(const RankingFilterState()),
          ],
          child: const MaterialApp(
            home: ExplorePage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(
          SnackBar,
          'オフラインモード中は検索・ランキングを利用できません',
        ),
        findsOneWidget,
      );
    });

    testWidgets('オフラインモード中にフィルターアイコンをタップすると説明が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(true),
            searchStateProvider.overrideWithValue(const SearchState()),
            rankingFilterStateProvider(
              NovelSource.narou,
              'd',
            ).overrideWithValue(const RankingFilterState()),
          ],
          child: const MaterialApp(
            home: ExplorePage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(
          SnackBar,
          'オフラインモード中は検索・ランキングを利用できません',
        ),
        findsOneWidget,
      );
    });

    testWidgets('プロバイダ切替でランキングタブが切り替わる', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineModeProvider.overrideWithValue(true),
            searchStateProvider.overrideWithValue(const SearchState()),
          ],
          child: const MaterialApp(
            home: ExplorePage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 初期状態はなろう（四半期タブあり）
      expect(find.text('四半期'), findsOneWidget);

      // カクヨムに切り替える
      await tester.tap(find.byType(DropdownButtonFormField<NovelSource?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('カクヨム').last);
      await tester.pumpAndSettle();

      // カクヨムのランキング種別（年間タブ）が表示される
      expect(find.text('年間'), findsOneWidget);
      expect(find.text('四半期'), findsNothing);
    });
  });
}
