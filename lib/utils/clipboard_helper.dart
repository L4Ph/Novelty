import 'package:flutter/services.dart';

/// テキストをクリップボードへコピーする。
///
/// スナックバーでの通知は呼び出し側で行う。
Future<void> copyTextToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}
