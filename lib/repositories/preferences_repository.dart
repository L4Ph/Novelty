import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_repository.g.dart';

/// SharedPreferencesをラップするRepositoryのプロバイダー
@Riverpod(keepAlive: true)
PreferencesRepository preferencesRepository(Ref ref) => PreferencesRepository();

/// SharedPreferencesをラップするRepository
class PreferencesRepository {
  SharedPreferences? _prefs;

  /// SharedPreferencesインスタンス取得
  Future<SharedPreferences> getInstance() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  /// Int値を保存
  Future<bool> setInt(String key, int value) async {
    final prefs = await getInstance();
    return prefs.setInt(key, value);
  }

  /// Double値を保存
  Future<bool> setDouble(String key, double value) async {
    final prefs = await getInstance();
    return prefs.setDouble(key, value);
  }

  /// String値を保存
  Future<bool> setString(String key, String value) async {
    final prefs = await getInstance();
    return prefs.setString(key, value);
  }

  /// Bool値を保存
  // ignore: avoid_positional_boolean_parameters
  Future<bool> setBool(String key, bool value) async {
    final prefs = await getInstance();
    return prefs.setBool(key, value);
  }

  /// Int値を取得
  Future<int?> getInt(String key) async {
    final prefs = await getInstance();
    return prefs.getInt(key);
  }

  /// Double値を取得
  Future<double?> getDouble(String key) async {
    final prefs = await getInstance();
    return prefs.getDouble(key);
  }

  /// String値を取得
  Future<String?> getString(String key) async {
    final prefs = await getInstance();
    return prefs.getString(key);
  }

  /// Bool値を取得
  Future<bool?> getBool(String key) async {
    final prefs = await getInstance();
    return prefs.getBool(key);
  }
}
