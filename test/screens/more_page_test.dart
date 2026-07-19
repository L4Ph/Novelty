import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/screens/more_page.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// path_providerのモック実装
class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '/mock/documents';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    // 他のテストへの状態漏れを防ぐため、モックSharedPreferencesをリセットする
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('オフラインモードスイッチが表示される', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MorePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('オフラインモード'), findsOneWidget);
    expect(find.text('通信を行わず、保存済みのコンテンツのみ利用します'), findsOneWidget);
  });

  testWidgets('オフラインモードスイッチを切り替えると設定が永続化される', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MorePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // オフラインモードのSwitchListTileを明示的に指定
    final switchListTile = find.widgetWithText(SwitchListTile, 'オフラインモード');
    expect(switchListTile, findsOneWidget);

    await tester.tap(switchListTile);
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('is_offline_mode'), isTrue);
  });
}
