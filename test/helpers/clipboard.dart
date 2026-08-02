import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// クリップボードのモック設定の結果。
class ClipboardMock {
  ClipboardMock(this._tester);

  final WidgetTester _tester;
  String? _copiedText;

  /// 最後にコピーされたテキスト。
  String? get copiedText => _copiedText;

  /// クリップボードへコピーされたテキストを検証する。
  void expectCopiedText(String expected) {
    expect(_copiedText, expected);
  }

  /// モックを解除する（tearDown で呼ぶ）。
  void dispose() {
    _tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  }
}

/// クリップボードのモックを設定する。
///
/// `Clipboard.setData` でコピーされたテキストを保持し、
/// `Clipboard.getData` で参照できるようにする。
/// 返り値の [ClipboardMock.dispose] を tearDown で呼ぶこと。
ClipboardMock installClipboardMock(WidgetTester tester) {
  final mock = ClipboardMock(tester);
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      switch (call.method) {
        case 'Clipboard.setData':
          mock._copiedText =
              (call.arguments as Map<Object?, Object?>)['text'] as String?;
          return null;
        case 'Clipboard.getData':
          return <String, dynamic>{'text': mock._copiedText};
        default:
          return null;
      }
    },
  );
  return mock;
}
