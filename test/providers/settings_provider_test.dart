import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/repositories/preferences_repository.dart';
import 'package:novelty/utils/settings_provider.dart';
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

  group('Settings Provider', () {
    late SettingsController settings;

    setUp(() {
      // path_providerのモック設定
      PathProviderPlatform.instance = FakePathProviderPlatform();
      SharedPreferences.setMockInitialValues({});
      settings = SettingsController(PreferencesRepository());
    });

    tearDown(() {
      settings.dispose();
    });

    test('should return default settings when no preferences exist', () async {
      SharedPreferences.setMockInitialValues({});

      await settings.load();

      expect(settings.value!.fontSize, equals(16.0));
      expect(settings.value!.isVertical, equals(false));
    });

    test('should load saved preferences', () async {
      SharedPreferences.setMockInitialValues({
        'font_size': 18.0,
        'is_vertical': true,
      });

      await settings.load();

      expect(settings.value!.fontSize, equals(18.0));
      expect(settings.value!.isVertical, equals(true));
    });

    test('should update font size setting', () async {
      SharedPreferences.setMockInitialValues({});

      // Wait for initial state to load
      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setFontSize(20);

      final asyncValue = settings.state;
      expect(asyncValue.valueOrNull != null, isTrue);
      final values = asyncValue.valueOrNull!;
      expect(values.fontSize, equals(20.0));
    });

    test('should update isVertical setting', () async {
      SharedPreferences.setMockInitialValues({});

      // Wait for initial state to load
      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setIsVertical(isVertical: true);

      final asyncValue = settings.state;
      expect(asyncValue.valueOrNull != null, isTrue);
      final values = asyncValue.valueOrNull!;
      expect(values.isVertical, isTrue);
    });

    test(
      'should default to true for isRubyEnabled when no preferences exist',
      () async {
        SharedPreferences.setMockInitialValues({});

        await settings.load();

        expect(settings.value!.isRubyEnabled, equals(true));
      },
    );

    test('should load saved isRubyEnabled preference', () async {
      SharedPreferences.setMockInitialValues({
        'is_ruby_enabled': false,
      });

      await settings.load();

      expect(settings.value!.isRubyEnabled, equals(false));
    });

    test(
      'should default to false for isOfflineMode when no preferences exist',
      () async {
        SharedPreferences.setMockInitialValues({});

        await settings.load();

        expect(settings.value!.isOfflineMode, equals(false));
      },
    );

    test('should load saved isOfflineMode preference', () async {
      SharedPreferences.setMockInitialValues({
        'is_offline_mode': true,
      });

      await settings.load();

      expect(settings.value!.isOfflineMode, equals(true));
    });

    test('should update isOfflineMode setting', () async {
      SharedPreferences.setMockInitialValues({});

      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setIsOfflineMode(isOfflineMode: true);

      final asyncValue = settings.state;
      expect(asyncValue.valueOrNull != null, isTrue);
      final values = asyncValue.valueOrNull!;
      expect(values.isOfflineMode, isTrue);
    });

    test('should persist isOfflineMode to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});

      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setIsOfflineMode(isOfflineMode: true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_offline_mode'), equals(true));
    });

    test('isOfflineMode is false before the settings are loaded', () async {
      SharedPreferences.setMockInitialValues({});

      expect(settings.isOfflineMode, isFalse);
    });

    test('isOfflineMode is true when offline mode is enabled', () async {
      SharedPreferences.setMockInitialValues({'is_offline_mode': true});

      await settings.load();

      expect(settings.isOfflineMode, isTrue);
    });

    test('should update isRubyEnabled setting', () async {
      SharedPreferences.setMockInitialValues({});

      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: false);

      final asyncValue = settings.state;
      expect(asyncValue.valueOrNull != null, isTrue);
      final values = asyncValue.valueOrNull!;
      expect(values.isRubyEnabled, isFalse);
    });

    test('should persist isRubyEnabled to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});

      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: false);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_ruby_enabled'), equals(false));
    });

    test('setIsRubyEnabled(true)でlineHeight<1.3なら自動的に1.3に調整', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 1.0,
      });

      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: true);

      final asyncValue = settings.state;
      expect(asyncValue.valueOrNull != null, isTrue);
      final values = asyncValue.valueOrNull!;
      expect(values.isRubyEnabled, isTrue);
      expect(values.lineHeight, equals(1.3));
    });

    test('setIsRubyEnabled(true)でlineHeight>=1.3なら値を保持', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 1.5,
      });

      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: true);

      final asyncValue = settings.state;
      expect(asyncValue.valueOrNull != null, isTrue);
      final values = asyncValue.valueOrNull!;
      expect(values.isRubyEnabled, isTrue);
      expect(values.lineHeight, equals(1.5));
    });

    test('setIsRubyEnabled(false)でlineHeightはそのまま保持', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 1.0,
      });

      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: false);

      final asyncValue = settings.state;
      expect(asyncValue.valueOrNull != null, isTrue);
      final values = asyncValue.valueOrNull!;
      expect(values.isRubyEnabled, isFalse);
      expect(values.lineHeight, equals(1.0));
    });

    test('自動調整後のlineHeightがSharedPreferencesに永続化される', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 1.0,
      });

      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('line_height'), equals(1.3));
      expect(prefs.getBool('is_ruby_enabled'), equals(true));
    });

    test('setIsRubyEnabled(true)でlineHeight=1.3の場合、値を保持する', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 1.3,
      });

      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: true);

      final asyncValue = settings.state;
      expect(asyncValue.valueOrNull != null, isTrue);
      final values = asyncValue.valueOrNull!;
      expect(values.isRubyEnabled, isTrue);
      expect(values.lineHeight, equals(1.3));
    });

    test('setIsRubyEnabled(true)でlineHeight<1.0の極端な値でも1.3に調整される', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 0.5,
      });

      await settings.load();

      final settingsNotifier = settings;
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: true);

      final asyncValue = settings.state;
      expect(asyncValue.valueOrNull != null, isTrue);
      final values = asyncValue.valueOrNull!;
      expect(values.isRubyEnabled, isTrue);
      expect(values.lineHeight, equals(1.3));
    });
  });

  group('AppSettings', () {
    test('should create instance with required parameters', () {
      const settings = AppSettings(
        fontSize: 16,
        isVertical: false,
        themeMode: ThemeMode.system,
        lineHeight: 1.5,
        isIncognito: false,
        isPageFlip: false,
        isRubyEnabled: true,
      );

      expect(settings.fontSize, equals(16.0));
      expect(settings.isVertical, isFalse);
      expect(settings.isRubyEnabled, isTrue);
    });

    test('should create copy with updated values', () {
      const originalSettings = AppSettings(
        fontSize: 16,
        isVertical: false,
        themeMode: ThemeMode.system,
        lineHeight: 1.5,
        isIncognito: false,
        isPageFlip: false,
        isRubyEnabled: true,
      );

      final updatedSettings = originalSettings.copyWith(
        fontSize: 18,
        isVertical: true,
      );

      expect(updatedSettings.fontSize, equals(18.0));
      expect(updatedSettings.isVertical, isTrue);
      expect(updatedSettings.isRubyEnabled, isTrue);
    });

    test('should create instance with isRubyEnabled parameter', () {
      const settings = AppSettings(
        fontSize: 16,
        isVertical: false,
        themeMode: ThemeMode.system,
        lineHeight: 1.5,
        isIncognito: false,
        isPageFlip: false,
        isRubyEnabled: false,
      );

      expect(settings.isRubyEnabled, isFalse);
    });

    test('should copy with updated isRubyEnabled value', () {
      const originalSettings = AppSettings(
        fontSize: 16,
        isVertical: false,
        themeMode: ThemeMode.system,
        lineHeight: 1.5,
        isIncognito: false,
        isPageFlip: false,
        isRubyEnabled: true,
      );

      final updatedSettings = originalSettings.copyWith(
        isRubyEnabled: false,
      );

      expect(updatedSettings.isRubyEnabled, isFalse);
      // 他のフィールドは変更されないことを確認
      expect(updatedSettings.fontSize, equals(16.0));
      expect(updatedSettings.isVertical, isFalse);
    });
  });
}
