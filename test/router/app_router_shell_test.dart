import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database_providers.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/screens/about_page.dart';

void main() {
  setUp(appRouter.reset);

  testWidgets('the shell shows the tab bar and an overlay covers it', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          libraryNovelsProvider.overrideWith(
            (ref) => Stream.value(<dynamic>[]),
          ),
        ],
        child: MaterialApp.router(routerConfig: appRouterConfig),
      ),
    );
    // The library tab keeps a progress indicator spinning, so settling would
    // never return; a couple of frames is enough.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(appRouter.overlays.entries, isEmpty);

    appRouter.pushOverlay(const AboutDest());
    await _pumpTransition(tester);

    expect(find.byType(AboutPage), findsOneWidget);
    expect(appRouter.overlays.entries, [const AboutDest()]);

    appRouter.pop();
    await _pumpTransition(tester);

    expect(find.byType(AboutPage), findsNothing);
    expect(appRouter.overlays.entries, isEmpty);
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Unmount so providers release whatever they scheduled.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 10));
  });
}

Future<void> _pumpTransition(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
