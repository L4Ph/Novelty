import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/novel_content.dart';
import 'package:tategaki/tategaki.dart';

// Helper to create settings
const pagedSettings = AppSettings(
  isVertical: true,
  fontSize: 16,
  themeMode: ThemeMode.system,
  lineHeight: 1.5,
  fontFamily: 'NotoSansJP',
  isIncognito: false,
  isPageFlip: true,
);

void main() {
  testWidgets(
    'NovelContentBody uses unique keys for TategakiTextPaged across episodes',
    (tester) async {
      final testContent = <NovelContentElement>[
        NovelContentElement.plainText('Text 1'),
      ];

      // Build with Episode 1
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelContentBody(
              ncode: 'n1234',
              episode: 1,
              content: AsyncData(testContent),
              settings: AsyncData(pagedSettings),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final finder1 = find.byType(TategakiTextPaged);
      expect(finder1, findsOneWidget);
      final widget1 = tester.widget(finder1);
      final key1 = widget1.key;

      // Build with Episode 2
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelContentBody(
              ncode: 'n1234',
              episode: 2,
              content: AsyncData(testContent),
              settings: AsyncData(pagedSettings),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final finder2 = find.byType(TategakiTextPaged);
      expect(finder2, findsOneWidget);
      final widget2 = tester.widget(finder2);
      final key2 = widget2.key;

      // Keys should be different
      expect(key1, isNotNull);
      expect(key2, isNotNull);
      expect(key1, isNot(equals(key2)));
    },
  );
}
