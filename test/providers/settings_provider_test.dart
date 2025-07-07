import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([SharedPreferences])
import 'settings_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Settings Provider', () {
    late MockSharedPreferences mockPrefs;
    late ProviderContainer container;

    setUp(() {
      mockPrefs = MockSharedPreferences();
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
      expect(settings.seedColor.value, equals(Colors.blue.value));
    });

    test('should load saved preferences', () async {
      SharedPreferences.setMockInitialValues({
        'selected_font': 'IBM Plex Sans JP',
        'font_size': 18.0,
        'seed_color': Colors.red.value,
      });

      final settings = await container.read(settingsProvider.future);

      expect(settings.selectedFont, equals('IBM Plex Sans JP'));
      expect(settings.fontSize, equals(18.0));
      expect(settings.seedColor.value, equals(Colors.red.value));
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
      await settingsNotifier.setFontSize(20.0);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.fontSize, equals(20.0));
    });

    test('should update seed color setting', () async {
      SharedPreferences.setMockInitialValues({});

      // Wait for initial state to load
      await container.read(settingsProvider.future);
      
      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setAndSaveSeedColor(Colors.green);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.seedColor.value, equals(Colors.green.value));
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

    test('should generate correct color scheme', () async {
      SharedPreferences.setMockInitialValues({
        'seed_color': Colors.purple.value,
      });

      final settings = await container.read(settingsProvider.future);
      final colorScheme = settings.colorScheme;

      expect(colorScheme, isA<ColorScheme>());
      expect(colorScheme.primary.value, isNot(equals(Colors.purple.value)));
    });

    test('should generate correct text style for each font', () async {
      final fonts = Settings.availableFonts;

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
        fontSize: 16.0,
        seedColor: Colors.blue,
      );

      expect(settings.selectedFont, equals('Noto Sans JP'));
      expect(settings.fontSize, equals(16.0));
      expect(settings.seedColor, equals(Colors.blue));
    });

    test('should create copy with updated values', () {
      const originalSettings = AppSettings(
        selectedFont: 'Noto Sans JP',
        fontSize: 16.0,
        seedColor: Colors.blue,
      );

      final updatedSettings = originalSettings.copyWith(
        selectedFont: 'IBM Plex Sans JP',
        fontSize: 18.0,
      );

      expect(updatedSettings.selectedFont, equals('IBM Plex Sans JP'));
      expect(updatedSettings.fontSize, equals(18.0));
      expect(updatedSettings.seedColor, equals(Colors.blue));
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
          fontSize: 16.0,
          seedColor: Colors.blue,
        );

        final textStyle = settings.selectedFontTheme;
        expect(textStyle, isA<TextStyle>());
      }
    });
  });
}
