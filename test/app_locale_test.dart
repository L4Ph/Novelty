import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/main.dart';

void main() {
  testWidgets('プラットフォームロケールがen_USでもja_JPに解決されること', (tester) async {
    // プラットフォームのロケールをen_USに設定する。
    TestWidgetsFlutterBinding.ensureInitialized()
        .platformDispatcher
        .localeTestValue = const Locale('en', 'US');
    addTearDown(() {
      TestWidgetsFlutterBinding.ensureInitialized()
          .platformDispatcher
          .clearLocaleTestValue();
    });

    late Locale resolvedLocale;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja', 'JP'),
        supportedLocales: appSupportedLocales,
        localizationsDelegates: appLocalizationsDelegates,
        home: Builder(
          builder: (context) {
            resolvedLocale = Localizations.localeOf(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(resolvedLocale, const Locale('ja', 'JP'));
  });
}
