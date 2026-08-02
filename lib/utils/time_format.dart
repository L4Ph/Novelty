/// 日時を `HH:mm` 形式の文字列に変換する。
///
/// `intl` パッケージに依存せず、時刻をゼロ埋めの2桁で表現する。
String formatTimeHm(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
