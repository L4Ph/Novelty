import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([SharedPreferences])
// ignore: unused_import
import 'settings_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Settings Provider', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should return default settings when no preferences exist', () async {
      SharedPreferences.setMockInitialValues({});

      final settings = await container.read(settingsProvider.future);

      expect(settings.selectedFont, equals('Noto Sans JP'));
      expect(settings.fontSize, equals(16.0));
    });

    test('should load saved preferences', () async {
      SharedPreferences.setMockInitialValues({
        'selected_font': 'IBM Plex Sans JP',
        'font_size': 18.0,
      });

      final settings = await container.read(settingsProvider.future);

      expect(settings.selectedFont, equals('IBM Plex Sans JP'));
      expect(settings.fontSize, equals(18.0));
    });

    test('should update font setting', () async {
      SharedPreferences.setMockInitialValues({});

      // Wait for initial state to load
      await container.read(settingsProvider.future);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setSelectedFont('M PLUS 1p');

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.selectedFont, equals('M PLUS 1p'));
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
      await settingsNotifier.setIsVertical(true);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.isVertical, isTrue);
    });

    test('should handle invalid font gracefully', () async {
      SharedPreferences.setMockInitialValues({});

      final settingsNotifier = container.read(settingsProvider.notifier);

      // Test that invalid font doesn't crash the app
      expect(
        () => settingsNotifier.setSelectedFont('Invalid Font'),
        returnsNormally,
      );
    });

    test('should generate correct text style for each font', () async {
      const fonts = Settings.availableFonts;

      for (final font in fonts) {
        SharedPreferences.setMockInitialValues({
          'selected_font': font,
        });

        final newContainer = ProviderContainer();
        final settings = await newContainer.read(settingsProvider.future);
        final textStyle = settings.selectedFontTheme;

        expect(textStyle, isA<TextStyle>());
        newContainer.dispose();
      }
    });
  });

  group('AppSettings', () {
    test('should create instance with required parameters', () {
      const settings = AppSettings(
        selectedFont: 'Noto Sans JP',
        fontSize: 16,
        isVertical: false,
        novelDownloadPath: '',
      );

      expect(settings.selectedFont, equals('Noto Sans JP'));
      expect(settings.fontSize, equals(16.0));
      expect(settings.isVertical, isFalse);
    });

    test('should create copy with updated values', () {
      const originalSettings = AppSettings(
        selectedFont: 'Noto Sans JP',
        fontSize: 16,
        isVertical: false,
        novelDownloadPath: '',
      );

      final updatedSettings = originalSettings.copyWith(
        selectedFont: 'IBM Plex Sans JP',
        fontSize: 18,
        isVertical: true,
      );

      expect(updatedSettings.selectedFont, equals('IBM Plex Sans JP'));
      expect(updatedSettings.fontSize, equals(18.0));
      expect(updatedSettings.isVertical, isTrue);
    });

    test('should return correct text style for each font', () {
      const fonts = [
        'IBM Plex Sans JP',
        'M PLUS 1p',
        'M PLUS 1',
        'Murecho',
        'M PLUS 2',
        'Noto Sans JP',
        'Unknown Font',
      ];

      for (final font in fonts) {
        final settings = AppSettings(
          selectedFont: font,
          fontSize: 16,
          isVertical: false,
          novelDownloadPath: '',
        );

        final textStyle = settings.selectedFontTheme;
        expect(textStyle, isA<TextStyle>());
      }
    });
  });
}
