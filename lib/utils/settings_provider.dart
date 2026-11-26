import 'package:flutter/material.dart';
import 'package:novelty/repositories/preferences_repository.dart';
import 'package:tiny_state/tiny_state.dart';

@immutable
/// The settings the app runs with.
class AppSettings {
  /// Creates the settings.
  const AppSettings({
    required this.themeMode,
    required this.fontSize,
    required this.lineHeight,
    required this.isVertical,
    required this.isIncognito,
    required this.isPageFlip,
    required this.isRubyEnabled,
    this.isOfflineMode = false,
  });

  /// Theme mode (system, light, dark).
  final ThemeMode themeMode;

  /// Font size.
  final double fontSize;

  /// Line height.
  final double lineHeight;

  /// Vertical writing.
  final bool isVertical;

  /// Incognito: do not record reading history.
  final bool isIncognito;

  /// Page flip (true) or scroll (false).
  final bool isPageFlip;

  /// Ruby (furigana) rendering.
  ///
  /// When `true` ruby is shown (the default).
  /// When `false` the base text is shown without ruby, which allows a
  /// smaller line height.
  final bool isRubyEnabled;

  /// Offline mode.
  ///
  /// When `true` no network requests are made; only downloaded content is
  /// used.
  final bool isOfflineMode;

  /// Returns a copy with the given fields replaced.
  AppSettings copyWith({
    ThemeMode? themeMode,
    double? fontSize,
    double? lineHeight,
    bool? isVertical,
    bool? isIncognito,
    bool? isPageFlip,
    bool? isRubyEnabled,
    bool? isOfflineMode,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      isVertical: isVertical ?? this.isVertical,
      isIncognito: isIncognito ?? this.isIncognito,
      isPageFlip: isPageFlip ?? this.isPageFlip,
      isRubyEnabled: isRubyEnabled ?? this.isRubyEnabled,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }
}

/// Holds the settings and notifies listeners on change.
///
/// The app root creates one and hands it out through the [Scope]. A change
/// reaches everything through [notifyListeners], so screens only read `state`.
class SettingsController extends ChangeNotifier {
  /// Creates the controller.
  ///
  /// [initialState] lets tests skip loading. Production omits it and calls
  /// [load] to read the stored settings.
  SettingsController(
    this._prefs, {
    Async<AppSettings> initialState = const AsyncLoading(),
  }) : _state = initialState;

  static const _themeModeKey = 'theme_mode';
  static const _fontSizeKey = 'font_size';
  static const _lineHeightKey = 'line_height';
  static const _isVerticalKey = 'is_vertical';
  static const _isIncognitoKey = 'is_incognito';
  static const _isPageFlipKey = 'is_page_flip';
  static const _isRubyEnabledKey = 'is_ruby_enabled';
  static const _isOfflineModeKey = 'is_offline_mode';

  /// Smallest line height while ruby is shown.
  ///
  /// Anything smaller overlaps the ruby; 1.25 is the theoretical minimum,
  /// so this adds a safety margin.
  static const double minLineHeightWithRuby = 1.3;

  /// Smallest line height without ruby.
  ///
  /// Without ruby the text can be set tighter.
  static const double minLineHeightWithoutRuby = 1;

  final PreferencesRepository _prefs;

  Async<AppSettings> _state;

  /// The current settings; [AsyncLoading] until loaded.
  Async<AppSettings> get state => _state;

  /// The loaded settings, or null before that.
  AppSettings? get value => _state.valueOrNull;

  /// Whether offline mode is on. False until loaded.
  bool get isOfflineMode => value?.isOfflineMode ?? false;

  void _setState(Async<AppSettings> next) {
    _state = next;
    notifyListeners();
  }

  /// Reads the stored settings. Called once at startup.
  ///
  /// A failure lands in [AsyncError] rather than leaving the app on the
  /// startup spinner forever; the root renders that state.
  Future<void> load() async {
    try {
      final repo = _prefs;
      final themeModeIndex =
          await repo.getInt(_themeModeKey) ?? ThemeMode.system.index;
      final fontSize = await repo.getDouble(_fontSizeKey) ?? 16.0;
      final lineHeight = await repo.getDouble(_lineHeightKey) ?? 1.5;
      final isVertical = await repo.getBool(_isVerticalKey) ?? false;
      final isIncognito = await repo.getBool(_isIncognitoKey) ?? false;
      final isPageFlip = await repo.getBool(_isPageFlipKey) ?? false;
      final isRubyEnabled = await repo.getBool(_isRubyEnabledKey) ?? true;
      final isOfflineMode = await repo.getBool(_isOfflineModeKey) ?? false;

      _setState(
        AsyncData(
          AppSettings(
            themeMode: ThemeMode.values[themeModeIndex],
            fontSize: fontSize,
            lineHeight: lineHeight,
            isVertical: isVertical,
            isIncognito: isIncognito,
            isPageFlip: isPageFlip,
            isRubyEnabled: isRubyEnabled,
            isOfflineMode: isOfflineMode,
          ),
        ),
      );
    } on Object catch (error, stackTrace) {
      debugPrint('Failed to load settings: $error\n$stackTrace');
      _setState(AsyncError(error, stackTrace));
    }
  }

  /// Sets the theme mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (value == null) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = _prefs;
      final success = await repo.setInt(_themeModeKey, mode.index);
      if (!success) {
        throw Exception('Failed to save theme mode setting');
      }
      _setState(AsyncData(value!.copyWith(themeMode: mode)));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving theme mode setting: $e\nStack trace: $stackTrace',
      );
      _setState(AsyncError(e, stackTrace));
      rethrow;
    }
  }

  /// Sets the font size.
  Future<void> setFontSize(double size) async {
    if (value == null) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = _prefs;
      final success = await repo.setDouble(_fontSizeKey, size);
      if (!success) {
        throw Exception('Failed to save font size setting');
      }
      _setState(AsyncData(value!.copyWith(fontSize: size)));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving font size setting: $e\nStack trace: $stackTrace',
      );
      _setState(AsyncError(e, stackTrace));
      rethrow;
    }
  }

  /// Sets the line height.
  Future<void> setLineHeight(double height) async {
    if (value == null) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = _prefs;
      final success = await repo.setDouble(_lineHeightKey, height);
      if (!success) {
        throw Exception('Failed to save line height setting');
      }
      _setState(AsyncData(value!.copyWith(lineHeight: height)));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving line height setting: $e\nStack trace: $stackTrace',
      );
      _setState(AsyncError(e, stackTrace));
      rethrow;
    }
  }

  /// Sets vertical writing.
  Future<void> setIsVertical({required bool isVertical}) async {
    if (value == null) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = _prefs;
      final success = await repo.setBool(_isVerticalKey, isVertical);
      if (!success) {
        throw Exception('Failed to save vertical setting');
      }
      _setState(AsyncData(value!.copyWith(isVertical: isVertical)));
    } catch (e, stackTrace) {
      debugPrint('Error saving vertical setting: $e\nStack trace: $stackTrace');
      _setState(AsyncError(e, stackTrace));
      rethrow;
    }
  }

  /// Sets incognito mode.
  Future<void> setIsIncognito({required bool isIncognito}) async {
    if (value == null) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = _prefs;
      final success = await repo.setBool(
        _isIncognitoKey,
        isIncognito,
      );
      if (!success) {
        throw Exception('Failed to save incognito setting');
      }
      _setState(AsyncData(value!.copyWith(isIncognito: isIncognito)));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving incognito setting: $e\nStack trace: $stackTrace',
      );
      _setState(AsyncError(e, stackTrace));
      rethrow;
    }
  }

  /// Sets offline mode.
  Future<void> setIsOfflineMode({required bool isOfflineMode}) async {
    if (value == null) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = _prefs;
      final success = await repo.setBool(
        _isOfflineModeKey,
        isOfflineMode,
      );
      if (!success) {
        throw Exception('Failed to save offline mode setting');
      }
      _setState(AsyncData(value!.copyWith(isOfflineMode: isOfflineMode)));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving offline mode setting: $e\nStack trace: $stackTrace',
      );
      _setState(AsyncError(e, stackTrace));
      rethrow;
    }
  }

  /// Sets page flip.
  Future<void> setIsPageFlip({required bool isPageFlip}) async {
    if (value == null) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = _prefs;
      final success = await repo.setBool(_isPageFlipKey, isPageFlip);
      if (!success) {
        throw Exception('Failed to save page flip setting');
      }
      _setState(AsyncData(value!.copyWith(isPageFlip: isPageFlip)));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving page flip setting: $e\nStack trace: $stackTrace',
      );
      _setState(AsyncError(e, stackTrace));
      rethrow;
    }
  }

  /// Sets ruby rendering.
  ///
  /// Enabling ruby raises a line height below [minLineHeightWithRuby] to
  /// that minimum, so the ruby cannot overlap.

  ///
  /// Persisting takes two steps. If the second fails, the first is rolled
  /// back so the stored settings stay consistent.
  Future<void> setIsRubyEnabled({required bool isRubyEnabled}) async {
    if (value == null) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = _prefs;
      final originalIsRubyEnabled = value!.isRubyEnabled;

      // Phase 1: store isRubyEnabled.
      final success = await repo.setBool(_isRubyEnabledKey, isRubyEnabled);
      if (!success) {
        throw Exception('Failed to save ruby enabled setting');
      }

      // A failure after phase 1 succeeded is rolled back too.
      AppSettings newSettings;
      try {
        newSettings = value!.copyWith(isRubyEnabled: isRubyEnabled);
      } catch (e, stackTrace) {
        debugPrint(
          'Failed to create new settings: $e\nStack trace: $stackTrace',
        );
        // Roll back phase 1.
        await _rollbackIsRubyEnabled(repo, originalIsRubyEnabled);
        rethrow;
      }

      // Phase 2: adjust the line height when needed (rolled back on failure).
      if (isRubyEnabled && newSettings.lineHeight < minLineHeightWithRuby) {
        final lineHeightSuccess = await repo.setDouble(
          _lineHeightKey,
          minLineHeightWithRuby,
        );
        if (!lineHeightSuccess) {
          // Roll back isRubyEnabled.
          await _rollbackIsRubyEnabled(repo, originalIsRubyEnabled);
          throw Exception(
            'Failed to save line height setting. '
            'Ruby setting has been rolled back.',
          );
        }
        newSettings = newSettings.copyWith(lineHeight: minLineHeightWithRuby);
      }

      _setState(AsyncData(newSettings));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving ruby enabled setting: $e\nStack trace: $stackTrace',
      );
      _setState(AsyncError(e, stackTrace));
      rethrow;
    }
  }

  /// Rolls isRubyEnabled back.
  ///
  /// A failure here leaves the stored settings inconsistent, so it is
  /// rethrown as a critical error.
  Future<void> _rollbackIsRubyEnabled(
    PreferencesRepository repo,
    bool originalValue,
  ) async {
    try {
      final rollbackSuccess = await repo.setBool(
        _isRubyEnabledKey,
        originalValue,
      );
      if (!rollbackSuccess) {
        debugPrint(
          'CRITICAL: Rollback failed - data may be in inconsistent state.',
        );
        throw Exception(
          'Failed to save line height and rollback failed. '
          'Settings may be inconsistent. Please restart the app.',
        );
      }
    } on Exception catch (rollbackError, rollbackStackTrace) {
      // Rethrow exceptions unchanged.
      debugPrint(
        'CRITICAL: Rollback threw exception: $rollbackError\n'
        '$rollbackStackTrace',
      );
      throw Exception(
        'Failed to save line height and rollback threw exception. '
        'Settings are inconsistent. Please restart the app.',
      );
    }
  }
}
