import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([SharedPreferences])
// Mockitoによって生成されたモックファイルのimportを無視
// ignore: unused_import
import 'settings_provider_test.mocks.dart';

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

  group('Settings Provider', () {
    late ProviderContainer container;

    setUp(() {
      // path_providerのモック設定
      PathProviderPlatform.instance = FakePathProviderPlatform();
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should return default settings when no preferences exist', () async {
      SharedPreferences.setMockInitialValues({});

      final settings = await container.read(settingsProvider.future);

      expect(settings.fontSize, equals(16.0));
      expect(settings.isVertical, equals(false));
    });

    test('should load saved preferences', () async {
      SharedPreferences.setMockInitialValues({
        'font_size': 18.0,
        'is_vertical': true,
      });

      final settings = await container.read(settingsProvider.future);

      expect(settings.fontSize, equals(18.0));
      expect(settings.isVertical, equals(true));
    });

    test('should update font size setting', () async {
      SharedPreferences.setMockInitialValues({});

      // Wait for initial state to load
      await container.read(settingsProvider.future);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setFontSize(20);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.fontSize, equals(20.0));
    });

    test('should update isVertical setting', () async {
      SharedPreferences.setMockInitialValues({});

      // Wait for initial state to load
      await container.read(settingsProvider.future);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setIsVertical(isVertical: true);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.isVertical, isTrue);
    });
  });

  group('AppSettings', () {
    test('should create instance with required parameters', () {
      const settings = AppSettings(
        fontSize: 16,
        isVertical: false,
        novelDownloadPath: '',
      );

      expect(settings.fontSize, equals(16.0));
      expect(settings.isVertical, isFalse);
    });

    test('should create copy with updated values', () {
      const originalSettings = AppSettings(
        fontSize: 16,
        isVertical: false,
        novelDownloadPath: '',
      );

      final updatedSettings = originalSettings.copyWith(
        fontSize: 18,
        isVertical: true,
      );

      expect(updatedSettings.fontSize, equals(18.0));
      expect(updatedSettings.isVertical, isTrue);
    });
  });
}
