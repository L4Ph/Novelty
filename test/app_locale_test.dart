import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/main.dart';

void main() {
  testWidgets('プラットフォームロケールがen_USでもja_JPに解決されること', (tester) async {
    // プラットフォームのロケールをen_USに設定する。
    TestWidgetsFlutterBinding.ensureInitialized()
        .platformDispatcher
        .localeTestValue = const Locale(
      'en',
      'US',
    );
    addTearDown(() {
      TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher
          .clearLocaleTestValue();
    });

    late Locale resolvedLocale;
    await tester.pumpWidget(
      MaterialApp(
        locale: appLocale,
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

  testWidgets('MyAppのMaterialAppにロケール設定が適用されていること', (tester) async {
    // データベース初期化をローディング状態に固定し、
    // スプラッシュ表示用のMaterialAppを検証する。
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('ja', 'JP'));
    expect(app.supportedLocales, appSupportedLocales);
    expect(app.localizationsDelegates, appLocalizationsDelegates);
  });
}
