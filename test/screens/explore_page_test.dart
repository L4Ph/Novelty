import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/screens/explore_page.dart';

import '../support/test_services.dart';

/// Pumps ExplorePage with the given settings.
Future<void> pumpExplore(WidgetTester tester, {required bool offline}) async {
  final db = AppDatabase.memory();
  addTearDown(db.close);
  await tester.pumpWidget(
    withServices(
      buildTestServices(
        db: db,
        settings: offline ? offlineTestSettings : testSettings,
      ),
      const MaterialApp(home: ExplorePage()),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExplorePage', () {
    testWidgets('オフラインモード中はオフライン用の画面が表示される', (tester) async {
      await pumpExplore(tester, offline: true);

      await tester.pumpAndSettle();

      expect(
        find.text('オフラインモード中は検索・ランキングを利用できません'),
        findsOneWidget,
      );
      expect(find.text('ライブラリに戻る'), findsOneWidget);
    });

    testWidgets('オフラインモード中に検索アイコンをタップすると説明が表示される', (tester) async {
      await pumpExplore(tester, offline: true);

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
      await pumpExplore(tester, offline: true);

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
      await pumpExplore(tester, offline: true);

      await tester.pumpAndSettle();

      // 初期状態はなろう（四半期タブあり）
      expect(find.text('四半期'), findsOneWidget);

      // カクヨムに切り替える
      await tester.tap(find.byKey(const Key('app_bar_source_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('カクヨム').last);
      await tester.pumpAndSettle();

      // カクヨムのランキング種別（年間タブ）が表示される
      expect(find.text('年間'), findsOneWidget);
      expect(find.text('四半期'), findsNothing);
    });
  });
}
