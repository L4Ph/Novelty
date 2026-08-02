import 'package:freezed_annotation/freezed_annotation.dart';

/// JSONからString?を変換するコンバーター。
///
/// なろうAPIの `genre` は作品によって `"101"`（文字列）と
/// `101`（数値）のどちらでも返り得るため、両方を受け付けて
/// 文字列へ正規化する。
class IntOrStringConverter implements JsonConverter<String?, Object?> {
  /// コンストラクタ。
  const IntOrStringConverter();

  @override
  String? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    if (json is String) {
      return json;
    }
    // int / double / その他の数値は文字列表現へ変換する
    return json.toString();
  }

  @override
  Object? toJson(String? object) {
    return object;
  }
}
