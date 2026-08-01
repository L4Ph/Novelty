import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/utils/font_family.dart';

void main() {
  group('resolveFontFamily (ゴシック)', () {
    test('Android ではファミリーを指定しない', () {
      final result = resolveFontFamily('sans', TargetPlatform.android);

      expect(result.family, isNull);
      expect(result.fallbacks, isEmpty);
    });

    test('iOS ではファミリーを指定しない', () {
      final result = resolveFontFamily('sans', TargetPlatform.iOS);

      expect(result.family, isNull);
      expect(result.fallbacks, isEmpty);
    });

    test('macOS ではファミリーを指定しない', () {
      final result = resolveFontFamily('sans', TargetPlatform.macOS);

      expect(result.family, isNull);
      expect(result.fallbacks, isEmpty);
    });

    test('Windows では Noto Sans JP を Yu Gothic のフォールバック付きで使う', () {
      final result = resolveFontFamily('sans', TargetPlatform.windows);

      expect(result.family, 'Noto Sans JP');
      expect(result.fallbacks, ['Yu Gothic']);
    });

    test('Linux では Noto Sans CJK JP を使う', () {
      final result = resolveFontFamily('sans', TargetPlatform.linux);

      expect(result.family, 'Noto Sans CJK JP');
      expect(result.fallbacks, isEmpty);
    });
  });

  group('resolveFontFamily (明朝)', () {
    test('Android ではシステムの serif ファミリーを使う', () {
      final result = resolveFontFamily('serif', TargetPlatform.android);

      expect(result.family, 'serif');
      expect(result.fallbacks, isEmpty);
    });

    test('iOS では Hiragino Mincho ProN を使う', () {
      final result = resolveFontFamily('serif', TargetPlatform.iOS);

      expect(result.family, 'Hiragino Mincho ProN');
      expect(result.fallbacks, isEmpty);
    });

    test('macOS では Hiragino Mincho ProN を使う', () {
      final result = resolveFontFamily('serif', TargetPlatform.macOS);

      expect(result.family, 'Hiragino Mincho ProN');
      expect(result.fallbacks, isEmpty);
    });

    test('Windows では Noto Serif JP を Yu Mincho のフォールバック付きで使う', () {
      final result = resolveFontFamily('serif', TargetPlatform.windows);

      expect(result.family, 'Noto Serif JP');
      expect(result.fallbacks, ['Yu Mincho']);
    });

    test('Linux では Noto Serif CJK JP を使う', () {
      final result = resolveFontFamily('serif', TargetPlatform.linux);

      expect(result.family, 'Noto Serif CJK JP');
      expect(result.fallbacks, isEmpty);
    });
  });

  group('resolveFontFamily (その他)', () {
    test('未知の設定値はゴシックとして扱う', () {
      final result = resolveFontFamily('NotoSerifJP', TargetPlatform.android);

      expect(result.family, isNull);
      expect(result.fallbacks, isEmpty);
    });

    test('fuchsia ではファミリーを指定しない', () {
      final result = resolveFontFamily('serif', TargetPlatform.fuchsia);

      expect(result.family, isNull);
      expect(result.fallbacks, isEmpty);
    });
  });
}
