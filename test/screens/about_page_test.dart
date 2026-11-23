import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/screens/about_page.dart';

void main() {
  group('AboutPage', () {
    testWidgets('ベータ版の導線とFAQの末尾まで到達でき、回答を展開できる', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutPage()));

      expect(find.text('ベータ版に参加（Google Play）'), findsOneWidget);
      expect(find.text('ベータ版のGoogleグループ'), findsOneWidget);

      // 画面外は遅延構築されるため、リストをスクロールしながら確認する
      await tester.scrollUntilVisible(find.text('よくある質問'), 300);
      expect(find.text('よくある質問'), findsOneWidget);

      // ビューポート次第で未構築の項目があるため、件数ではなく
      // 「末尾まで到達でき、回答を展開できる」ことを検証する
      await tester.scrollUntilVisible(
        find.text('アプリのインストール・アップデート方法は？'),
        300,
      );

      await tester.scrollUntilVisible(
        find.text('アプリ内に広告は表示されますか？'),
        -300,
      );
      await tester.tap(find.text('アプリ内に広告は表示されますか？'));
      await tester.pumpAndSettle();

      expect(find.textContaining('一切表示されません。'), findsOneWidget);
    });
  });
}
