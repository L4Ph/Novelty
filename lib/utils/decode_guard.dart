import 'package:json_annotation/json_annotation.dart';

/// Decodes an untrusted payload at the trust boundary.
///
/// External sites change shape without warning. Leaving that as a [TypeError]
/// (an `Error`) makes it uncatchable by the repository's narrowed `on
/// Exception` clauses, so a single retyped field would abort a whole download
/// instead of failing one episode. Normalise it to [FormatException] here.
T guardDecode<T>(T Function() decode) {
  try {
    return decode();
  } on CheckedFromJsonException catch (e) {
    throw FormatException('レスポンスの形式が不正です: ${e.message}');
    // Catching an Error is deliberate: this is the boundary where untrusted
    // input is converted into a failure the caller can handle.
    // ignore: avoid_catching_errors
  } on TypeError catch (e) {
    throw FormatException('レスポンスの構造が不正です: $e');
  }
}
