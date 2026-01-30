import 'package:flutter/material.dart';
import 'package:novelty/repositories/preferences_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@immutable
/// アプリケーションの設定を管理するクラス。
class AppSettings {
  /// コンストラクタ。
  const AppSettings({
    required this.themeMode,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.isVertical,
    required this.isIncognito,
    required this.isPageFlip,
    required this.isRubyEnabled,
  });

  /// テーマモード (system, light, dark)。
  final ThemeMode themeMode;

  /// フォントサイズ。
  final double fontSize;

  /// 行間。
  final double lineHeight;

  /// フォントファミリー。
  final String fontFamily;

  /// 縦書き設定。
  final bool isVertical;

  /// シークレットモード (履歴を残さない)。
  final bool isIncognito;

  /// ページ送り設定 (true: ページ送り, false: スクロール)。
  final bool isPageFlip;

  /// ルビ（ふりがな）の表示設定。
  ///
  /// `true` の場合、ルビが表示されます（デフォルト）。
  /// `false` の場合、ルビは非表示になりベーステキストのみが表示されます。
  /// これにより、行間をより小さく設定することができます。
  final bool isRubyEnabled;

  /// 設定をコピーするメソッド。
  AppSettings copyWith({
    ThemeMode? themeMode,
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    bool? isVertical,
    bool? isIncognito,
    bool? isPageFlip,
    bool? isRubyEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      isVertical: isVertical ?? this.isVertical,
      isIncognito: isIncognito ?? this.isIncognito,
      isPageFlip: isPageFlip ?? this.isPageFlip,
      isRubyEnabled: isRubyEnabled ?? this.isRubyEnabled,
    );
  }
}

@Riverpod(keepAlive: true)
/// アプリケーションの設定を提供するプロバイダー。
class Settings extends _$Settings {
  static const _themeModeKey = 'theme_mode';
  static const _fontSizeKey = 'font_size';
  static const _lineHeightKey = 'line_height';
  static const _fontFamilyKey = 'font_family';
  static const _isVerticalKey = 'is_vertical';
  static const _isIncognitoKey = 'is_incognito';
  static const _isPageFlipKey = 'is_page_flip';
  static const _isRubyEnabledKey = 'is_ruby_enabled';

  /// ルビ表示時の最小行間。
  ///
  /// ルビが重なることを防ぐための最小値。
  /// 理論値1.25に安全マージンを加えた値。
  static const double minLineHeightWithRuby = 1.3;

  /// ルビ非表示時の最小行間。
  ///
  /// ルビが非表示の場合、より詰まった表示が可能。
  static const double minLineHeightWithoutRuby = 1;

  PreferencesRepository? _repository;

  Future<PreferencesRepository> get _repo async {
    _repository ??= ref.read(preferencesRepositoryProvider);
    return _repository!;
  }

  @override
  Future<AppSettings> build() async {
    final repo = await _repo;
    final themeModeIndex =
        await repo.getInt(_themeModeKey) ?? ThemeMode.system.index;
    final fontSize = await repo.getDouble(_fontSizeKey) ?? 16.0;
    final lineHeight = await repo.getDouble(_lineHeightKey) ?? 1.5;
    final fontFamily = await repo.getString(_fontFamilyKey) ?? 'NotoSansJP';
    final isVertical = await repo.getBool(_isVerticalKey) ?? false;
    final isIncognito = await repo.getBool(_isIncognitoKey) ?? false;
    final isPageFlip = await repo.getBool(_isPageFlipKey) ?? false;
    final isRubyEnabled = await repo.getBool(_isRubyEnabledKey) ?? true;

    return AppSettings(
      themeMode: ThemeMode.values[themeModeIndex],
      fontSize: fontSize,
      lineHeight: lineHeight,
      fontFamily: fontFamily,
      isVertical: isVertical,
      isIncognito: isIncognito,
      isPageFlip: isPageFlip,
      isRubyEnabled: isRubyEnabled,
    );
  }

  /// テーマモードを設定するメソッド。
  Future<void> setThemeMode(ThemeMode mode) async {
    if (!state.hasValue) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = await _repo;
      final success = await repo.setInt(_themeModeKey, mode.index);
      if (!success) {
        throw Exception('Failed to save theme mode setting');
      }
      state = AsyncData(state.value!.copyWith(themeMode: mode));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving theme mode setting: $e\nStack trace: $stackTrace',
      );
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  /// フォントサイズを設定するメソッド。
  Future<void> setFontSize(double size) async {
    if (!state.hasValue) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = await _repo;
      final success = await repo.setDouble(_fontSizeKey, size);
      if (!success) {
        throw Exception('Failed to save font size setting');
      }
      state = AsyncData(state.value!.copyWith(fontSize: size));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving font size setting: $e\nStack trace: $stackTrace',
      );
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  /// 行間を設定するメソッド。
  Future<void> setLineHeight(double height) async {
    if (!state.hasValue) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = await _repo;
      final success = await repo.setDouble(_lineHeightKey, height);
      if (!success) {
        throw Exception('Failed to save line height setting');
      }
      state = AsyncData(state.value!.copyWith(lineHeight: height));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving line height setting: $e\nStack trace: $stackTrace',
      );
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  /// フォントファミリーを設定するメソッド。
  Future<void> setFontFamily(String family) async {
    if (!state.hasValue) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = await _repo;
      final success = await repo.setString(_fontFamilyKey, family);
      if (!success) {
        throw Exception('Failed to save font family setting');
      }
      state = AsyncData(state.value!.copyWith(fontFamily: family));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving font family setting: $e\nStack trace: $stackTrace',
      );
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  /// 縦書き設定を更新するメソッド。
  Future<void> setIsVertical({required bool isVertical}) async {
    if (!state.hasValue) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = await _repo;
      final success = await repo.setBool(_isVerticalKey, isVertical);
      if (!success) {
        throw Exception('Failed to save vertical setting');
      }
      state = AsyncData(state.value!.copyWith(isVertical: isVertical));
    } catch (e, stackTrace) {
      debugPrint('Error saving vertical setting: $e\nStack trace: $stackTrace');
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  /// シークレットモードを設定するメソッド。
  Future<void> setIsIncognito({required bool isIncognito}) async {
    if (!state.hasValue) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = await _repo;
      final success = await repo.setBool(
        _isIncognitoKey,
        isIncognito,
      );
      if (!success) {
        throw Exception('Failed to save incognito setting');
      }
      state = AsyncData(state.value!.copyWith(isIncognito: isIncognito));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving incognito setting: $e\nStack trace: $stackTrace',
      );
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  /// ページ送り設定を更新するメソッド。
  Future<void> setIsPageFlip({required bool isPageFlip}) async {
    if (!state.hasValue) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = await _repo;
      final success = await repo.setBool(_isPageFlipKey, isPageFlip);
      if (!success) {
        throw Exception('Failed to save page flip setting');
      }
      state = AsyncData(state.value!.copyWith(isPageFlip: isPageFlip));
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving page flip setting: $e\nStack trace: $stackTrace',
      );
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  /// ルビ表示設定を更新するメソッド。
  ///
  /// ルビを有効にする場合、行間が [minLineHeightWithRuby] 未満であれば
  /// 自動的に [minLineHeightWithRuby] に調整します。
  /// これはルビが重なることを防ぐためです。
  ///
  /// 永続化処理は2段階で行われるため、2段階目が失敗した場合は
  /// 1段階目の変更をロールバックしてデータ整合性を保証します。
  Future<void> setIsRubyEnabled({required bool isRubyEnabled}) async {
    if (!state.hasValue) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = await _repo;
      final originalIsRubyEnabled = state.value!.isRubyEnabled;

      // Phase 1: isRubyEnabled設定を保存
      final success = await repo.setBool(_isRubyEnabledKey, isRubyEnabled);
      if (!success) {
        throw Exception('Failed to save ruby enabled setting');
      }

      // Phase 1成功後の例外もロールバック対象
      AppSettings newSettings;
      try {
        newSettings = state.value!.copyWith(isRubyEnabled: isRubyEnabled);
      } catch (e, stackTrace) {
        debugPrint(
          'Failed to create new settings: $e\nStack trace: $stackTrace',
        );
        // Phase 1をロールバック
        await _rollbackIsRubyEnabled(repo, originalIsRubyEnabled);
        rethrow;
      }

      // Phase 2: 必要に応じて行間を調整（失敗時はロールバック）
      if (isRubyEnabled && newSettings.lineHeight < minLineHeightWithRuby) {
        final lineHeightSuccess = await repo.setDouble(
          _lineHeightKey,
          minLineHeightWithRuby,
        );
        if (!lineHeightSuccess) {
          // ロールバック: isRubyEnabledを元に戻す
          await _rollbackIsRubyEnabled(repo, originalIsRubyEnabled);
          throw Exception(
            'Failed to save line height setting. Ruby setting has been rolled back.',
          );
        }
        newSettings = newSettings.copyWith(lineHeight: minLineHeightWithRuby);
      }

      state = AsyncData(newSettings);
    } catch (e, stackTrace) {
      debugPrint(
        'Error saving ruby enabled setting: $e\nStack trace: $stackTrace',
      );
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  /// isRubyEnabledのロールバック処理。
  ///
  /// ロールバック処理自体が失敗した場合は、クリティカルエラーとして扱う。
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
      // Exceptionの場合はそのまま再スロー
      debugPrint(
        'CRITICAL: Rollback threw exception: $rollbackError\n$rollbackStackTrace',
      );
      throw Exception(
        'Failed to save line height and rollback threw exception. '
        'Settings are inconsistent. Please restart the app.',
      );
    }
  }
}
