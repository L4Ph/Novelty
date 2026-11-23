import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/screens/about_page.dart';

void main() {
  group('AboutPage', () {
    testWidgets('よくある質問が9件表示され、展開すると回答が読める', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutPage()));

      expect(find.text('よくある質問'), findsOneWidget);

      // 画面外は遅延構築されるため、リストをスクロールして全件を数える
      final tiles = find.byType(ExpansionTile);
      await tester.scrollUntilVisible(
        find.text('アプリのインストール・アップデート方法は？'),
        300,
      );
      expect(tiles, findsNWidgets(9));

      await tester.tap(find.text('アプリ内に広告は表示されますか？'));
      await tester.pumpAndSettle();

      expect(find.textContaining('一切表示されません。'), findsOneWidget);
    });
  });
}
