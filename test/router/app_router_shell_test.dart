import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/screens/about_page.dart';

import '../support/test_services.dart';

void main() {
  setUp(appRouter.reset);

  testWidgets('the shell shows the tab bar and an overlay covers it', (
    tester,
  ) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await tester.pumpWidget(
      withServices(
        buildTestServices(db: db),
        MaterialApp.router(routerConfig: appRouterConfig),
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

    // The system back has to reach the router through the dispatcher; without
    // one the press would leave the app instead of popping.
    expect(await tester.binding.handlePopRoute(), isTrue);
    await _pumpTransition(tester);

    expect(find.byType(AboutPage), findsNothing);
    expect(appRouter.overlays.entries, isEmpty);
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // A page pushed inside the tab pops the same way.
    appRouter.push(const AppearanceSettingsDest());
    await _pumpTransition(tester);
    expect(appRouter.stackOf(AppTab.library).length, 2);

    expect(await tester.binding.handlePopRoute(), isTrue);
    await _pumpTransition(tester);
    expect(appRouter.stackOf(AppTab.library).entries, [const LibraryDest()]);

    // At the tab root there is nothing left to pop, so the OS gets the press.
    expect(await tester.binding.handlePopRoute(), isFalse);

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
