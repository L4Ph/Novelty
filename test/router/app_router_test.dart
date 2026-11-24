// Sequential calls on the router read better than cascades in these tests.
// ignore_for_file: cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/sites/novel_source.dart';

void main() {
  late AppRouter router;

  setUp(() => router = AppRouter());
  tearDown(() => router.dispose());

  group('AppRouter', () {
    test('starts at the library tab with every branch at its root', () {
      expect(router.selected, AppTab.library);
      expect(router.stackOf(AppTab.library).entries, [const LibraryDest()]);
      expect(router.stackOf(AppTab.more).entries, [const MoreDest()]);
      expect(router.overlays.entries, isEmpty);
    });

    test('push stays inside the current tab', () {
      router.push(const AppearanceSettingsDest());

      expect(router.stackOf(AppTab.library).entries, [
        const LibraryDest(),
        const AppearanceSettingsDest(),
      ]);
      expect(router.overlays.entries, isEmpty);
    });

    test('pushOverlay leaves every tab untouched', () {
      router.pushOverlay(
        const NovelDetailDest(source: NovelSource.narou, workId: 'n1'),
      );

      expect(router.overlays.entries, [
        const NovelDetailDest(source: NovelSource.narou, workId: 'n1'),
      ]);
      for (final tab in AppTab.values) {
        expect(router.stackOf(tab).length, 1);
      }
    });

    test('pop takes the overlays before the tab stack', () {
      router
        ..push(const AppearanceSettingsDest())
        ..pushOverlay(
          const NovelDetailDest(source: NovelSource.narou, workId: 'n1'),
        );

      expect(router.pop(), isTrue);
      expect(router.overlays.entries, isEmpty);
      expect(router.stackOf(AppTab.library).length, 2);

      expect(router.pop(), isTrue);
      expect(router.stackOf(AppTab.library).entries, [const LibraryDest()]);

      expect(router.pop(), isFalse);
    });

    test('selecting the current tab returns it to its root', () {
      router
        ..push(const AppearanceSettingsDest())
        ..select(AppTab.library);

      expect(router.stackOf(AppTab.library).entries, [const LibraryDest()]);
    });

    test('switching tabs keeps the stacks of other tabs', () {
      router.push(const AppearanceSettingsDest());

      router.select(AppTab.more);
      expect(router.selected, AppTab.more);
      expect(router.stackOf(AppTab.more).entries, [const MoreDest()]);

      router.select(AppTab.library);
      expect(router.stackOf(AppTab.library).entries, [
        const LibraryDest(),
        const AppearanceSettingsDest(),
      ]);
    });

    test('reset returns every stack and the tab to the start', () {
      router
        ..select(AppTab.more)
        ..push(const DownloadsDest())
        ..pushOverlay(
          const NovelDetailDest(source: NovelSource.narou, workId: 'n1'),
        )
        ..reset();

      expect(router.selected, AppTab.library);
      expect(router.overlays.entries, isEmpty);
      for (final tab in AppTab.values) {
        expect(router.stackOf(tab).length, 1);
      }
    });

    test('notifies on tab change and on stack change', () {
      var notified = 0;
      router.addListener(() => notified++);

      router.select(AppTab.history);
      router.push(const AppearanceSettingsDest());
      router.pushOverlay(const AboutDest());
      router.pop();

      expect(notified, 4);
    });
  });
}
