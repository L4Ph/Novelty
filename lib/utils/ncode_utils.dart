/// Ncodeに関するユーティリティ拡張メソッド
extension NcodeExtension on String {
  /// Ncodeを正規化する（小文字に変換）
  ///
  /// なろうAPIではNcodeは大文字・小文字を区別しないため、
  /// データベース保存時やAPI呼び出し時には小文字に統一する。
  String toNormalizedNcode() => toLowerCase();
}
