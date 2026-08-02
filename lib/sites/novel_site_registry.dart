import 'package:novelty/sites/narou/narou_site.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_source.dart';

/// サイト種別とサイト実装の対応を管理するレジストリ。
///
/// P1時点ではなろうのみ登録する。カクヨムは P2 で追加する。
const Map<NovelSource, NovelSite> novelSiteRegistry = <NovelSource, NovelSite>{
  NovelSource.narou: NarouSite(),
};
