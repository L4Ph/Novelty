import 'package:novelty/sites/kakuyomu/kakuyomu_site.dart';
import 'package:novelty/sites/narou/narou_site.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_source.dart';

/// サイト種別とサイト実装の対応を管理するレジストリ。
///
/// カクヨムはDioを保持するためconstにはできない。
final Map<NovelSource, NovelSite> novelSiteRegistry = <NovelSource, NovelSite>{
  NovelSource.narou: const NarouSite(),
  NovelSource.kakuyomu: KakuyomuSite(),
};
