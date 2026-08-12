import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/providers/network_fallback_event_provider.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/network_fallback_snackbar.dart';

void main() {
  group('NetworkFallbackSnackbar', () {
    testWidgets('ヘッダーバナーを表示しない', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NetworkFallbackSnackbar(
              child: Scaffold(body: Placeholder()),
            ),
          ),
        ),
      );

      expect(find.text('オフラインモード'), findsNothing);
      expect(find.byIcon(Icons.cloud_off), findsNothing);
    });

    testWidgets('フォールバックイベント発生時にスナックバーを表示する', (tester) async {
      final container = ProviderContainer(
        overrides: [
          settingsProvider.overrideWith(FakeSettings.new),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: NetworkFallbackSnackbar(
              child: Scaffold(body: Placeholder()),
            ),
          ),
        ),
      );

      container
          .read(networkFallbackEventProvider.notifier)
          .emit('通信失敗のテストメッセージ');
      await tester.pumpAndSettle();

      expect(find.text('通信失敗のテストメッセージ'), findsOneWidget);
    });
  });
}

class FakeSettings extends Settings {
  @override
  Future<AppSettings> build() async {
    return const AppSettings(
      fontSize: 16,
      isVertical: false,
      themeMode: ThemeMode.system,
      lineHeight: 1.5,
      isIncognito: false,
      isPageFlip: false,
      isRubyEnabled: true,
    );
  }
}
