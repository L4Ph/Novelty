import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/utils/font_family.dart';

void main() {
  group('FontFamilySetting.fromStored', () {
    test('保存されていない場合はゴシック体として扱う', () {
      expect(FontFamilySetting.fromStored(null), FontFamilySetting.sans);
    });

    test('sans はそのままゴシック体として扱う', () {
      expect(FontFamilySetting.fromStored('sans'), FontFamilySetting.sans);
    });

    test('serif はそのまま明朝体として扱う', () {
      expect(FontFamilySetting.fromStored('serif'), FontFamilySetting.serif);
    });

    test('旧バージョンの NotoSerifJP は明朝体へ移行する', () {
      expect(
        FontFamilySetting.fromStored('NotoSerifJP'),
        FontFamilySetting.serif,
      );
    });

    test('旧バージョンの NotoSansJP はゴシック体へ移行する', () {
      expect(
        FontFamilySetting.fromStored('NotoSansJP'),
        FontFamilySetting.sans,
      );
    });

    test('未知の値はゴシック体として扱う', () {
      expect(
        FontFamilySetting.fromStored('unknown-font'),
        FontFamilySetting.sans,
      );
    });
  });

  group('FontFamilySetting.storageKey', () {
    test('保存表現は設定キーと一致する', () {
      expect(FontFamilySetting.sans.storageKey, 'sans');
      expect(FontFamilySetting.serif.storageKey, 'serif');
    });
  });

  group('resolveFontFamily (ゴシック)', () {
    test('Android ではファミリーを指定しない', () {
      final result = resolveFontFamily(
        FontFamilySetting.sans,
        TargetPlatform.android,
      );

      expect(result.family, isNull);
      expect(result.fallbacks, isEmpty);
    });

    test('iOS ではファミリーを指定しない', () {
      final result = resolveFontFamily(
        FontFamilySetting.sans,
        TargetPlatform.iOS,
      );

      expect(result.family, isNull);
      expect(result.fallbacks, isEmpty);
    });

    test('macOS ではファミリーを指定しない', () {
      final result = resolveFontFamily(
        FontFamilySetting.sans,
        TargetPlatform.macOS,
      );

      expect(result.family, isNull);
      expect(result.fallbacks, isEmpty);
    });

    test('Windows では Noto Sans JP を Yu Gothic のフォールバック付きで使う', () {
      final result = resolveFontFamily(
        FontFamilySetting.sans,
        TargetPlatform.windows,
      );

      expect(result.family, 'Noto Sans JP');
      expect(result.fallbacks, ['Yu Gothic']);
    });

    test('Linux では Noto Sans CJK JP を使う', () {
      final result = resolveFontFamily(
        FontFamilySetting.sans,
        TargetPlatform.linux,
      );

      expect(result.family, 'Noto Sans CJK JP');
      expect(result.fallbacks, isEmpty);
    });
  });

  group('resolveFontFamily (明朝)', () {
    test('Android ではシステムの serif ファミリーを使う', () {
      final result = resolveFontFamily(
        FontFamilySetting.serif,
        TargetPlatform.android,
      );

      expect(result.family, 'serif');
      expect(result.fallbacks, isEmpty);
    });

    test('iOS では Hiragino Mincho ProN を使う', () {
      final result = resolveFontFamily(
        FontFamilySetting.serif,
        TargetPlatform.iOS,
      );

      expect(result.family, 'Hiragino Mincho ProN');
      expect(result.fallbacks, isEmpty);
    });

    test('macOS では Hiragino Mincho ProN を使う', () {
      final result = resolveFontFamily(
        FontFamilySetting.serif,
        TargetPlatform.macOS,
      );

      expect(result.family, 'Hiragino Mincho ProN');
      expect(result.fallbacks, isEmpty);
    });

    test('Windows では Noto Serif JP を Yu Mincho のフォールバック付きで使う', () {
      final result = resolveFontFamily(
        FontFamilySetting.serif,
        TargetPlatform.windows,
      );

      expect(result.family, 'Noto Serif JP');
      expect(result.fallbacks, ['Yu Mincho']);
    });

    test('Linux では Noto Serif CJK JP を使う', () {
      final result = resolveFontFamily(
        FontFamilySetting.serif,
        TargetPlatform.linux,
      );

      expect(result.family, 'Noto Serif CJK JP');
      expect(result.fallbacks, isEmpty);
    });

    test('fuchsia ではファミリーを指定しない', () {
      final result = resolveFontFamily(
        FontFamilySetting.serif,
        TargetPlatform.fuchsia,
      );

      expect(result.family, isNull);
      expect(result.fallbacks, isEmpty);
    });
  });
}
