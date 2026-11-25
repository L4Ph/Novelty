import 'package:flutter/material.dart';
import 'package:novelty/repositories/preferences_repository.dart';
import 'package:tiny_state/tiny_state.dart';

@immutable
/// アプリケーションの設定を管理するクラス。
class AppSettings {
  /// コンストラクタ。
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

  /// テーマモード (system, light, dark)。
  final ThemeMode themeMode;

  /// フォントサイズ。
  final double fontSize;

  /// 行間。
  final double lineHeight;

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

  /// オフラインモード設定。
  ///
  /// `true` の場合、ネットワーク通信を行わず、ダウンロード済みのコンテンツのみを利用します。
  final bool isOfflineMode;

  /// 設定をコピーするメソッド。
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

/// アプリケーションの設定を保持し、変更を購読者へ通知する。
///
/// アプリルートが1つ生成して [Scope] 経由で配る。設定の変更は
/// [notifyListeners] で全体へ伝わるため、各画面は `state` を読むだけでよい。
class SettingsController extends ChangeNotifier {
  /// コンストラクタ。
  ///
  /// [initialState] はテストが読み込みを省くために使う。通常は省略し、
  /// [load] で保存済みの設定を読み込む。
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

  /// ルビ表示時の最小行間。
  ///
  /// ルビが重なることを防ぐための最小値。
  /// 理論値1.25に安全マージンを加えた値。
  static const double minLineHeightWithRuby = 1.3;

  /// ルビ非表示時の最小行間。
  ///
  /// ルビが非表示の場合、より詰まった表示が可能。
  static const double minLineHeightWithoutRuby = 1;

  final PreferencesRepository _prefs;

  Async<AppSettings> _state;

  /// 現在の設定。読み込み中は [AsyncLoading]。
  Async<AppSettings> get state => _state;

  /// 読み込み済みの設定。未読み込みなら null。
  AppSettings? get value => _state.valueOrNull;

  /// オフラインモードが有効か。未読み込みなら false。
  bool get isOfflineMode => value?.isOfflineMode ?? false;

  void _setState(Async<AppSettings> next) {
    _state = next;
    notifyListeners();
  }

  /// 保存済みの設定を読み込む。アプリ起動時に一度だけ呼ぶ。
  Future<void> load() async {
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
  }

  /// テーマモードを設定するメソッド。
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

  /// フォントサイズを設定するメソッド。
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

  /// 行間を設定するメソッド。
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

  /// 縦書き設定を更新するメソッド。
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

  /// シークレットモードを設定するメソッド。
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

  /// オフラインモードを設定するメソッド。
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

  /// ページ送り設定を更新するメソッド。
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

  /// ルビ表示設定を更新するメソッド。
  ///
  /// ルビを有効にする場合、行間が [minLineHeightWithRuby] 未満であれば
  /// 自動的に [minLineHeightWithRuby] に調整します。
  /// これはルビが重なることを防ぐためです。
  ///
  /// 永続化処理は2段階で行われるため、2段階目が失敗した場合は
  /// 1段階目の変更をロールバックしてデータ整合性を保証します。
  Future<void> setIsRubyEnabled({required bool isRubyEnabled}) async {
    if (value == null) {
      throw StateError('Settings are not loaded');
    }

    try {
      final repo = _prefs;
      final originalIsRubyEnabled = value!.isRubyEnabled;

      // Phase 1: isRubyEnabled設定を保存
      final success = await repo.setBool(_isRubyEnabledKey, isRubyEnabled);
      if (!success) {
        throw Exception('Failed to save ruby enabled setting');
      }

      // Phase 1成功後の例外もロールバック対象
      AppSettings newSettings;
      try {
        newSettings = value!.copyWith(isRubyEnabled: isRubyEnabled);
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
