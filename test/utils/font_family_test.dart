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

  group('resolveFontFamily', () {
    test('ゴシック体はバンドルの NotoSansJP を返す', () {
      expect(resolveFontFamily(FontFamilySetting.sans), 'NotoSansJP');
    });

    test('明朝体はバンドルの NotoSerifJP を返す', () {
      expect(resolveFontFamily(FontFamilySetting.serif), 'NotoSerifJP');
    });
  });
}
