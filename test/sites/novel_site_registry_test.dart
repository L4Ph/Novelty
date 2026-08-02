import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/sites/narou/narou_site.dart';
import 'package:novelty/sites/novel_site_registry.dart';
import 'package:novelty/sites/novel_source.dart';

void main() {
  group('novelSiteRegistry', () {
    test('narou が登録されており実装は NarouSite', () {
      expect(novelSiteRegistry.keys, contains(NovelSource.narou));
      expect(novelSiteRegistry[NovelSource.narou], isA<NarouSite>());
    });

    test('kakuyomu は P1 時点では未登録', () {
      expect(
        novelSiteRegistry.keys,
        isNot(contains(NovelSource.kakuyomu)),
      );
    });

    test('登録エントリは現時点で1件のみ', () {
      expect(novelSiteRegistry, hasLength(1));
    });

    test('登録済みエントリのキーと実装の source が一致する', () {
      for (final entry in novelSiteRegistry.entries) {
        expect(entry.value.source, entry.key);
      }
    });
  });
}
