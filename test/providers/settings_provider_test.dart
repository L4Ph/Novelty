import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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

    test(
      'should default to true for isRubyEnabled when no preferences exist',
      () async {
        SharedPreferences.setMockInitialValues({});

        final settings = await container.read(settingsProvider.future);

        expect(settings.isRubyEnabled, equals(true));
      },
    );

    test('should load saved isRubyEnabled preference', () async {
      SharedPreferences.setMockInitialValues({
        'is_ruby_enabled': false,
      });

      final settings = await container.read(settingsProvider.future);

      expect(settings.isRubyEnabled, equals(false));
    });

    test('should update isRubyEnabled setting', () async {
      SharedPreferences.setMockInitialValues({});

      await container.read(settingsProvider.future);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: false);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.isRubyEnabled, isFalse);
    });

    test('should persist isRubyEnabled to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});

      await container.read(settingsProvider.future);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: false);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_ruby_enabled'), equals(false));
    });

    test('setIsRubyEnabled(true)でlineHeight<1.3なら自動的に1.3に調整', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 1.0,
      });

      await container.read(settingsProvider.future);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: true);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.isRubyEnabled, isTrue);
      expect(settings.lineHeight, equals(1.3));
    });

    test('setIsRubyEnabled(true)でlineHeight>=1.3なら値を保持', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 1.5,
      });

      await container.read(settingsProvider.future);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: true);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.isRubyEnabled, isTrue);
      expect(settings.lineHeight, equals(1.5));
    });

    test('setIsRubyEnabled(false)でlineHeightはそのまま保持', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 1.0,
      });

      await container.read(settingsProvider.future);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: false);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.isRubyEnabled, isFalse);
      expect(settings.lineHeight, equals(1.0));
    });

    test('自動調整後のlineHeightがSharedPreferencesに永続化される', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 1.0,
      });

      await container.read(settingsProvider.future);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('line_height'), equals(1.3));
      expect(prefs.getBool('is_ruby_enabled'), equals(true));
    });

    test('setIsRubyEnabled(true)でlineHeight=1.3の場合、値を保持する', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 1.3,
      });

      await container.read(settingsProvider.future);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: true);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.isRubyEnabled, isTrue);
      expect(settings.lineHeight, equals(1.3));
    });

    test('setIsRubyEnabled(true)でlineHeight<1.0の極端な値でも1.3に調整される', () async {
      SharedPreferences.setMockInitialValues({
        'line_height': 0.5,
      });

      await container.read(settingsProvider.future);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: true);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.isRubyEnabled, isTrue);
      expect(settings.lineHeight, equals(1.3));
    });
  });

  group('AppSettings', () {
    test('should create instance with required parameters', () {
      const settings = AppSettings(
        fontSize: 16,
        isVertical: false,
        themeMode: ThemeMode.system,
        lineHeight: 1.5,
        fontFamily: 'NotoSansJP',
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
        fontFamily: 'NotoSansJP',
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
        fontFamily: 'NotoSansJP',
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
        fontFamily: 'NotoSansJP',
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
